this.hunting_webknechts_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		Dude = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hunting_webknechts";
		this.m.Name = "Chasser Webknechts";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 450 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Chassez ce qui tue les gens dans les bois autour de " + this.Contract.m.Home.getName()
				];

				if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.IntroChance)
				{
					this.Contract.setScreen("Intro");
				}
				else
				{
					this.Contract.setScreen("Task");
				}
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 10)
				{
					if (this.Contract.getDifficultyMult() >= 0.9)
					{
						this.Flags.set("IsOldArmor", true);
					}
				}
				else if (r <= 20)
				{
					this.Flags.set("IsSurvivor", true);
				}

				this.Flags.set("StartTime", this.Time.getVirtualTimeF());
				local disallowedTerrain = [];

				for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
				{
					if (i == this.Const.World.TerrainType.Forest || i == this.Const.World.TerrainType.LeaveForest || i == this.Const.World.TerrainType.AutumnForest)
					{
					}
					else
					{
						disallowedTerrain.push(i);
					}
				}

				local playerTile = this.World.State.getPlayer().getTile();
				local mapSize = this.World.getMapSize();
				local x = this.Math.max(3, playerTile.SquareCoords.X - 9);
				local x_max = this.Math.min(mapSize.X - 3, playerTile.SquareCoords.X + 9);
				local y = this.Math.max(3, playerTile.SquareCoords.Y - 9);
				local y_max = this.Math.min(mapSize.Y - 3, playerTile.SquareCoords.Y + 9);
				local numWoods = 0;

				while (x <= x_max)
				{
					while (y <= y_max)
					{
						local tile = this.World.getTileSquare(x, y);

						if (tile.Type == this.Const.World.TerrainType.Forest || tile.Type == this.Const.World.TerrainType.LeaveForest || tile.Type == this.Const.World.TerrainType.AutumnForest)
						{
							numWoods = ++numWoods;
						}

						y = ++y;
					}

					x = ++x;
				}

				local tile = this.Contract.getTileToSpawnLocation(playerTile, numWoods >= 12 ? 6 : 3, 9, disallowedTerrain);
				local party;
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Webknechts", false, this.Const.World.Spawn.Spiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.setDescription("A swarm of webknechts skittering about.");
				party.setFootprintType(this.Const.World.FootprintsType.Spiders);
				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);

				for( local i = 0; i < 2; i = ++i )
				{
					local nearTile = this.Contract.getTileToSpawnLocation(playerTile, 4, 5);

					if (nearTile != null)
					{
						this.Const.World.Common.addFootprintsFromTo(nearTile, party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Spiders, 0.75);
					}
				}

				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_beasts_01");
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setNoTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Forest, true);
				roam.setTerrain(this.Const.World.TerrainType.LeaveForest, true);
				roam.setTerrain(this.Const.World.TerrainType.AutumnForest, true);
				roam.setMinRange(1);
				roam.setMaxRange(1);
				c.addOrder(roam);
				this.Contract.m.Home.setLastSpawnTimeToNow();
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onTargetAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive())
				{
					if (this.Flags.get("IsOldArmor") && this.World.Assets.getStash().hasEmptySlot())
					{
						this.Contract.setScreen("OldArmor");
					}
					else if (this.Flags.get("IsSurvivor") && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
					{
						this.Contract.setScreen("Survivor");
					}
					else
					{
						this.Contract.setScreen("Victory");
					}

					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
				else if (!this.Flags.get("IsBanterShown") && this.Contract.m.Target.isHiddenToPlayer() && this.Math.rand(1, 1000) <= 1 && this.Flags.get("StartTime") + 10.0 <= this.Time.getVirtualTimeF())
				{
					local tileType = this.World.State.getPlayer().getTile().Type;

					if (tileType == this.Const.World.TerrainType.Forest || tileType == this.Const.World.TerrainType.LeaveForest || tileType == this.Const.World.TerrainType.AutumnForest)
					{
						this.Flags.set("IsBanterShown", true);
						this.Contract.setScreen("Banter");
						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (!this.Flags.get("IsEncounterShown"))
				{
					this.Flags.set("IsEncounterShown", true);
					this.Contract.setScreen("Encounter");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog(_isPlayerAttacking);
				}
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Retournez ?? " + this.Contract.m.Home.getName()
				];
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success");
					this.World.Contracts.showActiveContract();
				}
			}

		});
	}

	function createScreens()
	{
		this.importScreens(this.Const.Contracts.NegotiationDefault);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Task",
			Title = "N??gociations",
			Text = "[img]gfx/ui/events/event_43.png[/img]{%employer% vous fait signe d\'entrer dans sa chambre. Vous remarquez qu\'il y a des hommes arm??s de fourches qui montent la garde en regardant fixement par les fen??tres, bien que l\'un d\'entre eux soit clairement endormi contre le mur. Vous demandez au maire de la ville ce qu\'il veut. Il va droit au but.%SPEECH_ON%Les habitants de l\'arri??re-pays signalent que des monstruosit??s enl??vent des enfants, des chiens et autres. Je ne veux pas laisser de place ?? la parano??a et ?? la superstition, mais il semble que ces rapports parlent d\'araign??es. Webknechts comme mon p??re les appelait, et si c\'est vrai, il est probable qu\'ils aient un nid dans le coin et j\'ai besoin que vous le trouviez et le d??truisiez. Etes-vous int??ress??, mercenaire ?%SPEECH_OFF% | Vous trouvez %employer% qui tend une toile d\'araign??e entre deux fourchettes. Il tourne l\'un des ustensiles et enroule la toile d\'araign??e autour d\'une ficelle. En soupirant, il vous regarde enfin.%SPEECH_ON%Je n\'ai pas l\'intention d\'amener des mercenaires dans ces r??gions, mais je suis ?? bout de souffle ici. D\'??normes araign??es sont dans les parages, volant le b??tail, les animaux de compagnie. Une dame a signal?? que son enfant avait ??t?? enlev?? de son berceau, et qu\'il n\'y avait plus qu\'une toile d\'araign??e ?? l\'endroit o?? il dormait. Je veux qu\'on s\'occupe de ces horribles cr??atures et qu\'on d??truise leur nid. Avec une incitation appropri??e, seriez-vous int??ress?? ?%SPEECH_OFF% | Vous arrivez chez %employer% et votre ombre seule fait sursauter l\'homme. Il se redresse ?? son bureau et hoche la t??te.%SPEECH_ON%Ah, j\'en ai eu ma dose. Je ne me soucie pas de votre pr??sence ici, mercenaire, bien que vous soyez assez effrayant, mais la rumeur autour de ces r??gions est que de grandes araign??es sont en libert??. J\'ai des raisons de croire ces histoires, ??tant donn?? que je suis all?? dans une ferme et que j\'ai vu les grandes toiles et le b??tail d??vor??. J\'ai besoin d\'un homme dot?? d\'une violence absolue, en vous parlant, et j\'ai besoin d\'un tel homme pour trouver le nid de monstres et y mettre fin. ??tes-vous int??ress?? ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Combien de couronnes pouvez-vous rassembler ? | Parlons salaire. | Parlons couronnes.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{??a ne ressemble pas ?? notre genre de travail.}",
					function getResult()
					{
						this.World.Contracts.removeContract(this.Contract);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Banter",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_25.png[/img]{Vous tombez sur une vache morte dont la chair est aspir??e jusqu\'aux os, mais dont la peau ne porte aucun signe de s??chage. %randombrother% s\'accroupit et passe son doigt parmi un certain nombre de plaies perforantes. Il acquiesce.%SPEECH_ON%Le travail d\'un webknecht, sans aucun doute. Je dirais qu\'ils l\'ont empoisonn?? et se sont ensuite nourris de son corps paralys??. Et un cadavre encore frais signifie qu\'ils sont proches...%SPEECH_OFF% | Vous trouvez un cadavre couvert de toiles appuy?? contre un arbre isol??. Vous coupez les filaments. Le corps d\'un enfant s\'??chappe et s\'effondre sur le sol. Son visage est coll?? ?? l\'os, un cr??ne blafard dont les globes oculaires ressortent des orbites profondes. La langue est tout aussi effac??e et il n\'y a presque pas de nez. %randombrother%  crache et hoche la t??te.%SPEECH_ON%Tr??s bien. Nous sommes proches. Plut??t, ils sont proches. Si ??a peut vous consoler, le gar??on est mort avant d\'arriver ici. Les webknechts apportent du poison avec leurs piq??res et aucun enfant ne pourrait y survivre longtemps.%SPEECH_OFF%Eh bien, tant mieux. Il est temps pour les hommes de trouver ces monstres. | Vous trouvez un gar??on cach?? sous une brouette renvers??e. Il refuse de sortir, sa petite t??te regardant ?? l\'ext??rieur de l\'abri comme une perle d\'un coquillage. Vous lui demandez ce qu\'il fait. Il vous explique fr??n??tiquement qu\'il se cache des araign??es et que vous devez partir.%SPEECH_ON%Obtenez votre propre brouette. Celle-ci est ?? moi.%SPEECH_OFF% Brandissant votre ??p??e, vous lui dites que ce sont les araign??es que vous cherchez. Le gar??on vous regarde fixement. Il acquiesce.%SPEECH_ON%C\'est une tr??s mauvaise id??e, monsieur. Et non, je n\'ai aucune id??e de l\'endroit o?? ils sont all??s. J\'??tais ici avec une caravane et vous voyez une caravane ? Non, c\'est vrai, vous n\'en voyez pas parce qu\'il n\'y a plus que de la viande pour araign??e maintenant, alors partez avant qu\'ils ne vous voient me parler !%SPEECH_OFF%La brouette se referme en claquant. Vous n\'avez pas l\'intention de la relever, mais vous lui donnez un bon coup de pied en partant.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Gardez vos yeux ouverts.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Encounter",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_110.png[/img]{Le nid de webknechts est une fosse de terre envelopp??e de blanc. ?? son bord se trouvent de fins filaments qui s\'agitent ?? la moindre brise. En faisant marcher votre compagnie vers l\'int??rieur, la toile commence ?? prendre une sorte de forme civilis??e, comme si vous arriviez d\'un arri??re-pays hivernal, la nouveaut?? de sa cr??ation apparaissant dans ses pi??ges serr??s : cerfs, chiens, cocons de taille humaine qui ne montrent aucun signe de vie, tous li??s dans des cocons blancs comme des morceaux perdus sur un tapis p??le. Une ombre noire s\'avance derri??re le domicile voil??, se mettant en avant avec ses jambes accroupies en d??filade, sa t??te recroquevill??e au-del??, comme si cet immonde cr??tin ??tait entrav?? par sa propre foul??e. Une main humaine aspire et expire de ses mandibules comme une t??tine macabre. Vous ??tes au bon endroit. | Le nid de webknecht est silencieux et le fracas de l\'arriv??e de la compagnie semble apocryphe, avec le tintement et le tintement des m??taux bien nets avec leur intrusion.\n\n Vous trouvez un homme suspendu ?? l\'envers ?? un arbre, tout son corps est dans un cocon, sauf son visage qui est ??tir?? et tir?? par les filaments. Il vous demande de lib??rer ses paupi??res de la toile, ce que vous faites. Ses paupi??res se ferment lentement, la cro??te de ses yeux secs se refermant pour la premi??re fois depuis des jours. Mais ils s\'ouvrent brusquement et l\'homme hurle. Le cocon bouillonne ?? sa taille et se d??chire, un crachotement de minuscules araign??es noires en sort. Le corps de l\'homme s\'agite violemment tandis que l\'essaim le d??vore, ses cris gargaris??s par le scintillement des araign??es qui remplissent ses poumons et qu\'il crache en mourant. Horrifi??, vous reculez pour voir une foule d\'araign??es beaucoup plus grosses sortir d\'autour des arbres ! | Le nid est un endroit facile ?? trouver, une ??tendue de paysage hivernal o?? il n\'y a pas de froid, les toiles blanches sont ??parses et se dessinent sur chaque arbre, chaque bosquet, chaque centim??tre carr?? de l\'endroit. Vous faites entrer la compagnie, armes ?? la main, et l??, vous tombez sur les corps envelopp??s, le centre ouvert et noirci, une invasion d\'araign??es su??ant leurs organes.\n\n Levant les yeux, vous voyez des yeux rouges s\'illuminer entre les branches des arbres environnants, tout l\'arboretum arachnidien s\'anime, ses gardiens perch??s l?? au milieu des broussailles, leurs jambes accroupies indiscernables des branches, l\'ennemi se cachant ?? la vue de tous. Vous ??tes ?? deux doigts de vous chier dessus lorsqu\'un suppos?? arbre se d??ploie enti??rement, chaque tige de bois n\'??tant plus qu\'une patte d\'araign??e, le man??ge arboricole s\'abattant sur la compagnie en piaillant et en s\'agitant pour une bouch??e !}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Chargez!",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "Apr??s la bataille...",
			Text = "[img]gfx/ui/events/event_123.png[/img]{Le dernier des webknechts est ??limin??, ses jambes s\'enroulent comme pour s\'accrocher ??ternellement ?? l\'arme qui l\'a tu??. Vous saluez d\'un signe de t??te le bon travail de la compagnie, puis ordonnez que l\'on mette le feu ?? tout l\'endroit. Les feux courent rapidement le long des toiles, brisant les ponts de filaments et envoyant des flammes vers leurs connecteurs. Le nid tout entier est consum?? par le brasier et quelque part au fond de sa toile, vous entendez le cri strident des araign??es incendi??es. | Vous vous approchez du dernier des webknechts et fixez sa gueule effroyable. Il porte un ensemble vicieux de mandibules comme une sorte de prot??ge-dents, la bouche elle-m??me est une fente bord??e de dents ac??r??es comme des rasoirs, pointant ?? contre-courant pour d??chiqueter tout ce qui tente de s\'??chapper.\n\n Vous ordonnez que l\'on mette tout le nid ?? feu. Alors que les flammes s\'??l??vent, on entend le cri des araign??es quelque part dans leurs refuges. | Vous ??tes pr??ts ?? retourner voir %employer%, mais il faut d\'abord que le nid soit enti??rement br??l??. La compagnie se tient devant les flammes, ??coutant les cris stridents des araign??es et riant parfois des petits insectes qui s\'agitent comme de minuscules boules de feu sur pattes. | Les araign??es vaincues, vous avez br??l?? tout cet endroit maudit et ??tes pr??t ?? retourner voir %employer%. Lorsque les feux s\'??l??vent, de minuscules araign??es sortent en courant, leurs corps enflamm??s comme des lucioles dans la nuit. Quelques mercenaires se lancent dans un jeu improvis?? pour voir qui peut en ??craser le plus, une affaire qui se termine avec une araign??e particuli??rement audacieuse qui met presque le feu au pantalon d\'un mercenaire.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Finissons-en avec ??a, nous avons des couronnes ?? collecter.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "OldArmor",
			Title = "Apr??s la bataille...",
			Text = "[img]gfx/ui/events/event_123.png[/img]{Une fois les webknechts ??limin??s, vous demandez ?? la compagnie de fouiller bri??vement le nid des cr??atures, bien que les mercenaires aient re??u l\'ordre de ne jamais se promener seuls. Vous vous ne perdez pas de temps et rentrer dans le nid, %randombrother% ?? vos c??t??s. Ensemble, vous rep??rez un arbre qui est remarquablement ??pargn?? par les toiles. En faisant le tour, vous trouvez le cadavre d\'un chevalier appuy?? contre son tronc. Sa main repose sur le pommeau d\'une ??p??e bris??e, l\'autre main est compl??tement absente, rien d\'autre qu\'une manche au poignet, le bras mutil?? ??tant pos?? sur son ventre. Le cadavre repose dans un nid de sa propre fabrication, un bosquet de ce qui ressemble ?? des tiges de rhubarbe g??t??es et des carapaces d??compos??es, les corps bris??s sont caverneux et sentent le poison. %randombrother% acquiesce.%SPEECH_ON%C\'est vraiment dommage. Je parie qu\'il aurait fait un bon ajout ?? %companyname%, qui qu\'il soit.%SPEECH_OFF%En effet, cela ressemble ?? la fin d\'un grand combattant. Vous avez envie de l\'enterrer, mais vous n\'avez pas le temps. Vous dites ?? %randombrother% de r??cup??rer ce qu\'il peut sur le cadavre et de se pr??parer pour retourner ?? %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Retour ?? %townname%!",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				local item;
				local r = this.Math.rand(1, 2);

				if (r == 1)
				{
					item = this.new("scripts/items/armor/decayed_reinforced_mail_hauberk");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/armor/decayed_coat_of_scales");
				}

				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous avez re??u " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Survivor",
			Title = "Apr??s la bataille...",
			Text = "[img]gfx/ui/events/event_123.png[/img]{La bataille termin??e, vous trouvez un homme suspendu par des sangles attach??es ?? ses pieds. La moiti?? de son corps est li??e aux filaments et d\'autres pendent de sa hanche comme une robe d??chir??e. Il semble que les araign??es l\'aient abandonn?? ?? l\'arriv??e de %companyname%. Il sourit en vous voyant.%SPEECH_ON%H?? l??. Des mercenaires, c\'est ??a ? Ouais, je peux le voir. Vous ne vous souciez pas d\'??tre ici, c\'est l\'argent qui vous a amen??, et vous vous ??tes battus comme des b??tards sur lesquels on avait pari??. Des sauvages absolus.%SPEECH_OFF%Vous demandez ?? l\'homme ce que vous obtiendrez pour le faire descendre. Il tourne la t??te vers le haut, son corps entier commen??ant alors ?? se balancer et parfois ?? s\'??loigner compl??tement de vous. Il parle, soit ?? vous, soit ?? quelque direction qu\'il regarde.%SPEECH_ON%Oui, bonne question ! Eh bien, vous ne le voyez peut-??tre pas ici et maintenant, mais je suis un mercenaire moi-m??me, et vous ne savez pas que ma compagnie et son capitaine ont tous ??t?? pendus et enti??rement d??vor??s par ces araign??es ! Si vous me sauvez, je n\'aurai pas d\'autre endroit o?? aller que votre compagnie. Enfin, si vous voulez de moi.%SPEECH_OFF%Vous faites lib??rer l\'homme et d??battez de ce qu\'il doit faire avant de retourner chez %employer%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bienvenue dans la compagnie !",
					function getResult()
					{
						this.World.getPlayerRoster().add(this.Contract.m.Dude);
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude.onHired();
						this.Contract.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "Tu vas devoir trouver ta chance ailleurs.",
					function getResult()
					{
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude = null;
						return 0;
					}

				}
			],
			function start()
			{
				local roster = this.World.getTemporaryRoster();
				this.Contract.m.Dude = roster.create("scripts/entity/tactical/player");
				this.Contract.m.Dude.setStartValuesEx([
					"retired_soldier_background"
				]);

				if (!this.Contract.m.Dude.getSkills().hasSkill("trait.fear_beasts") && !this.Contract.m.Dude.getSkills().hasSkill("trait.hate_beasts"))
				{
					this.Contract.m.Dude.getSkills().removeByID("trait.fearless");
					this.Contract.m.Dude.getSkills().add(this.new("scripts/skills/traits/fear_beasts_trait"));
				}

				this.Contract.m.Dude.getBackground().m.RawDescription = "Vous avez trouv?? %name% pendu ?? un arbre, le mercenaire, dernier survivant d\'une bande de mercenaires envoy??e pour tuer des webknechts. Il a rejoint la compagnie apr??s que vous l\'ayez sauv??.";
				this.Contract.m.Dude.getBackground().buildDescription(true);
				this.Contract.m.Dude.worsenMood(0.5, "Il a perdu son ancienne compagnie aux Webknechts");
				this.Contract.m.Dude.worsenMood(0.5, "Presque d??vor?? vivant par des webknechts");

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).setArmor(this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).getArmor() * 0.33);
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).setArmor(this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).getArmor() * 0.33);
				}

				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Success",
			Title = "?? votre retour...",
			Text = "[img]gfx/ui/events/event_85.png[/img]{%employer% vous rencontre ?? l\'entr??e de la ville et il y a une foule de gens ?? ses c??t??s. Il vous accueille chaleureusement, pr??cisant qu\'un ??claireur qui vous suivait a vu toute la bataille se d??rouler. Apr??s qu\'il vous ait remis votre r??compense, les habitants de la ville s\'avancent un par un, beaucoup d\'entre eux h??sitant ?? regarder un mercenaire dans les yeux, mais ils offrent quelques cadeaux en remerciement de les avoir soulag??s des horreurs qu\'??taient les webknechts. | Vous devez retrouver %employer%, pour finalement trouver l\'homme dans une ??curie ayant une affaire avec une paysanne. Il se fraye un chemin dans le foin, faisant sursauter les chevaux qui hennissent et tapent du pied. ?? moiti?? habill??, l\'homme d??clare qu\'il a d??j?? votre salaire et vous le donne. En vous regardant regarder la fille, il commence ?? prendre tout ce qui lui tombe sous la main, y compris les sacoches des chevaux ?? l\'??curie, et les lui donne.%SPEECH_ON%Les, euh, habitants de la ville ont aussi cherch?? ?? participer. Vous savez, en guise de remerciement.%SPEECH_OFF%Bien. Pour vous remercier, vous lui demandez s\'il peut vous donner ce qu\'il y a dans une sacoche ?? proximit??. | %employer% vous accueille en vous applaudissant et en se frottant les mains, comme si vous veniez apporter une dinde et non la preuve effrayante de votre victoire. Apr??s vous avoir pay?? la r??compense convenue, vous entendez des nouvelles surprenantes. Le maire d??clare que les biens d\'un citadin disparu n\'ont pas pu ??tre partag??s convenablement et, en guise de remerciement, vous ??tes libre de prendre ce qu\'il en reste.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Une chasse r??ussie.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Rid the town of webknechts");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Couronnes"
				});
				local food;
				local r = this.Math.rand(1, 3);

				if (r == 1)
				{
					food = this.new("scripts/items/supplies/cured_venison_item");
				}
				else if (r == 2)
				{
					food = this.new("scripts/items/supplies/pickled_mushrooms_item");
				}
				else if (r == 3)
				{
					food = this.new("scripts/items/supplies/roots_and_berries_item");
				}

				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Vous recevez " + food.getName()
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Target.getTile())]
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/disappearing_villagers_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.setAttackableByAI(true);
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}

		if (this.m.Home != null && !this.m.Home.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Home.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(3);
			}
		}
	}

	function onIsValid()
	{
		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Target != null && !this.m.Target.isNull())
		{
			_out.writeU32(this.m.Target.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		this.contract.onDeserialize(_in);
	}

});


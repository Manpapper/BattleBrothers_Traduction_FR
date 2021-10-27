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
					"Retournez à " + this.Contract.m.Home.getName()
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
			Title = "Negotiations",
			Text = "[img]gfx/ui/events/event_43.png[/img]{%employer% vous fait signe d\'entrer dans sa chambre. Vous remarquez qu\'il y a des hommes armés de fourches qui montent la garde en regardant fixement par les fenêtres, bien que l\'un d\'entre eux soit clairement endormi contre le mur. Vous demandez au maire de la ville ce qu\'il veut. Il va droit au but.%SPEECH_ON%Les habitants de l\'arrière-pays signalent que des monstruosités enlèvent des enfants, des chiens et autres. Je ne veux pas laisser de place à la paranoïa et à la superstition, mais il semble que ces rapports parlent d\'araignées. Webknechts comme mon père les appelait, et si c\'est vrai, il est probable qu\'ils aient un nid dans le coin et j\'ai besoin que vous le trouviez et le détruisiez. Etes-vous intéressé, mercenaire ?%SPEECH_OFF% | Vous trouvez %employer% qui tend une toile d\'araignée entre deux fourchettes. Il tourne l\'un des ustensiles et enroule la toile d\'araignée autour d\'une ficelle. En soupirant, il vous regarde enfin.%SPEECH_ON%Je n\'ai pas l\'intention d\'amener des mercenaires dans ces régions, mais je suis à bout de souffle ici. D\'énormes araignées sont dans les parages, volant le bétail, les animaux de compagnie. Une dame a signalé que son enfant avait été enlevé de son berceau, et qu\'il n\'y avait plus qu\'une toile d\'araignée à l\'endroit où il dormait. Je veux qu\'on s\'occupe de ces horribles créatures et qu\'on détruise leur nid. Avec une incitation appropriée, seriez-vous intéressé ?%SPEECH_OFF% | Vous arrivez chez %employer% et votre ombre seule fait sursauter l\'homme. Il se redresse à son bureau et hoche la tête.%SPEECH_ON%Ah, j\'en ai eu ma dose. Je ne me soucie pas de votre présence ici, mercenaire, bien que vous soyez assez effrayant, mais la rumeur autour de ces régions est que de grandes araignées sont en liberté. J\'ai des raisons de croire ces histoires, étant donné que je suis allé dans une ferme et que j\'ai vu les grandes toiles et le bétail dévoré. J\'ai besoin d\'un homme doté d\'une violence absolue, en vous parlant, et j\'ai besoin d\'un tel homme pour trouver le nid de monstres et y mettre fin. Êtes-vous intéressé ?%SPEECH_OFF%}",
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
					Text = "{Ça ne ressemble pas à notre genre de travail.}",
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
			Text = "[img]gfx/ui/events/event_25.png[/img]{Vous tombez sur une vache morte dont la chair est aspirée jusqu\'aux os, mais dont la peau ne porte aucun signe de séchage. %randombrother% s\'accroupit et passe son doigt parmi un certain nombre de plaies perforantes. Il acquiesce.%SPEECH_ON%Le travail d\'un webknecht, sans aucun doute. Je dirais qu\'ils l\'ont empoisonné et se sont ensuite nourris de son corps paralysé. Et un cadavre encore frais signifie qu\'ils sont proches...%SPEECH_OFF% | Vous trouvez un cadavre couvert de toiles appuyé contre un arbre isolé. Vous coupez les filaments. Le corps d\'un enfant s\'échappe et s\'effondre sur le sol. Son visage est collé à l\'os, un crâne blafard dont les globes oculaires ressortent des orbites profondes. La langue est tout aussi effacée et il n\'y a presque pas de nez. %randombrother%  crache et hoche la tête.%SPEECH_ON%Très bien. Nous sommes proches. Plutôt, ils sont proches. Si ça peut vous consoler, le garçon est mort avant d\'arriver ici. Les webknechts apportent du poison avec leurs piqûres et aucun enfant ne pourrait y survivre longtemps.%SPEECH_OFF%Eh bien, tant mieux. Il est temps pour les hommes de trouver ces monstres. | Vous trouvez un garçon caché sous une brouette renversée. Il refuse de sortir, sa petite tête regardant à l\'extérieur de l\'abri comme une perle d\'un coquillage. Vous lui demandez ce qu\'il fait. Il vous explique frénétiquement qu\'il se cache des araignées et que vous devez partir.%SPEECH_ON%Obtenez votre propre brouette. Celle-ci est à moi.%SPEECH_OFF% Brandissant votre épée, vous lui dites que ce sont les araignées que vous cherchez. Le garçon vous regarde fixement. Il acquiesce.%SPEECH_ON%C\'est une très mauvaise idée, monsieur. Et non, je n\'ai aucune idée de l\'endroit où ils sont allés. J\'étais ici avec une caravane et vous voyez une caravane ? Non, c\'est vrai, vous n\'en voyez pas parce qu\'il n\'y a plus que de la viande pour araignée maintenant, alors partez avant qu\'ils ne vous voient me parler !%SPEECH_OFF%La brouette se referme en claquant. Vous n\'avez pas l\'intention de la relever, mais vous lui donnez un bon coup de pied en partant.}",
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
			Text = "[img]gfx/ui/events/event_110.png[/img]{Le nid de webknechts est une fosse de terre enveloppée de blanc. À son bord se trouvent de fins filaments qui s\'agitent à la moindre brise. En faisant marcher votre compagnie vers l\'intérieur, la toile commence à prendre une sorte de forme civilisée, comme si vous arriviez d\'un arrière-pays hivernal, la nouveauté de sa création apparaissant dans ses pièges serrés : cerfs, chiens, cocons de taille humaine qui ne montrent aucun signe de vie, tous liés dans des cocons blancs comme des morceaux perdus sur un tapis pâle. Une ombre noire s\'avance derrière le domicile voilé, se mettant en avant avec ses jambes accroupies en défilade, sa tête recroquevillée au-delà, comme si cet immonde crétin était entravé par sa propre foulée. Une main humaine aspire et expire de ses mandibules comme une tétine macabre. Vous êtes au bon endroit. | Le nid de webknecht est silencieux et le fracas de l\'arrivée de la compagnie semble apocryphe, avec le tintement et le tintement des métaux bien nets avec leur intrusion.\n\n Vous trouvez un homme suspendu à l\'envers à un arbre, tout son corps est dans un cocon, sauf son visage qui est étiré et tiré par les filaments. Il vous demande de libérer ses paupières de la toile, ce que vous faites. Ses paupières se ferment lentement, la croûte de ses yeux secs se refermant pour la première fois depuis des jours. Mais ils s\'ouvrent brusquement et l\'homme hurle. Le cocon bouillonne à sa taille et se déchire, un crachotement de minuscules araignées noires en sort. Le corps de l\'homme s\'agite violemment tandis que l\'essaim le dévore, ses cris gargarisés par le scintillement des araignées qui remplissent ses poumons et qu\'il crache en mourant. Horrifié, vous reculez pour voir une foule d\'araignées beaucoup plus grosses sortir d\'autour des arbres ! | Le nid est un endroit facile à trouver, une étendue de paysage hivernal où il n\'y a pas de froid, les toiles blanches sont éparses et se dessinent sur chaque arbre, chaque bosquet, chaque centimètre carré de l\'endroit. Vous faites entrer la compagnie, armes à la main, et là, vous tombez sur les corps enveloppés, le centre ouvert et noirci, une invasion d\'araignées suçant leurs organes.\n\n Levant les yeux, vous voyez des yeux rouges s\'illuminer entre les branches des arbres environnants, tout l\'arboretum arachnidien s\'anime, ses gardiens perchés là au milieu des broussailles, leurs jambes accroupies indiscernables des branches, l\'ennemi se cachant à la vue de tous. Vous êtes à deux doigts de vous chier dessus lorsqu\'un supposé arbre se déploie entièrement, chaque tige de bois n\'étant plus qu\'une patte d\'araignée, le manège arboricole s\'abattant sur la compagnie en piaillant et en s\'agitant pour une bouchée !}",
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
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_123.png[/img]{Le dernier des webknechts est éliminé, ses jambes s\'enroulent comme pour s\'accrocher éternellement à l\'arme qui l\'a tué. Vous saluez d\'un signe de tête le bon travail de la compagnie, puis ordonnez que l\'on mette le feu à tout l\'endroit. Les feux courent rapidement le long des toiles, brisant les ponts de filaments et envoyant des flammes vers leurs connecteurs. Le nid tout entier est consumé par le brasier et quelque part au fond de sa toile, vous entendez le cri strident des araignées incendiées. | Vous vous approchez du dernier des webknechts et fixez sa gueule effroyable. Il porte un ensemble vicieux de mandibules comme une sorte de protège-dents, la bouche elle-même est une fente bordée de dents acérées comme des rasoirs, pointant à contre-courant pour déchiqueter tout ce qui tente de s\'échapper.\n\n Vous ordonnez que l\'on mette tout le nid à feu. Alors que les flammes s\'élèvent, on entend le cri des araignées quelque part dans leurs refuges. | Vous êtes prêts à retourner voir %employer%, mais il faut d\'abord que le nid soit entièrement brûlé. La compagnie se tient devant les flammes, écoutant les cris stridents des araignées et riant parfois des petits insectes qui s\'agitent comme de minuscules boules de feu sur pattes. | Les araignées vaincues, vous avez brûlé tout cet endroit maudit et êtes prêt à retourner voir %employer%. Lorsque les feux s\'élèvent, de minuscules araignées sortent en courant, leurs corps enflammés comme des lucioles dans la nuit. Quelques mercenaires se lancent dans un jeu improvisé pour voir qui peut en écraser le plus, une affaire qui se termine avec une araignée particulièrement audacieuse qui met presque le feu au pantalon d\'un mercenaire.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Finissons-en avec ça, nous avons des couronnes à collecter.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "OldArmor",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_123.png[/img]{Une fois les webknechts éliminés, vous demandez à la compagnie de fouiller brièvement le nid des créatures, bien que les mercenaires aient reçu l\'ordre de ne jamais se promener seuls. Vous vous ne perdez pas de temps et rentrer dans le nid, %randombrother% à vos côtés. Ensemble, vous repérez un arbre qui est remarquablement épargné par les toiles. En faisant le tour, vous trouvez le cadavre d\'un chevalier appuyé contre son tronc. Sa main repose sur le pommeau d\'une épée brisée, l\'autre main est complètement absente, rien d\'autre qu\'une manche au poignet, le bras mutilé étant posé sur son ventre. Le cadavre repose dans un nid de sa propre fabrication, un bosquet de ce qui ressemble à des tiges de rhubarbe gâtées et des carapaces décomposées, les corps brisés sont caverneux et sentent le poison. %randombrother% acquiesce.%SPEECH_ON%C\'est vraiment dommage. Je parie qu\'il aurait fait un bon ajout à %companyname%, qui qu\'il soit.%SPEECH_OFF%En effet, cela ressemble à la fin d\'un grand combattant. Vous avez envie de l\'enterrer, mais vous n\'avez pas le temps. Vous dites à %randombrother% de récupérer ce qu\'il peut sur le cadavre et de se préparer pour retourner à %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Retour à %townname%!",
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
					text = "Vous avez reçu " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Survivor",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_123.png[/img]{La bataille terminée, vous trouvez un homme suspendu par des sangles attachées à ses pieds. La moitié de son corps est liée aux filaments et d\'autres pendent de sa hanche comme une robe déchirée. Il semble que les araignées l\'aient abandonné à l\'arrivée de %companyname%. Il sourit en vous voyant.%SPEECH_ON%Hé là. Des mercenaires, c\'est ça ? Ouais, je peux le voir. Vous ne vous souciez pas d\'être ici, c\'est l\'argent qui vous a amené, et vous vous êtes battus comme des bâtards sur lesquels on avait parié. Des sauvages absolus.%SPEECH_OFF%Vous demandez à l\'homme ce que vous obtiendrez pour le faire descendre. Il tourne la tête vers le haut, son corps entier commençant alors à se balancer et parfois à s\'éloigner complètement de vous. Il parle, soit à vous, soit à quelque direction qu\'il regarde.%SPEECH_ON%Oui, bonne question ! Eh bien, vous ne le voyez peut-être pas ici et maintenant, mais je suis un mercenaire moi-même, et vous ne savez pas que ma compagnie et son capitaine ont tous été pendus et entièrement dévorés par ces araignées ! Si vous me sauvez, je n\'aurai pas d\'autre endroit où aller que votre compagnie. Enfin, si vous voulez de moi.%SPEECH_OFF%Vous faites libérer l\'homme et débattez de ce qu\'il doit faire avant de retourner chez %employer%.}",
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

				this.Contract.m.Dude.getBackground().m.RawDescription = "Vous avez trouvé %name% pendu à un arbre, le mercenaire, dernier survivant d\'une bande de mercenaires envoyée pour tuer des webknechts. Il a rejoint la compagnie après que vous l\'ayez sauvé.";
				this.Contract.m.Dude.getBackground().buildDescription(true);
				this.Contract.m.Dude.worsenMood(0.5, "Il a perdu son ancienne compagnie aux Webknechts");
				this.Contract.m.Dude.worsenMood(0.5, "Presque dévoré vivant par des webknechts");

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
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_85.png[/img]{%employer% vous rencontre à l\'entrée de la ville et il y a une foule de gens à ses côtés. Il vous accueille chaleureusement, précisant qu\'un éclaireur qui vous suivait a vu toute la bataille se dérouler. Après qu\'il vous ait remis votre récompense, les habitants de la ville s\'avancent un par un, beaucoup d\'entre eux hésitant à regarder un mercenaire dans les yeux, mais ils offrent quelques cadeaux en remerciement de les avoir soulagés des horreurs qu\'étaient les webknechts. | Vous devez retrouver %employer%, pour finalement trouver l\'homme dans une écurie ayant une affaire avec une paysanne. Il se fraye un chemin dans le foin, faisant sursauter les chevaux qui hennissent et tapent du pied. À moitié habillé, l\'homme déclare qu\'il a déjà votre salaire et vous le donne. En vous regardant regarder la fille, il commence à prendre tout ce qui lui tombe sous la main, y compris les sacoches des chevaux à l\'écurie, et les lui donne.%SPEECH_ON%Les, euh, habitants de la ville ont aussi cherché à participer. Vous savez, en guise de remerciement.%SPEECH_OFF%Bien. Pour vous remercier, vous lui demandez s\'il peut vous donner ce qu\'il y a dans une sacoche à proximité. | %employer% vous accueille en vous applaudissant et en se frottant les mains, comme si vous veniez apporter une dinde et non la preuve effrayante de votre victoire. Après vous avoir payé la récompense convenue, vous entendez des nouvelles surprenantes. Le maire déclare que les biens d\'un citadin disparu n\'ont pas pu être partagés convenablement et, en guise de remerciement, vous êtes libre de prendre ce qu\'il en reste.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Une chasse réussie.",
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


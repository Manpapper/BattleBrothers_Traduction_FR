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
			Text = "[img]gfx/ui/events/event_43.png[/img]{%employer% vous fait signe d'entrer dans sa chambre. Vous remarquez qu'il y a des hommes armés de fourches qui montent la garde en regardant fixement par les fenêtres, bien que l'un d'entre eux soit clairement endormi contre le mur. Vous demandez au maire de la ville ce qu'il veut. Il va droit au but.%SPEECH_ON%Les habitants de l'arrière-pays signalent que des monstruosités enlèvent des enfants, des chiens et autres. Je ne veux pas laisser de place à la paranoïa et à la superstition, mais il semble que ces rapports parlent d'araignées. Webknechts comme mon père les appelait, et si c'est vrai, il est probable qu'ils aient un nid dans le coin et j'ai besoin que vous le trouviez et le détruisiez. Etes-vous intéressé, mercenaire ?%SPEECH_OFF% | Vous trouvez %employer% qui tend une toile d'araignée entre deux fourchettes. Il tourne l'un des ustensiles et enroule la toile d'araignée autour d'une ficelle. En soupirant, il vous regarde enfin.%SPEECH_ON%Je n'ai pas l'intention d'amener des mercenaires dans ces régions, mais je suis à bout de souffle ici. D'énormes araignées sont dans les parages, volant le bétail, les animaux de compagnie. Une dame a signalé que son enfant avait été enlevé de son berceau, et qu'il n'y avait plus qu'une toile d'araignée à l'endroit où il dormait. Je veux qu'on s'occupe de ces horribles créatures et qu'on détruise leur nid. Avec une incitation appropriée, seriez-vous intéressé ?%SPEECH_OFF% | Vous arrivez chez %employer% et votre ombre seule fait sursauter l'homme. Il se redresse à son bureau et hoche la tête.%SPEECH_ON%Ah, j'en ai eu ma dose. Je ne me soucie pas de votre présence ici, mercenaire, bien que vous soyez assez effrayant, mais la rumeur autour de ces régions est que de grandes araignées sont en liberté. J'ai des raisons de croire ces histoires, étant donné que je suis allé dans une ferme et que j'ai vu les grandes toiles et le bétail dévoré. J'ai besoin d'un homme doté d'une violence absolue, en vous parlant, et j'ai besoin d'un tel homme pour trouver le nid de monstres et y mettre fin. Êtes-vous intéressé ?%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_25.png[/img]{Vous tombez sur une vache morte dont la chair est aspirée jusqu'aux os, mais dont la peau ne porte aucun signe de séchage. %randombrother% s'accroupit et passe son doigt parmi un certain nombre de plaies perforantes. Il acquiesce.%SPEECH_ON%Le travail d'un webknecht, sans aucun doute. Je dirais qu'ils l'ont empoisonné et se sont ensuite nourris de son corps paralysé. Et un cadavre encore frais signifie qu'ils sont proches...%SPEECH_OFF% | Vous trouvez un cadavre couvert de toiles appuyé contre un arbre isolé. Vous coupez les filaments. Le corps d'un enfant s'échappe et s'effondre sur le sol. Son visage est collé à l'os, un crâne blafard dont les globes oculaires ressortent des orbites profondes. La langue est tout aussi effacée et il n'y a presque pas de nez. %randombrother%  crache et hoche la tête.%SPEECH_ON%Très bien. Nous sommes proches. Plutôt, ils sont proches. Si ça peut vous consoler, le garçon est mort avant d'arriver ici. Les webknechts apportent du poison avec leurs piqûres et aucun enfant ne pourrait y survivre longtemps.%SPEECH_OFF%Eh bien, tant mieux. Il est temps pour les hommes de trouver ces monstres. | Vous trouvez un garçon caché sous une brouette renversée. Il refuse de sortir, sa petite tête regardant à l'extérieur de l'abri comme une perle d'un coquillage. Vous lui demandez ce qu'il fait. Il vous explique frénétiquement qu'il se cache des araignées et que vous devez partir.%SPEECH_ON%Obtenez votre propre brouette. Celle-ci est à moi.%SPEECH_OFF% Brandissant votre épée, vous lui dites que ce sont les araignées que vous cherchez. Le garçon vous regarde fixement. Il acquiesce.%SPEECH_ON%C'est une très mauvaise idée, monsieur. Et non, je n'ai aucune idée de l'endroit où ils sont allés. J'étais ici avec une caravane et vous voyez une caravane ? Non, c'est vrai, vous n'en voyez pas parce qu'il n'y a plus que de la viande pour araignée maintenant, alors partez avant qu'ils ne vous voient me parler !%SPEECH_OFF%La brouette se referme en claquant. Vous n'avez pas l'intention de la relever, mais vous lui donnez un bon coup de pied en partant.}",
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
			Text = "[img]gfx/ui/events/event_110.png[/img]{Le nid de webknechts est une fosse de terre enveloppée de blanc. À son bord se trouvent de fins filaments qui s'agitent à la moindre brise. En faisant marcher votre compagnie vers l'intérieur, la toile commence à prendre une sorte de forme civilisée, comme si vous arriviez d'un arrière-pays hivernal, la nouveauté de sa création apparaissant dans ses pièges serrés : cerfs, chiens, cocons de taille humaine qui ne montrent aucun signe de vie, tous liés dans des cocons blancs comme des morceaux perdus sur un tapis pâle. Une ombre noire s'avance derrière le domicile voilé, se mettant en avant avec ses jambes accroupies en défilade, sa tête recroquevillée au-delà, comme si cet immonde crétin était entravé par sa propre foulée. Une main humaine aspire et expire de ses mandibules comme une tétine macabre. Vous êtes au bon endroit. | Le nid de webknecht est silencieux et le fracas de l'arrivée de la compagnie semble apocryphe, avec le tintement et le tintement des métaux bien nets avec leur intrusion.\n\n Vous trouvez un homme suspendu à l'envers à un arbre, tout son corps est dans un cocon, sauf son visage qui est étiré et tiré par les filaments. Il vous demande de libérer ses paupières de la toile, ce que vous faites. Ses paupières se ferment lentement, la croûte de ses yeux secs se refermant pour la première fois depuis des jours. Mais ils s'ouvrent brusquement et l'homme hurle. Le cocon bouillonne à sa taille et se déchire, un crachotement de minuscules araignées noires en sort. Le corps de l'homme s'agite violemment tandis que l'essaim le dévore, ses cris gargarisés par le scintillement des araignées qui remplissent ses poumons et qu'il crache en mourant. Horrifié, vous reculez pour voir une foule d'araignées beaucoup plus grosses sortir d'autour des arbres ! | Le nid est un endroit facile à trouver, une étendue de paysage hivernal où il n'y a pas de froid, les toiles blanches sont éparses et se dessinent sur chaque arbre, chaque bosquet, chaque centimètre carré de l'endroit. Vous faites entrer la compagnie, armes à la main, et là, vous tombez sur les corps enveloppés, le centre ouvert et noirci, une invasion d'araignées suçant leurs organes.\n\n Levant les yeux, vous voyez des yeux rouges s'illuminer entre les branches des arbres environnants, tout l'arboretum arachnidien s'anime, ses gardiens perchés là au milieu des broussailles, leurs jambes accroupies indiscernables des branches, l'ennemi se cachant à la vue de tous. Vous êtes à deux doigts de vous chier dessus lorsqu'un supposé arbre se déploie entièrement, chaque tige de bois n'étant plus qu'une patte d'araignée, le manège arboricole s'abattant sur la compagnie en piaillant et en s'agitant pour une bouchée !}",
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
			Text = "[img]gfx/ui/events/event_123.png[/img]{Le dernier des webknechts est éliminé, ses jambes s'enroulent comme pour s'accrocher éternellement à l'arme qui l'a tué. Vous saluez d'un signe de tête le bon travail de la compagnie, puis ordonnez que l'on mette le feu à tout l'endroit. Les feux courent rapidement le long des toiles, brisant les ponts de filaments et envoyant des flammes vers leurs connecteurs. Le nid tout entier est consumé par le brasier et quelque part au fond de sa toile, vous entendez le cri strident des araignées incendiées. | Vous vous approchez du dernier des webknechts et fixez sa gueule effroyable. Il porte un ensemble vicieux de mandibules comme une sorte de protège-dents, la bouche elle-même est une fente bordée de dents acérées comme des rasoirs, pointant à contre-courant pour déchiqueter tout ce qui tente de s'échapper.\n\n Vous ordonnez que l'on mette tout le nid à feu. Alors que les flammes s'élèvent, on entend le cri des araignées quelque part dans leurs refuges. | Vous êtes prêts à retourner voir %employer%, mais il faut d'abord que le nid soit entièrement brûlé. La compagnie se tient devant les flammes, écoutant les cris stridents des araignées et riant parfois des petits insectes qui s'agitent comme de minuscules boules de feu sur pattes. | Les araignées vaincues, vous avez brûlé tout cet endroit maudit et êtes prêt à retourner voir %employer%. Lorsque les feux s'élèvent, de minuscules araignées sortent en courant, leurs corps enflammés comme des lucioles dans la nuit. Quelques mercenaires se lancent dans un jeu improvisé pour voir qui peut en écraser le plus, une affaire qui se termine avec une araignée particulièrement audacieuse qui met presque le feu au pantalon d'un mercenaire.}",
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
			Text = "[img]gfx/ui/events/event_123.png[/img]{With the webknechts dispatched you have the company briefly search the creatures\' nest, though the mercenaries are ordered to never wander alone. You muck about as well, %randombrother% at your side. Together, you spot a tree that\'s remarkably untouched by the webs. As you circle around, you find a knight\'s corpse leaning against its trunk. His hand rests atop a broken sword\'s pommel, the other hand is missing altogether, nothing but sleeve at the wrist with the mutilated arm couched at his belly. The corpse rests in a nest of its own making, a thicket of what look like spoiled rhubarb stalks and decayed carapaces, the broken bodies caverned and smelling of poison. %randombrother% nods.%SPEECH_ON%That\'s a right shame. I\'d wager he would have made a sound addition to the %companyname%, whoever he was.%SPEECH_OFF%Indeed, it has all the look of a great fighter\'s end. You\'ve mind to bury him, but you\'ve no time. You tell %randombrother% to fetch what he can from the corpse and to ready a Retournez à %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Back to %townname%!",
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
					text = "You gain a " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Survivor",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_123.png[/img]{The battle over, you find a man dangling by webbing attached to his feet. Half of his body is bound in the filaments and more dangle from his hip like a shredded dress. Seems the spiders deserted him upon the %companyname%\'s arrival. He smiles at the sight of you.%SPEECH_ON%Hey there. Mercenaries ain\'t ya? Yeah I see it. You\'ve no mind being here lest it was coin that brought ya, and you fought like bastards that\'d been bet on. Absolute savages.%SPEECH_OFF%You ask the man what you\'ll get for cutting him down. He turns his head up, his whole body then starting to swing about and at times twist him away from you entirely. He speaks, either to you or to whichever direction he\'s facing.%SPEECH_ON%Aye, good question! Well, you may not see it here and now, but I\'m a sellsword m\'self, and wouldn\'t you know that my company and its captain all been done stringed up and consumed whole by them spiders! Cut me down and I\'ve nowhere else better to go then your company. That is, if you\'d have me.%SPEECH_OFF%You have the man cut free and debate what to do before returning to %employer%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Welcome to the company!",
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
					Text = "You\'ll have to find your luck elsewhere.",
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

				this.Contract.m.Dude.getBackground().m.RawDescription = "You found %name% dangling from a tree, the sellsword the last survivor of a mercenary band sent to kill webknechts. He joined the company after you rescued him.";
				this.Contract.m.Dude.getBackground().buildDescription(true);
				this.Contract.m.Dude.worsenMood(0.5, "Lost his previous company to webknechts");
				this.Contract.m.Dude.worsenMood(0.5, "Almost consumed alive by webknechts");

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
			Text = "[img]gfx/ui/events/event_85.png[/img]{%employer% meets you at the town entrance and there\'s a crowd of folks beside him. He welcomes you warmly, stating he had a scout following you who saw the whole battle unfold. After he hands you your reward, the townsfolk come forward one by one, many of them reluctant to stare a sellsword in the eyes, but they offer a few gifts as thanks for relieving them of the webknecht horrors. | You have to track down %employer%, ultimately finding the man in a stable livery with a peasant girl. He saws upward from the hay, startling the horses which whinny and stamp their feet. Half-dressed, the man states he already has your pay and forks it over. Eyeing you eyeing the girl, he then starts to grab whatever\'s in reach, including from the saddlebags of stabled mounts, and hands them over.%SPEECH_ON%The, uh, townsfolk also sought to pitch in. You know, as thanks.%SPEECH_OFF%Right. For further \'thanks\' you ask if he\'ll give you whatever\'s in a nearby satchel. | %employer% welcomes you back with a great clap and rub of his hands, as though you\'d just brought in a turkey and not the horrifying evidence of your victory. After paying you the agreed reward, you hear some surprising news. The mayor states that the estate of a lost townsman could not be properly divvied up and, as further thanks, you\'re free to take what\'s left of it.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "A successful hunt.",
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
					text = "Recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Couronnes"
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
					text = "You gain " + food.getName()
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


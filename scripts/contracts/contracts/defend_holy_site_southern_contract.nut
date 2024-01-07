this.defend_holy_site_southern_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Target = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.defend_holy_site_southern";
		this.m.Name = "Defend Holy Site";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		if (this.m.Home == null)
		{
			this.setHome(this.World.State.getCurrentTown());
		}

		local sites = [
			"location.holy_site.oracle",
			"location.holy_site.meteorite",
			"location.holy_site.vulcano"
		];
		local locations = this.World.EntityManager.getLocations();
		local target;
		local targetIndex = 0;
		local closestDist = 9000;
		local myTile = this.m.Home.getTile();

		foreach( v in locations )
		{
			foreach( i, s in sites )
			{
				if (v.getTypeID() == s && v.getFaction() != 0 && this.World.FactionManager.isAllied(this.getFaction(), v.getFaction()))
				{
					local d = myTile.getDistanceTo(v.getTile());

					if (d < closestDist)
					{
						target = v;
						targetIndex = i;
						closestDist = d;
					}
				}
			}
		}

		this.m.Destination = this.WeakTableRef(target);
		this.m.Destination.setVisited(true);
		this.m.Payment.Pool = 1200 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
		local r = this.Math.rand(1, 2);

		if (r == 1)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else if (r == 2)
		{
			this.m.Payment.Completion = 1.0;
		}

		local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		local houses = [];

		foreach( n in nobles )
		{
			if (n.getFlags().get("IsHolyWarParticipant"))
			{
				houses.push(n);
			}
		}

		this.m.Flags.set("DestinationName", this.m.Destination.getName());
		this.m.Flags.set("DestinationIndex", targetIndex);
		this.m.Flags.set("EnemyID", houses[this.Math.rand(0, houses.len() - 1)].getID());
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Allez à %holysite% et défendez le contre les païens du Nord"
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 25)
				{
					this.Flags.set("IsAlchemist", true);
				}

				local r = this.Math.rand(1, 100);

				if (r <= 30)
				{
					this.Flags.set("IsSallyForth", true);
				}
				else if (r <= 60)
				{
					this.Flags.set("IsAlliedSoldiers", true);
				}

				local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
				local houses = [];

				foreach( n in nobles )
				{
					if (n.getFlags().get("IsHolyWarParticipant"))
					{
						n.addPlayerRelation(-99.0, "Took sides in the war");
						houses.push(n);
					}
				}

				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);

				if (this.Contract.getDifficultyMult() >= 0.95)
				{
					local f = houses[this.Math.rand(0, houses.len() - 1)];
					local candidates = [];

					foreach( s in f.getSettlements() )
					{
						if (s.isMilitary())
						{
							candidates.push(s);
						}
					}

					local party = f.spawnEntity(this.Contract.m.Destination.getTile(), candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly() + " Company", true, this.Const.World.Spawn.Noble, this.Math.rand(100, 150) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
					party.setDescription("Soldats professionnels au service des seigneurs locaux.");
					party.getLoot().Money = this.Math.rand(50, 200);
					party.getLoot().ArmorParts = this.Math.rand(0, 25);
					party.getLoot().Medicine = this.Math.rand(0, 3);
					party.getLoot().Ammo = this.Math.rand(0, 30);
					local r = this.Math.rand(1, 4);

					if (r == 1)
					{
						party.addToInventory("supplies/bread_item");
					}
					else if (r == 2)
					{
						party.addToInventory("supplies/roots_and_berries_item");
					}
					else if (r == 3)
					{
						party.addToInventory("supplies/dried_fruits_item");
					}
					else if (r == 4)
					{
						party.addToInventory("supplies/ground_grains_item");
					}

					local c = party.getController();
					local roam = this.new("scripts/ai/world/orders/roam_order");
					roam.setAllTerrainAvailable();
					roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
					roam.setTerrain(this.Const.World.TerrainType.Shore, false);
					roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
					roam.setPivot(this.Contract.m.Destination);
					roam.setMinRange(4);
					roam.setMaxRange(8);
					roam.setTime(300.0);
				}

				local entities = this.World.getAllEntitiesAtPos(this.Contract.m.Destination.getPos(), 1.0);

				foreach( e in entities )
				{
					if (e.isParty())
					{
						e.getController().clearOrders();
					}
				}

				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Flags.get("IsAlchemist") && this.Contract.isPlayerAt(this.Contract.m.Home) && this.World.Assets.getStash().getNumberOfEmptySlots() >= 2)
				{
					this.Contract.setScreen("Alchemist1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerAt(this.Contract.m.Destination))
				{
					this.Contract.setScreen("Approaching" + this.Flags.get("DestinationIndex"));
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Running_Defend",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Defendez %holysite% contre les païens du Nord",
					"Détruisez ou déroutez les régiments ennemis dans les alentours"
					"Ne vous éloignez pas trop"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
				}

				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Flags.get("IsFailure") || !this.Contract.isPlayerNear(this.Contract.m.Destination, 700) || !this.World.FactionManager.isAllied(this.Contract.getFaction(), this.Contract.m.Destination.getFaction()))
				{
					this.Contract.setScreen("Failure");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsSallyForthNextWave"))
				{
					this.Contract.setScreen("SallyForth3");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsVictory"))
				{
					if (!this.Contract.isEnemyPartyNear(this.Contract.m.Destination, 400.0))
					{
						this.Contract.setScreen("Victory");
						this.World.Contracts.showActiveContract();
					}
				}
				else if (!this.Flags.get("IsTargetDiscovered") && this.Contract.m.Target != null && !this.Contract.m.Target.isNull() && this.Contract.m.Target.isDiscovered())
				{
					this.Flags.set("IsTargetDiscovered", true);
					this.Contract.setScreen("TheEnemyAttacks");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsArrived") && this.Flags.get("AttackTime") > 0 && this.Time.getVirtualTimeF() >= this.Flags.get("AttackTime"))
				{
					if (this.Flags.get("IsSallyForth"))
					{
						this.Contract.setScreen("SallyForth1");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsAlliedSoldiers"))
					{
						this.Contract.setScreen("AlliedSoldiers1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Flags.set("AttackTime", 0.0);
						local party = this.Contract.spawnEnemy();
						party.setOnCombatWithPlayerCallback(this.Contract.getActiveState().onDestinationAttacked.bindenv(this));
						this.Contract.m.Target = this.WeakTableRef(party);
					}
				}
			}

			function onDestinationAttacked( _dest, _isPlayerInitiated = false )
			{
				if (this.Flags.get("IsSallyForthNextWave"))
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "DefendHolySite";
					p.Music = this.Const.Music.NobleTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.Entities = [];
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
					p.EnemyBanners = [
						this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
					];

					if (this.Flags.get("IsLocalsRecruited"))
					{
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.PeasantsSouthern, 10, this.Contract.getFaction());
						p.AllyBanners.push("banner_noble_11");
					}

					this.World.Contracts.startScriptedCombat(p, false, true, true);
				}
				else if (this.Flags.get("IsSallyForth"))
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "DefendHolySite";
					p.Music = this.Const.Music.NobleTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.Entities = [];
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, (this.Flags.get("IsEnemyReinforcements") ? 130 : 100) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
					p.EnemyBanners = [
						this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
					];

					if (this.Flags.get("IsLocalsRecruited"))
					{
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.PeasantsSouthern, 50, this.Contract.getFaction());
						p.AllyBanners.push("banner_noble_11");
					}

					this.World.Contracts.startScriptedCombat(p, false, true, true);
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
					p.LocationTemplate.OwnedByFaction = this.Const.Faction.Player;
					p.CombatID = "DefendHolySite";

					if (this.Contract.isPlayerAt(this.Contract.m.Destination))
					{
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Flags.get("IsPalisadeBuilt") ? this.Const.Tactical.FortificationType.WallsAndPalisade : this.Const.Tactical.FortificationType.Walls;
						p.LocationTemplate.CutDownTrees = true;
						p.LocationTemplate.ShiftX = -4;
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineForward;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];

						if (this.Flags.get("IsAlliedReinforcements"))
						{
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, 50 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
							p.AllyBanners.push(this.World.FactionManager.getFaction(this.Contract.getFaction()).getPartyBanner());
						}

						if (this.Flags.get("IsLocalsRecruited"))
						{
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.PeasantsSouthern, 50, this.Contract.getFaction());
							p.AllyBanners.push("banner_noble_11");
						}
					}

					this.World.Contracts.startScriptedCombat(p, false, true, true);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "DefendHolySite")
				{
					if (this.Flags.get("IsSallyForthNextWave"))
					{
						this.Flags.set("IsSallyForthNextWave", false);
						this.Flags.set("IsSallyForth", false);
						this.Flags.set("IsVictory", true);
					}
					else if (this.Flags.get("IsSallyForth"))
					{
						this.Flags.set("IsSallyForthNextWave", true);
					}
					else
					{
						this.Flags.set("IsVictory", true);
					}
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "DefendHolySite")
				{
					this.Flags.set("IsFailure", true);
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

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
				}
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
			Title = "Négociations",
			Text= "{[img]gfx/ui/events/event_163.png[/img]%employer% n\'est nulle part en vue. À la place, un homme en habits ecclésiastiques s\'approche avec un lieutenant général à ses côtés. Ils déclarent qu\'un contingent de soldats du nord approche de %holysite% dans le but de le prendre entièrement pour le Nord. Avec les soldats de la cité-état ailleurs, ils devront compter sur vous pour vous rendre rapidement sur les lieux et le défendre. Leur manière autoritaire de parler, combinée à une pointe d\'anxiété, fait sans aucun doute de cela une journée potentiellement enrichissante. | [img]gfx/ui/events/event_162.png[/img]Vous êtes poussé dans la chambre de %employer% et le Vizir vous fait signe de la tête et applaudit.%SPEECH_ON%Enfin, le petit Crownling est là, prêt à accomplir de grandes choses pour nous tous. Venez, regardez cette carte. Voyez-vous où sont mes hommes ? Et voyez-vous où se trouve %holysite% ? Et ici, les rats du nord... Ils sont près des terres sacrées et mes hommes loin. Vous, cependant, êtes ici, tout près, n\'est-ce pas ? Pour %reward% couronnes, je veux que vous Voyagez jusqu\'à %holysite% et le défendiez.%SPEECH_OFF%Le Vizir vous regarde avec un sourire chaleureux comme si ce n\'était pas une question, mais une demande si chargée d\'or qu\'elle aurait aussi bien pu être un ordre.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text= "{Le %companyname% peut vous aider avec cela. | Se défendre contre une armée du nord doit bien payer. | Je suis intéressé, Continuez.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text= "{Ça ne vaut pas le coup. | On est demandé autre part. | Je ne risquerai pas la compagnie contre les armées du nord.}",
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
			ID = "Approaching1",
			Title = "En vous approchant...",
			Text= "[img]gfx/ui/events/%illustration%.png[/img]{La grande caldeira a été en grande partie vidée de ses fidèles et occupants curieux. Même la plus légère suggestion de guerre a dispersé les croyants vers les abris de leurs prieurés respectifs. Après tout, il y aura un gagnant et un perdant dans les heures à venir. Un certain niveau de vigueur pourrait inciter les premiers à s\'adonner à un excès de vertu...}",
			Image = "",
			List = [],
			Options = [
				{
					Text= "Nous installerons notre campement ici.",
					function getResult()
					{
						return "Preparation1";
					}

				}
			],
			function start()
			{
				this.Flags.set("IsArrived", true);
			}

		});
		this.m.Screens.push({
			ID = "Approaching0",
			Title = "En vous approchant...",
			Text= "[img]gfx/ui/events/%illustration%.png[/img]{L\'Oracle n\'est pas tel que vous vous en souvenez = beaucoup des fidèles sont partis et les tambours de la guerre ont atteint le seuil du temple ancien. Peu importe. Vous n\'avez pas de visions à chercher ici, pas de rêves à démêler, seulement des cauchemars à offrir à vos ennemis.}",
			Image = "",
			List = [],
			Options = [
				{
					Text= "Nous installerons notre campement ici.",
					function getResult()
					{
						return "Preparation1";
					}

				}
			],
			function start()
			{
				this.Flags.set("IsArrived", true);
			}

		});
		this.m.Screens.push({
			ID = "Approaching2",
			Title = "En vous approchant...",
			Text= "[img]gfx/ui/events/%illustration%.png[/img]{Ironiquement, la cité nivelée qui se trouve sous la montagne à moitié soufflée semble enfin étrangement abandonnée. Peu des fidèles persistent, les autres étant partis bien avant que les troubles religieux n\'atteignent leurs cités de tentes et leur intrusion spirituelle.}",
			Image = "",
			List = [],
			Options = [
				{
					Text= "Nous installerons notre campement ici.",
					function getResult()
					{
						return "Preparation1";
					}

				}
			],
			function start()
			{
				this.Flags.set("IsArrived", true);
			}

		});
		this.m.Screens.push({
			ID = "Preparation1",
			Title = "À %holysite%",
			Text= "[img]gfx/ui/events/%illustration%.png[/img]{Vous pensez avoir érigé une défense modeste avec les positions que %holysite% peut offrir. Avec le peu de temps qui reste, il y a probablement au moins une tâche sérieuse que vous pouvez assigner à la %companyname% pour la mener à bien. C\'est simplement une question de savoir exactement ce qui conviendrait le mieux à la compagnie.}",
			Image = "",
			List = [],
			Options = [
				{
					Text= "Construire des palissades pour renforcer davantage les murs !",
					function getResult()
					{
						return "Preparation2";
					}

				},
				{
					Text= "Explorer ces lieux pour trouver tout ce qui pourrait nous être utile !",
					function getResult()
					{
						return "Preparation3";
					}

				},
				{
					Text= "Recruter certains des fidèles pour nous aider dans la défense !",
					function getResult()
					{
						return "Preparation4";
					}

				}
			],
			function start()
			{
				this.Contract.setState("Running_Defend");
			}

		});
		this.m.Screens.push({
			ID = "Preparation2",
			Title = "À %holysite%",
			Text= "[img]gfx/ui/events/%illustration%.png[/img]{En pillant le site sacré lui-même, que vous ne direz à personne que vous avez fait, et en fouillant à travers les biens abandonnés des fidèles, vous parvenez à rassembler assez de bois pour renforcer une série de murs qui entourent un coin de %holysite%. C\'est, à votre avis, le meilleur endroit par lequel un assaillant pourrait venir, et donc celui que vous voudrez défendre le plus.}",
			Image = "",
			List = [],
			Options = [
				{
					Text= "Maintenant, nous attendons.",
					function getResult()
					{
						this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
						return 0;
					}

				}
			],
			function start()
			{
				this.Flags.set("IsPalisadeBuilt", true);
			}

		});
		this.m.Screens.push({
			ID = "Preparation3",
			Title = "À %holysite%",
			Text= "[img]gfx/ui/events/%illustration%.png[/img]{Vous faites fouiller la région par les hommes à la recherche de fournitures de guerre. Une litanie d\'objets est pillée et entassée. Une fois que la totalité de %holysite% a été fouillée, vous et les hommes passez quelques minutes à déterminer ce qui serait le plus utile...}",
			Image = "",
			List = [],
			Options = [
				{
					Text= "Maintenant, nous attendons.",
					function getResult()
					{
						this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
						return 0;
					}

				}
			],
			function start()
			{
				for( local i = 0; i < 3; i = ++i )
				{
					local r = this.Math.rand(1, 12);
					local item;

					switch(r)
					{
					case 1:
						item = this.new("scripts/items/weapons/oriental/saif");
						break;

					case 2:
						item = this.new("scripts/items/tools/throwing_net");
						break;

					case 3:
						item = this.new("scripts/items/weapons/oriental/polemace");
						break;

					case 4:
						item = this.new("scripts/items/weapons/ancient/broken_ancient_sword");
						break;

					case 5:
						item = this.new("scripts/items/armor/ancient/ancient_mail");
						break;

					case 6:
						item = this.new("scripts/items/supplies/ammo_item");
						break;

					case 7:
						item = this.new("scripts/items/supplies/armor_parts_item");
						break;

					case 8:
						item = this.new("scripts/items/shields/ancient/tower_shield");
						break;

					case 9:
						item = this.new("scripts/items/loot/ancient_gold_coins_item");
						break;

					case 10:
						item = this.new("scripts/items/loot/silver_bowl_item");
						break;

					case 11:
						item = this.new("scripts/items/weapons/wooden_stick");
						break;

					case 12:
						item = this.new("scripts/items/helmets/oriental/spiked_skull_cap_with_mail");
						break;
					}

					if (item.getConditionMax() > 1)
					{
						item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(10, 50) * 0.01));
					}

					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "Vous recevez " + item.getName()
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Preparation4",
			Title = "À %holysite%",
			Text= "[img]gfx/ui/events/%illustration%.png[/img]{Les rares fidèles qui errent encore autour de %holysite% doivent être les plus fervents et zélés. Étant donné que vous représentez le sud, vous demandez à vos hommes de choisir quelques adeptes du Gilder et de leur demander de combattre pour leur Dieu. C\'est un outil de recrutement pratique s\'il en est un, et ils se hâtent de s\'armer et de suivre la formation la plus courte. Vous ne pouvez qu\'espérer qu\'ils seront utiles dans la bataille à venir.}",
			Image = "",
			List = [],
			Options = [
				{
					Text= "Maintenant, nous attendons.",
					function getResult()
					{
						this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
						return 0;
					}

				}
			],
			function start()
			{
				this.Flags.set("IsLocalsRecruited", true);
			}

		});
		this.m.Screens.push({
			ID = "TheEnemyAttacks",
			Title = "À %holysite%",
			Text = "[img]gfx/ui/events/event_78.png[/img]{L\'armée du nord est là. Ou du moins, ce qu\'il en reste. Avec une armure et des armes aussi lourdes, le long voyage a éclairci leurs rangs, mais ils semblent toujours constituer un défi considérable. Vous regardez %randombrother% qui hausse les épaules.%SPEECH_ON%{Mis à part le paysage, c\'est juste une autre bataille, n\'est-ce pas ? | Je sais que tout le monde va parler de conneries religieuses, mais franchement, c\'est juste un autre combat pour moi. Et j\'adore ça.}%SPEECH_OFF%En acquiesçant, vous tirez votre épée et ordonnez aux hommes d\'être prêts.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Prenez la formation !",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Alchemist1",
			Title = "À %townname%",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Un homme s\'approche de vous aux portes de %townname%. À en juger par les baudriers et phylactères follement colorés sur sa poitrine, c\'est un alchimiste. Il annonce qu\'il a été envoyé par le Vizir.%SPEECH_ON%Je suis un peu à court de matériel, mais j\'ai assez pour produire du contenu d\'une manière très spécifique, bien sûr, selon votre demande.%SPEECH_OFF%Il décrit ses solutions comme suit : des pots de feu, des pots flash ou des pots de fumée.}",
			Image = "",
			Banner = "",
			List = [],
			Options = [
				{
					Text = "Nous prendrons les pots de feu.",
					function getResult()
					{
						this.Flags.set("IsFirepot", true);
						return "Alchemist2";
					}

				},
				{
					Text = "Nous prendrons les pots flash.",
					function getResult()
					{
						this.Flags.set("IsFlashpot", true);
						return "Alchemist2";
					}

				},
				{
					Text = "Nous prendrons les pots de fumée.",
					function getResult()
					{
						this.Flags.set("IsSmokepot", true);
						return "Alchemist2";
					}

				},
				{
					Text = "Nous avons tout ce dont nous avons besoin.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Flags.set("IsAlchemist", false);
				this.Banner = this.World.FactionManager.getFaction(this.Contract.getFaction()).getUIBanner();
			}

		});
		this.m.Screens.push({
			ID = "Alchemist2",
			Title = "À %townname%",
			Text = "[img]gfx/ui/events/event_163.png[/img]{L\'alchimiste travaille rapidement, versant une pile entière d\'ingrédients en poudre dans un bol et écrasant ensuite un éparpillement de matériaux que vous ne pouvez même pas reconnaître. Cela prend un temps étonnamment court, et vous n\'êtes pas sûr si c\'est parce qu\'il est si talentueux ou si toute cette chose est une farce. Quoi qu\'il en soit, il vous remet les pots comme promis.%SPEECH_ON%Que le Gilder fasse briller la lumière sur votre chemin, et que vos épées ramènent la paix à %holysite%.%SPEECH_OFF%}",
			Image = "",
			Banner = "",
			List = [],
			Options = [
				{
					Text = "Ces pots seront utiles.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Banner = this.World.FactionManager.getFaction(this.Contract.getFaction()).getUIBanner();

				for( local i = 0; i < 2; i = ++i )
				{
					local item;

					if (this.Flags.get("IsFirepot"))
					{
						item = this.new("scripts/items/tools/fire_bomb_item");
					}
					else if (this.Flags.get("IsFlashpot"))
					{
						item = this.new("scripts/items/tools/daze_bomb_item");
					}
					else if (this.Flags.get("IsSmokepot"))
					{
						item = this.new("scripts/items/tools/smoke_bomb_item");
					}

					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "Vous recevez a " + item.getName()
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "SallyForth1",
			Title = "À %holysite%",
			Text = "[img]gfx/ui/events/event_78.png[/img]{Les Nordiques apparaissent, mais ce n\'est pas en force complète, et ce ne sont pas nécessairement que leurs éclaireurs. Il semble qu\'ils aient peu pris le temps de maintenir la cohésion et se soient plutôt dispersés dans leur approche. Si vous deviez sortir en force et attaquer maintenant, vous les surprendriez probablement dans une posture vulnérable.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous devons saisir cette opportunité. Préparez les hommes à sortir en force !",
					function getResult()
					{
						return this.Math.rand(1, 100) <= 50 ? "SallyForth2" : "SallyForth4";
					}

				},
				{
					Text = "Nous avons une position défendable ici. Nous restons en place.",
					function getResult()
					{
						return "SallyForth5";
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "SallyForth2",
			Title = "À %holysite%",
			Text = "[img]gfx/ui/events/event_156.png[/img]{%SPEECH_START%Bien parlé.%SPEECH_OFF%Les paroles de %randombrother% suivent votre ordre. Partant à un rythme rapide, le %companyname% se met en route pour surprendre les Nordiques avant qu\'ils ne rassemblent leur pleine force. Vous traversez le champ et, avant même de vous en rendre compte, vous êtes sur eux. Ils déchargent encore leur équipement et, à la simple vue de vous, quelques suiveurs de camp s\'enfuient pour sauver leur vie. Le reste des soldats se dépêche de récupérer leurs armes. À en juger par sa voix aiguë, le seul commandant dans la région n\'est pas formé pour ce genre de chose, car sa voix se brise à chaque ordre aboyé alors qu\'une sorte de formation tente de prendre forme. Ne perdant pas plus de temps, vous chargez dans la mêlée !}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Chargez !",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "SallyForth3",
			Title = "À %holysite%",
			Text = "[img]gfx/ui/events/event_90.png[/img]{Vous achevez les derniers soldats, la surprise toujours figée sur leur visage.%SPEECH_ON%Capitaine, les autres arrivent.%SPEECH_OFF%%randombrother% dit en revenant d\'un rapide coup d\'œil à l\'horizon. En acquiesçant, vous ordonnez aux hommes de se préparer. Cette fois, les Nordiens s\'approchent en bonne formation, bien qu\'elle vacille brièvement à la vue de vous et des cadavres jonchant le sol. Leur bannière s\'élève dans le ciel, et les Nordiens sont revigorés, chargeant avec colère et énergie. Vous regardez %randombrother% et retirez un morceau d\'organe de son épaule. Quand il vous regarde à nouveau, vous souriez simplement.%SPEECH_ON%Le plaisir est là, autant bien paraître pour lui.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Rassemblez-vous ! Préparez-vous !",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "SallyForth4",
			Title = "À %holysite%",
			Text = "[img]gfx/ui/events/event_78.png[/img]{%SPEECH_START%Bonne décision.%SPEECH_OFF%Les paroles de %randombrother% suivent votre ordre. À un rythme rapide, la %companyname% se met en route pour rattraper les Nordiens avant qu\'ils ne rassemblent leur force totale. Vous traversez le champ et, avant même de vous en rendre compte, vous êtes sur eux. Ils déchargent encore du matériel et des équipements, et à votre simple vue, quelques suiveurs de camp s\'enfuient pour sauver leur vie. Le reste des soldats se presse pour récupérer leurs armes. Juste au moment où vous pensez avoir l\'avantage, une autre unité arrive sur le côté.%SPEECH_ON%Nom de Dieu, c\'est presque tout le lot.%SPEECH_OFF%%randombrother% dit. Les défenses sont trop loin, et l\'ennemi trop proche. Il n\'y a plus qu\'un seul endroit où aller. Vous levez votre épée et préparez les hommes à charger.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous allons nous battre pour nous en sortir !",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			],
			function start()
			{
				this.Flags.set("IsEnemyReinforcements", true);
			}

		});
		this.m.Screens.push({
			ID = "SallyForth5",
			Title = "À %holysite%",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{Vous estimez qu\'il est préférable de manœuvrer les défenses. Cela pourrait laisser passer une opportunité, mais c\'est en partie la option la plus sûre parmi toutes celles disponibles.%SPEECH_ON%On aurait dû sortir. On a manqué quelque chose là-dessus, capitaine.%SPEECH_OFF%En regardant autour de vous, vous voyez %randombrother% hausser les épaules. Vous lui dites de surveiller sa langue, sinon il risque de perdre quelque chose lui-même.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Tout le monde, préparez-vous. Ils attaqueront bientôt en force.",
					function getResult()
					{
						this.Flags.set("IsSallyForth", false);
						this.Flags.set("AttackTime", 1.0);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "AlliedSoldiers1",
			Title = "À %holysite%",
			Text = "[img]gfx/ui/events/event_164.png[/img]{En attendant les Nordiques, un petit groupe de soldats du sud vous surprend presque. Heureusement, ils sont toujours de votre côté et offrent leurs services.%SPEECH_ON%Le Gilder nous a dit que vous seriez ici, et bien que vous soyez un Couronné, nous nous soumettrons à votre commandement pour défendre ce lieu dans Sa gloire.%SPEECH_OFF%À en juger par leur équipement, ils seraient mieux utilisés comme une force d\'écran pour peut-être attirer des éléments de la force ennemie imminente. Ou peut-être serait-il préférable de les intégrer simplement dans le %companyname% pour l\'instant, renforçant vos rangs là où vous êtes déjà le plus fort.}",
			Image = "",
			Banner = "",
			List = [],
			Options = [
				{
					Text = "J\'ai besoin que vous et vos hommes contourniez leurs arbalétriers, lieutenant.",
					function getResult()
					{
						this.Flags.set("IsEnemyLuredAway", true);
						this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
						return "AlliedSoldiers2";
					}

				},
				{
					Text = "J\'ai besoin que vous et vos hommes attiriez certains de leurs fantassins, lieutenant.",
					function getResult()
					{
						this.Flags.set("IsEnemyLuredAway", true);
						this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
						return "AlliedSoldiers2";
					}

				},
				{
					Text = "J\'ai besoin que vous et vos hommes combattiez à nos côtés, lieutenant.",
					function getResult()
					{
						this.Flags.set("IsAlliedReinforcements", true);
						this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
						return "AlliedSoldiers3";
					}

				}
			],
			function start()
			{
				this.Banner = this.World.FactionManager.getFaction(this.Contract.getFaction()).getUIBanner();
				this.Flags.set("IsAlliedSoldiers", false);
			}

		});
		this.m.Screens.push({
			ID = "AlliedSoldiers2",
			Title = "À %holysite%",
			Text = "[img]gfx/ui/events/event_164.png[/img]{Vous sortez une longue-vue et examinez le champ de bataille devant vous. Les soldats du sud se dispersent comme des fourmis et entrent en escarmouche avec les Nordiques. À votre grande surprise, la feinte fonctionne. En souriant, vous regardez les troupes du nord se diviser et partir à la poursuite, affaiblissant leurs rangs dans le processus.}",
			Image = "",
			Banner = "",
			List = [],
			Options = [
				{
					Text = "Très bien.",
					function getResult()
					{
						this.Flags.set("IsAlliedSoldiers", false);
						this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
						return 0;
					}

				}
			],
			function start()
			{
				this.Banner = this.World.FactionManager.getFaction(this.Contract.getFaction()).getUIBanner();
			}

		});
		this.m.Screens.push({
			ID = "AlliedSoldiers3",
			Title = "À %holysite%",
			Text = "[img]gfx/ui/events/event_164.png[/img]{Vous préférez que les soldats restent avec vous. Le lieutenant hoche la tête.%SPEECH_ON%Le Gilder nous a fait confiance pour vous aider, et que vous le croyiez ou non, Il a aussi confiance en vous.%SPEECH_OFF%D\'accord. Bien sûr. Vous leur dites où aller et ils s\'y mettent avec une obéissance agaçante et religieuse, parlant sans fin d\'or et de lumières, et ainsi de suite.}",
			Image = "",
			List = [],
			Banner = "",
			Options = [
				{
					Text = "Maintenant, nous attendons à nouveau.",
					function getResult()
					{
						this.Flags.set("IsAlliedSoldiers", false);
						this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
						return 0;
					}

				}
			],
			function start()
			{
				this.Banner = this.World.FactionManager.getFaction(this.Contract.getFaction()).getUIBanner();
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_87.png[/img]{Le dernier norrois vivant est à terre, une blessure à la poitrine, du sang sur le sol. Il a un regard long dans les yeux et respire calmement, avec un sentiment que c\'est la fin des choses. Vous sortez votre épée mais il tend la main. Non pas pour demander grâce, mais pour un moment.%SPEECH_ON%Pas besoin de ça. Je le vois déjà. Ça s\'en va. Et ça s\'en va. Je ne sais pas pourquoi ça m\'importait autant.%SPEECH_OFF%Il s\'affaisse et sa main se relâche, tombant de sa poitrine. %randombrother% pique le cadavre, puis le pille. Vous remettez votre épée au fourreau et dites aux hommes de se préparer pour un retour chez le Vizir. | Vos hommes achèvent les derniers survivants. C\'est surtout une question de transpercer rapidement les cadavres d\'un ou deux coups. Certains corps bougent encore, mais vous savez qu\'ils sont partis. Vous ne savez pas pourquoi ils bougent encore comme ça, comme si l\'homme qui était autrefois avait laissé sa peur derrière lui. D\'autres ne réagissent pas du tout. Il y a un cri d\'un soldat qui a essayé de se cacher, mais il est rapidement réduit au silence. Avec le champ jonché de vaincus, vous dites au %companyname% d\'aller piller ce qu\'ils peuvent et de se préparer pour un voyage de retour chez le Vizir. | Un dernier norrois s\'est coincé entre la cale de deux rochers, ses mains écartées sur les côtés comme une araignée reculant dans son trou caché.%SPEECH_ON%Que les vieux dieux n\'aient pas pitié de vous tous.%SPEECH_OFF%Une ombre apparaît brièvement et disparaît d\'en haut, puis le rocher qui l\'a manifestée suit et écrase la tête de l\'homme. Il tombe au sol, le corps s\'agitant, la bouche gargouillant. %randombrother% regarde du sommet des deux rochers.%SPEECH_ON%C\'est le dernier d\'entre eux. Nous devrions prendre leurs affaires et retourner à euh, ce gars-là, celui avec la pompe, le viz... vis... vicomte ?%SPEECH_OFF%Vizir. Mais c\'est assez proche.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Victoire !",
					function getResult()
					{
						this.Contract.spawnAlly();
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Failure",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{Eh bien, %holysite% appartient maintenant aux norrois. Étant donné que vous attachez une grande valeur à votre propre tête et que vous souhaitez la conserver, vous ne voyez aucun intérêt à retourner chez le Vizir pour le moment.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Désastre !",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to defend a holy site");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Success",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% est trouvé dans un petit prieuré loin de son palais. C\'est un endroit inhabituel pour le trouver, et il y a seulement une petite foule de fidèles appauvris à ses pieds, écoutant ce qu\'il dit. Le Vizir jette un coup d\'œil à vous, puis, en plein discours, fait un signe de tête à quelqu\'un d\'autre. Un instant plus tard, un homme barbu avec deux épées s\'approche. Il vous regarde de haut en bas, puis se déplace pour révéler deux serviteurs portant un coffre.%SPEECH_ON%Le Vizir souhaite vous remercier, Couronné. Et puissiez-vous voyager éternellement sur le chemin doré.%SPEECH_OFF%Bien sûr, vous êtes immédiatement renvoyé dès que l\'argent est transféré. Pas un signe de tête ou de vague de la part du Vizir alors que les portes se referment derrière vous. | On vous conduit le long d\'un long couloir et vous êtes conduit dans une pièce vide. Pendant un moment, vous vous demandez si vous êtes censé être trahi ici. Les trahisons viennent rarement dans des endroits où un gâchis serait indésirable. Tandis que vous fixez le sol en pierre propre, %employer% entre par l\'autre côté. Il se tient à plusieurs pieds de distance et la pièce fait écho à sa voix.%SPEECH_ON%On dit que vous avez bien combattu et que les Norrois se sont montrés des chiens aigus au combat. J\'imagine que cette dernière affirmation est un mensonge destiné à induire mon bonheur personnel. Mais je suis un penseur et un réaliste. J\'imagine que vous avez trouvé la détermination de l\'ennemi tout aussi redoutable, tout comme ils trouveraient la nôtre. Vous serez récompensé selon notre prix convenu, Couronné.%SPEECH_OFF%Un groupe d\'hommes entre soudainement dans la pièce derrière le Vizir et, encore une fois, vous vous demandez s\'ils sont là pour un autre but. À votre grand soulagement, ils portent avec eux des bourses pleines de pièces. Lorsque vous regardez vers la porte, %employer% a disparu et un moment plus tard, ses serviteurs ont également disparu. | %employer% vous accueille dans une pièce avec lui-même et quelques figures religieuses sélectionnées. Chacun de ces modestes prieurs vient et s\'incline brièvement devant vous. Le Vizir ne participe pas, mais il fait claquer des doigts et ses serviteurs traînent une grande malle de couronnes. Enfin, les hommes religieux se tournent vers le Vizir et, dans une procession similaire, s\'inclinent devant lui. Ils embrassent aussi ses pieds et un anneau, des choses qui ne sont pas au programme pour vous. %employer% parle.%SPEECH_ON%Mon chemin a toujours été doré, Couronné. Pour que le Gilder m\'accorde une telle connaissance et que vous, un modeste mercenaire que beaucoup négligeraient, soyez celui que j\'engage pour épargner %holysite%. Je suis béni. Vraiment.%SPEECH_OFF%Vous prenez l\'or et partez, et la dernière chose que vous voyez sont les hommes en froc revenant pour des secondes.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Des couronnes bien méritées.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Defended a holy site");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isHolyWar())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCriticalContract);
						}

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
			}

		});
	}

	function spawnAlly()
	{
		local o = this.m.Destination.getTile().SquareCoords;
		local tiles = [];

		for( local x = o.X - 4; x < o.X + 4; x = ++x )
		{
			for( local y = o.Y - 6; y <= o.Y - 3; y = ++y )
			{
				if (!this.World.isValidTileSquare(x, y))
				{
				}
				else
				{
					local tile = this.World.getTileSquare(x, y);

					if (tile.Type == this.Const.World.TerrainType.Ocean)
					{
					}
					else
					{
						local s = this.Math.rand(0, 3);

						if (tile.Type == this.Const.World.TerrainType.Mountains)
						{
							s = s - 10;
						}

						if (tile.HasRoad)
						{
							s = s + 10;
						}

						tiles.push({
							Tile = tile,
							Score = s
						});
					}
				}
			}
		}

		if (tiles.len() == 0)
		{
			tiles.push({
				Tile = this.m.Destination.getTile(),
				Score = 0
			});
		}

		tiles.sort(function ( _a, _b )
		{
			if (_a.Score > _b.Score)
			{
				return -1;
			}
			else if (_a.Score < _b.Score)
			{
				return 1;
			}

			return 0;
		});
		local f = this.World.FactionManager.getFaction(this.getFaction());
		local candidates = [];

		foreach( s in f.getSettlements() )
		{
			candidates.push(s);
		}

		local party = f.spawnEntity(tiles[0].Tile, "Regiment of " + candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly(), true, this.Const.World.Spawn.Southern, this.Math.rand(100, 150) * this.getScaledDifficultyMult());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
		party.setDescription("Soldats enrôlés fidèles à leur cité-état.");
		party.getLoot().Money = this.Math.rand(50, 200);
		party.getLoot().ArmorParts = this.Math.rand(0, 25);
		party.getLoot().Medicine = this.Math.rand(0, 3);
		party.getLoot().Ammo = this.Math.rand(0, 30);
		local r = this.Math.rand(1, 4);

		if (r <= 2)
		{
			party.addToInventory("supplies/rice_item");
		}
		else if (r == 3)
		{
			party.addToInventory("supplies/dates_item");
		}
		else if (r == 4)
		{
			party.addToInventory("supplies/dried_lamb_item");
		}

		local c = party.getController();
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(this.m.Destination.getTile());
		c.addOrder(move);
		local guard = this.new("scripts/ai/world/orders/guard_order");
		guard.setTarget(this.m.Destination.getTile());
		guard.setTime(240.0);
		c.addOrder(guard);
		return party;
	}

	function spawnEnemy()
	{
		local cityState = this.World.FactionManager.getFaction(this.getFaction());
		local o = this.m.Destination.getTile().SquareCoords;
		local tiles = [];

		for( local x = o.X - 4; x < o.X + 4; x = ++x )
		{
			for( local y = o.Y + 4; y <= o.Y + 6; y = ++y )
			{
				if (!this.World.isValidTileSquare(x, y))
				{
				}
				else
				{
					local tile = this.World.getTileSquare(x, y);

					if (tile.Type == this.Const.World.TerrainType.Ocean)
					{
					}
					else
					{
						local s = this.Math.rand(0, 3);

						if (tile.Type == this.Const.World.TerrainType.Mountains)
						{
							s = s - 10;
						}

						if (tile.HasRoad)
						{
							s = s + 10;
						}

						tiles.push({
							Tile = tile,
							Score = s
						});
					}
				}
			}
		}

		if (tiles.len() == 0)
		{
			tiles.push({
				Tile = this.m.Destination.getTile(),
				Score = 0
			});
		}

		tiles.sort(function ( _a, _b )
		{
			if (_a.Score > _b.Score)
			{
				return -1;
			}
			else if (_a.Score < _b.Score)
			{
				return 1;
			}

			return 0;
		});
		local f = this.World.FactionManager.getFaction(this.m.Flags.get("EnemyID"));
		local candidates = [];

		foreach( s in f.getSettlements() )
		{
			if (s.isMilitary())
			{
				candidates.push(s);
			}
		}

		local party = f.spawnEntity(tiles[0].Tile, candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly() + " Company", true, this.Const.World.Spawn.Noble, (this.m.Flags.get("IsEnemyLuredAway") ? 130 : 160) * this.getDifficultyMult() * this.getScaledDifficultyMult());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
		party.setDescription("Soldats professionnels au service des seigneurs locaux.");
		party.setAttackableByAI(false);
		party.setAlwaysAttackPlayer(true);
		party.getLoot().Money = this.Math.rand(50, 200);
		party.getLoot().ArmorParts = this.Math.rand(0, 25);
		party.getLoot().Medicine = this.Math.rand(0, 3);
		party.getLoot().Ammo = this.Math.rand(0, 30);
		local r = this.Math.rand(1, 4);

		if (r == 1)
		{
			party.addToInventory("supplies/bread_item");
		}
		else if (r == 2)
		{
			party.addToInventory("supplies/roots_and_berries_item");
		}
		else if (r == 3)
		{
			party.addToInventory("supplies/dried_fruits_item");
		}
		else if (r == 4)
		{
			party.addToInventory("supplies/ground_grains_item");
		}

		local c = party.getController();
		local attack = this.new("scripts/ai/world/orders/attack_zone_order");
		attack.setTargetTile(this.m.Destination.getTile());
		c.addOrder(attack);
		local occupy = this.new("scripts/ai/world/orders/occupy_order");
		occupy.setTarget(this.m.Destination);
		occupy.setTime(10.0);
		occupy.setSafetyOverride(true);
		c.addOrder(occupy);
		local guard = this.new("scripts/ai/world/orders/guard_order");
		guard.setTarget(this.m.Destination.getTile());
		guard.setTime(999.0);
		c.addOrder(guard);
		return party;
	}

	function onPrepareVariables( _vars )
	{
		local illustrations = [
			"event_152",
			"event_154",
			"event_151"
		];
		_vars.push([
			"illustration",
			illustrations[this.m.Flags.get("DestinationIndex")]
		]);
		_vars.push([
			"holysite",
			this.m.Flags.get("DestinationName")
		]);
		_vars.push([
			"employerfaction",
			this.World.FactionManager.getFaction(this.m.Faction).getName()
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
			}

			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isHolyWar())
		{
			return false;
		}

		local sites = [
			"location.holy_site.oracle",
			"location.holy_site.meteorite",
			"location.holy_site.vulcano"
		];
		local locations = this.World.EntityManager.getLocations();

		foreach( v in locations )
		{
			foreach( i, s in sites )
			{
				if (v.getTypeID() == s && v.getFaction() != 0 && this.World.FactionManager.isAllied(this.getFaction(), v.getFaction()))
				{
					return true;
				}
			}
		}

		return false;
	}

	function onIsTileUsed( _tile )
	{
		if (this.m.Destination != null && !this.m.Destination.isNull() && _tile.ID == this.m.Destination.getTile().ID)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		if (this.m.Destination != null && !this.m.Destination.isNull())
		{
			_out.writeU32(this.m.Destination.getID());
		}
		else
		{
			_out.writeU32(0);
		}

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
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		this.contract.onDeserialize(_in);
	}

});


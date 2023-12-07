this.defend_holy_site_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Target = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.defend_holy_site";
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
		this.m.Payment.Pool = 1250 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
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

		local cityStates = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState);
		this.m.Flags.set("DestinationName", this.m.Destination.getName());
		this.m.Flags.set("DestinationIndex", targetIndex);
		this.m.Flags.set("EnemyID", cityStates[this.Math.rand(0, cityStates.len() - 1)].getID());
		this.m.Flags.set("MapSeed", this.Time.getRealTime());
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Allez à %holysite% et défendez le contre les païens du Sud"
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

				if (r <= 25)
				{
					this.Flags.set("IsQuartermaster", true);
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

				local cityStates = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState);

				foreach( c in cityStates )
				{
					c.addPlayerRelation(-99.0, "Took sides in the war");
				}

				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);

				if (this.Contract.getDifficultyMult() >= 0.95)
				{
					local cityState = cityStates[this.Math.rand(0, cityStates.len() - 1)];
					local party = cityState.spawnEntity(this.Contract.m.Destination.getTile(), "Regiment of " + cityState.getNameOnly(), true, this.Const.World.Spawn.Southern, this.Math.rand(100, 150) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + cityState.getBannerString());
					party.setDescription("Conscripted soldiers loyal to their city state.");
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
				if (this.Flags.get("IsQuartermaster") && this.Contract.isPlayerAt(this.Contract.m.Home) && this.World.Assets.getStash().getNumberOfEmptySlots() >= 3)
				{
					this.Contract.setScreen("Quartermaster");
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
					"Defendez %holysite% contre les païens du Sud",
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
					p.Music = this.Const.Music.OrientalCityStateTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.Entities = [];
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
					p.EnemyBanners = [
						this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
					];

					if (this.Flags.get("IsLocalsRecruited"))
					{
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.PeasantsArmed, 10, this.Contract.getFaction());
						p.AllyBanners.push("banner_noble_11");
					}

					this.World.Contracts.startScriptedCombat(p, false, true, true);
				}
				else if (this.Flags.get("IsSallyForth"))
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "DefendHolySite";
					p.Music = this.Const.Music.OrientalCityStateTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.Entities = [];
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, (this.Flags.get("IsEnemyReinforcements") ? 130 : 100) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyID"));
					p.EnemyBanners = [
						this.World.FactionManager.getFaction(this.Flags.get("EnemyID")).getPartyBanner()
					];

					if (this.Flags.get("IsLocalsRecruited"))
					{
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.PeasantsArmed, 50, this.Contract.getFaction());
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
						p.MapSeed = this.Flags.getAsInt("MapSeed");
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Flags.get("IsPalisadeBuilt") ? this.Const.Tactical.FortificationType.WallsAndPalisade : this.Const.Tactical.FortificationType.Walls;
						p.LocationTemplate.CutDownTrees = true;
						p.LocationTemplate.ShiftX = -2;
						p.Music = this.Const.Music.OrientalCityStateTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineForward;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];

						if (this.Flags.get("IsAlliedReinforcements"))
						{
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 50 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
							p.AllyBanners.push(this.World.FactionManager.getFaction(this.Contract.getFaction()).getPartyBanner());
						}

						if (this.Flags.get("IsLocalsRecruited"))
						{
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.PeasantsArmed, 50, this.Contract.getFaction());
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%SPEECH_START%Dune rune, maudits bâtards.%SPEECH_OFF%C'est la première chose que vous entendez en entrant dans la chambre de %employer%. Il vous fait signe d'entrer à contrecœur.%SPEECH_ON%La guerre avec le Sud continue, mais ils ont décidé de rompre les accords tacites : ils se dirigent vers %holysite% et je n'ai aucun moyen de le protéger. Je ne suis pas du genre à m'attarder sur l'importance des lieux, mais si je laisse passer ça, le public me coupera inévitablement les couilles. Étant donné que j'aime assez mes bijoux de famille, je mettrai %reward% couronnes sur la table pour que vous alliez là-bas et défendiez %holysite%.%SPEECH_OFF% | Vous trouvez %employer% en train d'essayer de parler à une foule de paysans. Il semble que des nouvelles soient arrivées selon lesquelles des soldats du Sud s'approchent de %holysite%.%SPEECH_ON%Nous avons des règles non écrites selon lesquelles ces terres sacrées, elles sont, elles sont... sacrées !%SPEECH_OFF%Vous voyant, le noble se fraye un chemin, vous présentant comme des guerriers courageux qu'il a convoqués il y a une semaine. Cependant, lorsqu'il s'approche, il abrite sa voix dans un chuchotement.%SPEECH_ON%Ces idiots n'ont pas besoin de savoir que vous êtes des mercenaires. Regardez, les Sudistes m'ont bien embêté sur ce coup-là. Les sauvages font vraiment un mouvement sur %holysite% et j'ai besoin que vous y alliez et que vous les arrêtiez. %reward% couronnes devraient être suffisantes pour cette tâche, non ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					 Text = "{La %companyname% peut vous aider avec cela. | Se défendre contre une armée du Sud devrait bien payer. | Je suis intéressé, Continuez.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Ça ne vaut pas le coup. | On est demandé ailleurs. | Je ne risquerai pas la compagnie contre les machines de guerre du Sud.}",
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
			Text: "[img]gfx/ui/events/%illustration%.png[/img]{La grande caldeira a été en grande partie vidée de ses fidèles et de ses occupants curieux. Même la plus légère allusion à la guerre a dispersé les croyants vers les abris de leurs prieurés respectifs. Après tout, il y aura un gagnant et un perdant dans les heures à venir. Un certain niveau de vigueur pourrait inciter les premiers à s'adonner à l'excès de vertu...}",
			Image = "",
			List = [],
			Options = [
				{
					 Text: "Nous camperons ici.",
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
			Text: "[img]gfx/ui/events/%illustration%.png[/img]{L'Oracle n'est pas comme dans votre dernier souvenir : beaucoup des fidèles sont partis et les roulements de tambour de la guerre ont atteint le seuil du temple ancien. Peu importe. Vous n'avez aucune vision à chercher ici, aucun rêve à démêler, seulement des cauchemars à offrir à vos ennemis.}",
			Image = "",
			List = [],
			Options = [
				{
					Text: "Nous camperons ici.",
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
			 Text: "[img]gfx/ui/events/%illustration%.png[/img]{L'Oracle n'est pas comme dans votre dernier souvenir : beaucoup des fidèles sont partis et les roulements de tambour de la guerre ont atteint le seuil du temple ancien. Peu importe. Vous n'avez aucune vision à chercher ici, aucun rêve à démêler, seulement des cauchemars à offrir à vos ennemis.}",
			Image = "",
			List = [],
			Options = [
				{
					Text: "Nous camperons ici.",
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
			 Text: "[img]gfx/ui/events/%illustration%.png[/img]{Vous pensez avoir mis en place une défense modeste avec les positions que %holysite% peut offrir. Avec le peu de temps qu'il reste, il y a probablement au moins une tâche sérieuse que vous pouvez confier à la %companyname% pour la réaliser. C'est juste une question de savoir ce qui conviendrait le mieux à la compagnie.}",
			Image = "",
			List = [],
			Options = [
				{
            Text: "Construire des palissades pour renforcer davantage les murs !",
            function getResult() {
                return "Preparation2";
            }
        },
        {
            Text: "Explorer ces environs pour trouver tout ce qui pourrait nous être utile !",
            function getResult() {
                return "Preparation3";
            }
        },
        {
            Text: "Recruter certains des fidèles pour nous aider dans la défense !",
            function getResult() {
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
			  Text: "[img]gfx/ui/events/%illustration%.png[/img]{En pillant le site sacré lui-même, dont vous ne direz à personne que vous l'avez fait, et en fouillant les affaires abandonnées des fidèles, vous parvenez à rassembler assez de bois pour renforcer un ensemble de murs qui entourent un coin de %holysite%. C'est, selon vous, le meilleur endroit pour qu'un assaillant entre, et donc celui que vous voudrez défendre le plus.}",
			Image = "",
			List = [],
			Options = [
				{
					Text: "Maintenant, nous attendons.",
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
			 Text: "[img]gfx/ui/events/%illustration%.png[/img]{Vous faites parcourir la zone par vos hommes à la recherche de fournitures de guerre. Une kyrielle d'articles est pillée et entassée. Une fois que la totalité de %holysite% a été ratissée, vous et vos hommes passez quelques minutes à déterminer ce qui serait le plus utile...}",
			Image = "",
			List = [],
			Options = [
				{
					Text: "Maintenant, nous attendons.",
					function getResult()
					{
						this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
						return 0;
					}

				}
			],
			function start()
			{
				for( local i = 0; i < 2; i = ++i )
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

				local amount = this.Math.rand(10, 30);
				this.World.Assets.addArmorParts(amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_supplies.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + amount + "[/color] Tools and Supplies."
				});
			}

		});
		this.m.Screens.push({
			ID = "Preparation4",
			Title = "À %holysite%",
			 Text: "[img]gfx/ui/events/%illustration%.png[/img]{Les quelques fidèles qui persistent autour de %holysite% doivent être les plus fervents et zélés. Étant donné que vous êtes ici représentant le nord, vous demandez aux hommes de choisir quelques zélotes des anciens dieux au regard robuste et de leur demander de combattre pour leurs dieux. C'est un outil de recrutement pratique s'il en existe un, et ils se hâtent de s'armer et de suivre la formation la plus courte. Vous ne pouvez qu'espérer qu'ils seront utiles dans la bataille à venir.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Maintenant, nous attendons.",
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
			Text = "[img]gfx/ui/events/event_164.png[/img]{Les sudistes apparaissent à l'horizon. Les adeptes du Gilded One est une description appropriée pour leur armure qui scintille même à grande distance. %randombrother% crache et regarde alentour.%SPEECH_ON%Ils ont l'air beaucoup trop bien habillés pour un tas de morts. Tu te demandes parfois si on ne s'habillerait pas comme des djinns et qu'on ne sortirait pas avec toute la confiance des petits diables, est-ce que les sudistes ne partiraient pas tout simplement ?%SPEECH_OFF%Souriant, tu tires ton épée et ordonnes aux hommes de se préparer pour la bataille.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Prenez position !",
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
			ID = "Quartermaster",
			Title = "À %townname%",
			Text = "[img]gfx/ui/events/event_158.png[/img]{En quittant %townname%, un homme portant la bannière de %employerfaction% sur l'arrière d'une charrette s'approche de vous. Il déclare être l'intendant de votre employeur et avoir quelques fournitures à décharger.%SPEECH_ON%Nous avons quelques chiens de guerre, des filets et des javelots. On m'a dit que vous pouvez en choisir un, mais pas tout, car il y a beaucoup d'hommes en quête de combat ici.%SPEECH_OFF%}",
			Image = "",
			Banner = "",
			List = [],
			Options = [
				{
					Text = "Nous prendrons les chiens de guerre.",
					function getResult()
					{
						for( local i = 0; i < 3; i = ++i )
						{
							local item = this.new("scripts/items/accessory/wardog_item");
							this.World.Assets.getStash().add(item);
						}

						return 0;
					}

				},
				{
					Text = "Nous prendrons les filets.",
					function getResult()
					{
						for( local i = 0; i < 4; i = ++i )
						{
							local item = this.new("scripts/items/tools/throwing_net");
							this.World.Assets.getStash().add(item);
						}

						return 0;
					}

				},
				{
					Text = ""Nous prendrons les javelots.",
					function getResult()
					{
						if (this.Const.DLC.Wildmen)
						{
							for( local i = 0; i < 4; i = ++i )
							{
								local item = this.new("scripts/items/weapons/throwing_spear");
								this.World.Assets.getStash().add(item);
							}
						}
						else
						{
							for( local i = 0; i < 4; i = ++i )
							{
								local item = this.new("scripts/items/weapons/javelin");
								this.World.Assets.getStash().add(item);
							}
						}

						return 0;
					}

				},
				{
					Text = "Nous avons tout ce dont nous avons besoin. Gardez-le pour les autres.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Flags.set("IsQuartermaster", false);
				this.Banner = this.World.FactionManager.getFaction(this.Contract.getFaction()).getUIBanner();
			}

		});
		this.m.Screens.push({
			ID = "SallyForth1",
			Title = "À %holysite%",
			Text = "[img]gfx/ui/events/event_164.png[/img]{Les sudistes apparaissent, mais ce n'est pas en force complète, et ce ne sont pas nécessairement que leurs éclaireurs. Il semble qu'ils aient peu pris le temps de rester groupés et se soient plutôt dispersés à l'approche. Si vous deviez sortir et attaquer maintenant, vous les surprendriez probablement avec leurs pantalons baissés.}",
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
			Text = "[img]gfx/ui/events/event_50.png[/img]{%SPEECH_START%Bonne décision.%SPEECH_OFF%Les mots de %randombrother% suivent votre ordre. Partant à un rythme rapide, le %companyname% se met en route pour surprendre les sudistes avant qu'ils n'aient rassemblé toute leur force. Vous traversez le champ et, avant même de vous en rendre compte, vous êtes sur eux. Ils sont encore en train de décharger du matériel et des équipements, et à la simple vue de vous, quelques suiveurs de camp s'enfuient en courant. Le reste des soldats se dépêche de ramasser leurs armes.\n\nÀ en juger par sa voix stridente, le seul commandant dans la région n'est pas formé pour ce genre de chose, car sa voix craque à chaque ordre aboyé alors qu'une sorte de formation tente de prendre forme. Ne perdant pas plus de temps, vous vous précipitez dans la mêlée !}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "À l'attaque !",
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
			Text = "[img]gfx/ui/events/event_90.png[/img]{Vous achevez les derniers soldats, l'expression de surprise toujours fermement dessinée sur leur visage.%SPEECH_ON%Capitaine, les autres arrivent.%SPEECH_OFF%%randombrother% dit en revenant d'un coup d'œil rapide à l'horizon. En acquiesçant, vous ordonnez aux hommes de se préparer. Cette fois, les sudistes approchent en bonne formation, bien qu'elle vacille brièvement à la vue de vous et des morts jonchant le sol à vos pieds. Leur bannière s'élève dans le ciel et les sudistes sont revivifiés, chargeant avec colère et énergie. Des cris de 'pour le Gilder !' résonnent dans l'air. Vous pointez votre épée en avant.%SPEECH_ON%Aussi admirable que puisse être leur foi, aucun dieu ne les trouvera ici, seul le %companyname% les attend et nous n'avons qu'une prière à offrir.%SPEECH_OFF%Les hommes rugissent alors que la bataille s'abat sur eux.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Rassemblement ! Préparez-vous !",
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
			Text = "[img]gfx/ui/events/event_164.png[/img]{%SPEECH_START%Bon choix.%SPEECH_OFF%Les paroles de %randombrother% suivent votre ordre. Partant à vive allure, le %companyname% se lance pour rattraper les sudistes avant qu'ils ne rassemblent toute leur force. Vous traversez le champ et, avant même de vous en rendre compte, vous êtes sur eux. Ils déchargent encore des équipements et, à votre simple vue, quelques suiveurs de camp s'enfuient pour sauver leur vie. Le reste des soldats se précipite pour récupérer leurs armes. Juste au moment où vous pensez avoir l'avantage, un autre contingent arrive sur le côté.%SPEECH_ON%Le Gilder ne sourit qu'à ceux qui méritent Son éclat, Couronné !%SPEECH_OFF%Le commandant du sud crie avec moquerie. Les défenses étant trop éloignées et l'ennemi trop proche, il n'y a plus qu'un endroit où aller maintenant. Vous levez votre épée et préparez les hommes à charger.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous nous frayerons un chemin hors d'ici !",
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
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{Vous estimez qu'il est préférable de défendre la position. Cela pourrait laisser passer une opportunité, mais c'est en partie l'option la plus sûre parmi toutes celles disponibles.%SPEECH_ON%On aurait dû sortir. On a raté quelque chose là-dessus, capitaine.%SPEECH_OFF%En regardant autour de vous, vous trouvez %randombrother% haussant les épaules. Vous lui dites de faire attention à sa langue, sinon il risque de manquer quelque chose lui-même.}",
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
			ext = "[img]gfx/ui/events/event_78.png[/img]{En attendant les sudistes, une troupe de nordistes arrive. Leur lieutenant incline son casque.%SPEECH_ON%Quand ils m'ont dit de venir par ici pour aider un mercenaire, j'ai dit qu'ils pouvaient se faire foutre avec leur commande. Mais vous savez ce qui m'a convaincu ? Le fait que c'était le %companyname%. Vous avez de la réputation, et j'ai des hommes à épargner pour ce combat.%SPEECH_OFF%À en juger par leur équipement, ils seraient mieux utilisés comme une force d'écran pour peut-être attirer des éléments de la force ennemie qui approche. Ou peut-être serait-il préférable de les intégrer simplement à la compagnie, renforçant vos rangs là où vous êtes déjà le plus fort.}",
			Image = "",
			Banner = "",
			List = [],
			Options = [
				{
					Text = "J'ai besoin que vous et vos hommes contourniez leurs artilleurs, lieutenant.",
					function getResult()
					{
						this.Flags.set("IsEnemyLuredAway", true);
						this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
						return "AlliedSoldiers2";
					}

				},
				{
					Text = "J'ai besoin que vous et vos hommes attiriez quelques-uns de leurs fantassins, lieutenant.",
					function getResult()
					{
						this.Flags.set("IsEnemyLuredAway", true);
						this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
						return "AlliedSoldiers2";
					}

				},
				{
					Text = "J'ai besoin que vous et vos hommes combattiez à nos côtés, lieutenant.",
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
			Text = "[img]gfx/ui/events/event_78.png[/img]{Vous sortez une longue-vue et scrutez le champ de bataille devant vous. La troupe du nord charge vers l'ennemi en formation de chevron, puis se divise aux ailes pour s'enfuir dans des directions différentes. Cela semble une charge suicidaire, mais à votre grande surprise, ils ont effectué une retraite savoureuse que les sudistes ne peuvent pas tout à fait résister. Vous regardez les adeptes du Gilder ne pas garder un œil sur l'éclat, épuisant plutôt leurs rangs pour poursuivre la feinte.%SPEECH_ON%Cela a fonctionné comme un charme, capitaine.%SPEECH_OFF%%randombrother% dit.}",
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
			Text = "[img]gfx/ui/events/event_78.png[/img]{Vous préférez que les soldats restent avec vous. Le lieutenant hoche la tête.%SPEECH_ON%Oui, monsieur, capitaine, euh, comment vous appelez-vous ?%SPEECH_OFF%L'ignorant, vous dites à %randombrother% d'accommoder la troupe du nord aux défenses.%SPEECH_ON%Assurez-vous qu'ils le sachent bien, mais pas trop bien.%SPEECH_OFF%Le mercenaire s'approche et chuchote.%SPEECH_ON%Ah, s'ils sont des espions, nous ne voulons pas leur donner trop de détails, hein capitaine ?%SPEECH_OFF%Vous vous penchez et murmurez à nouveau.%SPEECH_ON%Non. Placez-les là où nous sommes les plus faibles. Espérons qu'ils se cassent tous la figure en première ligne et ensuite nous aurons leurs affaires.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Banner = "",
			Options = [
				{
					Text = "Maintenant, nous attendons encore.",
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
			Text = "[img]gfx/ui/events/event_168.png[/img]{Le dernier soldat sudiste vous regarde.%SPEECH_ON%Par l'éclat du Gilder, je suis prêt.%SPEECH_OFF%Vous tirez votre épée.%SPEECH_ON%Et à quoi servait cet éclat si c'est moi qui suis ici, et vous là-bas ?%SPEECH_OFF%Avant qu'il ne puisse répondre, vous enfoncez la lame dans son cou. Vous dites aux mercenaires de piller les restes et de se préparer à Retournez à %employer%. | Vous trouvez le dernier soldat sudiste adossé à un rocher, son bras posé sur le dessus comme s'il était un copain de boisson. Il crache du sang et hoche la tête.%SPEECH_ON%Peut-être que mon chemin n'était pas aussi doré que je le pensais.%SPEECH_OFF%Acquiesçant, vous lui dites qu'il pourra demander au Gilder lui-même tout à l'heure.%SPEECH_ON%Et je lui demanderai aussi de vous.%SPEECH_OFF%Il répond. Vous faites une pause d'un moment sur ce commentaire, puis vous le transpercez avec l'épée. Le reste des restes devra être pillé. %employer% devrait être heureux de vous voir. | La bataille est terminée et les morts jonchent le champ. Vous vous tenez au-dessus du dernier sudiste respirant. Il fixe par-dessus votre épaule le ciel. Lorsque vous demandez s'il pense que son 'Gilder' observe, l'homme sourit.%SPEECH_ON%Il nous regarde tous les deux.%SPEECH_OFF%Vous hochez la tête puis mettez fin à sa vie. D'un sifflement aigu, vous attirez l'attention du %companyname%. Vos ordres sont simples : pillez ce qui vaut la peine d'être pillé, puis préparez-vous à Retournez à %employer%.}",
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
		Text = "[img]gfx/ui/events/%illustration%.png[/img]{Les sudistes hissent leurs bannières sur %holysite%.%SPEECH_ON%Je suppose que c'est fini, alors.%SPEECH_OFF%%randombrother% dit. Si par 'c'est fini', vous voulez dire qu'il n'y a aucune raison de voir %employer% à propos de la fin du contrat, alors oui, c'est effectivement fini.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Catastrophe !",
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
		Text = "[img]gfx/ui/events/event_04.png[/img]{%SPEECH_START%J'imagine que ces foutus sudistes ont crié quand vous avez mis fin à leurs conneries.%SPEECH_OFF%%employer% mord dans une moitié de blanc de poulet avant que vous ne puissiez répondre. Et il continue de parler quand même, la bouche pleine de contenus jusqu'à ce qu'ils n'aient pas encore été lancés et répandus sur la table.%SPEECH_ON%Tu sais, je doutais des vieux dieux, mais maintenant, avec ça, je peux voir que leurs voies sont vraies et leur divinité des plus justes.%SPEECH_OFF%Il avale ce qu'il reste et frappe le poulet sur son assiette.%SPEECH_ON%Payez le mercenaire, son argent.%SPEECH_OFF% | Vous trouvez %employer% en compagnie de quelques moines, de leur prieur et de femmes qui n'ont pas l'air d'être en statut matrimonial avec qui que ce soit. Le noble sourit de toutes ses dents.%SPEECH_ON%La nouvelle de vos exploits nous est parvenue il y a quelques jours. Les anciens dieux lèvent leurs calices à vos hommes, mercenaire. Je suis sûr que vous avez infligé tous les enfers qu'ils méritent à ces sudistes, et dans lesquels ils résident sans aucun doute. Votre paiement, comme promis.%SPEECH_OFF%Quelques femmes se dirigent vers vous, mais sont rapidement ramenées.%SPEECH_ON%Dames, mesdames, je vous prie, soyez convenables. Mercenaire.%SPEECH_OFF%%employer% pointe vers un coffre contenant %reward% couronnes. | Vous trouvez %employer% dans un prieuré. Il prie seul à un autel, et quand il a fini, il parle sans se retourner.%SPEECH_ON%Je crois que les anciens dieux m'ont parlé la nuit dernière. Ils ont dit que vous reveniez avec de bonnes nouvelles et en effet, vous voilà. Parce que nous sommes seuls, je vais vous dire quelque chose. Les 'Gildés' qui circulent dans ce désert, je les considère comme des gens sincères. Je pense que peu importe les bâtiments dans lesquels ils prient, ils prient dedans maintenant. Vous n'avez en rien ébranlé leur foi, et un jour nous serons de nouveau là-bas.%SPEECH_OFF%Le noble se lève et se retourne.%SPEECH_ON%La défaite endurcit les fidèles. J'ai pris mes coups, et maintenant ils ont les leurs. Lorsque vous prendrez votre or pour le travail, ajoutez une prière pour que ce soit la dernière que vous fassiez pour cela.%SPEECH_OFF%Vous ne ferez pas cela, mais vous trouvez cela incorrect de dire la vérité à un cœur ouvert. Cependant, %reward% couronnes font une entrée très correcte dans les cordons de la bourse de la compagnie.}",
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
		local f = this.World.FactionManager.getFaction(this.getFaction());
		local candidates = [];

		foreach( s in f.getSettlements() )
		{
			this.logInfo("name: " + s.getName());

			if (s.isMilitary())
			{
				candidates.push(s);
			}
		}

		local party = f.spawnEntity(tiles[0].Tile, candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly() + " Company", true, this.Const.World.Spawn.Noble, this.Math.rand(100, 150) * this.getDifficultyMult() * this.getScaledDifficultyMult());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
		party.setDescription("Professional soldiers in service to local lords.");
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
			for( local y = o.Y - 4; y <= o.Y - 3; y = ++y )
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
			candidates.push(s);
		}

		local party = f.spawnEntity(tiles[0].Tile, "Regiment of " + candidates[this.Math.rand(0, candidates.len() - 1)].getNameOnly(), true, this.Const.World.Spawn.Southern, (this.m.Flags.get("IsEnemyLuredAway") ? 130 : 160) * this.getScaledDifficultyMult());
		party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + f.getBannerString());
		party.setDescription("Conscripted soldiers loyal to their city state.");
		party.setAttackableByAI(false);
		party.setAlwaysAttackPlayer(true);
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


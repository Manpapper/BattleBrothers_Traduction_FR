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
			Title = "Negotiations",
			Text = "[img]gfx/ui/events/event_45.png[/img]{%SPEECH_START%Dune rune bastards.%SPEECH_OFF%This is the first thing you hear upon entering %employer%\'s room. He begrudgingly waves you in.%SPEECH_ON%The war with the South continues, but they\'ve taken it upon themselves to break bonds of unspoken agreements: they\'re moving on %holysite% and I\'ve no means to protect it. I\'m not one to dally on how important the grounds are, but if I were to let it slide the public will undoubtedly clip my nuts. Being that I quite like my balls, I\'ll put %reward% crowns on the table for you to go there and defend %holysite%.%SPEECH_OFF% | You find %employer% trying to talk his way over a throng of peasants. It appears news has arrived that Southern soldiers are approaching %holysite%.%SPEECH_ON%We\'ve unspoken rules that these sacred grounds, they\'re, they\'re... they\'re sacred!%SPEECH_OFF%Seeing you, the nobleman clears a path, announcing you as brave warriors that he beckoned a week ago. When he gets near, however, he shelters his voice in a whisper.%SPEECH_ON%These idiots don\'t need to know you\'re sellswords. Look, the Southerners jammed a stick far up my ass on this one. The savages truly are making a move on %holysite% and I need you to get there and stop them. %reward% crowns should be sufficient for this task, yeah?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{The %companyname% can help you with this. | Defending against a southern host better pay well. | I\'m interested, go on.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{This isn\'t worth it. | We\'re needed elsewhere. | I won\'t risk the company against southern machines of war.}",
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
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{The great caldera has been mostly emptied of its faithful and curious occupants. Even the slightest suggestion of war has dispersed believers back to the shelters of their respective priories. After all, there will be a winner and a loser in the hours to come. A certain level of vigor may entreat the former to overindulging themselves on righteousness...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We\'ll set up camp here.",
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
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{The Oracle isn\'t as you last remember it: many of the faithful have departed and the drums of war have come to the ancient temple\'s doorstep. Not that it matters. You\'ve no visions to seek here, no dreams to unwind, only nightmares to provide your enemies.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We\'ll set up camp here.",
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
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{Ironically, the leveled city which dwells beneath the half-blown mountain finally feels eerily abandoned. Few of the faithful linger, the rest having departed long before the religious strife arrives upon their tent cities and spiritual interloping.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We\'ll set up camp here.",
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
			Title = "At %holysite%",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{You believe you have made a modest defense out of what positions %holysite% can give. With what little time remains, there\'s probably at least one serious task you can set the %companyname% to completing. It\'s just a question of what exactly would suit the company best.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Build palisades to further bolster the walls!",
					function getResult()
					{
						return "Preparation2";
					}

				},
				{
					Text = "Search these grounds for anything that could be of use to us!",
					function getResult()
					{
						return "Preparation3";
					}

				},
				{
					Text = "Recruit some of the faithful to help us in the defense!",
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
			Title = "At %holysite%",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{Looting the holy site itself, which you\'ll tell no one of your doing, and pilfering through the abandoned belongings of the faithful, you manage to scrap together enough wood to reinforce a set of walls that ring a corner of %holysite%. It is in your estimation the best spot for an attacker to come in, and thus the one you\'ll want to defend most.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Now we wait.",
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
			Title = "At %holysite%",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{You have the men scour the area for battle supplies. A litany of items are pilfered and piled. Once the whole of %holysite% has been combed, you and the men spend a few minutes figuring out what would be of most use...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Now we wait.",
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
						text = "You gain " + item.getName()
					});
				}

				local amount = this.Math.rand(10, 30);
				this.World.Assets.addArmorParts(amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_supplies.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + amount + "[/color] Tools and Supplies."
				});
			}

		});
		this.m.Screens.push({
			ID = "Preparation4",
			Title = "At %holysite%",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{What few faithful still linger autour de %holysite% must be the most fervid and zealous. Being that you are here representing the north, you have the men pick out a few hardy looking old gods zealots and ask that they fight for their gods. It is a convenient recruiting tool if there ever was one, and they are quick to arm themselves and undergo the shortest of training. You can only hope they are of any use in the actual battle to come.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Now we wait.",
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
			Title = "At %holysite%",
			Text = "[img]gfx/ui/events/event_164.png[/img]{The southerners appear over the horizon. Followers of the Gilded One is an apt description for their armor glints and shines even at great distance. %randombrother% spits and looks over.%SPEECH_ON%They look far too dapper for a buncha dead men. You ever wonder if we just dressed ourselves like a buncha djinn and rode out with all the confidence of little devils them southerners would just up and leave?%SPEECH_OFF%Smiling, you draw out your sword and command the men to battle.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Take formation!",
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
			Title = "At %townname%",
			Text = "[img]gfx/ui/events/event_158.png[/img]{Leaving %townname%, you\'re approached by a man flying %employerfaction%\'s banner off the back end of a wagon. He states that he is a quartermaster for your employer and he has a few supplies to offload.%SPEECH_ON%Got a couple of wardogs, nets and throwing spears. I\'ve been told you can have one or the other, but not all as there are plenty of fightin\' men in need around here.%SPEECH_OFF%}",
			Image = "",
			Banner = "",
			List = [],
			Options = [
				{
					Text = "We\'ll take the wardogs.",
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
					Text = "We\'ll take the nets.",
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
					Text = "We\'ll take the throwing spears.",
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
					Text = "We have all that we need. Save it for the others.",
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
			Title = "At %holysite%",
			Text = "[img]gfx/ui/events/event_164.png[/img]{The southerners appear, but it is not in full force, and nor is it necessarily just their scouts. It seems they have spent little time keeping cohesion and have instead spread themselves out on the approach. If you were to sally forth and attack now, you\'d likely catch them with their drawers down.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We need to seize this opportunity. Prepare the men to sally forth!",
					function getResult()
					{
						return this.Math.rand(1, 100) <= 50 ? "SallyForth2" : "SallyForth4";
					}

				},
				{
					Text = "We have a defensible position here. We stay put.",
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
			Title = "At %holysite%",
			Text = "[img]gfx/ui/events/event_50.png[/img]{%SPEECH_START%Good call.%SPEECH_OFF%The words of %randombrother% follow your order. Set to a fast pace, the %companyname% sets out to catch the southerners before they muster their full strength. You cross the field and before you know it are upon them. They\'re still offloading gear and equipment and at the very sight of you a few camp followers up and run for their lives. The rest of the soldiers hurry to collect their weapons.\n\nJudging by his shrill voice, the only commander in the area isn\'t trained for this sort of thing as his voice cracks with every barked order as some semblance of a formation tries to take shape. Wasting no more time, you charge into the fray!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Charge!",
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
			Title = "At %holysite%",
			Text = "[img]gfx/ui/events/event_90.png[/img]{You finish off the last of the soldiers, the look of surprise still grimly shaped across their faces.%SPEECH_ON%Captain, got the rest coming.%SPEECH_OFF%%randombrother% says, returning from a quick gaze of the horizon. Nodding, you order the men to get ready. This time, the southerners are making an approach in good formation, though it briefly waivers at the sight of you and the dead littered about your feet. Their banner rises into the sky and the southerners are revivified, charging forth with anger and energy. Shouts of \'for the Gilder!\' ripple through the air. You point your sword forward.%SPEECH_ON%Admirable in their faith they might be, no god shall find them here, only the %companyname% awaits and we\'ve but one prayer to offer.%SPEECH_OFF%The men roar as the battle hastens upon them.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Rally! Rally! Get ready!",
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
			Title = "At %holysite%",
			Text = "[img]gfx/ui/events/event_164.png[/img]{%SPEECH_START%Good call.%SPEECH_OFF%The words of %randombrother% follow your order. Set to a fast pace, the %companyname% sets out to catch the southerners before they muster their full strength. You cross the field and before you know it are upon them. They\'re still offloading gear and equipment and at the very sight of you a few camp followers up and run for their lives. The rest of the soldiers hurry to collect their weapons. Just when you think you have the upper hand, another contingent arrives from the side.%SPEECH_ON%The Gilder smiles only upon those who deserve His gleam, Crownling!%SPEECH_OFF%The southern commander shouts mockingly. With the defenses too far, and the enemy too close, there\'s only one place to go now. You raise your sword and ready the men to charge.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We\'ll fight our way out of this!",
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
			Title = "At %holysite%",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{You figure it\'s best to man the defenses. It might let an opportunity slip, but it is in part the safest of all available options.%SPEECH_ON%Shoulda went out. We missed something there on that one, captain.%SPEECH_OFF%Looking over you find %randombrother% shrugging. You tell him to mind his tongue, or he\'ll be missing something himself.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Everyone, get ready. They\'ll soon attack in full force.",
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
			Title = "At %holysite%",
			Text = "[img]gfx/ui/events/event_78.png[/img]{As you await the southerners, a troop of northerners arrives. Their lieutenant tips his helmet.%SPEECH_ON%When they told me to come out this way to aide a sellsword, I said they can go shit that command out their arse. But you know what convinced me? Knowing it was the %companyname%. You\'ve reputation, and I\'ve men to spare for this fight.%SPEECH_OFF%Judging by their equipment, they\'d be best used as a screening force to perhaps draw away elements of the oncoming enemy force. That, or perhaps it\'d be best to just fold them into the company, bolstering your ranks where you\'re already strongest.}",
			Image = "",
			Banner = "",
			List = [],
			Options = [
				{
					Text = "I need you and your men to flank their gunners, lieutenant.",
					function getResult()
					{
						this.Flags.set("IsEnemyLuredAway", true);
						this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
						return "AlliedSoldiers2";
					}

				},
				{
					Text = "I need you and your men to lure away some of their infantry, lieutenant.",
					function getResult()
					{
						this.Flags.set("IsEnemyLuredAway", true);
						this.Flags.set("AttackTime", this.Time.getVirtualTimeF() + this.Math.rand(5, 10));
						return "AlliedSoldiers2";
					}

				},
				{
					Text = "I need you and your men to fight at our side, lieutenant.",
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
			Title = "At %holysite%",
			Text = "[img]gfx/ui/events/event_78.png[/img]{You take out a long-glass and scope the battlefield ahead. The northern troop charge toward the enemy in a chevron formation, and then split off at the wings to run off in separate directions. It seems a suicidal charge, but much to your surprise they\'ve made a tasty retreat the southerners can\'t quite resist. You watch as the Gilder\'s followers don\'t keep their eye on the shine, instead depleting their ranks to chase down the feint.%SPEECH_ON%Worked like a charm, captain.%SPEECH_OFF%%randombrother% says.}",
			Image = "",
			Banner = "",
			List = [],
			Options = [
				{
					Text = "Very good.",
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
			Title = "At %holysite%",
			Text = "[img]gfx/ui/events/event_78.png[/img]{You\'d rather the soldiers stay with you. The lieutenant nods.%SPEECH_ON%Yessir, captain, uh, what\'s your name?%SPEECH_OFF%Ignoring him, you tell %randombrother% to accommodate the northern troop to the defenses.%SPEECH_ON%Make sure they know it well, but not too well.%SPEECH_OFF%The sellsword leans in and whispers.%SPEECH_ON%Ah, if they\'re spies we don\'t want to give them too much detail, aye captain?%SPEECH_OFF%You lean in and whisper back.%SPEECH_ON%No. Put them where we are weakest. Hopefully they all eat shit on the frontline and then we\'ll have their belongings.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Banner = "",
			Options = [
				{
					Text = "Now we wait again.",
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
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_168.png[/img]{The last southern soldier looks up at you.%SPEECH_ON%By the Gilder\'s gleam, I am ready.%SPEECH_OFF%You draw out your sword.%SPEECH_ON%And of what use was that gleam if I\'m the one here, and you there?%SPEECH_OFF%Before he can respond, you put the blade through his neck. You tell the sellswords to loot the remains and ready a Retournez à %employer%. | You find the last of the southern soldiers perched against a rock, his arm slung across its top as though it were a drinking buddy. He spits blood and nods.%SPEECH_ON%Perhaps my path was not so gilded as I thought.%SPEECH_OFF%Nodding back, you tell him that he can ask the Gilder about that himself real soon here.%SPEECH_ON%And I\'ll ask Him about you, too.%SPEECH_OFF%He responds. You pause for a moment on that comment, then run him through with the sword. The rest of the remains will need to be looted. %employer% should be happy to see you. | The battle is over and the dead litter the field. You stand over the last breathing southerner. He stares over your shoulder at the sky. When you ask if he thinks his \'Gilder\' is watching, the man smiles.%SPEECH_ON%He\'s watching us both.%SPEECH_OFF%You nod and then end his life. With a sharp whistle, you get the %companyname%\'s attention. Your orders are simple: loot what\'s worthwhile, and then ready to Retournez à %employer%.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Victory!",
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
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{The southerners raise their banners over %holysite%.%SPEECH_ON%I suppose that\'s it, then.%SPEECH_OFF%%randombrother% says. If by \'it\' you mean there\'s no reason to see %employer% about the end of the contract then yes, that is indeed it.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Disaster!",
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
			Title = "On your return...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%SPEECH_START%I take it them southern shits squealed when you put an end to their farkin\' around.%SPEECH_OFF%%employer% bites into half a chicken breast before you can respond. And he keeps talking anyway, mouth only full of contents insofar as they have not yet launched out and spread across the table.%SPEECH_ON%Ya know, I\'d doubt of the old gods, but now, with this, I can see their ways are true, and their divinity most righteous.%SPEECH_OFF%He swallows what\'s left and slams the chicken on his plate.%SPEECH_ON%Pay the sellsword his money.%SPEECH_OFF% | You find %employer% in the company of a few monks, their prior, and women who don\'t look in remotely marital status with anyone. The nobleman is grinning ear to ear.%SPEECH_ON%Word of your doings reached us a few days ago. The old gods raise their chalices to your men, sellsword. I\'m sure you gave them southerners all the hells they deserve, and in which they no doubt dwell. Your payment, as promised.%SPEECH_OFF%A few of the women go toward you, but are quickly reeled back.%SPEECH_ON%Ladies, ladies, please, be proper. Sellsword.%SPEECH_OFF%%employer% points toward a chest of %reward% crowns. | You find %employer% in a priory. He is praying alone at an altar, and when he finishes he speaks without turning back.%SPEECH_ON%I believe the old gods spoke to me last night. Said you were returning with good news and indeed, here you are. Because we are alone, I\'ll tell you something. The \'Gilded\' ones riding around in that desert, I think them an earnest sort. I think whatever buildings they pray in, they\'re praying in them now. You\'ve not shook their faith at all, and someday we\'ll be out there again.%SPEECH_OFF%The nobleman stands up and turns around.%SPEECH_ON%Defeat hardens the faithful. I\'ve taken my licks, and now they have theirs. When you take your gold for the job, put in a prayer that it\'s the last you take for it.%SPEECH_OFF%You\'ll not be doing that, but feel it improper to tell the truth to an opened heart. %reward% crowns, however, makes a very proper entrance into the company\'s purse strings.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Crowns well deserved.",
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
					text = "Recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Couronnes"
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


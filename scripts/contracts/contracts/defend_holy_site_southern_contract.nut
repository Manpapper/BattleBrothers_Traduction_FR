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
			Title = "Negotiations",
			Text = "{[img]gfx/ui/events/event_163.png[/img]%employer% is nowhere to be seen. Instead a man in clerical colors approaches with a lieutenant general at his side. They state that a contingent of northern soldiers is approaching %holysite% with the aim to take it wholly for the North. With the city-state\'s soldiers elsewhere, they will have to lean on you to hurry to the location and defend it. Their heavy-handed manner of speaking combined with a hint of anxiety no doubt makes this a potentially pocket-deepening payday. | [img]gfx/ui/events/event_162.png[/img]You are pushed into %employer%\'s room and the Vizier nods at you and claps.%SPEECH_ON%Finally, the little Crownling is here, ready to do big things for us all. Come, look at this map. Do you see where my men are? And do you see where %holysite% is? And here, the northern rats... They\'re near to the sacred grounds and my men far. You, however, are here, close indeed, no? For %reward% crowns I want you to Voyagez jusqu\'à %holysite% and defend it.%SPEECH_OFF%The Vizier stares at you with a warm smile as though this wasn\'t a question, but a request so weighted with gold it may as well have been an order.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{The %companyname% can help you with this. | Defending against a northern host better pay well. | I\'m interested, go on.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{This isn\'t worth it. | We\'re needed elsewhere. | I won\'t risk the company against northern armies.}",
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
						text = "You gain " + item.getName()
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Preparation4",
			Title = "At %holysite%",
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{What few faithful still linger around %holysite% must be the most fervid and zealous. Being that you are here representing the south, you have the men pick out a few followers of the Gilder and ask that they fight for their God. It is a convenient recruiting tool if there ever was one, and they are quick to arm themselves and undergo the shortest of training. You can only hope they are of any use in the actual battle to come.}",
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
			Text = "[img]gfx/ui/events/event_78.png[/img]{The northern army is here. Or, at least, what\'s left of it. With such heavy armor and arms, the long travel has left their ranks a little thinned, but they still look quite the considerable challenge. You look over at %randombrother% who shrugs.%SPEECH_ON%{Aside from the scenery, just another battle, ain\'t it? | I know everyone is going to chat about this and that religious bullshit, but frankly, this is just another fight to me. And I love it.}%SPEECH_OFF%Nodding, you unsheathe your sword and command the men to the ready.}",
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
			ID = "Alchemist1",
			Title = "At %townname%",
			Text = "[img]gfx/ui/events/event_163.png[/img]{A man approaches you at the gates of %townname%. Judging by the madly colored bandoliers and phylacteries about his chest, he is an alchemist. He announces that he was sent by the Vizier.%SPEECH_ON%I am a bit short on material, but I\'ve enough to produce content of a very specific manner, of your call, of course.%SPEECH_OFF%He describes his solutions as thus: fire pots, flash pots, or smoke pots.}",
			Image = "",
			Banner = "",
			List = [],
			Options = [
				{
					Text = "We\'ll take the fire pots.",
					function getResult()
					{
						this.Flags.set("IsFirepot", true);
						return "Alchemist2";
					}

				},
				{
					Text = "We\'ll take the flash pots.",
					function getResult()
					{
						this.Flags.set("IsFlashpot", true);
						return "Alchemist2";
					}

				},
				{
					Text = "We\'ll take the smoke pots.",
					function getResult()
					{
						this.Flags.set("IsSmokepot", true);
						return "Alchemist2";
					}

				},
				{
					Text = "We have all that we need.",
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
			Title = "At %townname%",
			Text = "[img]gfx/ui/events/event_163.png[/img]{The alchemist works quickly, pouring an entire pile of powdered ingredients into a bowl and then mashing in a smattering of materials you can\'t even recognize. It takes a surprisingly short period of time, and you\'re not sure if that\'s because he\'s so talented or this whole thing is a farce. Either way, he hands you the pots as promised.%SPEECH_ON%May the Gilder shine light upon your path, and may your swords bring peace back to %holysite%.%SPEECH_OFF%}",
			Image = "",
			Banner = "",
			List = [],
			Options = [
				{
					Text = "These should come in handy.",
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
						text = "You gain a " + item.getName()
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "SallyForth1",
			Title = "At %holysite%",
			Text = "[img]gfx/ui/events/event_78.png[/img]{The northerners appear, but it is not in full force, and nor is it necessarily just their scouts. It seems they have spent little time keeping cohesion and have instead spread themselves out on the approach. If you were to sally forth and attack now, you\'d likely catch them with their drawers down.}",
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
			Text = "[img]gfx/ui/events/event_156.png[/img]{%SPEECH_START%Good call.%SPEECH_OFF%The words of %randombrother% follow your order. Set to a fast pace, the %companyname% sets out to catch the northerners before they muster their full strength. You cross the field and before you know it are upon them. They\'re still offloading gear and equipment and at the very sight of you a few camp followers up and run for their lives. The rest of the soldiers hurry to collect their weapons. Judging by his shrill voice, the only commander in the area isn\'t trained for this sort of thing as his voice cracks with every barked order as some semblance of a formation tries to take shape. Wasting no more time, you charge into the fray!}",
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
			Text = "[img]gfx/ui/events/event_90.png[/img]{You finish off the last of the soldiers, the look of surprise still grimly shaped across their faces.%SPEECH_ON%Captain, got the rest coming.%SPEECH_OFF%%randombrother% says, returning from a quick gaze of the horizon. Nodding, you order the men to get ready. This time, the northerners are making an approach in good formation, though it briefly waivers at the sight of you and the dead littered about your feet. Their banner rises into the sky and the northerners are revivified, charging forth with anger and energy. You look down at %randombrother% and brush a piece of organ off his shoulder. When he looks back you simply smile.%SPEECH_ON%The fun\'s here, you should look nice for it.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_78.png[/img]{%SPEECH_START%Good call.%SPEECH_OFF%The words of %randombrother% follow your order. Set to a fast pace, the %companyname% sets out to catch the northerners before they muster their full strength. You cross the field and before you know it are upon them. They\'re still offloading gear and equipment and at the very sight of you a few camp followers up and run for their lives. The rest of the soldiers hurry to collect their weapons. Just when you think you have the upper hand, another contingent arrives from the side.%SPEECH_ON%Farkin\' hell, that\'s nearly the whole lot of them.%SPEECH_OFF%%randombrother% says. The defenses are too far, and the enemy too close. There\'s only one place to go now. You raise your sword and ready the men to charge.}",
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
			Text = "[img]gfx/ui/events/event_164.png[/img]{As you await the northerners, a small band of southern soldiers almost gets the drop on you. Thankfully, they\'re still on your side and offer their services.%SPEECH_ON%The Gilder told us you would be here, and though you are a Crownling we will submit to your command in defending this site in His glory.%SPEECH_OFF%Judging by their equipment, they\'d be best used as a screening force to perhaps draw away elements of the oncoming enemy force. That, or perhaps it\'d be best to just fold them into the %companyname% for now, bolstering your ranks where you\'re already strongest.}",
			Image = "",
			Banner = "",
			List = [],
			Options = [
				{
					Text = "I need you and your men to flank their arbalesters, lieutenant.",
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
			Text = "[img]gfx/ui/events/event_164.png[/img]{You take out a long-glass and scope the battlefield ahead. The southern soldiers fan out like ants and get into a skirmish with the northerners. Much to your surprise, the feint works. Grinning, you watch as the northern troop split and give chase, weakening their ranks in the process.}",
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
			Text = "[img]gfx/ui/events/event_164.png[/img]{You\'d rather the soldiers stay with you. The lieutenant nods.%SPEECH_ON%The Gilder has trusted us to help you, and whether you believe it or not, He trusts you, too.%SPEECH_OFF%Alright. Sure. You tell them where to go and they hop to it with annoyingly religious obedience, going on and on about gold and lights and the like.}",
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
			Text = "[img]gfx/ui/events/event_87.png[/img]{The last living northerner is on the ground, a wound in his chest, blood about the ground. He\'s got a long look in his eyes and breathes calmly and with a sense that this is the end of things. You take out your sword but he holds out his hand. Not for mercy, but for a moment.%SPEECH_ON%No need for that. I can see it already. It goes. And it goes. Don\'t know why I cared so much.%SPEECH_OFF%He slumps over and his hand tenses and falls from his chest. %randombrother% prods the corpse, then loots it. You sheathe your sword and tell the men to ready for a Retournez à the Vizier. | Your men go about finishing off the last of the survivors. It\'s mostly a matter of running corpses through with a quick stab or two. Some bodies still jump, but you know they\'re gone. You\'re not sure why they still move like that, as if the man that once was left his fear behind. Others don\'t react at all. There\'s one scream from a soldier who tried to hide, but he is quickly silenced. With the field littered with the defeated, you tell the %companyname% to go loot what they can and prepare for a trip back to the Vizier. | One last northerner has backed himself between the wedge of two rocks, his hands splayed out to the sides like a spider receding back into its hidden hole.%SPEECH_ON%The old gods shant have mercy on ye lot.%SPEECH_OFF%A shadow briefly comes and goes from above, and then the rock which manifested it follows and crushes the man\'s head. He falls to the ground, body jerking, mouth gargling. %randombrother% stares from the peak of the two rocks.%SPEECH_ON%That\'s the last of them. We should get their gear and get back to uh, that fella, the one with the pomp, the viz... vis... viscount?%SPEECH_OFF%Vizier. But close enough.}",
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
			Text = "[img]gfx/ui/events/%illustration%.png[/img]{Well, %holysite% belongs to the northerners now. Given that you place heavy value upon your own head, and wish to keep it there, you see no point in returning to the Vizier for at least awhile.}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% is found in a small priory far from his palace. It is an unusual place to find him, and there\'s but a small crowd of impoverished followers at his feet, listening as he speaks. The Vizier glances at you, and then, mid-talk, nods at someone else. A moment later, a bearded man with two swords approaches. He looks you up and down, then moves aside to reveal two servants carrying a chest.%SPEECH_ON%The Vizier wishes to thank you Crownling. And may you forever travel the Gilded path.%SPEECH_OFF%Of course, you\'re ushered right back out the moment the money is transferred. Not so much as a nod or wave comes from the Vizier as the doors close behind you. | You are led down a long hall and are brought to an empty room. For a moment, you wonder if you are meant to be betrayed here. Betrayals rarely come in places where a mess would be unwanted. While you stare at the clean stone flooring, %employer% enters from the opposite side. He stands many feet away and the room echoes his voice.%SPEECH_ON%It is said that you fought well, and that the northerners proved themselves shrill dogs in battle. I imagine this latter statement is an untruth meant to induce my personal happiness. But I am a thinker and a realist. I imagine you found the enemy\'s determination to be quite formidable, just as they would ours. You will be rewarded our agreed price, Crownling.%SPEECH_OFF%A group of men suddenly file into the room behind the Vizier and, again, you wonder if they are meant there for another purpose entirely. Much to your relief, they carry with them purses of coin. When you look back toward the door, %employer% is gone and a moment later his servants are gone as well. | %employer% welcomes you into a room with himself and a few select religious figures. Each of these modest priors comes and briefly bows before you. The Vizier does not partake, but he does snap his fingers and his servants lug over a large chest of crowns. Finally, the religious men now turn to the Vizier and in a similar procession bow before him. They also kiss his feet and a ring, things not on the docket for yourself. %employer% speaks.%SPEECH_ON%My path has been ever gilded, Crownling. For the Gilder to bestow upon me such knowledge that you, a modest sellsword many would overlook, should be the one I hire to spare %holysite%. I am blessed. Truly.%SPEECH_OFF%You take the gold and go, and the last thing you see are the frocked men going back around for seconds.}",
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
		party.setDescription("Professional soldiers in service to local lords.");
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


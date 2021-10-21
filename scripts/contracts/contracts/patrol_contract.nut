this.patrol_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Location1 = null,
		Location2 = null,
		NextObjective = null,
		Dude = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.patrol";
		this.m.Name = "Patrol";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 5.0;
		this.m.MakeAllSpawnsAttackableByAIOnceDiscovered = true;
		this.m.MakeAllSpawnsResetOrdersOnceDiscovered = true;
		this.m.DifficultyMult = 1.0;
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

		local settlements = clone this.World.FactionManager.getFaction(this.m.Faction).getSettlements();
		local i = 0;

		while (i < settlements.len())
		{
			local s = settlements[i];

			if (s.isIsolatedFromRoads() || !s.isDiscovered() || s.getID() == this.m.Home.getID())
			{
				settlements.remove(i);
				continue;
			}

			i = ++i;
		}

		this.m.Location1 = this.WeakTableRef(this.getNearestLocationTo(this.m.Home, settlements, true));
		this.m.Location2 = this.WeakTableRef(this.getNearestLocationTo(this.m.Location1, settlements, true));
		this.m.Payment.Pool = 750 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
		local r = this.Math.rand(1, 3);

		if (r == 1)
		{
			this.m.Payment.Count = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else if (r == 2)
		{
			this.m.Payment.Count = 0.75;
			this.m.Payment.Completion = 0.25;
		}
		else
		{
			this.m.Payment.Count = 1.0;
		}

		local maximumHeads = [
			20,
			25,
			30,
			35
		];
		this.m.Payment.MaxCount = maximumHeads[this.Math.rand(0, maximumHeads.len() - 1)];
		this.m.Flags.set("HeadsCollected", 0);
		this.m.Flags.set("StartDay", 0);
		this.m.Flags.set("LastUpdateDay", 0);
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Flags.set("StartDay", this.World.getTime().Days);
				this.Contract.m.BulletpointsObjectives = [
					"Patrouillez la route jusqu\'à " + this.Contract.m.Location1.getName(),
					"Patrouillez la route jusqu\'à " + this.Contract.m.Location2.getName(),
					"Patrouillez la route jusqu\'à " + this.Contract.m.Home.getName()
				];
				this.Contract.m.BulletpointsObjectives.push("Revenez dans les %days% prochains jours");

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
				this.Flags.set("EnemiesAtWaypoint1", this.Math.rand(1, 100) <= 25 * this.Math.pow(this.Contract.getDifficultyMult(), 2));
				this.Flags.set("EnemiesAtWaypoint2", this.Math.rand(1, 100) <= 25 * this.Math.pow(this.Contract.getDifficultyMult(), 2) + (this.Flags.get("EnemiesAtWaypoint1") ? 0 : 50));
				this.Flags.set("EnemiesAtLocation3", this.Math.rand(1, 100) <= 25 * this.Math.pow(this.Contract.getDifficultyMult(), 2) + (this.Flags.get("EnemiesAtWaypoint2") ? 0 : 100));
				this.Flags.set("StartDay", this.World.getTime().Days);

				if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().get("Betrayed"))
				{
					this.Flags.set("IsBetrayal", this.Math.rand(1, 100) <= 75);
				}
				else
				{
					local r = this.Math.rand(1, 100);

					if (r <= 10)
					{
						if (this.World.FactionManager.isGreenskinInvasion())
						{
							this.Flags.set("IsCrucifiedMan", true);
						}
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
				this.Contract.m.Location1.getSprite("selection").Visible = true;
				this.Contract.m.Location2.getSprite("selection").Visible = false;
				this.Contract.m.Home.getSprite("selection").Visible = false;
				this.Contract.m.NextObjective = this.Contract.m.Location1;
				this.Contract.m.BulletpointsObjectives = [
					"Patrouillez la route jusqu\'à " + this.Contract.m.Location1.getName()
				];

				if (this.Contract.m.Payment.Count != 0)
				{
					this.Contract.m.BulletpointsObjectives.push("Soyez payé pour chaque tête que vous récupérez sur la route(%killcount%/%maxcount%)");
				}

				this.Contract.m.BulletpointsObjectives.push("Revenez dans les %days% prochains jours");
			}

			function update()
			{
				if (this.Flags.get("LastUpdateDay") != this.World.getTime().Days)
				{
					if (this.World.getTime().Days - this.Flags.get("StartDay") >= 5)
					{
						this.Contract.setScreen("Failure1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Flags.set("LastUpdateDay", this.World.getTime().Days);
						this.start();
						this.World.State.getWorldScreen().updateContract(this.Contract);
					}
				}

				if (this.Contract.isPlayerAt(this.Contract.m.Location1))
				{
					this.Contract.setScreen("Success1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("EnemiesAtWaypoint1"))
				{
					if (this.Contract.spawnEnemies())
					{
						this.Flags.set("EnemiesAtWaypoint1", false);
					}
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				this.Contract.addKillCount(_actor, _killer);
			}

			function onCombatVictory( _combatID )
			{
				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Location2",
			function start()
			{
				this.Contract.m.Location1.getSprite("selection").Visible = false;
				this.Contract.m.Location2.getSprite("selection").Visible = true;
				this.Contract.m.Home.getSprite("selection").Visible = false;
				this.Contract.m.NextObjective = this.Contract.m.Location2;
				this.Contract.m.BulletpointsObjectives = [
					"Patrouillez la route jusqu\'à " + this.Contract.m.Location2.getName()
				];

				if (this.Contract.m.Payment.Count != 0)
				{
					this.Contract.m.BulletpointsObjectives.push("Soyez payé pour chaque tête que vous récupérez sur la route(%killcount%/%maxcount%)");
				}

				this.Contract.m.BulletpointsObjectives.push("Revenez dans les %days% prochains jours");
			}

			function update()
			{
				if (this.Flags.get("LastUpdateDay") != this.World.getTime().Days)
				{
					if (this.World.getTime().Days - this.Flags.get("StartDay") >= 5)
					{
						this.Contract.setScreen("Failure1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Flags.set("LastUpdateDay", this.World.getTime().Days);
						this.start();
						this.World.State.getWorldScreen().updateContract(this.Contract);
					}
				}

				if (this.Contract.isPlayerAt(this.Contract.m.Location2))
				{
					this.Contract.setScreen("Success2");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("EnemiesAtWaypoint2"))
				{
					if (this.Contract.spawnEnemies())
					{
						this.Flags.set("EnemiesAtWaypoint2", false);
					}
				}

				if (this.Flags.get("IsCrucifiedMan") && !this.TempFlags.get("IsCrucifiedManShown") && this.World.State.getPlayer().getTile().HasRoad && this.Contract.getDistanceToNearestSettlement() >= 6 && this.Math.rand(1, 1000) <= 1)
				{
					this.TempFlags.set("IsCrucifiedManShown", true);
					this.Contract.setScreen("CrucifiedA");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsCrucifiedManWon"))
				{
					this.Flags.set("IsCrucifiedManWon", false);

					if (this.Math.rand(1, 100) <= 50)
					{
						this.Contract.setScreen("CrucifiedE_AftermathGood");
					}
					else
					{
						this.Contract.setScreen("CrucifiedE_AftermathBad");
					}

					this.World.Contracts.showActiveContract();
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				this.Contract.addKillCount(_actor, _killer);
			}

			function onCombatVictory( _combatID )
			{
				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);

				if (_combatID == "CrucifiedMan")
				{
					this.Flags.set("IsCrucifiedManWon", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.Location1.getSprite("selection").Visible = false;
				this.Contract.m.Location2.getSprite("selection").Visible = false;
				this.Contract.m.Home.getSprite("selection").Visible = true;
				this.Contract.m.NextObjective = this.Contract.m.Home;
				this.Contract.m.BulletpointsObjectives = [
					"Patrouillez la route jusqu\'à " + this.Contract.m.Home.getName()
				];

				if (this.Contract.m.Payment.Count != 0)
				{
					this.Contract.m.BulletpointsObjectives.push("Soyez payé pour chaque tête que vous récupérez sur la route(%killcount%/%maxcount%)");
				}

				this.Contract.m.BulletpointsObjectives.push("Revenez dans les %days% prochains jours");
			}

			function update()
			{
				if (this.Flags.get("LastUpdateDay") != this.World.getTime().Days)
				{
					if (this.World.getTime().Days - this.Flags.get("StartDay") >= 5)
					{
						this.Contract.setScreen("Failure1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Flags.set("LastUpdateDay", this.World.getTime().Days);
						this.start();
						this.World.State.getWorldScreen().updateContract(this.Contract);
					}
				}

				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					if (this.Flags.get("HeadsCollected") != 0)
					{
						this.Contract.setScreen("Success3");
					}
					else
					{
						this.Contract.setScreen("Success4");
					}

					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("EnemiesAtWaypoint3"))
				{
					if (this.Contract.spawnEnemies())
					{
						this.Flags.set("EnemiesAtWaypoint3", false);
					}
				}

				if (this.Flags.get("IsCrucifiedMan") && !this.TempFlags.get("IsCrucifiedManShown") && this.World.State.getPlayer().getTile().HasRoad && this.Contract.getDistanceToNearestSettlement() >= 6 && this.Math.rand(1, 1000) <= 1)
				{
					this.TempFlags.set("IsCrucifiedManShown", true);
					this.Contract.setScreen("CrucifiedA");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsCrucifiedManWon"))
				{
					this.Flags.set("IsCrucifiedManWon", false);

					if (this.Math.rand(1, 100) <= 50)
					{
						this.Contract.setScreen("CrucifiedE_AftermathGood");
					}
					else
					{
						this.Contract.setScreen("CrucifiedE_AftermathBad");
					}

					this.World.Contracts.showActiveContract();
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				this.Contract.addKillCount(_actor, _killer);
			}

			function onCombatVictory( _combatID )
			{
				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);

				if (_combatID == "CrucifiedMan")
				{
					this.Flags.set("IsCrucifiedManWon", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);
			}

		});
	}

	function createScreens()
	{
		this.importScreens(this.Const.Contracts.NegotiationPerHead);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Task",
			Title = "Negotiations",
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% offers a stern hand to one of his chairs. You take a seat.%SPEECH_ON%The region is not safe. Traders are complaining about brigands and other threats along the road.%SPEECH_OFF%He looks down, massaging his temples.%SPEECH_ON%As all my men are currently tied up, I need you to patrol the area. Voyagez jusqu\'à %location1%, continue to %location2% and then return here within %days% days. If you encounter any threats, make sure to take care of them. I won\'t be paying you for a stroll through the woods, mercenary. Payment will be granted per head you bring me.%SPEECH_OFF% | %employer%\'s crooning over a map, his eyes darting like that of a hawk over a field of scurrying mice. He seems unable to focus.%SPEECH_ON%All over the place, that\'s where my men are. Here. There. Over there. This part of the map? Doesn\'t even have a name, but they\'re there, too. Where they\'re not is here, and here. And that\'s where you come in, mercenary.%SPEECH_OFF%He pauses to look up at you.%SPEECH_ON%I need you to patrol the territories to %location1% and then to %location2%. Kill anything or anyone that thinks the road belongs to them. I\'m sure you know that type. But I\'m not paying you to take a walk, sellsword. Bring me every head you collect within %days% days and I\'ll pay you for each.%SPEECH_OFF% | %employer% takes a swig of wine and burps. He seems rather annoyed.%SPEECH_ON%I don\'t ordinarily ask mercenaries to do patrols for me, but most of my men are currently tied up elsewhere. It\'s a pretty simple task: just go to %location1% then to %location2%, then return here within %days% days. Sur la route, slay every man or beast that\'d be a danger to the people of these lands. But do be sure to collect their heads: I\'ll be paying you by the trophy, not by how many miles you walked.%SPEECH_OFF% | %employer% grins slyly.%SPEECH_ON%What say I give you a task where you\'re not paid just for doing it, but paid for how many heads you can collect? Does that prospect interest you? Because right now I need the lands to %location1% and %location2% patrolled. You take a stroll, kill things here and there, and then Retournez à me within %days% days with whatever heads you\'ve collected.\n\nI will pay you for those you kill. Let me know what you think.%SPEECH_OFF% | %employer% puts a finger to a map.%SPEECH_ON%I need you to go here.%SPEECH_OFF%He trails the finger to another location.%SPEECH_ON%And then to here. One long patrol. You kill anything that thinks it owns the roads that doesn\'t carry the %noblehousename% name. Do be sure to take their heads, though. I will not be paying you to take a vacation. I\'ll be paying you for each trophy you bring me À votre retour within %days% days.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "How much are we talking about?",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "That\'s too much walking for my taste.",
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
			ID = "CrucifiedA",
			Title = "Along the road...",
			Text = "[img]gfx/ui/events/event_02.png[/img]%randombrother% comes back to you with a scouting report.%SPEECH_ON%Some burned hamlets. A dead man cut in half at the belly. Legs missing. His dog was just laying there. Wouldn\'t leave. Couldn\'t coax it nowhere. Found a dead donkey up in some trees. The hawing end had a spear sticking out of it.%SPEECH_OFF%He pauses, thinks, then snaps his fingers.%SPEECH_ON%Oh! Almost forgot. There\'s a crucified man down the other side of that hill yonder. He was alive. Doing a bunch of screaming, but I stayed clear. A stranger\'s pain is tricky business.%SPEECH_OFF%",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Yes. Let\'s go see this crucified fellow.",
					function getResult()
					{
						return "CrucifiedB";
					}

				},
				{
					Text = "Nothing actionable. Good report.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Flags.set("IsCrucifiedMan", false);
			}

		});
		this.m.Screens.push({
			ID = "CrucifiedB",
			Title = "Along the road...",
			Text = "[img]gfx/ui/events/event_02.png[/img]You decide to venture down and see the crucified fella.\n\n You top a nearby hill and look down its slopes. It\'s pretty much as the sellsword put it. There\'s a crucified man down the end of the hillside. He\'s hanging limp, though even from here you can hear his occasional scream. %randombrother% asks what to do.",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Let\'s cut him down.",
					function getResult()
					{
						if (this.Math.rand(1, 100) <= 50 && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
						{
							return "CrucifiedC";
						}
						else
						{
							return "CrucifiedD";
						}
					}

				},
				{
					Text = "This is clearly a trap. Let\'s wait.",
					function getResult()
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "CrucifiedE";
						}
						else
						{
							return "CrucifiedF";
						}
					}

				},
				{
					Text = "Let\'s leave. Something is off about this.",
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
			ID = "CrucifiedC",
			Title = "Along the road...",
			Text = "[img]gfx/ui/events/event_02.png[/img]You\'re not sure you could sleep at night knowing you left this poor sod to such a horrid fate. You and the company start down the hillside. It\'s not an especially quick rescue as you\'re still worried about ambushes, but nothing does spring. The crucified man grins when you near.%SPEECH_ON%Lemme down and I\'ll fight for you to the end of my days, I promise it!%SPEECH_OFF%The sellswords leverage their weapons beneath the nails and wrench the man free. He slides down the wooden post into the arms of some mercenaries who gently lower him to the ground. In between sips of water, he talks.%SPEECH_ON%Greenskins did this to me. I was the last of my village and I guess they thought to have a bit of fun beyond just putting an axe in my face. I was beginning to prefer the latter until you came along. I\'m not in the best of shape, sir, but with time I\'ll recover and I swear by my name, which I am the last of, that I will fight for you until death or the last victory!%SPEECH_OFF%",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Few men could survive such horrors. Welcome to the company.",
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
					Text = "This company is no place for you.",
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
				this.Contract.m.Dude.setStartValuesEx(this.Const.CharacterVillageBackgrounds);
				this.Contract.m.Dude.getBackground().m.RawDescription = "You pulled the crucified %name% down off the means to his execution just in time. He has pledged allegiance to your side until the end of his days or the last of your victories.";
				this.Contract.m.Dude.getBackground().buildDescription(true);
				this.Contract.m.Dude.getSkills().removeByID("trait.disloyal");
				this.Contract.m.Dude.getSkills().add(this.new("scripts/skills/traits/loyal_trait"));
				this.Contract.m.Dude.setHitpoints(1);

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
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "CrucifiedD",
			Title = "Along the road...",
			Text = "[img]gfx/ui/events/event_67.png[/img]Sleeping at night would get a little harder if you left this poor sod behind. You lead the company down the hillside in part to save him and save your own sanity. The crucified fella begins to smile as you near.%SPEECH_ON%Thank you, stranger! Thank you thank you thank--%SPEECH_OFF%He\'s cut off by a sickening \'thunk\' of a javelin spearing his chest and into the wooden boards upon which he is crucified. You spin around in time to see greenskins rushing out of some nearby bushes. Goddammit, it was a trap all along! To arms!",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "To arms!",
					function getResult()
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.GoblinsTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.EnemyBanners = [
							"banner_goblins_03"
						];
						properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.GreenskinHorde, this.Math.rand(90, 110), this.Const.Faction.Enemy);
						this.World.Contracts.startScriptedCombat(properties, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "CrucifiedE",
			Title = "Along the road...",
			Text = "[img]gfx/ui/events/event_07.png[/img]You decide to wait it out. As you sit and listen the dying man\'s wails slowly quiet down into silence, %randombrother% grabs you by the shoulder and points a little ways off. There are some brigands coming toward the crucified fella. They get there and talk for a time. One man takes out a dagger and starts stabbing it into the dying man\'s toes. His wails aren\'t quiet any longer. One of the brigands turns around laughing. He stops. He says something. He points. You\'ve been seen! Before those arseholes can get into formation, you order the %companyname% to charge!",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "To arms!",
					function getResult()
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "CrucifiedMan";
						properties.Music = this.Const.Music.GoblinsTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.EnemyBanners = [
							"banner_bandits_03"
						];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.BanditRaiders, this.Math.rand(90, 110), this.Const.Faction.Enemy);
						this.World.Contracts.startScriptedCombat(properties, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "CrucifiedE_AftermathGood",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]Shockingly, the crucified man is still alive Après la bataille. He calls to you with a raspy voice that carries no words, but a simple tone of \'please help\'. You have the brothers cut him down. He passes out the second he hits the ground, then jolts awakes and grabs you by the hand.%SPEECH_ON%Thank you, stranger. Thank you so much. The orcs... they came... and then brigands to pillage the remains... but you, you\'re different. Thank you! I\'ve nothing left in this world but to fight against those who took everything from me. I am %crucifiedman%, the last of my name, and if you give me the honor, I pledge you my sword until the day I die or you see your last victory.%SPEECH_OFF%",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Few men could survive such horrors. Welcome to the company.",
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
					Text = "This company is no place for you.",
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
				this.Contract.m.Dude.setStartValuesEx(this.Const.CharacterVillageBackgrounds);
				this.Contract.m.Dude.getBackground().m.RawDescription = "You pulled the crucified %name% down off the means to his execution just in time. He has pledged allegiance to your side until the end of his days or the last of your victories.";
				this.Contract.m.Dude.getBackground().buildDescription(true);
				this.Contract.m.Dude.getSkills().removeByID("trait.disloyal");
				this.Contract.m.Dude.getSkills().add(this.new("scripts/skills/traits/loyal_trait"));
				this.Contract.m.Dude.setHitpoints(1);

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
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "CrucifiedE_AftermathBad",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]The brigands taken care of, you go to see if the crucified man is still alive. He did not survive. With nothing on his body worth taking, you loot the brigands and get the %companyname% back on the path.",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Rest in peace.",
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
			ID = "CrucifiedF",
			Title = "Along the road...",
			Text = "[img]gfx/ui/events/event_02.png[/img]You decide to wait it out. The dying man keeps on dying. His cries get a little bit quieter, which is nice on the ears, but bad on the souls of the men. After a while, %randombrother% comes up and suggests that the company head on down. The likelihood that someone would stay around for an ambush now is very unlikely indeed. You and the company trot down the hillside and get to the crucified man. His chin is to his chest, his eyes half-opened, a froth of drool and blood dripping from his lips. With nothing on him worth taking, you order the %companyname% to get back on the path.",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Rest in peace.",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-1);
						return 0;
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().isOffendedByViolence() && !bro.getBackground().isCombatBackground())
					{
						bro.worsenMood(0.5, "You let a crucified man die a slow death");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "At %location1%...",
			Text = "[img]gfx/ui/events/event_45.png[/img]{You reach %location1% and have the men take a break. While they rest, you count supplies and make sure everything is in order. Soon enough, you get the company back to marching. | Stopping at %location1%, the first leg of the patrol, you have the men rest for a time. You\'ve more road ahead so you figure now is a good time as any to resupply. | The first leg of the patrol is finished. Now you\'ve to move on to the next one. You inform the men as much and they groan. You also inform them that you are not paying them to bitch, but they groan at that, too. | You reach the first point of patrol and order the men to take five while you count supplies. The patrol is only one third finished. You wonder if you should stock up on more equipment before heading back out. | You reach %location1% safe and for the most part sound.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "We move on.",
					function getResult()
					{
						this.Contract.setState("Location2");
						return 0;
					}

				}
			],
			function start()
			{
				if (this.Math.rand(1, 100) <= 33)
				{
					this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/safe_roads_situation"), 2, this.Contract.m.Location1, this.List);
				}
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "At %location2%...",
			Text = "[img]gfx/ui/events/event_45.png[/img]{%location2% is just where it was said to be. You have the men go for some rest and recuperation while you plan out the last leg of the patrol. | The patrol takes you to %location2% which receives you with the same guff and suspicion a mercenary is met with anywhere. You\'ve another leg of the journey to go, so perhaps gathering supplies here is a good idea. | The men fan out into %location2%\'s pubs. You simply take stock of your supplies and wonder if resupplying is a good idea. Glancing at the dim lights of a pub, you also wonder if a quick drink wouldn\'t hurt, either. | Reaching %location2%, %randombrother% suggests that the company should pick up some supplies for the journey back to %employer%. You\'ve already thought of this, but you give the sellsword the satisfaction of having come up with the idea himself.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "We move on.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				if (this.Math.rand(1, 100) <= 33)
				{
					this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/safe_roads_situation"), 2, this.Contract.m.Location2, this.List);
				}
			}

		});
		this.m.Screens.push({
			ID = "Success3",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_45.png[/img]{Your Retournez à %employer% is met with curiosity. He\'s counting crowns but, before giving you any, asks you how many \'heads\' you collected in your journey. After reporting %killcount% kills, he purses his lips and nods.%SPEECH_ON%Good enough.%SPEECH_OFF%The man spills some crowns into a satchel and hands it over. | Returning to %employer%, you find the man sitting deeply into an enormous chair, as if he needed all that space to support his nobility, opulence, and pride.\n\nYou talk about the patrol, how you killed %killcount% while on the road. Your emphasis is on the kills, as that is what you\'re being paid for. %employer% nods and has one of his men throw crowns into a satchel and hand it over. | %employer% stands by a window, drinking wine and seeming to ogle a few women gardening below. Without turning to face you, he asks how many you killed on your journey.%SPEECH_ON%%killcount%.%SPEECH_OFF%The nobleman chuckles.%SPEECH_ON%You make it seem so easy.%SPEECH_OFF%Again without looking, he snaps his fingers. A man appears from the side with a satchel in hand. You take it, then take your leave. | %employer% is reading scrolls of papers as he welcomes you in. He\'s curious as to how many kills you racked up on patrol. You report %killcount%, to which he hums and makes a small note on one of the papers. Nodding his head, he kicks open a chest next to him and starts scooping crowns into a satchel. He hands it over and then, without even looking up, tells you to get out. | There\'s a party going on at %employer%\'s abode. You weave through the crowd drunken opulence to get to the man. He shouts over the music and noise, asking how many you cut down on your patrol. It\'s odd, but shouting that you killed %killcount% seems to have no effect on the partygoers. Shrugging, %employer% turns and leaves, slipping into the crowd of attendees. You try to chase, but a man cuts you off, slamming a satchel into your chest.%SPEECH_ON%Your payment, mercenary. Now, please, see to the door. People are beginning to notice you and they did not come here to feel uncomfortable.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Enough marching for today.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.Assets.addMoney(this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected"));
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Patrolled the realm");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				local money = this.Contract.m.Payment.getOnCompletion() + this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected");
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
				});

				if (this.Math.rand(1, 100) <= 33)
				{
					this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/safe_roads_situation"), 2, this.Contract.m.Home, this.List);
				}
			}

		});
		this.m.Screens.push({
			ID = "Success4",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_45.png[/img]{You return %employer% emptyhanded. He sizes you up, notably eyeing your lack of scalps.%SPEECH_ON%Really? No trouble at all?%SPEECH_OFF%You don\'t move. The man purses his lips and shrugs.%SPEECH_ON%Ah hell, well...%SPEECH_OFF%He looks at you and almost gags on a chuckle.%SPEECH_ON%Interesting, I guess.%SPEECH_OFF% | %employer% looks you up and down.%SPEECH_ON%Where are the heads, sellsword? Surely you didn\'t forget to collect those...?%SPEECH_OFF%You explain that you didn\'t run into anything on the patrol. The man raises an eyebrow.%SPEECH_ON%No shit? Hell... well... bye.%SPEECH_OFF% | You Retournez à %employer% emptyhanded. He stares at your lack of... wares.%SPEECH_ON%What\'s this? Where the hell are the heads I was gonna pay you for?%SPEECH_OFF%Shrugging, you explain that there was no trouble on the patrol. %employer%\'s taking a sip of wine and almost chokes on it at this news.%SPEECH_ON%Wait, really? I mean, I guess that\'s good and all, but damned... didn\'t expect that. I, uh, suppose you didn\'t either.%SPEECH_OFF%You stare at each other. A bird coos to fill the silence. The man sips his wine and glances out his window.%SPEECH_ON%So... interesting weather today, yeah?%SPEECH_OFF%You roll your eyes.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Enough marching for today.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnVictory);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractPoor, "Patrolled the realm");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				if (this.Contract.m.Payment.getOnCompletion() > 0)
				{
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Couronnes"
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_45.png[/img]{You took far too long to complete the patrol you\'ve been tasked with. Consider the contract failed. | A man in the employ of %employer% approaches with a notice. It states that your patrol was meant to be quick, not a merry little walk for yourself. Consider the contract failed. | What were you trying to do, collect as many heads as possible? It\'s doubtful that your employer, %employer%, would buy such a ruse. There\'s a reason he only gave you a few days to complete this task. Consider it failed.}",
			Image = "",
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Damn this contract!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Wandered off while tasked to patrol");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function addKillCount( _actor, _killer )
	{
		if (_killer != null && _killer.getFaction() != this.Const.Faction.Player && _killer.getFaction() != this.Const.Faction.PlayerAnimals)
		{
			return;
		}

		if (this.m.Flags.get("HeadsCollected") >= this.m.Payment.MaxCount)
		{
			return;
		}

		if (_actor.getXPValue() == 0)
		{
			return;
		}

		if (_actor.getType() == this.Const.EntityType.GoblinWolfrider || _actor.getType() == this.Const.EntityType.Wardog || _actor.getType() == this.Const.EntityType.Warhound || _actor.getType() == this.Const.EntityType.SpiderEggs || this.isKindOf(_actor, "lindwurm_tail"))
		{
			return;
		}

		if (!_actor.isAlliedWithPlayer() && !_actor.isAlliedWith(this.m.Faction) && !_actor.isResurrected())
		{
			this.m.Flags.set("HeadsCollected", this.m.Flags.get("HeadsCollected") + 1);
		}
	}

	function spawnEnemies()
	{
		if (this.m.Flags.get("HeadsCollected") >= this.m.Payment.MaxCount)
		{
			return false;
		}

		local tries = 0;
		local myTile = this.m.NextObjective.getTile();
		local tile;

		while (tries++ < 10)
		{
			local tile = this.getTileToSpawnLocation(myTile, 7, 11);

			if (tile.getDistanceTo(this.World.State.getPlayer().getTile()) <= 6)
			{
				continue;
			}

			local nearest_bandits = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getNearestSettlement(tile);
			local nearest_goblins = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(tile);
			local nearest_orcs = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(tile);
			local nearest_barbarians = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians) != null ? this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).getNearestSettlement(tile) : null;
			local nearest_nomads = this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits) != null ? this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getNearestSettlement(tile) : null;

			if (nearest_bandits == null && nearest_goblins == null && nearest_orcs == null && nearest_barbarians == null && nearest_nomads == null)
			{
				this.logInfo("no enemy base found");
				return false;
			}

			local bandits_dist = nearest_bandits != null ? nearest_bandits.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local goblins_dist = nearest_goblins != null ? nearest_goblins.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local orcs_dist = nearest_orcs != null ? nearest_orcs.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local barbarians_dist = nearest_barbarians != null ? nearest_barbarians.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local nomads_dist = nearest_nomads != null ? nearest_nomads.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local party;
			local origin;

			if (bandits_dist <= goblins_dist && bandits_dist <= orcs_dist && bandits_dist <= barbarians_dist && bandits_dist <= nomads_dist)
			{
				if (this.Math.rand(1, 100) <= 50)
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).spawnEntity(tile, "Brigands", false, this.Const.World.Spawn.BanditRaiders, 110 * this.getDifficultyMult() * this.getScaledDifficultyMult());
				}
				else
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).spawnEntity(tile, "Brigand Hunters", false, this.Const.World.Spawn.BanditRoamers, 80 * this.getDifficultyMult() * this.getScaledDifficultyMult());
				}

				party.setDescription("A rough and tough band of brigands preying on the weak.");
				party.setFootprintType(this.Const.World.FootprintsType.Brigands);
				party.getLoot().Money = this.Math.rand(50, 100);
				party.getLoot().ArmorParts = this.Math.rand(0, 10);
				party.getLoot().Medicine = this.Math.rand(0, 2);
				party.getLoot().Ammo = this.Math.rand(0, 20);
				local r = this.Math.rand(1, 6);

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
				else if (r == 5)
				{
					party.addToInventory("supplies/pickled_mushrooms_item");
				}

				origin = nearest_bandits;
			}
			else if (goblins_dist <= bandits_dist && goblins_dist <= orcs_dist && goblins_dist <= barbarians_dist && goblins_dist <= nomads_dist)
			{
				if (this.Math.rand(1, 100) <= 50)
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).spawnEntity(tile, "Goblin Raiders", false, this.Const.World.Spawn.GoblinRaiders, 110 * this.getDifficultyMult() * this.getScaledDifficultyMult());
				}
				else
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).spawnEntity(tile, "Goblin Scouts", false, this.Const.World.Spawn.GoblinScouts, 80 * this.getDifficultyMult() * this.getScaledDifficultyMult());
				}

				party.setDescription("A band of mischievous goblins, small but cunning and not to be underestimated.");
				party.setFootprintType(this.Const.World.FootprintsType.Goblins);
				party.getLoot().ArmorParts = this.Math.rand(0, 10);
				party.getLoot().Medicine = this.Math.rand(0, 2);
				party.getLoot().Ammo = this.Math.rand(0, 30);

				if (this.Math.rand(1, 100) <= 75)
				{
					local loot = [
						"supplies/strange_meat_item",
						"supplies/roots_and_berries_item",
						"supplies/pickled_mushrooms_item"
					];
					party.addToInventory(loot[this.Math.rand(0, loot.len() - 1)]);
				}

				if (this.Math.rand(1, 100) <= 33)
				{
					local loot = [
						"loot/goblin_carved_ivory_iconographs_item",
						"loot/goblin_minted_coins_item",
						"loot/goblin_rank_insignia_item"
					];
					party.addToInventory(loot[this.Math.rand(0, loot.len() - 1)]);
				}

				origin = nearest_goblins;
			}
			else if (barbarians_dist <= goblins_dist && barbarians_dist <= bandits_dist && barbarians_dist <= orcs_dist && barbarians_dist <= nomads_dist)
			{
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).spawnEntity(tile, "Barbarians", false, this.Const.World.Spawn.Barbarians, 110 * this.getDifficultyMult() * this.getScaledDifficultyMult());
				party.setDescription("A warband of barbarian tribals.");
				party.setFootprintType(this.Const.World.FootprintsType.Barbarians);
				party.getLoot().Money = this.Math.rand(0, 50);
				party.getLoot().ArmorParts = this.Math.rand(0, 10);
				party.getLoot().Medicine = this.Math.rand(0, 5);
				party.getLoot().Ammo = this.Math.rand(0, 30);

				if (this.Math.rand(1, 100) <= 50)
				{
					party.addToInventory("loot/bone_figurines_item");
				}

				if (this.Math.rand(1, 100) <= 50)
				{
					party.addToInventory("loot/bead_necklace_item");
				}

				local r = this.Math.rand(2, 5);

				if (r == 2)
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
				else if (r == 5)
				{
					party.addToInventory("supplies/pickled_mushrooms_item");
				}

				origin = nearest_barbarians;
			}
			else if (nomads_dist <= barbarians_dist && nomads_dist <= goblins_dist && nomads_dist <= bandits_dist && nomads_dist <= orcs_dist)
			{
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).spawnEntity(tile, "Nomads", false, this.Const.World.Spawn.NomadRaiders, 110 * this.getDifficultyMult() * this.getScaledDifficultyMult());
				party.setDescription("A band of desert raiders preying on anyone trying to cross the seas of sand.");
				party.setFootprintType(this.Const.World.FootprintsType.Nomads);
				party.getLoot().Money = this.Math.rand(50, 200);
				party.getLoot().ArmorParts = this.Math.rand(0, 10);
				party.getLoot().Medicine = this.Math.rand(0, 2);
				party.getLoot().Ammo = this.Math.rand(0, 20);
				local r = this.Math.rand(1, 4);

				if (r == 1)
				{
					party.addToInventory("supplies/bread_item");
				}
				else if (r == 2)
				{
					party.addToInventory("supplies/dates_item");
				}
				else if (r == 3)
				{
					party.addToInventory("supplies/rice_item");
				}
				else if (r == 4)
				{
					party.addToInventory("supplies/dried_lamb_item");
				}

				origin = nearest_nomads;
			}
			else
			{
				if (this.Math.rand(1, 100) <= 50)
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).spawnEntity(tile, "Orc Marauders", false, this.Const.World.Spawn.OrcRaiders, 110 * this.getDifficultyMult() * this.getScaledDifficultyMult());
				}
				else
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).spawnEntity(tile, "Orc Scouts", false, this.Const.World.Spawn.OrcScouts, 80 * this.getDifficultyMult() * this.getScaledDifficultyMult());
				}

				party.setDescription("A band of menacing orcs, greenskinned and towering any man.");
				party.setFootprintType(this.Const.World.FootprintsType.Orcs);
				party.getLoot().ArmorParts = this.Math.rand(0, 25);
				party.getLoot().Ammo = this.Math.rand(0, 10);
				party.addToInventory("supplies/strange_meat_item");
				origin = nearest_orcs;
			}

			party.getSprite("banner").setBrush(origin.getBanner());
			party.setAttackableByAI(false);
			party.setAlwaysAttackPlayer(true);
			local c = party.getController();
			local intercept = this.new("scripts/ai/world/orders/intercept_order");
			intercept.setTarget(this.World.State.getPlayer());
			c.addOrder(intercept);
			this.m.UnitsSpawned.push(party.getID());
			return true;
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"location1",
			this.m.Location1.getName()
		]);
		_vars.push([
			"location2",
			this.m.Location2.getName()
		]);
		_vars.push([
			"killcount",
			this.m.Flags.get("HeadsCollected")
		]);
		_vars.push([
			"noblehousename",
			this.World.FactionManager.getFaction(this.m.Faction).getNameOnly()
		]);
		_vars.push([
			"days",
			5 - (this.World.getTime().Days - this.m.Flags.get("StartDay"))
		]);
		_vars.push([
			"crucifiedman",
			this.m.Dude != null ? this.m.Dude.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Location1 != null)
			{
				this.m.Location1.getSprite("selection").Visible = false;
			}

			if (this.m.Location2 != null)
			{
				this.m.Location2.getSprite("selection").Visible = false;
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (this.m.IsStarted)
		{
			if (this.m.Location1 == null || this.m.Location1.isNull() || !this.m.Location1.isAlive())
			{
				return false;
			}

			if (this.m.Location2 == null || this.m.Location2.isNull() || !this.m.Location2.isAlive())
			{
				return false;
			}

			return true;
		}
		else
		{
			if (this.World.FactionManager.getFaction(this.m.Faction).getSettlements().len() < 3)
			{
				return false;
			}

			return true;
		}
	}

	function onIsTileUsed( _tile )
	{
		if (this.m.Location1 != null && !this.m.Location1.isNull() && _tile.ID == this.m.Location1.getTile().ID)
		{
			return true;
		}

		if (this.m.Location2 != null && !this.m.Location2.isNull() && _tile.ID == this.m.Location2.getTile().ID)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		if (this.m.Location1 != null)
		{
			_out.writeU32(this.m.Location1.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		if (this.m.Location2 != null)
		{
			_out.writeU32(this.m.Location2.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local location1 = _in.readU32();

		if (location1 != 0)
		{
			this.m.Location1 = this.WeakTableRef(this.World.getEntityByID(location1));
		}

		local location2 = _in.readU32();

		if (location2 != 0)
		{
			this.m.Location2 = this.WeakTableRef(this.World.getEntityByID(location2));
		}

		this.contract.onDeserialize(_in);
	}

});


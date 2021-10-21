this.hold_chokepoint_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Target = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hold_chokepoint";
		this.m.Name = "Hold Fortress";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		local enemies = [];

		foreach( n in nobles )
		{
			if (n.getFlags().get("IsHolyWarParticipant"))
			{
				enemies.push(n);
			}
		}

		this.m.Flags.set("EnemyID", enemies[this.Math.rand(0, enemies.len() - 1)].getID());
		local locations = this.World.EntityManager.getLocations();
		local candidates = [];

		foreach( v in locations )
		{
			if (v.getTypeID() == "location.abandoned_fortress")
			{
				candidates.push(v);
			}
		}

		local closest;
		local closest_dist = 9000;

		foreach( c in candidates )
		{
			local d = this.m.Home.getTile().getDistanceTo(c.getTile()) + this.Math.rand(0, 5);

			if (d < closest_dist)
			{
				closest = c;
				closest_dist = d;
			}
		}

		this.m.Destination = this.WeakTableRef(closest);
		this.m.Payment.Pool = 1400 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
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

		this.m.Flags.set("Wave", 0);
		this.m.Flags.set("WavesDefeated", 0);
		this.m.Flags.set("WaitUntil", 0.0);
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
					"Allez jusqu\'à la forteresse abandonnée et défendez la contre les incursions des Nordiques"
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 20)
				{
					if (this.Contract.getDifficultyMult() <= 1.05)
					{
						this.Flags.set("IsEnemyRetreating", true);
					}
				}

				if (r <= 40)
				{
					this.Flags.set("IsReinforcements", true);
				}
				else if (r <= 70)
				{
					this.Flags.set("IsUltimatum", true);
				}

				local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);

				foreach( n in nobles )
				{
					if (n.getFlags().get("IsHolyWarParticipant"))
					{
						n.addPlayerRelation(-99.0, "Took sides in the war");
					}
				}

				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
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
				if (this.Contract.isPlayerAt(this.Contract.m.Destination))
				{
					this.Contract.setScreen("Arrive");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Running_Defend",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Utilisez la forteresse abandonnée pour vous défendre contre les incursions des nordiques",
					"Ne vous éloignez pas trop"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
				}

				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Flags.get("IsFailure") || !this.Contract.isPlayerNear(this.Contract.m.Destination, 600))
				{
					this.Contract.setScreen("Failure");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (this.Flags.get("Wave") > this.Flags.get("WavesDefeated") && (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive()))
				{
					this.Flags.increment("WavesDefeated", 1);
					this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + this.Math.rand(3, 6));

					if (this.Flags.get("WavesDefeated") == 1)
					{
						this.Contract.setScreen("Waiting1");
					}
					else if (this.Flags.get("WavesDefeated") == 2)
					{
						this.Contract.setScreen("Waiting2");
					}
					else if (this.Flags.get("WavesDefeated") == 3)
					{
						this.Contract.setScreen("Victory");
					}

					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("WaitUntil") > 0 && this.Time.getVirtualTimeF() >= this.Flags.get("WaitUntil"))
				{
					this.Flags.set("WaitUntil", 0.0);
					this.Flags.set("IsWaveShown", false);

					if (this.Flags.getAsInt("Wave") == 2 && this.Flags.get("IsEnemyRetreating"))
					{
						this.Contract.setScreen("EnemyRetreats");
						this.World.Contracts.showActiveContract();
						return;
					}
					else if (this.Flags.getAsInt("Wave") == 2 && this.Flags.get("IsUltimatum"))
					{
						this.Contract.setScreen("Ultimatum1");
						this.World.Contracts.showActiveContract();
						return;
					}
					else
					{
						this.Flags.increment("Wave", 1);
						local enemyNobleHouse = this.World.FactionManager.getFaction(this.Flags.get("EnemyID"));
						local candidates = [];

						foreach( s in enemyNobleHouse.getSettlements() )
						{
							if (s.isMilitary())
							{
								candidates.push(s);
							}
						}

						local mapSize = this.World.getMapSize();
						local o = this.Contract.m.Destination.getTile().SquareCoords;
						local tiles = [];

						for( local x = o.X - 3; x < o.X + 3; x = ++x )
						{
							for( local y = o.Y + 3; y <= o.Y + 6; y = ++y )
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
						local party = enemyNobleHouse.spawnEntity(tiles[0].Tile, candidates[this.Math.rand(0, candidates.len() - 1)].getName() + " Company", true, this.Const.World.Spawn.Noble, (this.Math.rand(100, 120) + this.Flags.get("Wave") * 10 + (this.Flags.get("IsAlliedReinforcements") ? 50 : 0)) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + enemyNobleHouse.getBannerString());
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
						local attack = this.new("scripts/ai/world/orders/attack_zone_order");
						attack.setTargetTile(this.Contract.m.Destination.getTile());
						c.addOrder(attack);
						local move = this.new("scripts/ai/world/orders/move_order");
						move.setDestination(this.Contract.m.Destination.getTile());
						c.addOrder(move);
						local guard = this.new("scripts/ai/world/orders/guard_order");
						guard.setTarget(this.Contract.m.Destination.getTile());
						guard.setTime(240.0);
						c.addOrder(guard);
						party.setAttackableByAI(false);
						party.setAlwaysAttackPlayer(true);
						party.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
						this.Contract.m.Target = this.WeakTableRef(party);
					}
				}
			}

			function onDestinationAttacked( _dest, _isPlayerInitiated )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerInitiated;

				if (!this.Flags.get("IsWaveShown"))
				{
					this.Flags.set("IsWaveShown", true);

					if (this.Flags.getAsInt("Wave") == 3 && this.Flags.get("IsReinforcements"))
					{
						this.Contract.setScreen("Reinforcements");
					}
					else
					{
						this.Contract.setScreen("Wave" + this.Flags.get("Wave"));
					}

					this.World.Contracts.showActiveContract();
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "HoldChokepoint";
					p.Music = this.Const.Music.NobleTracks;

					if (this.Contract.isPlayerAt(this.Contract.m.Destination))
					{
						_isPlayerInitiated = false;
						p.MapSeed = this.Flags.getAsInt("MapSeed");
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineForward;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.LocationTemplate.OwnedByFaction = this.Const.Faction.Player;
						p.LocationTemplate.Template[0] = "tactical.southern_ruins";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						p.LocationTemplate.ShiftX = -4;

						if (this.Flags.get("IsAlliedReinforcements"))
						{
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Southern, 50 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
							p.AllyBanners.push(this.World.FactionManager.getFaction(this.Contract.getFaction()).getPartyBanner());
						}
					}

					this.World.Contracts.startScriptedCombat(p, _isPlayerInitiated, true, true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "HoldChokepoint")
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
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					if (this.Flags.getAsInt("WavesDefeated") <= 2 && !this.Flags.get("IsEnemyRetreating"))
					{
						this.Contract.setScreen("Success1");
					}
					else
					{
						this.Contract.setScreen("Success2");
					}

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
			Text = "[img]gfx/ui/events/event_162.png[/img]{%employer% is surrounded by his military men. They\'re wearing a great deal of pompous clothes that make you think they\'re a little outside their element taking on war. However, despite the rather feathery appearance, one of the commanders takes you aside with a map and speaks clearly.%SPEECH_ON%Crownling, we need you to Voyagez jusqu\'à an abandoned fortress %direction% from here. We have a wing of soldiers marching to the location, but they will not beat the northern savages to it. Of anyone within reach, you are the closest. Go there and defend until our soldiers show. The fortification is decrepit, but I believe a man of your conniving nature can make do with a bit of rubble if he needs to. %reward% crowns will wait upÀ votre retour, and your success, of course.%SPEECH_OFF% | %employer% sits on a pillow with a huge rug spread out before him. Well-dressed lieutenants sit autour de corners, each armed with a long wooden stick to push pieces around. And at the length of the rug are a few carpetmakers still adding to the map - as far as you can tell they are adding sections of the north. The Vizier sees you and speaks from a distance.%SPEECH_ON%Crownling, there lies a fort %direction% of here. It is a fallen fortress, made of little more than rubble some say, but the ancients built it there for good reason: it is of great strategic importance. While I have soldiers moving swiftly to its location, they will not arrive before a contingent of northerners do. Unclean savages they are, you have to respect their wile in advancing rapidly. So, I need you to occupy the fortress and hold off the northerners until my armies there.%SPEECH_OFF%He holds up a piece of paper with a number you can understand easily: %reward% crowns. | A very tall man in military garb heads you off from entering %employer%\'s room. The Vizier can be heard mingling with his harem, but that\'s not your business. The lieutenant presses a scroll into your chest.%SPEECH_ON%The ancients built a fortress %direction% from here. It has since fallen apart, weak as all things are to the passage of time, but its location still proves strategic. We are currently moving a troop of soldiers to the location, but our scouts have relayed that the northern dogs are as aware of its import and will beat us there. That is where you come in. %reward% crowns to commandeer the fort and hold it until help arrives. Once relieved, you Retournez à us and earn a good little Crowling\'s pay.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Sounds like something the %companyname% can do. | Let\'s talk some more about what we\'re paid for this. | We can hold the fortress against heathen invaders.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Ça ne vaut pas le coup. | On est demandé autre part. | I won\'t risk the company to hold some ruins.}",
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
			ID = "Arrive",
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/event_167.png[/img]{The fortress is both familiar and unusual. Despite being broken apart and sliding into piles of rubble, you can\'t help but get a sense of eminence in its walls. Further inside, about the dilapidated armories and abandoned mess halls, there are more cursory constructs: hastily erected defenses, signs of last stands made far away from where they should be. There is no telling what happened here, or even when, but for now it will serve as the %companyname%\'s temporary home.\n\n You walk to the crenelated walls and look out. It seems you have taken the position just in time: the northerners are already on the approach, a line of silhouettes marching just over the horizon like ants to their hill. | The fortress being a lost vestige of an ancient empire seems right: its constructs are as familiar as they are alien. You understand what walls are for, but you\'re not sure what to make of some of the symbols carved into them. Even the architecture of some of the rooms, the way the corners sweep in incredible bricked swirls, is not like anything you\'ve seen. You\'re not sure if there is some tactical advantage there or perhaps its builders intended the designs to be of other import.\n\nBut there is no time to dally on the matter of its history, you\'re here to simply use it as a chokepoint. And it seems the time is at hand: a wave of northerners is crashing over the horizon and charging directly for you!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Everyone, get ready!",
					function getResult()
					{
						this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + this.Math.rand(5, 8));
						this.Contract.setState("Running_Defend");
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Wave1",
			Title = "Before the battle...",
			Text = "[img]gfx/ui/events/event_90.png[/img]{The northern vanguard is here. You jump to the walls and shout at the %companyname% to ready themselves for battle. The sellswords jump to action, taking up positions and readying their weapons. All the while, the chink-and-chunk of northern arm claps loudly as they draw near. The first arrow sails harmlessly into the fort, a meek sign that an ugly battle is about to take place.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To arms!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Wave2",
			Title = "Before the battle...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{%randombrother% yells out and you rush to the walls. Arrayed across the field is a contingent of heavily armed northerners. Perhaps they have learned that is the %companyname% standing before them and they wish to take the matter a mite more seriously. Not that extra caution will save them. There\'s only one result of facing down the %companyname% and you can\'t help but offer an inviting grin at the approaching assault.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To arms!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Wave3",
			Title = "Before the battle...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{The northerners approach once more. They march through the corpses like bream through brine, a dark knot of men and material, darkly and silhouetted in the bloody mud which you\'ve made of the earth they dare trespass over. Rats already pecking at the dead scatter every which way and the buzzards take flight. You raise your arm and order the men to prepare for what is hopefully the final battle.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To arms!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Waiting1",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_167.png[/img]{The first attack has been repelled. You briefly consider using the corpses to plug holes in the walls, but you\'ve no interest inviting rats and their pestilence to the field. With a snap order, you have the bodies heaped in a pile outside the walls and then have the men prepare for the next assault.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Get ready for their next assault!",
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
			ID = "Waiting2",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_167.png[/img]{The %companyname% are almost starting to look like the men they were when you first hired them: downtrodden and beaten by the world. But all this time with the company has made them better men. Despite the exhaustion, there is no tiring out training, there is no wearing down prestige, there is no taxing renown. When it comes, the %companyname% will be ready for the next assault.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "There may be more coming still.",
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
			ID = "Failure",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_87.png[/img]{You\'ve seen enough of this. The Vizier tasked the company with holding for a period of time, not to sit here and commit suicide.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "This is not worth losing the company over...",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Failed to hold a fortification against northern invaders");
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
			ID = "EnemyRetreats",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_168.png[/img]{With bodies piling up, flies buzzing about, and buzzards circling the air in great black clouds, it appears the northerners have had enough. A horn sounds off with a defeated pitter-patter of bleats and the men lower their arms and turn back from whence they came. At the same time, a scout arrives from the south saying that %employer%\'s troops will soon arrive. It seems you are safe to Retournez à your employer.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We made it!",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.spawnAllies();
			}

		});
		this.m.Screens.push({
			ID = "Reinforcements",
			Title = "Before the battle...",
			Text = "[img]gfx/ui/events/event_164.png[/img]{The northerners approach once more. They march through the corpses like bream through brine, a dark knot of men and material, darkly and silhouetted in the bloody mud which you\'ve made of the earth they dared trespass over. Just as you raise your arms to give your men command, more men appear on the horizon. Your heart sinks for a moment, until you realize they are flying %employer%\'s colors! The Vizier\'s men have arrived!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Finally, some help!",
					function getResult()
					{
						this.Flags.set("IsAlliedReinforcements", true);
						this.Flags.set("IsReinforcements", false);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Ultimatum1",
			Title = "As you wait...",
			Text = "[img]gfx/ui/events/event_90.png[/img]{A blaring horn catches your attention. You go to the top of your defenses and look down to find a herald flying noble colors. He\'s alone, though his voice easily accounts for a full company.%SPEECH_ON%Doth thee gentle sellsword seek clemency? Doth thee gentle sellsword seek to have another \'morrow, perhaps another winter and spring? Doth thee gentle sellsword wish to liveth, so that his...%SPEECH_OFF%You yell back at him to get to the point. The man clears his throat.%SPEECH_ON%The nobles are willing to make a deal. Depart these premises at once and you will be let go without hounding. Not only this, we submit that your tablet is of wax, and to leave here is to melt its slate clean. All hostilities between the %companyname% and the North will be set aside by northern writ. That is, of course, only if you accept the offer.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Your offer is acceptable.",
					function getResult()
					{
						return "Ultimatum2";
					}

				},
				{
					Text = "To hell with you and your wax!",
					function getResult()
					{
						return "Ultimatum3";
					}

				}
			],
			function start()
			{
				this.Flags.set("IsArrived", true);
			}

		});
		this.m.Screens.push({
			ID = "Ultimatum2",
			Title = "As you wait...",
			Text = "[img]gfx/ui/events/event_90.png[/img]{You take the deal. A few of the men grouse, others are relieved, though the hint of one or the other is kept very well hidden to not rouse your own suspicions no doubt. The %companyname% \'lawfully\' absconds this site, and the northerners take control. You are given a number of formal scripts which carry every signature of note that could be drawn out of the northern families, and their formal stamps as well. It will carry you peacefully through northern territories, though you\'ve no doubt earned that right with the forfeiture of good will in the south.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "It\'s best for the company this way.",
					function getResult()
					{
						local f = this.World.FactionManager.getFaction(this.Contract.getFaction());
						f.addPlayerRelation(-f.getPlayerRelation(), "Changed sides in the war");
						f.getFlags().set("Betrayed", true);
						local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);

						foreach( n in nobles )
						{
							n.addPlayerRelationEx(50.0 - n.getPlayerRelation(), "Changed sides in the war");
							n.makeSettlementsFriendlyToPlayer();
						}

						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
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
			ID = "Ultimatum3",
			Title = "As you wait...",
			Text = "[img]gfx/ui/events/event_90.png[/img]{You tell the herald to Retournez à his commander. He nods.%SPEECH_ON%May thine fortitude impress the old gods, for it will not impress the might of the North.%SPEECH_OFF%The herald bows and makes his leave.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Get ready for their next attack.",
					function getResult()
					{
						this.Flags.set("IsUltimatum", false);
						this.Flags.set("WaitUntil", this.Time.getVirtualTimeF() + this.Math.rand(3, 6));
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_168.png[/img]{Corpses litter the field, sometimes piled three or four high. The men of the %companyname% walk between the bodies to loot what they can, and joining their looting are crows, buzzards, rats, mice, cats, roaming dogs, a wolf, a wildman who is too dangerous to approach, and a flock of geese who apparently found the spot warm enough to stop a seasonal migration. The Vizier\'s men are also here and taking over, so you yourself will need to migrate back to %employer% for your pay. | There is damp stagnation in the air with a pungent smell of copper. So thorough has the slaughter been that the earth here has turned into a swamp of blood and gore. Bodies are twisted up every which way, sometimes stacked upon each other. Sometimes you hear someone moaning, but so plentiful are the dead that it would be a waste of time to try and find the survivor. %employer%\'s men will soon take over your duties, which means it is a good time to Retournez à the Vizier for your pay.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "We made it!",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.spawnAllies();
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% stops you at a good stone\'s throw from his throne. He snaps his fingers and a servant comes forward, but the Vizier laughs and holds up his hand.%SPEECH_ON%No wait. Have one of the women do it. Her. The ugliest one.%SPEECH_OFF%He points at his harem, and the ladies separate out until a woman is isolated from the group. She is a creature so lithe you\'d imagine she would fetch a castle in the north. She takes a purse of crowns from the servant and prostrates herself before you. %employer% smirks.%SPEECH_ON%You were to hold the fort until my men arrived. Instead, you took to the feminine nature and ran at the sight of danger. Thankfully for you, my men, the real men, came to capture the fort back from the northerners and have established it as a chokepoint. Stop staring at the concubine, Crownling! Your eyes may set upon the ground or upon your pay. I suggest you take your coin and leave my sight before the Gilder\'s shine lights a fire beneath your very feet.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Held a fort against northerners");
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
		this.m.Screens.push({
			ID = "Success2",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{You report to %employer% everything which occurred. A smile slowly goes across the Vizier\'s face.%SPEECH_ON%Goodness, my lieutenants sent you there? That fort is worth nothing. Who would play such a trick? I\'d have the notion to behead the man responsible, but alas, what was it, %reward% crowns? It means nothing to me. I\'ve paid more for a northern jester\'s jake to be told to me in person, and their sense of humor is impoverished at best. Take your gold and depart my premises, Crownling.%SPEECH_OFF% | When you Retournez à %employer%, the Vizier is nowhere to be found. Instead, one of his lieutenants takes you aside and thanks you for your service.%SPEECH_ON%Between us and the mice, and let it be known these words were never spoken, and that there are no mice in these halls, that if I were to have men like you in my ranks I would have temptations of conquests in my heart. Alas, I am given troops as useful to me as the single grains of sand are to the desert. Here is your pay, Crown-, soldier.%SPEECH_OFF%He hands over a purse of %reward% crowns. Another lieutenant starts down the hallway, and the man before you slaps you on the shoulder, his face suddenly without humor or congeniality.%SPEECH_ON%Get out of here, Crownling, that is your pay and we will not hear so much as a single syllable from a haggler\'s tongue!%SPEECH_OFF% | You enter the Vizier\'s halls only to find a lone man sweeping the marbled floors. His broom\'s bristles scratch to a stop on your boot and he looks up.%SPEECH_ON%Ah. They told me a man of your stature would be here.%SPEECH_OFF%He sets the broom down, its handle possibly thicker than his frail frame. He walks over to a table and opens a chest filled with trays of %reward% crowns. You ask how the Viziers would ever trust him with so much coin. The man picks up his broom and laughs.%SPEECH_ON%Were I to steal the crowns for myself, how far would I get? It is heavy. I cannot carry it all. So can I take a little? No. I\'m a man of no material presence. As surely as the Gilder\'s eye blossoms the flower, gold in my palm illuminates me as a thief. I would never get far. This here is my station, and this is yours.%SPEECH_OFF%You take the coin, but then ask how he knows you\'re the right sellsword. His broom scratches to a stop again, and a bead of sweat slowly goes down his cheek. Before he answers, you take the crowns and go. | %employer% is found amongst his council. The rarely seen knot of silk-wearing, beard stroking peoples regard you with contempt. You state loudly that the fort has been held and taken by the southern soldiers. All noise is ceased and your words echo about the marbled halls and every servant stops and the council pauses. %employer% stands up.%SPEECH_ON%Servants, fetch this wagging tongue his coin.%SPEECH_OFF%One of the councilmen spits, which a collared child quickly cleans up.%SPEECH_ON%Should have remitted his pay while he was at the fort. How dare he so much as breathe in this room.%SPEECH_OFF%Servants rush to your side with purses of %reward% crowns. The Vizier waves his hand.%SPEECH_ON%Begone, Crownling. I\'ve persons I hire to dally, and you are not one of them.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Held a fort against northerners");
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

	function spawnAllies()
	{
		local cityState = this.World.FactionManager.getFaction(this.getFaction());
		local mapSize = this.World.getMapSize();
		local o = this.m.Destination.getTile().SquareCoords;
		local tiles = [];

		for( local x = o.X - 3; x < o.X + 3; x = ++x )
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
		local party = cityState.spawnEntity(tiles[0].Tile, "Regiment of " + cityState.getNameOnly(), true, this.Const.World.Spawn.Southern, this.Math.rand(100, 150) * this.getDifficultyMult() * this.getScaledDifficultyMult());
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
		local guard = this.new("scripts/ai/world/orders/guard_order");
		guard.setTarget(this.m.Destination.getTile());
		guard.setTime(240.0);
		c.addOrder(guard);
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"employerfaction",
			this.World.FactionManager.getFaction(this.m.Faction).getName()
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Destination.getTile())]
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

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isHolyWar())
		{
			return false;
		}

		return true;
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


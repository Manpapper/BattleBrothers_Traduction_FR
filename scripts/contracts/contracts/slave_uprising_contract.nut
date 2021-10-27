this.slave_uprising_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Target = null,
		IsEscortUpdated = false,
		IsPlayerAttacking = false
	},
	function setLocation( _l )
	{
		this.m.Destination = this.WeakTableRef(_l);
	}

	function create()
	{
		this.contract.create();
		this.m.DifficultyMult = this.Math.rand(70, 105) * 0.01;
		this.m.Type = "contract.slave_uprising";
		this.m.Name = "Slave Uprising";
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

		this.m.Flags.set("SpartacusName", this.Const.Strings.SouthernNames[this.Math.rand(0, this.Const.Strings.SouthernNames.len() - 1)] + " " + this.Const.Strings.SouthernNamesLast[this.Math.rand(0, this.Const.Strings.SouthernNamesLast.len() - 1)]);
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Renversez le soulèvement des endettés à %location% près de %townname%"
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 20)
				{
					this.Flags.set("IsOutlaws", true);
					this.Contract.m.Destination.setActive(false);
					this.Contract.m.Destination.spawnFireAndSmoke();
				}
				else if (r <= 40)
				{
					this.Flags.set("IsSpartacus", true);
				}
				else if (r <= 60)
				{
					this.Flags.set("IsFleeing", true);
				}
				else
				{
					this.Flags.set("IsFightingBack", true);
				}

				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Renversez le soulèvement des endettés à %location% près de %townname%"
				];
				this.Contract.m.Destination.getSprite("selection").Visible = true;
				this.Contract.m.Destination.setOnEnterCallback(this.onDestinationEntered.bindenv(this));
			}

			function update()
			{
				if (this.Flags.get("IsVictory"))
				{
					if (this.Flags.get("IsSpartacus"))
					{
						this.Contract.setScreen("Spartacus4");
					}
					else if (this.Flags.get("IsFightingBack"))
					{
						this.Contract.setScreen("FightingBack2");
					}

					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
			}

			function onDestinationEntered( _dest )
			{
				if (this.Flags.get("IsFleeing"))
				{
					this.Contract.setScreen("Fleeing1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsOutlaws"))
				{
					this.Contract.setScreen("Outlaws1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsSpartacus"))
				{
					this.Contract.setScreen("Spartacus1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsFightingBack"))
				{
					this.Contract.setScreen("FightingBack1");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "SlaveUprisingContract")
				{
					this.Flags.set("IsVictory", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_Outlaws",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Chassez les endettés qui ont maintenant recourt au banditisme autour de %townname%"
				];
				this.Contract.m.Destination.getSprite("selection").Visible = false;
				this.Contract.m.Destination.setOnEnterCallback(null);
				this.Contract.m.Home.getSprite("selection").Visible = false;

				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull())
				{
					this.Contract.setScreen("Outlaws3");
					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerInitiated )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerInitiated;
				this.World.Contracts.showCombatDialog();
			}

		});
		this.m.States.push({
			ID = "Running_Fleeing",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Chassez les endettés qui s\'enfuit de %townname%"
				];
				this.Contract.m.Destination.getSprite("selection").Visible = false;
				this.Contract.m.Destination.setOnEnterCallback(null);
				this.Contract.m.Home.getSprite("selection").Visible = false;

				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull())
				{
					this.Contract.setScreen("Fleeing3");
					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerInitiated )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerInitiated;

				if (!this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					this.Contract.setScreen("Fleeing2");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog();
				}
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Retournez à %townname%"
				];
				this.Contract.m.Destination.getSprite("selection").Visible = false;
				this.Contract.m.Destination.setOnEnterCallback(null);
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
			Text = "[img]gfx/ui/events/event_162.png[/img]{Normally surrounded by contemplative opulence, %employer% is in a whirlwind of advisers and fellow Viziers, each counseling the other with snaps of their fingers and aggressive points on a map. Despite all the frenzy, a small servant threads through the crowd and comes to you with a scroll. He deftly explains that indebted have overtaken their masters in %townname%\'s %location%.%SPEECH_ON%A Crownling\'s services are requested. If you wish to partake in the restoration of normative statuses for all parties involved, and for the betterment of indebted and master alike, please take this here pen and cross an X here on the scroll.%SPEECH_OFF%He stares at you and you at him. He sighs and taps the page.%SPEECH_ON%Your pay, if accepted, here. %reward% crowns.%SPEECH_OFF% | En vous approchant %employer%\'s rooms, a pair of guards move to stick you with the business ends of their halberds. This elicits shouting and hurried footsteps from down the hall as an interfering servant comes sprinting down.%SPEECH_ON%Guards! These sloppily dressed travelers are Crownlings. Apologies, Crownling, we are on edge for the very reason the Viziers may need your assistance: the indebted have overtaken the %location% in %townname%. The uprising may spread from there.%SPEECH_OFF%The servant produces a scroll and hands it over. It states that there are %reward% crowns awaiting those who squash the revolt of the indebted, and the scroll bears the sigil of %townname%\'s various Viziers. | The Viziers of %townname% are together in their war room and there is more tension than usual in the air. You are gated off from getting anywhere close to them. You\'re not sure how, but large golden bars have been brought down from the ceiling. They talk amongst themselves, nodding now and again, before handing a servant a scroll. You watch as the servant rushes to you. He hands it over, and then repeats its words from memory.%SPEECH_ON%The indebted have overrun their masters and thence taken over the %location%. %reward% crowns are available to dispatch to the coffers of the man or mans who will crush this band of upstarts.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{They stand no chance. | We\'ll make an example out of them. | We\'ll retake the %location%.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Ça ne ressemble pas à notre type de travail. | Je ne pense pas. | We\'re not in the business of fighting former slaves.}",
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
			ID = "FightingBack1",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_71.png[/img]{The indebted at %location% see you coming and you hope the presence of your weapons will help deter them from continuing whatever freedom seeking they\'ve undertaken. Shockingly, they do not lay down their arms but merely come together to stand against you. They are a crude lot, an arrangement of those whom enforced labor and recruitment has put the number on. | You find the indebted and they stare back with a very clear understanding of why you are there. The arrangement of participants, yourself armed to the teeth, coming by way of town, the indebted, armed with whatever they scavenged, far from their chains. They are a motley, sad assembly, but you know well that whatever they lack in weaponry they more than make up for in desire. A taste of freedom is nothing if not a sharpening effect. | As described, the indebted have taken over the %location% and armed themselves with whatever they could find. Upon seeing you, they hurry to some notion of formation, but they lack training, discipline, food, and much else. What they have, though, is no desire to Retournez à whence they came which can be as sharp and dangerous a steel as any.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Destroy them!",
					function getResult()
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.Music = this.Const.Music.OrientalBanditTracks;
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.LocationTemplate.Template[0] = "tactical.desert_camp";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.None;
						p.LocationTemplate.CutDownTrees = true;
						p.Tile = tile;
						p.CombatID = "SlaveUprisingContract";
						p.TerrainTemplate = "tactical.desert";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.NomadRaiders, 30 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getID());
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Slaves, 55 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "FightingBack2",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_71.png[/img]{The uprising has been crushed. In death, the faces of the slaves do seem to carry some relief, as though the end of all things is preferred to the relentless cruelty of living in the chain. %employer% and the Viziers will be awaiting your return.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Our work is done.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Outlaws1",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_176.png[/img]{You get to the %location% to find it burned to the ground and ransacked. A survivor stumbles out of the blackened ashes of a building. He explains the indebted set themselves upon everyone available, ravishing the women, killing children, stole everything of value and then split off into the hinterland. | The uprising of the indebted has long since departed %location%, leaving behind a wake of destruction and death. A number of survivors stumble about picking up their things. Those who can still speak talk of horrors, the indebted basically setting upon the area like savages, killing, ravishing, robbing. A man with rags over his eyes says he heard them talk about heading into the countryside and splitting up there.%SPEECH_ON%They\'re simple bandits now. Animals who have tasted the blood, for them there is no Retournez à the safety of the chain. They are lost.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We\'ll hunt them down.",
					function getResult()
					{
						this.World.uncoverFogOfWar(this.Contract.m.Target.getPos(), 400.0);
						this.World.getCamera().moveTo(this.Contract.m.Target);
						this.Contract.setState("Running_Outlaws");
						return 0;
					}

				}
			],
			function start()
			{
				local cityTile = this.Contract.m.Home.getTile();
				local nearest_nomads = this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getNearestSettlement(cityTile);
				local tile = this.Contract.getTileToSpawnLocation(this.Contract.m.Home.getTile(), 9, 15);
				local party = this.World.FactionManager.getFaction(nearest_nomads.getFaction()).spawnEntity(tile, "Indebted", false, this.Const.World.Spawn.NomadRaiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.setDescription("A group of indebted that turned to banditry.");
				party.setFootprintType(this.Const.World.FootprintsType.Nomads);
				party.getSprite("banner").setBrush(nearest_nomads.getBanner());
				party.getSprite("body").setBrush("figure_nomad_03");
				this.Contract.m.UnitsSpawned.push(party);
				this.Contract.m.Target = this.WeakTableRef(party);
				party.setVisibleInFogOfWar(true);
				party.setImportant(true);
				party.setDiscovered(true);
				party.setAttackableByAI(false);
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setPivot(this.Contract.m.Home);
				roam.setMinRange(8);
				roam.setMaxRange(12);
				roam.setAllTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
				roam.setTerrain(this.Const.World.TerrainType.Shore, false);
				roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
				c.addOrder(roam);
			}

		});
		this.m.Screens.push({
			ID = "Outlaws3",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_168.png[/img]{You look down at the corpse of a slave, his body molded by labors of a prior life, but in his hands and around his neck the adornments of stolen weapons and loot. In a cruel turn of thought, you find it strange that they would have been easier to put down had they simply no ambition at all besides their freedom. But it was their greed and sense of wanting that made them all the more dangerous. But. They\'re dead. And the Viziers of %townname% will be happy regardless of whatever lofty goals the indebted had.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Our work is done.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Spartacus1",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_166.png[/img]{You find the indebted sitting amongst desert rocks and they do not rise to your arrival. Instead, one man comes to you. Despite his powerful build, you sense that he has come to barter, a diplomatic tongue bedded in all his muscle.%SPEECH_ON%Crownling, I figured you would come. My name is %spartacus%, the chosen leader of these freedom seekers, insofar as the open cage is the leader of the bird who wishes to fly. You arrive to us by way of the gilded road, lead by the chain of unseen gold, promises which you cannot guarantee to be kept, and it is upon these forgeries of agreement, these misunderstood arrangements, that you are to come and kill or capture us. Is that so?%SPEECH_OFF%You nod. %spartacus% nods back.%SPEECH_ON%So it is. Before we commit ourselves to our agreements, ourselves to be masters of our own hands, and yourself slave to the mighty crown, let me try and negotiate in a manner which you, Crownling, will find beneficial.%SPEECH_OFF%The man kneels.%SPEECH_ON%I am the scion to a lost family, to a lost heritage, to a lost estate. These people, these men, are my family now. But from my previous life I have something which you may find valuable.%SPEECH_OFF%He holds out a piece of paper.%SPEECH_ON%Let us go and I will write upon this paper here the location of treasures which you cannot find elsewhere. Attack us, and I shall take my family\'s final heirlooms to the grave, and gasp my final breath not in concern with such lost riches, but with to breathe the fierce fire of freedom itself, glistening in my lungs, the pain preferable to the comforts of any chain.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "I agree to your terms. You shall have your freedom.",
					function getResult()
					{
						return "Spartacus2";
					}

				},
				{
					Text = "This is just business. Your little rebellion is about to be crushed.",
					function getResult()
					{
						return "Spartacus3";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Spartacus2",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_166.png[/img]{You stick your hand out. %spartacus% sticks out his. He speaks.%SPEECH_ON%So it is.%SPEECH_OFF%He holds up a pencil made of rock and some black powdery rock at its tip. He points at a far away stone.%SPEECH_ON%As we leave, I will write the location of my family\'s heirlooms there. Now I see upon your face the question of whether I am lying or not. Such uncertainty is the price of freedom, no? To be unsure of where you go, but to do so of your own mind. That is true freedom. The comfort of the cage is for birds who do not wish to fly, Crownling. May your travels upon the gilded road be as fruitful as our first steps.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Enjoy your freedom while it lasts.",
					function getResult()
					{
						local bases = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getSettlements();
						local location;
						local lowest_distance = 9000;

						foreach( b in bases )
						{
							if (!b.getLoot().isEmpty() && !b.getFlags().get("IsEventLocation"))
							{
								local d = b.getTile().getDistanceTo(this.Contract.m.Home.getTile()) + this.Math.rand(1, 5);

								if (d < lowest_distance)
								{
									location = b;
									lowest_distance = d;
								}
							}
						}

						if (location == null)
						{
							bases = this.World.EntityManager.getLocations();

							foreach( b in bases )
							{
								if (!b.getLoot().isEmpty() && !b.getFlags().get("IsEventLocation") && !b.isAlliedWithPlayer() && b.isLocationType(this.Const.World.LocationType.Lair))
								{
									local d = b.getTile().getDistanceTo(this.Contract.m.Home.getTile()) + this.Math.rand(1, 5);

									if (d < lowest_distance)
									{
										location = b;
										lowest_distance = d;
									}
								}
							}
						}

						this.World.uncoverFogOfWar(location.getTile().Pos, 700.0);
						location.getFlags().set("IsEventLocation", true);
						location.setDiscovered(true);
						this.World.getCamera().moveTo(location);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationMajorOffense, "Sided with indebted in their uprising");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Spartacus3",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_166.png[/img]{%spartacus% sticks his hand out, but you do not stick out yours. Instead, you draw your sword. The rebellion\'s leader nods.%SPEECH_ON%Alright. You are forbidden to leave the cage of the crown, I see, and you are bidden to the glistening of the gilded road, so urgent your enslavement, so captured, that when the gate is open you do not open your wings, instead you settle for a mere hop to the master\'s finger. May battle treat us well, Crownling.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To Arms!",
					function getResult()
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.Music = this.Const.Music.OrientalBanditTracks;
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.LocationTemplate.Template[0] = "tactical.desert_camp";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.None;
						p.LocationTemplate.CutDownTrees = true;
						p.Tile = tile;
						p.CombatID = "SlaveUprisingContract";
						p.TerrainTemplate = "tactical.desert";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.NomadRaiders, 30 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getID());
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Slaves, 55 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Spartacus4",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_168.png[/img]{You stand over %spartacus%. Despite his fondness for freedom, the rebellion\'s dead leader is not smiling in his final, liberated moment. His face is wrenched in pain and he has wounds which reveal the slick patterns of that which folds beneath the flesh. But his eyes. There is a spark there, staring up at the sky. A shadow crosses his eyes and you look up expecting a bird, but there is nothing. When you look down, the spark is gone and the dead man is just a dead man.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Our work is done.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Fleeing1",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_59.png[/img]{You find a pile of rankled shackles which are hot to the touch. An old man points his hand north.%SPEECH_ON%The freed men went that way.%SPEECH_OFF%Curious, you ask him why he\'d rat out the indebted. He smiles.%SPEECH_ON%I\'ve work that needs finishing and sometimes the Viziers lend me a few. Hard to get a good task done with just my own two hands.%SPEECH_OFF% | You come across a long trail of sand and dirt and scrub which has clearly suffered northbound disturbances. Amongst the littered path you find a shackle, the last bit of evidence needed. The indebted have turned in north and you\'ll have to hunt them down. | You find a shackle flailing from the bush of desert scrub. An old man sipping water from a mug grunts and points northward.%SPEECH_ON%The indebted rabbited that way. If you manage to gather them back to the Vizier, perhaps put in a good word for me. I could use a man or two around here to fetch water. No freedmen ever fetches me water.%SPEECH_OFF%You\'ll not be putting in a word for nobody, but thank him anyway and head north.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We\'ll hunt them down.",
					function getResult()
					{
						this.World.uncoverFogOfWar(this.Contract.m.Target.getPos(), 400.0);
						this.World.getCamera().moveTo(this.Contract.m.Target);
						this.Contract.setState("Running_Fleeing");
						return 0;
					}

				}
			],
			function start()
			{
				local cityTile = this.Contract.m.Home.getTile();
				local nearest_nomads = this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getNearestSettlement(cityTile);
				local tile = this.Contract.getTileToSpawnLocation(this.Contract.m.Home.getTile(), 9, 15);
				local party = this.World.FactionManager.getFaction(nearest_nomads.getFaction()).spawnEntity(tile, "Indebted", false, this.Const.World.Spawn.Slaves, 90 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.setDescription("A group of indebted.");
				party.setFootprintType(this.Const.World.FootprintsType.Nomads);
				party.getSprite("banner").setBrush("banner_deserters");
				this.Contract.m.UnitsSpawned.push(party);
				this.Contract.m.Target = this.WeakTableRef(party);
				party.setVisibleInFogOfWar(true);
				party.setImportant(true);
				party.setDiscovered(true);
				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);
				local c = party.getController();
				local randomVillage;
				local northernmostY = 0;

				for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = ++i )
				{
					local v = this.World.EntityManager.getSettlements()[i];

					if (v.getTile().SquareCoords.Y > northernmostY && !v.isMilitary() && !v.isIsolatedFromRoads() && v.getSize() <= 2)
					{
						northernmostY = v.getTile().SquareCoords.Y;
						randomVillage = v;
					}
				}

				local move = this.new("scripts/ai/world/orders/move_order");
				move.setDestination(randomVillage.getTile());
				c.addOrder(move);
				local wait = this.new("scripts/ai/world/orders/wait_order");
				wait.setTime(9000.0);
				c.addOrder(wait);
				this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Destination.getTile(), party.getTile(), this.Const.GenericFootprints, this.Const.World.FootprintsType.Nomads, 0.75);
			}

		});
		this.m.Screens.push({
			ID = "Fleeing2",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_59.png[/img]{You finally catch up to the indebted. They\'re rough roaders by now, the bleak terrain which they have crossed having left its own marks upon them as they have upon it. But they\'ve not come this far to just to give up: the whole lot arm themselves at the very sight of you and make their own approach. | The indebted are found in a desperate state, insofar as the journey has given them free breath, they\'ve paid for it with mind and body alike. The sunburned, beleaguered and ragged men approach with eyes both wide and weary. You know by the wild stares that they\'ve no quit left in them. They\'ll be fighting it out on way or another.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Destroy them!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Fleeing3",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_168.png[/img]{Putting an end to the indebted is a simple matter once it is all said and done. Any survivors make themselves incapable of a return, instead preferring the steel demise. In their skin you are not sure you would choose it any different. You collect what evidences you can and ready a Retournez à %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Our work is done.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_162.png[/img]{You do not find %employer% with a harem or swimming in wine. Instead you find him strutting about with an empty bird cage at his side. He somberly states that his favorite bird got out and flew away.%SPEECH_ON%Do not consider me dull witted, Crownling, I see that you might find similarity between my pet and my indebted. Feel free, if I may say, to do so. But you are shortsighted to think in such a manner. My bird will fly free, and to the world be of no use than to be consumed. But this is not freedom, Crownling, to resume a duty which birth had given it. Freedom was its escape from such a doom, an escape to my world, an escape not afforded to many of its kind.%SPEECH_OFF%The Vizier snaps his fingers and a servant appears seemingly from nowhere. He hands you a purse of coins. You look up to see the Vizier set the cage down and walk away. | %employer% is buried amongst the limbs of his, in the guard\'s words, \'favorite harem.\' He pokes his mouth out and you get the sense his eyes stare at you from the nook of a sweaty knee, though there\'s no real telling.%SPEECH_ON%The victorious Crownling returns to feast his weary eyes upon my finest wares. And it is so, my scouts say, that you laid to waste those upstart indebted, and that the message of their death has been reissued as a new utility, a kind word, written by your hand, Crownling, as warning to all other of the indebted.%SPEECH_OFF%The Vizier disappears momentarily, then reemerges between a woman\'s thighs.%SPEECH_ON%Servants! Pay the Crownling.%SPEECH_OFF%Two wiry-framed boys carry over a small chest and leave it at your feet. It is quite heavy, and you are offered no help carrying it out. | A man in chains meets you outside %employer%\'s rooms. He has a chain attached to each arm. One chain runs to the wall, the other chain rankles across the floor to a chest of crowns. Both chains are held by a lock. And this man has the key. He stares at you, his fingers gripping and ungripping the key, his breath uneven. He finally squats and unlocks the lock to your chest which you take up and step back. The slave holds the key at his chest, and he glances at the other lock, and he folds his hand autour de key and bows his head and there comes a noise you\'re not sure what to make of. A guard tells him to keep it quiet before ushering you out the door.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Crowns are crowns.",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-2);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Beat down an indebted uprising");
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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"location",
			this.m.Destination.getRealName()
		]);
		_vars.push([
			"spartacus",
			this.m.Flags.get("SpartacusName")
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/slave_revolt_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
				this.m.Destination.setOnEnterCallback(null);
			}

			if (this.m.Target != null && !this.m.Target.isNull())
			{
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
		if (this.m.IsStarted)
		{
			if (this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive())
			{
				return false;
			}

			return true;
		}
		else
		{
			return true;
		}
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
		local location = _in.readU32();

		if (location != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(location));
		}

		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		this.contract.onDeserialize(_in);
	}

});


this.restore_location_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Caravan = null,
		Location = null,
		IsEscortUpdated = false
	},
	function setLocation( _l )
	{
		this.m.Location = this.WeakTableRef(_l);
	}

	function create()
	{
		this.contract.create();
		this.m.DifficultyMult = this.Math.rand(70, 90) * 0.01;
		this.m.Type = "contract.restore_location";
		this.m.Name = "Rebuilding Effort";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 300 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Sécurisez les ruines %location% près de %townname%"
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

				if (r <= 15)
				{
					this.Flags.set("IsEmpty", true);
				}
				else if (r <= 30)
				{
					this.Flags.set("IsRefugees", true);
				}
				else if (r <= 60)
				{
					this.Flags.set("IsSpiders", true);
				}
				else
				{
					this.Flags.set("IsBandits", true);
				}

				this.Contract.m.Home.setLastSpawnTimeToNow();
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Sécurisez les ruines %location% près de %townname%"
				];
				this.Contract.m.Location.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Location))
				{
					if (this.Flags.get("IsVictory"))
					{
						this.Contract.setScreen("Victory");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("ReturnForEscort");
					}
					else if (this.Flags.get("IsFleeing"))
					{
						this.Contract.setScreen("Failure2");
						this.World.Contracts.showActiveContract();
						return;
					}
					else if (this.Flags.get("IsEmpty"))
					{
						this.Contract.setScreen("Empty");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsRefugees"))
					{
						this.Contract.setScreen("Refugees1");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsSpiders"))
					{
						this.Contract.setScreen("Spiders");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsBandits"))
					{
						this.Contract.setScreen("Bandits");
						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "RestoreLocationContract")
				{
					this.Flags.set("IsVictory", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "RestoreLocationContract")
				{
					this.Flags.set("IsFleeing", true);
				}
			}

		});
		this.m.States.push({
			ID = "ReturnForEscort",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Retournez à %townname%"
				];
				this.Contract.m.Location.getSprite("selection").Visible = false;
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success1");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Escort",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Escortez les travailleurs à %location% près de %townname%"
				];
				this.Contract.m.Location.getSprite("selection").Visible = true;
				this.Contract.m.Home.getSprite("selection").Visible = false;
			}

			function update()
			{
				if (this.Contract.m.Caravan == null || this.Contract.m.Caravan.isNull() || !this.Contract.m.Caravan.isAlive() || this.Contract.m.Caravan.getTroops().len() == 0)
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (!this.Contract.m.IsEscortUpdated)
				{
					this.World.State.setEscortedEntity(this.Contract.m.Caravan);
					this.Contract.m.IsEscortUpdated = true;
				}

				this.World.State.setCampingAllowed(false);
				this.World.State.getPlayer().setPos(this.Contract.m.Caravan.getPos());
				this.World.State.getPlayer().setVisible(false);
				this.World.Assets.setUseProvisions(false);
				this.World.getCamera().moveTo(this.World.State.getPlayer());

				if (!this.World.State.isPaused())
				{
					this.World.setSpeedMult(this.Const.World.SpeedSettings.EscortMult);
				}

				this.World.State.m.LastWorldSpeedMult = this.Const.World.SpeedSettings.EscortMult;

				if (this.Flags.get("IsFleeing"))
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
					return;
				}
				else if (this.Contract.isPlayerAt(this.Contract.m.Location))
				{
					this.Contract.setScreen("RebuildingLocation");
					this.World.Contracts.showActiveContract();
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Flags.set("IsFleeing", true);

				if (this.Contract.m.Caravan != null && !this.Contract.m.Caravan.isNull())
				{
					this.Contract.m.Caravan.die();
					this.Contract.m.Caravan = null;
				}
			}

			function end()
			{
				this.World.State.setCampingAllowed(true);
				this.World.State.setEscortedEntity(null);
				this.World.State.getPlayer().setVisible(true);
				this.World.Assets.setUseProvisions(true);

				if (!this.World.State.isPaused())
				{
					this.World.setSpeedMult(1.0);
				}

				this.World.State.m.LastWorldSpeedMult = 1.0;
				this.Contract.clearSpawnedUnits();
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Retournez à %townname%"
				];
				this.Contract.m.Location.getSprite("selection").Visible = false;
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success2");
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer% offers some bread and beer, and seems happy to avail himself. After some smalltalk on how you like %townname%, he gets to the point.%SPEECH_ON%This region has been prosperous before, but many of our assets have been pillaged, burned or taken over by brigands. We need you to go to the %location% outside of %townname% and clear it of any occupants so that we can safely send materials there and have our craftsmen rebuild what we once had.%SPEECH_OFF%He leans over the table and looks firmly at you.%SPEECH_ON%Are you willing to assist us in this endeavor?%SPEECH_OFF% | %employer% takes a bite of an apple then tosses the rest to you. Catching it, you look at the man, not entirely sure what to do with it. When he says nothing, you take a bite and toss it back, thanking him.%SPEECH_ON%No problem, sellsword. Today\'s a decent day, although, obviously, I need something from you. The %location% outside of %townname% is, I believe, host to a group of brigands. All I need you to do is go there and clear the out so that I can restore the place to its former, crimeless glory. Does that suit your... interests?%SPEECH_OFF% | %employer% sighs as he drops a scroll from his fingers as though its news weighted it so heavily.%SPEECH_ON%We\'re not getting enough crowns from %townname%, and I believe it\'s because brigands may have taken over the %location%. That\'s not entirely confirmed... I really should follow the news of my people better, but you know how it is.%SPEECH_OFF%You shrug.%SPEECH_ON%Anyway, I want you to go there, find the problem, and then report back to me for further instruction. Sounds simple enough, right?%SPEECH_OFF% | Leaning forward in his chair, %employer% points to a map he\'s got sprawled out across his desk.%SPEECH_ON%The %location% outside of %townname% has been destroyed by brigands. Now, sellsword, I need your services to take the territory back and help me restore it to its former glory or whatever it is I tell the peasants these days. Are you interested?%SPEECH_OFF% | %employer% sighs, his breath leaving him one way, and his body sinking into his chair the other.%SPEECH_ON%I used to visit the %location% when I was a kid. It was such a prosperous place, but now it lay in ruin thanks to some vagabonds. Obviously, I\'m not talking to you just to reminisce. I need you to go there and take it back! Kill those brigands and then report back to me immediately. Does this simple task interest you?%SPEECH_OFF% | %employer% kicks his feet up on his desk, knocking an empty goblet over.%SPEECH_ON%The peasants are at it again. Bugging me. They say the %location% outside of %townname% has been destroyed. I don\'t ordinarily take the fools at their word, but a few of my councilmen seem to have confirmed the news. So now I gotta do something about it.%SPEECH_OFF%He swings a finger at you, smiling as he does it.%SPEECH_ON%That\'s where you come in. Go to the %location%, kill those unruly vagabonds, then report back to me. How\'s that sound to you?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Sounds easy enough. | Let\'s talk crowns.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{This doesn\'t sound like our kind of work. | I don\'t think so.}",
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
			ID = "Empty",
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/event_71.png[/img]{Arriving at the %location%, you have the men fan out and slowly creep into the area. You march in yourself, carefully weaving your way toward the buildings whose windows whistle as a spurting wind comes through. Investigating further, there doesn\'t appear to be anyone here. Not even evidence that they\'d just left, either. You gather your men and head back to inform %employer%. | %location% is surprisingly empty. You mosey about one of the homes, picking up dusted cups and flipping over straw beds, but find neither insect nor man. The place has been wholly abandoned. You head back to tell %employer% of the news. | A deerscare nods and tips at the edge of %location%, its wooden chiming the only thing around that seems to be alive. If anyone was living here, they left a long time ago. Buildings stand empty. Hollowed out. You can tell just by looking at them that no one is inside. The old gods themselves could destroy this place and not a single person would know or care. Sad. Best let %employer% know of the \'good\' news. | %location%\'s abandoned, just as you figured, but there is not a bandit or vagabond in sight. You can\'t blame them for not wanting the place: even though there\'s few buildings around, everything about them make you on edge. Old, frail... haunted? As though they were home to immeasurable crimes. Maybe %employer%\'s workers will tear them down and start anew. | Not a bandit is to be found at %location%. Half the buildings are destroyed while the other half stand empty and abandoned. A few of %employer%\'s workers could probably get this place into shape so you\'d best go inform him. | You find a weathervane stuck in the mud and a cow carcass beside it. A pig pen is layered with fresh green grass. One of the buildings has been verdantly painted by a crawl of vines. The cemetery\'s markings are tilted and some flat on the ground. You find a shovel and a hole beside it. Water\'s filled the unused grave and there blue birds are bathing. You wonder if this place would be best left as is, but it\'s not your place to wonder. You head back to inform %employer% on the state of things. | You enter the %location% and have the men fan out and start searching the buildings. Not one to leave an investigation entirely to a bunch of sellswords, you enter a nearby home. The door peels open and almost immediately your foot kicks through a pile of pots and pans left on the earthen floor. Trudging in, you spot a few dead mice in the corner of the place, their skeletons still in a state of scurrying, and adjacent to them is a dead cat. There\'s a bird nest in the rafters. Yellowed eggs wink their shelled hoods, but you have yet to see much less hear a bird.\n\n%randombrother% comes in through the door and says nothing has been found. If brigands were here, they left long ago. You tell the mercenary to gather the men as it is time to report your findings to %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Not what I expected.",
					function getResult()
					{
						this.Contract.setState("ReturnForEscort");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Bandits",
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/event_71.png[/img]{You order your men to fan out through the %location%. You creep through the area with your sword in hand. As you turn a corner, you find a man squatting over a shithole. His knees wobble at the sight of you. When he reaches for his weapon, you run him through, quickly kicking his body off your blade and warning your men of brigands who quickly begin streaming out of nearby buildings. | The %location%\'s quiet, but not quiet enough. Here and there you hear a creak or croak of wood, the jingle jangle of chains being moved. People are here. You draw out your sword and order you men to prepare for battle. Just as soon as you do, a bandit kicks open a building door and sprints out of it, a throng of equally shouty men piling out behind him. | Brigands! Just as you expected. Not only are they at the %location%, they don\'t appear to give two shits about how out in the open they are. As your men converge on the area, the brigands lazily gather their weapons as if they\'ve handled men of your ilk already. | The %location%\'s completely empty - except for the large group of brigands inhabiting its center, squatting around a fire and a spitted pig. They glance at you, back at the pig, then back at you. One draws a meaty fork away from the fire.%SPEECH_ON%Hell, sir, we just want to eat.%SPEECH_OFF%You draw out your sword and nod.%SPEECH_ON%Me too.%SPEECH_OFF% | You find a bandit just outside the %location%. He\'s carrying the body of a peasant which is about good of evidence as you need to kill him and all his friends. You order your men to attack. | Brigands scurry from a campfire as you near the %location%. Surprisingly, they arm themselves and come out to defend their newly acquired \'territory.\'}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To Arms!",
					function getResult()
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.Music = this.Const.Music.BanditTracks;
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "RestoreLocationContract";
						p.TerrainTemplate = "tactical.plains";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.LocationTemplate.Template[0] = "tactical.human_camp";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.None;
						p.LocationTemplate.CutDownTrees = true;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.BanditScouts, 90 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Spiders",
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/event_110.png[/img]{The white limply twisting in the wind from the abodes of %location% looks like smoke, but the buildings are untouched. As you near the dwellings, pairs upon pairs of red eyes flare in the dark of their windows. The webknechts scuttle forth, their spiny legs clattering on the slats of wood and scratching the corrugated rooftops, the mass of black bodies fluttering out the window frame like the flakes of a smoldered dandelion. | You find %location% deserted, but there\'s a silky white film frosting every corner of the place, tendrils of it twisting limply in the wind. %randombrother% touches a tip of one and it stretches back with his arm and he has to cut himself free. Looking back ahead, you see the webknechts rushing toward you, their spiny legs scissoring as they cross ground with frightening speed, their mandibles clattering with hunger.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To Arms!",
					function getResult()
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.Music = this.Const.Music.BeastsTracks;
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "RestoreLocationContract";
						p.TerrainTemplate = "tactical.plains";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Spiders, 90 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Refugees1",
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/event_59.png[/img]{The %location% is full of people, alright, but they aren\'t brigands. Refugees clutter the place like moving trash looking for somewhere to rest. The disgusting men and women and even children walk meekly autour de premise, altogether too weak to pay mind to the mercenary band before them. %randombrother% comes to your side and asks what should be done.\n\n If they are left to stay, %employer% won\'t be very happy and you\'ll probably not be seeing any pay. On the other hand... just look at the miserable lot. They deserve a rest from whatever troubles drove them here. | You take the spyglass from your eye and shake your head. The %location% is filled - or perhaps infested - with refugees. Better than brigands, you suppose, but still an issue. %employer% won\'t be very happy about them, you know that much. On the other hand, the people down there... ragged... looking more bone than flesh... tired... they don\'t deserve to be put out on the road again, do they? | %randombrother% turns and spits. He\'s got his fists to his hips and shakes his head.%SPEECH_ON%Goddammit.%SPEECH_OFF%Standing before you and the rest of the company is a motley group of refugees. Twenty, thirty maybe. Mostly men. You figure the rest of the group, the women and the children, are hiding in the hinterlands for now. The tired lot seems too exhausted to really communicate with you. They just exchange glances and the occasional, subservient shrug.\n\n A brother speaks to one side of you.%SPEECH_ON%We gotta kick them out if we want %employer%\'s money...%SPEECH_OFF%But then another brother pipes in from your other side...%SPEECH_ON%Yeah, but look at these people. Can we really send them back out into the world? Let \'em stay, I say.%SPEECH_OFF% | Refugees have taken to the %location%, presumably survivors from some wayward war. They\'ve scoured the area for resources and now seem rather entrenched. You know %employer% won\'t be happy about their presence - they don\'t seem particularly local. %randombrother% comes to your side and nods toward the ragged band of tired strangers.%SPEECH_ON%I could take a few men and drive them out, sir. It\'d be real easy.%SPEECH_OFF% | There\'s not a bandit in sight. Instead, you\'ve come to find a large group of refugees has occupied the %location%. A throng of tired souls has taken to the place quite well: they\'ve got a few stewpots cooking over crackling fires and seem rather happy about their new \'home.\' But %employer% will not be happy about their being there. Not at all. You don\'t want to believe it, but the cold truth here is that if you want to get paid these people have got to go.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Kick these people out.",
					function getResult()
					{
						return "Refugees2";
					}

				},
				{
					Text = "These people have nowhere to go. Just... leave them be.",
					function getResult()
					{
						return "Refugees3";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Refugees2",
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/event_59.png[/img]{You order the men to clear the refugees out. They don\'t put up much of a fight - mostly just moan and groan about cruel the world is. All you can think about is how much you\'re getting paid, though. | %randombrother% and a few mercenaries are ordered to go in and kick them out. Luckily it is without bloodshed, but every refugee that passes before your gaze meets it with a solemn, sad look. You shrug. | The refugees are kicked out. One looks ready to say something to you, but closes his mouth. It is as though he had said those thoughts before and remembered they had no effect then just as they wouldn\'t now. You enjoy the silence. | You have %randombrother% dole out a few foodstuffs to the refugees. Items that were close to going bad anyway: or pieces of bread that double as bricks and an old stew that reeks of death when you pull the lid off. The refugees take every item as though you\'d given them the world. They don\'t say thanks, though. They just nod and shrug and carry on.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Get lost, you rabble!",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-2);
						this.Contract.setState("ReturnForEscort");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Refugees3",
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/event_59.png[/img]{You leave the refugees where they are. Might as well not Retournez à %employer% because he won\'t be happy about this at all. | The men, women, and children look like they\'ve had enough of getting pushed around. You decide to leave them be. | These people have had enough of this world. You don\'t think they\'d survive another trip out into the wilds and decide to leave them where they\'ve settled. | The haggard and harried people don\'t deserve to be booted from this place. You figure to leave \'em be. They\'ll turn it into a workable area soon enough, although %employer% won\'t be happy not having his own people in the area. | %employer% wants his own people settled here, but you figure these folks got to it first. That, and they don\'t look like they could live any longer being put out into the wild.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We\'ll find work elsewhere...",
					function getResult()
					{
						this.World.Assets.addMoralReputation(2);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to secure a ruined " + this.Contract.m.Location.getRealName());
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_71.png[/img]{The battle is over and %location% has been secured. It\'s time to Retournez à %employer%. | You look over the battle and nod, happy to still have a head upon your shoulders with which to nod with. Time to Retournez à %employer%. | As rough a fight as there can be, you gather the men and ready a Retournez à %employer%. | The fight over, you assess the scene and ready a report. %employer% will want to know everything which has happened here.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "That\'s taken care of.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "RebuildingLocation",
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/event_71.png[/img]{You Retournez à %location% and watch the workers fan out to the buildings. They get to work, piling slats of wood, putting up support beams, and one group is digging themselves a well. Looks like you can Retournez à %employer% now. | The builders thank you for getting them to the %location% safe and sound. They then turn and begin work, spreading out amongst the location and turning their hands to what tools are about them. The snicker-snacker and snoring haw of hammers and saws echo behind you as you leave to Retournez à %employer%. | Most of the builders head into %location% and begin preparations for its rebuilding. The foreman thanks you for getting them there safely as he knows the dangers of the world. He also thanks you for not betraying them all into an early grave. You take this gratitude with a smirk before starting the return journey to %employer%. | Well, the workers are here safe and sound. You turn back, returning to %employer% to get the pay you\'ve rightly earned. | It\'s been a long journey, there and back and there again, but it seems %location% is now about to get its legs underneath itself again. After making sure the workers are safe, you start the return trip to %employer% for your pay.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Time to get paid.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "On your return...",
			Text = "[img]gfx/ui/events/event_98.png[/img]{%employer% glances at you as enter.%SPEECH_ON%So is it clear?%SPEECH_OFF%You nod. %employer% gets up and gives you instructions: you\'re to take a troop of builders back to the %location% so that they can rebuild it. | %employer% listens to your report and nods.%SPEECH_ON%I have a group of men going back to the %location% so that they can rebuild it. I need you to escort them. Got it? Good.%SPEECH_OFF% | Rolling up some scrolls, %employer% gives you your next instruction.%SPEECH_ON%I\'ve got a gang of men going back there to rebuild the place. A lot of crowns are involved here, so I need you to make sure those men get there in one piece. After that, come back and get your pay.%SPEECH_OFF% | %employer% sits back after listening to your report. He\'s sipping a goblet of cobra wine.%SPEECH_ON%News?%SPEECH_OFF%You tell him that the area has been cleared out. The man swigs the rest of the drink in one go and sets the cup down.%SPEECH_ON%Good... good. Now take a gang of my workers back there to help rebuild. Once they are finished, come back for your payday.%SPEECH_OFF% | %employer% sits back as you enter.%SPEECH_ON%I take it by your return that the %location% has been cleared, yes?%SPEECH_OFF%You confirm what the man wants to hear. He seems happy, though your job is not yet finished: %employer% wants you to take a gang of workers back to the area to help rebuild and resettle it. Once they\'re there safe and sound, Retournez à him for payment.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "This shouldn\'t take long.",
					function getResult()
					{
						this.Contract.spawnCaravan();
						this.Contract.setState("Escort");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "On your return...",
			Text = "[img]gfx/ui/events/event_63.png[/img]{%employer% welcomes your return with a satchel heavy with crowns. He waves you off, hardly even thanking you for your work. Although, screw him and screw the formalities. A bag of crowns is thanks enough. | You enter %employer%\'s abode and he waves you in. One of his men hands you a large satchel of crowns. You look at the man.%SPEECH_ON%How did you know they made it?%SPEECH_OFF%%employer% smiles sheepishly.%SPEECH_ON%I have many eyes and ears in these parts. Even the birds talk to me...%SPEECH_OFF%That explanation\'s good enough. | Returning to %employer%, you explain that the %location% is well underway to restoration. He thanks you.%SPEECH_ON%Well, would you look at that? A mercenary who keeps his word and gets his work done. A rarity. Here is your pay.%SPEECH_OFF%One of his men hands you a burlap sack heavy and sharpened by crowns. %employer% tips a hand.%SPEECH_ON%Be seeing you, sellsword.%SPEECH_OFF% | %employer% is in his study when you return. He shows a scroll to you and asks if you know what it is. You shrug.%SPEECH_ON%I\'m not a learned man. Not of the written word, anyway.%SPEECH_OFF%%employer% returns the shrug.%SPEECH_ON%What a shame. But you are a man of the spoken word. You\'ve owned up to your promises and, believe me, that is rare to see. Your pay is in the corner.%SPEECH_OFF%The pay is right where he says it is. You spend little time dawdling on ceremony and take it and make your leave. | %employer% sits back, seemingly smug with himself.%SPEECH_ON%I know how to pick \'em. Sellswords, that is. Most of my compatriots hire folks like you, but it goes tits up because they don\'t know how to spot a good man from the wag of a dead dog\'s tail. But you... I knew you were good on your word the second I saw you. Your pay, mercenary...%SPEECH_OFF%He slams a satchel of crowns on his desk.%SPEECH_ON%It\'s all there, but I understand if you want to count it.%SPEECH_OFF%You do count it - and it\'s all there.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Easy crowns.",
					function getResult()
					{
						this.Contract.m.Location.setActive(true);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Helped rebuild a " + this.Contract.m.Location.getRealName());
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
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "After the battle",
			Text = "[img]gfx/ui/events/event_60.png[/img]{The building trek is in ruin and any hope to salvage %location% is lost. At least for the time being.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Darn it!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to protect a building trek");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Failure2",
			Title = "After the battle",
			Text = "[img]gfx/ui/events/event_71.png[/img]{Your men failed to secure the %location% and so you shouldn\'t expect any pay.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Darn it!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to secure the " + this.Contract.m.Location.getName());
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function spawnCaravan()
	{
		local faction = this.World.FactionManager.getFaction(this.getFaction());
		local party = faction.spawnEntity(this.m.Home.getTile(), "Worker Caravan", false, this.Const.World.Spawn.CaravanEscort, this.m.Home.getResources() * 0.4);
		party.getSprite("banner").Visible = false;
		party.getSprite("base").Visible = false;
		party.setMirrored(true);
		party.setDescription("A caravan of workers and building materials from " + this.m.Home.getName() + ".");
		party.setFootprintType(this.Const.World.FootprintsType.Caravan);
		party.setMovementSpeed(this.Const.World.MovementSettings.Speed * 0.5);
		party.setLeaveFootprints(false);
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(this.m.Location.getTile());
		move.setRoadsOnly(false);
		local despawn = this.new("scripts/ai/world/orders/despawn_order");
		c.addOrder(move);
		c.addOrder(despawn);
		this.m.Caravan = this.WeakTableRef(party);
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"location",
			this.m.Location.getRealName()
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.World.State.setCampingAllowed(true);
			this.World.State.setEscortedEntity(null);
			this.World.State.getPlayer().setVisible(true);
			this.World.Assets.setUseProvisions(true);

			if (!this.World.State.isPaused())
			{
				this.World.setSpeedMult(1.0);
			}

			this.World.State.m.LastWorldSpeedMult = 1.0;

			if (this.m.Location != null && !this.m.Location.isNull())
			{
				this.m.Location.getSprite("selection").Visible = false;
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (this.m.Location == null || this.m.Location.isActive() || !this.m.Location.isUsable())
		{
			return false;
		}

		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Caravan != null && !this.m.Caravan.isNull())
		{
			_out.writeU32(this.m.Caravan.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		if (this.m.Location != null && !this.m.Location.isNull())
		{
			_out.writeU32(this.m.Location.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local caravan = _in.readU32();

		if (caravan != 0)
		{
			this.m.Caravan = this.WeakTableRef(this.World.getEntityByID(caravan));
		}

		local location = _in.readU32();

		if (location != 0)
		{
			this.m.Location = this.WeakTableRef(this.World.getEntityByID(location));
		}

		this.contract.onDeserialize(_in);
	}

});


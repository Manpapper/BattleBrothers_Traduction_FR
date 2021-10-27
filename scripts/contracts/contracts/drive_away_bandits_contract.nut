this.drive_away_bandits_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		Reward = 0,
		OriginalReward = 0
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.drive_away_bandits";
		this.m.Name = "Drive Off Brigands";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function generateName()
	{
		local vars = [
			[
				"randomname",
				this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]
			],
			[
				"randomtown",
				this.Const.World.LocationNames.VillageWestern[this.Math.rand(0, this.Const.World.LocationNames.VillageWestern.len() - 1)]
			]
		];
		return this.buildTextFromTemplate(this.Const.Strings.BanditLeaderNames[this.Math.rand(0, this.Const.Strings.BanditLeaderNames.len() - 1)], vars);
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		local banditcamp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getNearestSettlement(this.m.Home.getTile());
		this.m.Destination = this.WeakTableRef(banditcamp);
		this.m.Flags.set("DestinationName", banditcamp.getName());
		this.m.Flags.set("RobberBaronName", this.generateName());
		this.m.Payment.Pool = 550 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Repoussez les bandits à " + this.Flags.get("DestinationName") + " %direction% de %origin%"
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
				this.Contract.m.Destination.clearTroops();
				this.Contract.m.Destination.setLastSpawnTimeToNow();

				if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Destination.getLoot().clear();
				}

				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.BanditDefenders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setLootScaleBasedOnResources(110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);

				if (this.World.Assets.getBusinessReputation() >= 500 && this.Contract.getDifficultyMult() >= 0.95 && this.Math.rand(1, 100) <= 20)
				{
					this.Flags.set("IsRobberBaronPresent", true);

					if (this.World.Assets.getBusinessReputation() > 600 && this.Math.rand(1, 100) <= 50)
					{
						this.Flags.set("IsBountyHunterPresent", true);
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
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					if (this.Flags.get("IsRobberBaronDead"))
					{
						this.Contract.setScreen("RobberBaronDead");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Math.rand(1, 100) <= 10)
					{
						this.Contract.setScreen("Survivors1");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Math.rand(1, 100) <= 10 && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
					{
						this.Contract.setScreen("Volunteer1");
						this.World.Contracts.showActiveContract();
					}

					this.Contract.setState("Return");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (this.Flags.get("IsRobberBaronPresent"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("AttackRobberBaron");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.Music = this.Const.Music.BanditTracks;
						properties.Entities.push({
							ID = this.Const.EntityType.BanditLeader,
							Variant = 0,
							Row = 2,
							Script = "scripts/entity/tactical/enemies/bandit_leader",
							Faction = _dest.getFaction(),
							Callback = this.onRobberBaronPlaced.bindenv(this)
						});
						properties.EnemyBanners.push(this.Contract.m.Destination.getBanner());
						this.World.Contracts.startScriptedCombat(properties, true, true, true);
					}
				}
				else
				{
					this.World.Contracts.showCombatDialog();
				}
			}

			function onRobberBaronPlaced( _entity, _tag )
			{
				_entity.getFlags().set("IsRobberBaron", true);
				_entity.setName(this.Flags.get("RobberBaronName"));
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getFlags().get("IsRobberBaron") == true)
				{
					this.Flags.set("IsRobberBaronDead", true);
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
					if (this.Flags.get("IsRobberBaronDead"))
					{
						this.Contract.setScreen("Success2");
					}
					else
					{
						this.Contract.setScreen("Success1");
					}

					this.World.Contracts.showActiveContract();
				}

				if (this.Flags.get("IsRobberBaronDead") && this.Flags.get("IsBountyHunterPresent") && !this.TempFlags.get("IsBountyHunterTriggered") && this.World.Events.getLastBattleTime() + 7.0 < this.Time.getVirtualTimeF() && this.Math.rand(1, 1000) <= 2)
				{
					this.Contract.setScreen("BountyHunters1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsBountyHunterRetreat"))
				{
					this.Contract.setScreen("BountyHunters3");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "BountyHunters")
				{
					this.Flags.set("IsBountyHunterPresent", false);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "BountyHunters")
				{
					this.Flags.set("IsBountyHunterPresent", false);
					this.Flags.set("IsBountyHunterRetreat", true);
					this.Flags.set("IsRobberBaronDead", false);
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer% angrily shakes his head.%SPEECH_ON%Brigands have been tearing up these parts for far too long! I sent a lad, %randomname%\'s son, to go find them. And you know what? Only his head came back. Of course, the idiot brigands sent one of their own to deliver it. We captured and interrogated him... so now we know where they\'re at.%SPEECH_OFF%The man leans back, pedaling his thumbs over one another in thought.%SPEECH_ON%I do not have the men, but I do have the crowns - what say I slip some your way, and you slip a sword theirs?%SPEECH_OFF% | %employer% pours himself a drink, stares at the cup, and pours himself some more. He seems to drain it in one gulp before belching his news.%SPEECH_ON%Brigands killed %randomname% and his whole family. Can you believe that? I know you don\'t know who they are, but they were a well-liked family in these parts. I\'m sure you can already imagine, but I want these brigands done with. I spent half my men just finding their camp, now I\'m ready to spend ha... some of my crowns for you to go kill them. Are you interested?%SPEECH_OFF% | %employer% is looking out a window, dancing a finger along the rim of a drink as he weighs his thoughts.%SPEECH_ON%Brigands have been taking off with precious livestock. They come in the night, the brigands I mean, and cut the bells to make off all quiet like. I\'m sure livestock aren\'t important to you, but one calf, one cow, one bull? That\'s a fortune to some people autour dese parts.\n\nSo the other day I have a lad follow the animal tracks out of town and now he\'s told me exactly where those brigands are. As I\'m sure you could guess, I don\'t have the men to spare to take these vagabonds on, but crowns... crowns I am not short on. If I were to cross your palms with copper, would you be willing to cross these brigands with steel?%SPEECH_OFF% | %employer% sighs as if he\'s tired of all these troubles, as though he\'s about to start a conversation he\'s already had many times before.%SPEECH_ON%%randomname%, a man of some import here, states that brigands made a pass on his daughters. Now he\'s worried what they\'ll do the next time. Luckily, that man is of some wealth and could easily track these brigands down. If I were to pay you a decent sum, how earnestly could you drive one of them swords of yours through a brigand or two?%SPEECH_OFF% | %employer% takes a seat in a chair big enough to be comfortable for two. He bandies a mug back and forth.%SPEECH_ON%Brigands have been harrying us for weeks now and just yesterday they tried to set fire to a pub. Can you believe that? Who sets fire to such a thing? Luckily we put it out just in time, but things are getting bad around here. If they threaten our precious drink, what will they do next? Luckily, we managed to find where these vagrants are hiding. So... yes I see your look. It\'s a simple task, sellsword: we want you to go kill every last brigand there. Are you willing to work with us?%SPEECH_OFF% | As you settle into the room, %employer% finishes a goblet of cobra wine and heaves the cup out a window. You hear the din of it clattering hollow far, far away. He turns to you.%SPEECH_ON%While walking the roads, brigands swarmed my wagon and made off with all my goods! They left me my life, which is fine, but the gall of what they did keeps me up at night. I see their sneering faces... hear their laughter... I believe it was a message, to go after me, because I refused to pay their \'tolls\'. Well, now I am ready to pay a toll - to you, sellsword. If you go and slaughter these vagabonds, I\'ll pay a tidy toll indeed. What say you?%SPEECH_OFF% | As you begin to take a seat, %employer% throws a scroll at you. It unfurls just as you catch it. You begin to read, but %employer% starts in with the news anyway.%SPEECH_ON%Traders from %randomtown% have all agreed to no longer patronize %townname% until our little brigand problem is done away with. The history of it is pretty simple, as I\'m sure you\'re aware of the brigands\' methods, but these damn vagabonds have been harrying the roads, pillaging caravans and killing merchants.\n\nI know exactly where they are, I just need a man of guts and in need of glory - or gold! - to go and kill them. So what say you, mercenary? Name a price and we can talk.%SPEECH_OFF% | %employer% is shaking when you greet him. He\'s practically frothing with anger - or maybe he\'s just really drunk.%SPEECH_ON%Citizens of this fine town are starving. Why? Because brigands keep sneaking in during the night to raid the granaries! And if we catch them, they burn the buildings down! Now we can\'t defend ourselves by sitting back... Now... I want to defend myself by killing them all.%SPEECH_OFF%The man teeters for a moment, as if about to spill himself across his desk. He steadies before continuing.%SPEECH_ON%I want you to go kill these vagrants, obviously. All you have to do is be interested and... -hic-... name your price.%SPEECH_OFF% | %employer% looks solemnly at the ground. He unfurls a scroll, showing you a face.%SPEECH_ON%This is %randomname%, a brigand at large who we captured the other day. He once lead an outfit of vagrants that used to harry and raid our town day and night. Problem is, he\'s not really the head of a snake, but one head of a hydra. Kill one criminal head, another takes its place. So what\'s the answer? Why, kill them ALL of course. And that\'s exactly what I want you to do, sellsword. Are you interested?%SPEECH_OFF% | %employer% turns to you as you look for somewhere to sit.%SPEECH_ON%Hoy, mercenary, how long has it been since you\'ve slaked your sword with the blood of evil, cruel men?%SPEECH_OFF%He drops the sarcasm and you figure you\'ll be standing now.%SPEECH_ON%We here at %townname% are having a bit of a tiff with some local brigands. Local to us, that is, with their little rat\'s hole not far from here. Obviously, I think the answer to this issue is to hire some finely armed men such as your little company of goodfellas. So, does that pique your interest, mercenary, or do I need to find sturdier men for this task?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{De combien de Couronnes parle-t-on? | Combien est prêt à payer %townname% pour leur sécurité? | Parlons argent.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Pas intéressé. | Nous avons d\'autres importants problèmes à régler. | Je vous souhaite bonne chance, mais nous ne participerons pas à cela.}",
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
			ID = "AttackRobberBaron",
			Title = "Before the attack...",
			Text = "[img]gfx/ui/events/event_54.png[/img]{While spying on the brigand encampment, you notice the profile of a man you\'ve heard the locals almost fervently describing: it is %robberbaron%, a famed robber baron that terrorizes these parts. He\'s got a retinue of brutish looking men following him everywhere he goes.\n\nYou wager his head is worth a few extra crowns. | You didn\'t plan to see him, but it\'s no doubt the man himself: %robberbaron% is at the brigands\' encampment. The famed killer is apparently paying a visit to one of his criminal offshoots, studiously marching autour de thieves, pointing his finger to this or that, remarking about the quality of that and this.\n\nA few bodyguards follow him everywhere. You estimate that between him and the rest of the brigands, there\'s about %totalenemy% men mucking about. | The contract was just to wipe out the brigands, but it appears another, much heavier carrot has been added to the stick: %robberbaron%, the infamous killer and road raider, is at the camp. Followed by a bodyguard, the robber baron seems to be assessing one of his criminal outfits.\n\nYou wonder how much %robberbaron%\'s head would weigh in crowns... | %robberbaron%. It\'s him, you know it. Eyeing through a spyglass, you can easily see the silhouette of the infamous robber baron as he moves about the brigands\' encampment. He wasn\'t in your plans, nor mentioned in the contract, but there\'s little doubt that if you bring his head back to town you\'ll be getting a little extra for your troubles. | While spying on the brigands - you count about %totalenemy% men moving about - you spot a figure you did not at all expect: %robberbaron%, the infamous robber baron. The man and his bodyguard detail must be inspecting the state of the camp.\n\nWhat luck! If you could take his head back to your employer, you might just earn yourself a little bonus.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Prepare the attack!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "RobberBaronDead",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{The battle finished, you walk over to %robberbaron%\'s slain body and remove his head with two quick thwacks of your sword, the first cutting the meat, the second the bone. You drive a hook through the lip of neckflesh and draw a rope so as to attach it your hip. | With the fighting over, you quickly search for and find %robberbaron%\'s corpse amongst the dead. He still looks mighty mean even as the color leaves his body. He still looks quite  mean when you relieve his head of his body and though you can\'t see his face any longer as you toss his head into a burlap sack, you assume he still looks pretty mean then, too. | %robberbaron% lies dead at your feet. You turn the body over and straighten out the neck, giving your sword a better target. It takes two good cuts to remove the head which you quickly put into a mealsack. | Now that he\'s dead, %robberbaron% suddenly reminds you of a lot of men you used to know. You don\'t settle on the deja vu for long: with a few quick slashes of a sword, you remove the man\'s head before tossing it into a sack. | %robberbaron% put up a good fight and his neck put up another, the sinews and bones not letting his head go easily as you collect your bounty. | You collect %robberbaron%\'s head. %randombrother% points at it as you walk past.%SPEECH_ON%What is that? Is that %robberbaron%\'s...?%SPEECH_OFF%You shake your head.%SPEECH_ON%Naw, that man is dead. This here is just bonus pay.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We move out!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BountyHunters1",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_07.png[/img]{Heading back to collect on your contract, a few men step out onto the road. One of them points at the head of %robberbaron%. %SPEECH_ON%We are the highest paid bounty hunters in these parts and I believe you\'re carrying off a bit of our business. Give us that there head and all parties shall get to sleep in their beds tonight.%SPEECH_OFF%You laugh.%SPEECH_ON%You will have to try better than that. %robberbaron%\'s head is worth a lot of crowns, my friend.%SPEECH_OFF%The leader of these supposed bounty hunters laughs right back at you. He lifts up a bulbously weighted sack.%SPEECH_ON%This here is %randomname%, one of the more wanted fellas in these parts. And this...%SPEECH_OFF%He holds up another sack.%SPEECH_ON%Is the head of the man who killed him. Understand? So hand over the bounty and we can all be on our way.%SPEECH_OFF% | A man steps out onto the road, straightens up, and postures toward you.%SPEECH_ON%Hello good sirs. I believe you have the head of %robberbaron% in your midst.%SPEECH_OFF%You nod. The man smiles.%SPEECH_ON%Would you please kindly turn it over to me.%SPEECH_OFF%You laugh and shake your head. The man doesn\'t smile, instead he raises a hand and snaps his fingers. A throng of well-armed men pour out of some nearby bushes, marching onto the road to the tune of heavy metal clinks and clanks. They look like what a man on death row might dream of the night before his reckoning. Their leader flashes a gold-speckled grin.%SPEECH_ON%I\'m not gonna ask you again.%SPEECH_OFF% | While talking to %randombrother%, a loud yell draws your attention. You look up the road to see a mob of men standing in your way. They got all manner of weaponry and armor. Their ringleader steps forward, announcing that they are famed bounty hunters.%SPEECH_ON%We only wish to have the head of %robberbaron%.%SPEECH_OFF%You shrug.%SPEECH_ON%We killed the man, we\'re collecting on his head. Now get out of our way.%SPEECH_OFF%When you take one step forward, the bounty hunters raise their weapons. Their leader takes one step toward you.%SPEECH_ON%There\'s a choice to be made here that could get a lot of good men killed. I know it isn\'t easy, but I do suggest you think it over very carefully.%SPEECH_OFF% | A sharp whistle draws the attention of you and your men. You turn to the side of the road to see a group of men emerging from some bushes. Everyone draws their weapons, but the strangers don\'t move a foot further. Their ringleader steps forward. He\'s got a bandolier of ears going across his chest, a summation of his handiwork.%SPEECH_ON%Hello fellas. We here are bounty hunters, if you couldn\'t tell, and I do believe you have one of our bounties.%SPEECH_OFF%You lift the head of %robberbaron%.%SPEECH_ON%You mean this?%SPEECH_OFF%The ringleader smiles warmly.%SPEECH_ON%Of course. Now if you could please hand it over, that\'d sit pretty well with me and my friends.%SPEECH_OFF%Tapping the hilt of his sword, the man grins.%SPEECH_ON%It\'s only a matter of business. I\'m sure you understand.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Take the damned head then and leave.",
					function getResult()
					{
						this.Flags.set("IsRobberBaronDead", false);
						this.Flags.set("IsBountyHunterPresent", false);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractPoor);
						return "BountyHunters2";
					}

				},
				{
					Text = "{You\'ll have to pay with blood if you want it so badly. | If you want your head to join this one, go on, take your chances.}",
					function getResult()
					{
						this.TempFlags.set("IsBountyHunterTriggered", true);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.Music = this.Const.Music.BanditTracks;
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "BountyHunters";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.BountyHunters, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BountyHunters2",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_07.png[/img]You\'ve seen enough bloodshed for today and hand the head over.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Let\'s move on. We still have payment to collect.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BountyHunters3",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_07.png[/img]The bounty hunters are too much for the %companyname%! Not wanting your men needlessly killed, you order a hasty retreat. Unfortunately, the head of %robberbaron% was lost in the chaos...",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Oh well. We still have payment to collect.",
					function getResult()
					{
						this.Flags.set("IsBountyHunterRetreat", false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivors1",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{With the battle drawing to a close, a few enemies drop to their knees and beg for mercy. %randombrother% looks to you for what to do next. | Après la bataille, your men round-up what brigands remain. The survivors beg for their lives. One looks more like a kid than a man, but he is the quietest of them all. | Realizing their defeat, the few last standing brigands drop their weapons and ask for mercy. You now wonder what they would do were the shoe on the other foot. | The battle\'s over, but decisions are still yet to be made: a few brigands survived the battle. %randombrother% stands over one, his sword to the prisoner\'s neck, and he asks you what you wish to do.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Slit their throats.",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-1);
						return "Survivors2";
					}

				},
				{
					Text = "Take their arms and chase them away.",
					function getResult()
					{
						this.World.Assets.addMoralReputation(2);
						return "Survivors3";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivors2",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Altruism is for the naive. You have the prisoners slaughtered. | You recall how many times brigands slew hapless merchants. The thought is barely out of your mind when you give the order to have the prisoners executed. They pipe up a brief protest, but it is cut short by swords and spears. | You turn away.%SPEECH_ON%Through their necks. Make it quick.%SPEECH_OFF%The mercenaries follow the order and you soon here the gargling of dying men. It is not quick at all. | You shake your head \'no\'. The prisoners cry out, but the men are already upon them, hacking and slashing and stabbing. The lucky ones are decapitated before they can even realize the immediacy of their own demise. Those with some fight in them suffer to the very end. | Mercy requires time. Time to look over your shoulder. Time to wonder if it was the right decision. You\'ve no time. You\'ve no mercy. The prisoners are executed and that takes little time at all.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We have more important things to take care of.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivors3",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{There\'s been enough killing and dying today. You let the prisoners go, taking their arms and armor before sending them off. | Clemency for thieves and brigands doesn\'t come often, so when you let the prisoners go they practically kiss your feet as though they were attached to a god. | You think for a time, then nod.%SPEECH_ON%Mercy it is. Take their equipment and cut them loose.%SPEECH_OFF%The prisoners are let go, leaving behind what arms and armor they had with them. | You have the brigands strip to their skivvies - if they even have them - then let the men go. %randombrother% rummages through what equipment is left behind as you watch a group of half-naked men hurry away.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We\'re not getting paid for killing them.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Volunteer1",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Just as the battle ends and things begin to quiet, you hear a man shouting. You move toward the noise to find a prisoner of the brigands. He\'s got ropes over his mouth and hands which you quickly undo. As he catches his breath, he meekly asks if maybe he could join your outfit. | You find a prisoner tied up in the brigands\' camp. Freeing him, he explains that he is from %randomtown%, and was kidnapped by the vagabonds just a few days ago. He asks if maybe he could join your band of mercenaries. | Rummaging what\'s left of the brigands\' camp, you discover a prisoner of theirs. Freeing him, the man sits up and explains that the brigands kidnapped him as he was traveling to %randomtown% in seek of work. You wonder if maybe he could work for you instead... | A man is left behind Après la bataille. He\'s not a brigand, but in fact a prisoner of theirs. When you ask who he is, he mentions that he is from %randomtown% and that he\'s looking for work. You ask if he can wield a sword. He nods.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "You might as well join us.",
					function getResult()
					{
						return "Volunteer2";
					}

				},
				{
					Text = "Go home.",
					function getResult()
					{
						return "Volunteer3";
					}

				}
			],
			function start()
			{
				local roster = this.World.getTemporaryRoster();
				this.Contract.m.Dude = roster.create("scripts/entity/tactical/player");
				this.Contract.m.Dude.setStartValuesEx(this.Const.CharacterLaborerBackgrounds);

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Volunteer2",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{The man joins your ranks, immersing himself in a crowd of brothers who seem to take to him warmly enough for a group of paid killers. The newly hired states he\'s good with all weapons, but you figure you\'ll be the one to decide what he\'s best with. | The prisoner grins from ear to ear as you wave him in. A few brothers ask what weapons they should give him, but you shrug and figure you\'ll see to yourself what to arm the man with.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Let\'s see about a weapon for you.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Contract.m.Dude.getImagePath());
				this.World.getPlayerRoster().add(this.Contract.m.Dude);
				this.World.getTemporaryRoster().clear();
				this.Contract.m.Dude.onHired();
				this.Contract.m.Dude = null;
			}

		});
		this.m.Screens.push({
			ID = "Volunteer3",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{You shake your head no. The man frowns.%SPEECH_ON%Are you sure? I\'m pretty good with...%SPEECH_OFF%You cut him off.%SPEECH_ON%I\'m sure. Now enjoy your newfound freedom, stranger.%SPEECH_OFF% | You appraise the man and figure he\'s not fit for the life of a sellsword.%SPEECH_ON%We appreciate the offer, stranger, but the mercenary life is a dangerous one. Go home to your family, your work, your home.%SPEECH_OFF% | You\'ve enough men to see you through, although you find yourself tempted to replace %randombrother% just to see the man\'s reaction to a demotion. Instead, you offer the prisoner a handshake and send him on his way. Although disappointed, he does thank you for freeing him.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Off you go.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Contract.m.Dude.getImagePath());
				this.World.getTemporaryRoster().clear();
				this.Contract.m.Dude = null;
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{You Retournez à %townname% and talk to %employer%. The details of your journey are simple: you killed the brigands. He nods, smiling tersely before handing over your payment as agreed upon.%SPEECH_ON%Good work, men. Those brigands were giving us plenty of trouble.%SPEECH_OFF% | %employer% opens the door for you as you get to his home. He\'s got a satchel in hand and holds it up.%SPEECH_ON%I take it by your return that the brigands are dead?%SPEECH_OFF%You nod. The man heaves the satchel your way. You tell him you could be lying. %employer% shrugs.%SPEECH_ON%Could be, but word travels fast for those who bite the hands that feed. Good work, sellsword. Unless you\'re lying of course, then I\'ll come find you.%SPEECH_OFF% | %employer% grins as you enter his room and lay a sacked head on his desk.%SPEECH_ON%You need not stain my fineries to show you\'ve completed the task, sellsword. I\'ve already gotten news of your success - the birds in these lands do travel fast, don\'t they? Your payment is in the corner.%SPEECH_OFF% | As you finish your report, %employer% wipes his forehead with a handkerchief.%SPEECH_ON%Really, they\'re all dead then? Boy... you have no idea how much you\'ve lifted off my shoulders, sellsword. No idea at all! Your crowns, as promised.%SPEECH_OFF%He sets a satchel on his desk and you quickly take it. All is there, as promised. | %employer% sips his goblet and nods.%SPEECH_ON%You know, I don\'t take kindly to your sort, but you did a good job, mercenary. %randomname% reported to me, before you even got here, that all the brigands had been slain. It was some mighty fine work by the way he describes it. And, well...%SPEECH_OFF%He heaves a satchel onto the desk.%SPEECH_ON%Here\'s some mighty fine pay, as promised.%SPEECH_OFF% | %employer% leans back in his chair, folding his hands over his lap.%SPEECH_ON%Sellswords don\'t sit right with many folks, I suppose on the account of y\'all killing and destroying whole villages on a shortchanged whim, but I\'ll admit you\'ve done good.%SPEECH_OFF%He nods to a corner of the room where a wooden chest lays unopened.%SPEECH_ON%It\'s all there, but I won\'t be offended if you need to count it.%SPEECH_OFF%You do count it, and it is indeed all there. | %employer%\'s desk is blanketed in dirtied and unfurled scrolls. He\'s smiling warmly over them as if he\'s crooning over a pile of treasure.%SPEECH_ON%Trade deals! Trade deals everywhere! Happy farmers! Happy families! Everyone\'s happy! Ah, it\'s good to be me. And, of course, it\'s good to be you, sellsword, because your pockets just got a little bit heavier!%SPEECH_OFF%The man tosses a small purse your way, then another and another.%SPEECH_ON%I would\'ve paid with a larger satchel, but I just like doing that.%SPEECH_OFF%He cheekily tosses another purse which you casually catch with the sort of unamused aplomb of a man who still has fresh blood on his sword.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Destroyed a brigand encampment");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] Couronnes"
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{You throw the criminal\'s head on %employer%\'s table. With a grin, you point at it.%SPEECH_ON%That\'s %robberbaron%.%SPEECH_OFF%%employer% stands up and unveils the burlap sack covering the trophy. He nods.%SPEECH_ON%Aye, that\'s him alright. I guess you\'ll be getting extra for that.%SPEECH_OFF%You\'re paid a tidy sum of %reward% crowns for killing the brigands as well as destroying the leadership of many nearby syndicates. | %employer% leans back as you enter his room, carrying a head by its hair. Luckily, it is not dripping.%SPEECH_ON%This here is %robberbaron%. Or should I say was?%SPEECH_OFF%Slowly standing, %employer% takes a cursory look.%SPEECH_ON%\'Was\' works... So, not only did you destroy the brigands\' rat hole, but you\'ve brought me the head of their leader. That is some mighty fine work, sellsword, and you\'ll be getting extra for this.%SPEECH_OFF%The man forks over a satchel of %original_reward% crowns and then takes a purse off his own self and pitches it toward you. | You hold %robberbaron%\'s head up, its sloped gaze turning to the ropes of bloodied hair. A slow smile etches across %employer%\'s face.%SPEECH_ON%You know what you\'ve done, sellsword? Do you know how much relief you\'ve brought to these parts just by removing that man\'s head from his shoulders? You\'ll be getting more than what you bargained for! %original_reward% crowns for the original task and...%SPEECH_OFF%The man slides a chunky purse across his table.%SPEECH_ON%A little something for that... extra weight you\'ve been carrying around.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Des couronnes bien méritées.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() * 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Destroyed a brigand encampment");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() * 2;
				this.Contract.m.OriginalReward = this.Contract.m.Payment.getOnCompletion();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] Couronnes"
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"reward",
			this.m.Reward
		]);
		_vars.push([
			"original_reward",
			this.m.OriginalReward
		]);
		_vars.push([
			"robberbaron",
			this.m.Flags.get("RobberBaronName")
		]);
		_vars.push([
			"totalenemy",
			this.m.Destination != null && !this.m.Destination.isNull() ? this.beautifyNumber(this.m.Destination.getTroops().len()) : 0
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive() ? "" : this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Destination.getTile())]
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/ambushed_trade_routes_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
				this.m.Destination.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}

		if (this.m.Home != null && !this.m.Home.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Home.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(4);
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
		_out.writeI32(0);

		if (this.m.Destination != null && !this.m.Destination.isNull())
		{
			_out.writeU32(this.m.Destination.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		_in.readI32();
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		this.contract.onDeserialize(_in);
	}

});


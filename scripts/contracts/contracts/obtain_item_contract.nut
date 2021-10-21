this.obtain_item_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		RiskItem = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.obtain_item";
		this.m.Name = "Obtain Artifact";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		local camp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getNearestSettlement(this.m.Home.getTile());
		this.m.Destination = this.WeakTableRef(camp);
		this.m.Flags.set("DestinationName", camp.getName());
		local items = [
			"Fingerbone of Sir Gerhardt",
			"Blood Vial of the Holy Mother",
			"Shroud of the Founder",
			"Elderstone",
			"Staff of Foresight",
			"Seal of the Sun",
			"Starmap Disc",
			"Forefathers\' Scroll",
			"Petrified Almanach",
			"Coat of Sir Istvan",
			"Staff of Golden Harvests",
			"Prophet\'s Pamphlets",
			"Forefathers\' Standard",
			"Seal of the False King",
			"Flute of the Debaucher",
			"Dice of Destiny",
			"Fetish of Fertility"
		];
		this.m.Flags.set("ItemName", items[this.Math.rand(0, items.len() - 1)]);
		this.m.Payment.Pool = 500 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Obtenez %item% à %location%"
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
				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.UndeadArmy, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setLootScaleBasedOnResources(100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());

				if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Destination.getLoot().clear();
				}

				this.Contract.m.Destination.setDiscovered(true);
				this.Contract.m.Destination.m.IsShowingDefenders = false;
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				local r = this.Math.rand(1, 100);

				if (r <= 10)
				{
					this.Flags.set("IsRiskReward", true);
					local i = this.Math.rand(1, 6);
					local item;

					if (i == 1)
					{
						item = this.new("scripts/items/weapons/ancient/ancient_sword");
					}
					else if (i == 2)
					{
						item = this.new("scripts/items/weapons/ancient/bladed_pike");
					}
					else if (i == 3)
					{
						item = this.new("scripts/items/weapons/ancient/crypt_cleaver");
					}
					else if (i == 4)
					{
						item = this.new("scripts/items/weapons/ancient/khopesh");
					}
					else if (i == 5)
					{
						item = this.new("scripts/items/weapons/ancient/rhomphaia");
					}
					else if (i == 6)
					{
						item = this.new("scripts/items/weapons/ancient/warscythe");
					}

					this.Contract.m.RiskItem = item;
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
					"Obtenez %item% à %location% %direction% de %origin%"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.m.IsShowingDefenders = false;
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					if (this.Flags.get("IsRiskReward"))
					{
						this.Contract.setState("Return");
					}
					else
					{
						this.Contract.setScreen("LocationDestroyed");
						this.World.Contracts.showActiveContract();
					}
				}
				else if (this.TempFlags.get("GotTheItem"))
				{
					this.Contract.setState("Return");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;

				if (!this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);

					if (this.Flags.get("IsRiskReward"))
					{
						this.Contract.setScreen("RiskReward");
					}
					else
					{
						this.Contract.setScreen("SearchingTheLocation");
					}

					this.World.Contracts.showActiveContract();
				}
				else
				{
					local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
					properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
					properties.EnemyBanners.push(this.Contract.m.Destination.getBanner());
					this.World.Contracts.startScriptedCombat(properties, _isPlayerAttacking, true, true);
				}
			}

			function end()
			{
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull() && this.Contract.m.Destination.isAlive())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(null);
					this.Contract.m.Destination = null;
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
					if (this.Flags.get("IsFailure"))
					{
						this.Contract.setScreen("Failure1");
					}
					else
					{
						this.Contract.setScreen("Success1");
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
			Text = "{[img]gfx/ui/events/event_43.png[/img]%employer% welcomes you and walks you toward %townname%\'s square. There\'s a party of peasants milling about, but when they see you coming they shape up and start talking as though they\'d been expecting you all along. They mostly talk in descriptors: tall as any man! Armor like you\'d never seen before! Spears as sharp as a peddler\'s tongue! You hold your hand up and ask what it is they are talking about. %employer% laughs.%SPEECH_ON%The men here say they saw some oddities out in a spot by the name of %location% just %direction% of here. Naturally, they weren\'t out there for no reason. They were looking for something by the name of %item%, a relic dear to the town for through it we pray for food and shelter.%SPEECH_OFF%One of the peasants speak up.%SPEECH_ON%And we was lookin\' fer it at his behest!%SPEECH_OFF%%employer% nods.%SPEECH_ON%Of course. And where they failed, perhaps you can succeed? Get this relic for me and you\'ll be paid quite well for your services. Pay no mind to their fairy tales. I\'m sure there\'s nothing to worry about.%SPEECH_OFF% | [img]gfx/ui/events/event_62.png[/img]%employer% welcomes you into his room and pours you a mug of water. He hands it over with a sheepish smile.%SPEECH_ON%I\'d offer a bit of ale or wine if I had it on me, but you know how things are nowadays.%SPEECH_OFF%He takes a sip and clears his throat.%SPEECH_ON%Of course, what I\'m not short on are crowns, otherwise we wouldn\'t be having this conversation, right? I need you to go to a place by the name of %location% just %direction% of here and retrieve a relic by the name of %item%. Pretty simple, no?%SPEECH_OFF%You ask what this relic is good for. The man explains.%SPEECH_ON%Townsfolk pray to it. Through it they find peace, call for the rains, fark their goats, I don\'t care. They believe in it and it keeps them motivated. For that alone it\'s worth retrieving.%SPEECH_OFF% | [img]gfx/ui/events/event_62.png[/img]You step into %employer%\'s room to find the man staring at a map of the hinterlands. He shakes his head.%SPEECH_ON%See this spot right here? That\'s %location%. %townname% used to worship a relic by the name of %item%, but the townsfolk are saying it\'s gone missing and, well, for whatever reason they think it\'s there. I\'ve no men to hire and see, for the roads are dangerous and I can\'t afford to pay for failure, but you, sellsword, seem up to the task. Would you go there and find this %item% for us?%SPEECH_OFF% | [img]gfx/ui/events/event_43.png[/img]You find %employer% talking to a group of peasants. Seeing you, he quiets them all down.%SPEECH_ON%Shush, the lot of you. This man here can solve our problem.%SPEECH_OFF%The townsman takes you aside.%SPEECH_ON%Sellsword, we have a bit of a problem. There\'s a relic I need finding, some such thing by the name of %item%. I don\'t really give a good old gods damn about it, but these people worship it for spring rains and winter shelter. Naturally, it\'s gone missing. And for whatever reason folks think it\'s gone off to a place by the name of %location% all on its own. Nobody\'ll go there, but you will, yes? For the right price, of course.%SPEECH_OFF% | [img]gfx/ui/events/event_62.png[/img]You find %employer% talking to a druidic monk cloaked in shapes more familiar to beasts than man. Horns for a helmet, bearskin for armor, and the hooves of deer clattering around his chest in a brutish necklace. He\'s quite the sight. Seeing you, %employer% waves you in.%SPEECH_ON%Sellsword! It is good to see you--%SPEECH_OFF%The druid pushes the man out of the way mid-talk. He speaks with a wobble in his voice, as though he were speaking from the depths of a cavern.%SPEECH_ON%A mercenary, ha! Surely you are a man of faith, no? We of %townname% have lost the %item%. This relic is of great import to us, for through it we can speak to the old gods and have our prayers answered. It\'s been stolen away, in some manner or another, to the %location%. Go there and retrieve it.%SPEECH_OFF%You glance at %employer% who nods.%SPEECH_ON%Aye, what he said.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{You did right by coming to us. Let\'s talk payment. | Parlons argent. | Sounds simple enough. What\'s the pay?}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Pas intéressé. | Nous avons d\'autres importants problèmes à régler. | Je suis sûr que vous trouverez quelqu\'un d\'autre pour faire ça.}",
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
			ID = "SearchingTheLocation",
			Title = "At %location%",
			Text = "[img]gfx/ui/events/event_73.png[/img]{You don\'t step into the ruins so much as clamber, hobbling over the stoneworks like a bat trying to walk upright. Getting to the bottom of the descent, you find what looks like hundreds of clay pots, old chariots more mulch than wood, and metal water basins filled with rusted shields and spears. %randombrother% takes a torch and throws its glow toward the walls. Great murals run along the length of them, great artworks depicting battles you\'ve never heard of. Each step you take seems to unveil another ancient victory until, finally, you come to a giant painted map. There you see a continent overrun with the rule of an empire, gilded its belly, blackened its borders.\n\n %randombrother% walks over, the %item% in hand. You nod and tell him it\'s time to go. When the two of you turn around, there\'s a man standing there with a spear in one hand and a shield in the other. Another figure joins him, and another, their steps hitting the stone floor with metal malice. You yell at the mercenary to run and the both of you abandon the ruins in a hurry, the staccato clap of a death march on your heels.\n\n Outside you wheel around and order the men to get ready for a fight. Before the first sellsword can so much as draw his sword, a stream of armored soldiers emerge from the ruins, stack formation, and level their spears at you. Their lieutenant points a decayed finger and speaks with a voice so graveled the words weigh deep in your chest.%SPEECH_ON%The Empire rises. The False King must die.%SPEECH_OFF% | The hole into the ruins is big enough for only one man to get through. You\'re worried that if everyone goes in at once they\'ll get stuck and you\'ll have basically killed the %companyname% off like a bunch of rats in a tight tunnel. Instead, you send in only %randombrother%, who knows what he\'s after and who you trust can take care of himself were anything to happen.\n\n A few minutes later and you hear the man struggling to crawl back out - and he sounds to be in quite the rush. He yells for help and you and a few other mercenaries stick their hands into the hole. He grabs on and, together, you yank him out. He\'s got the %item%, but a horrified look on his face. He rolls over and gets up in a hurry.%SPEECH_ON%Hurry! To arms!%SPEECH_OFF%As the mercenaries look into the hole to see if something\'s coming out, you ask the brother what he saw. He shakes his head.%SPEECH_ON%I don\'t know, sir. It was a mausoleum for people I\'ve never seen before. There was armor and spears all over the place, and murals of a great empire that spanned the whole world over! Painted from floor to ceiling! And... and then they started coming out of the walls. I got out of there as fast I could and...%SPEECH_OFF%Before he can even finish, the rubble where the hole used to be begins to shift and move. Stones roll away and suddenly they all burst outward, a malevolent force standing there - armed and well armored men standing in formation, spears over shields, shuffling forward in uniform steps. Their leader points directly at you.%SPEECH_ON%The Empire rises. The False King must die.%SPEECH_OFF%You\'ve never heard surer fighting words and immediately prepare your men for combat. | You venture into the ruins with %randombrother% at your side. The %item% is easy enough to find, if not a little too easy, but something else catches your attention altogether. There are pots strewn all across the stone floor. Each piece of pottery is a reservoir for spears, and shields hang against the walls on hooks that seem far too ancient and rusted to hold up a cobweb much less a piece of metal. Suddenly, %randombrother% grabs your arm.%SPEECH_ON%Sir. Trouble.%SPEECH_OFF%He points down the halls and you see a man standing there, his movements janky and quick, as though he were breaking in his suit of armor. Suddenly, his head snaps up and stares at you. Despite the fact he\'s standing so far away, his voice carries as though he were speaking right next to you.%SPEECH_ON%The False King dare trespass here? The Empire will rise again, but first you must die.%SPEECH_OFF%These are fighting words, no doubt, and you grab the sellsword and make a quick escape. You don\'t get far outside before the mercenaries take up arms without your ordering so: following behind you is a formation of soldiers in armor you\'ve never seen before. They step forward in a formation like a turtle\'s shell, clasped together with their shields held up to provide protection for the whole unit. Based on the fellow in the ruins, you\'ve no doubt they have come to kill you and the rest of the company! | You enter the ruins and find the %item% easily enough. When you turn around, a tall man in rustic armor is standing there, spear in hand, with vacated eye sockets leering down at you. He swings the spear back.%SPEECH_ON%The False King must die.%SPEECH_OFF%The spear stabs forward. %randombrother% leaps over and deflects it to the ground, the spear tip crackling a couple of sparks off the stone floor. You look at the undead man, a worm coursing through its nose. It speaks again.%SPEECH_ON%The False King must...%SPEECH_OFF%With a quick draw, you unsheathe your sword and cut the ancient dead\'s head right off. The skull and helmet carrying it clatter and clank off the ground. Before you can investigate, %randombrother% grabs you and tells you to run: more undead figures are appearing out of the walls, shaking free of the granitic grip of a mausoleum\'s entombment.\n\n Once outside, you order the rest of the company to get into formation. | You send a few of the men into the ruins to find the %item%. All of them return in a hurry, which is unusual as they have a strong inclination to dawdle about to eat up sunlight and earn an easy day\'s salary. Thankfully, one of them has the relic in hand. Unfortunately, they all look like they\'ve seen a ghost. They need not explain the source of their horror as a group of skittering, armor-clanking undead emerge from the ruins and level their spears at your company. | Arriving at the ruins, you expected some bandits to be footing about. Instead, retrieving the %item% could not have been easier. At least, that\'s what you thought before a throng of armored undead emerged yelling about the \'False King\' and demanding your head on a platter. To arms! | Finding and bagging the %item% was easier than expected. Finding a group of undead men top-heavy with rustic armor and wielding spears in a tighter military formation than even the highest paid army in the realm... not so expected. To arms!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To arms!",
					function getResult()
					{
						this.TempFlags.set("GotTheItem", true);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "LocationDestroyed",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_46.png[/img]{The battle over, and the %item% obtained, you tell the men to prepare for a Retournez à %employer%. You\'re not entirely sure who or what just attacked you, but right now it\'s time to get paid. | With the fighting over, you look over your attackers. They\'re shelled within armor you don\'t recognize. %randombrother% tries to pry one of the corpses out of its helm but to no avail. He looks incredulously at the body.%SPEECH_ON%It\'s like it\'s just stuck there, or a part of him or something.%SPEECH_OFF%You tell the men to gear up and get ready for a Retournez à %employer%. No matter who these men are, you\'re out here to get the %item% and that part is done. Now it\'s time to get paid. | You\'ve gotten the %item%, but at the cost of running into a sort of evil you\'ve never seen before. Armored men, ostensibly dead, yet operating in tight formations. %randombrother% holds up the %item% and asks what to do next. You inform the men that it is time to Retournez à %employer%. | You take a look at the %item% and at the men who attacked you over it. Or, at least you think they attacked you over it. The enemy lieutenant seemed to have said something, but you can\'t remember what it was. Ah well, time to Retournez à %employer% and get paid. | You\'re not entirely sure what it was you ran into. %randombrother% asks if you know what they said.%SPEECH_ON%Seems like they were pointing you out specifically, sir.%SPEECH_OFF%Nodding, you tell the man you\'re not sure what the armored man said, but it matters not. You have the %item% and it\'s time to Retournez à %employer% for your pay. | The %item% is in hand, but at what cost? Strange men, if you can call them that, attacked the company and you swear one of them specifically pointed you out, as though you\'d committed a crime that went beyond space and time. Oh well. You\'re not the sort to dwell on these things. What you\'re here for is the relic, which you\'ve got, and for a good payday which awaits you with %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Let\'s head back.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "RiskReward",
			Title = "At %location%",
			Text = "[img]gfx/ui/events/event_57.png[/img]{You step into %location% and take a good look around. It\'s not a moment later that %randombrother% points out the %item%, the relic sitting atop a stone podium that\'s covered in moss and cobwebs. He also points to something else sitting across the room: a very nice looking %risk% adorned to a tall statue\'s body.\n\nThe rest of the place is dilapidated and looking ready to crumble right on top of your heads. What the %risk% is doing there is definitely questionable. | The %item% is plain as day to see, but there\'s something else in the room that catches your attention. Sitting beside an enormous statue is a very unique looking %risk%. Of course, it begs the question, what in all the hells is it doing out there? While you think it\'s plain as day you should go and grab it, something tells you that might not be the wisest of decisions. | Well, you found the %item%. It was a lot easier than you\'d thought it would be. But there\'s something else here, too. You spot a glittering %risk% adorned to a tall statue of a man with a blank face. You\'re not sure what a statue is doing with such a thing, but there it is. And there it seems to always have been, which begs the question, why? | The %item% was easy enough to find, but as you prepare to go and grab the townsfolks\' relic, you spy a shiny %risk% adorning a tall and ominous statue of a man. Your first thought is to send a mercenary to go and grab it, but then you wonder what in all the hells it is doing there.} Perhaps the %companyname% should stick to what it was tasked to do?",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Just take that %item%.",
					function getResult()
					{
						return "TakeJustItem";
					}

				},
				{
					Text = "We might as well take that %risk% while we\'re here.",
					function getResult()
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "TakeRiskItemBad";
						}
						else
						{
							return "TakeRiskItemGood";
						}
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TakeJustItem",
			Title = "At %location%",
			Text = "[img]gfx/ui/events/event_57.png[/img]%employer% asked you to get the %item% and that\'s exactly what you\'re going to do. {%randombrother% agrees with this approach.%SPEECH_ON%I think we should leave that %risk% well enough alone. I\'ve never seen a clearer display of a trap than that.%SPEECH_OFF% | Shaking his head, %randombrother% laughs at your hesitancy.%SPEECH_ON%You scared of that big ol\' statue, huh? Though you\'d have had more guts than that, sir.%SPEECH_OFF% | After you grab the relic, %randombrother% barbs you with an elbow to the side.%SPEECH_ON%Is someone afraid of the big bad statue, huh? C\'mon, let me grab it. We can have it and be out the door in two seconds!%SPEECH_OFF%You kindly remind the mercenary who is in charge lest he \'joke\' around again. | The relic already in your hand, %randombrother% simply nods.%SPEECH_ON%Good on ya, sir. I say we leave that %risk% well enough alone. That there shining bauble ain\'t nothing but trouble. Going after it would be akin to a fool chasing a beautiful woman in the middle of all the ocean!%SPEECH_OFF% | %randombrother% glares at the %risk% and spits, clearing his throat and running a hand across hid disheveled face.%SPEECH_ON%Yeah. Let\'s leave it well enough alone. If I were to find a pile of gold in the middle of a forest, I think I\'d think twice about runnin\' fer it. Same notion here.%SPEECH_OFF% | %randombrother% agrees with your decision.%SPEECH_ON%Aye, let\'s leave that there %risk% alone. Nothing\'s free in this world, nothing. Certainly nothing with that sort of shine. No sir.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "That was easy enough.",
					function getResult()
					{
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
			ID = "TakeRiskItemGood",
			Title = "At %location%",
			Text = "[img]gfx/ui/events/event_57.png[/img]{With the %item% in hand, you figure you might as well grab the %risk%. %randombrother% goes and does it, carefully freeing the statue of the piece. Once the metal wriggles free, the man pauses, readied to get clobbered if the statue were to jump to life. Instead, nothing happens. He nervously laughs.%SPEECH_ON%E-easy-peasy!%SPEECH_OFF%As relief spreads over the men, you tell them to get ready to Retournez à %employer%. | As you grab the %item%, you glance at the %risk% and figure why not. You climb up the statue and stare into the face of the man it has taken its image from. Whoever it was, they had chiseled cheekbones and a jaw to hang a coat on. Looking past his features, you grab the %risk% and hold it out, waiting for something to happen. Nothing does. %randombrother% laughs.%SPEECH_ON%You gonna tell that statue \'welcome\' or not?%SPEECH_OFF%You pat the statue on the head and climb down. The company should head back to %employer% now.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "That was easy enough.",
					function getResult()
					{
						this.Contract.m.RiskItem = null;
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				this.World.Assets.getStash().add(this.Contract.m.RiskItem);
				this.List.push({
					id = 10,
					icon = "ui/items/" + this.Contract.m.RiskItem.getIcon(),
					text = "You gain " + this.Contract.m.RiskItem.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "TakeRiskItemBad",
			Title = "At %location%",
			Text = "[img]gfx/ui/events/event_73.png[/img]{You send %randombrother% up the statue to retrieve the %risk%. While he\'s up there, you notice %employer%\'s lost bauble tottling about on the podium. Sticking your hand out, you hope to steady it, but instead of it going upright, it simply blows through your fingers like dust. The powdered remains stream around your arm like a snake made of fog. You leap away and the smoke shoots toward the statue, thrusting itself into the eyes which now turn a bright red. The stone cracks and crumbles. The sellsword jumps away. All autour dere are shapes emerging from the walls, statues breaking apart to give birth to strange looking men armor-clad and with spears yoked over their shoulders.\n\n You order everyone to prepare for battle! | There\'s no way you could turn down something like that %risk%. You climb up the statue\'s face and reach for it, but the second a bit of metal touches your finger there\'s a rumbling and the statue begins to shake. %randombrother% shouts and you turn around. He\'s pointing toward the %item% which is dissolving before your very eyes! It turns to powder and you can only watch as a stream of it, like a fog taken to life, swirls autour de room and zips right past your face and up the nose of the statue. Its eyes beam red and you immediately jump away. A sellsword comes to your side, his weapon already out.%SPEECH_ON%Sir, sir! Look!%SPEECH_OFF%There are shapes emerging from the walls! Statues that lurch forward like stringed puppets dangling from an old man\'s fingers. Slowly, each one discards its stony carapace and emerges as an odd looking, armor-clad and spear-wielding man. You quickly command your men into battle formation because whatever it is you have set free here isn\'t going to be friendly!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Rally!",
					function getResult()
					{
						this.Contract.m.RiskItem = null;
						this.Flags.set("IsFailure", true);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination, false);
						return 0;
					}

				}
			],
			function start()
			{
				this.World.Assets.getStash().add(this.Contract.m.RiskItem);
				this.List.push({
					id = 10,
					icon = "ui/items/" + this.Contract.m.RiskItem.getIcon(),
					text = "You gain " + this.Contract.m.RiskItem.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% meets you at the town square. You hand over the %item% and the man cradles it as if it were an infant he thought lost. After a moment of awkward embrace with the relic, he holds it up high, letting the townspeople see it. They cheer for a time. Too long, truly. You have to elbow %employer% to remind him to pay you. | You find %employer% mucking about in a pig pen. He\'s kicking the fat sows around, though they seem more focused on the feed than the leather toe tapping on their arse. You loudly clear your throat. %employer% wheels around and his eyes immediately go wide at the sight of the relic. He jumps over a pig and takes the %item%. He shouts to the townsfolk who gather around and pray to the gods for their mercy. Not a one thanks you, naturally. You have to remind %employer% of the crowns he owes you. It\'s paid and you make your leave as fast as you can. | You find %employer% sitting in the town square, his arms up to the skies, his eyes closed, his mouth murmuring prayers. The townsfolk are all around him, kneeling and doing the same. You pick up a rock and hurl at a weathervane, the clank and rustic spins drawing everyone\'s attention.\n\nYou hold the relic up so all can see. %employer% jumps to his feet and takes the %item%. The people roar with delight, speaking of good things to come. Your payment is handed to you which, truly, is what you would consider a \'good thing\'.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "The townsfolk seem to be in a good spirit now.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Obtained " + this.Flags.get("ItemName"));
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isUndeadScourge())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCommonContract);
						}

						return 0;
					}

				}
			],
			function start()
			{
				local reward = this.Contract.m.Payment.getOnCompletion();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + reward + "[/color] Crowns"
				});
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/high_spirits_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_43.png[/img]{The townsfolk of %townname% are eagerly awaiting your return. A shame, because you don\'t have the relic that they so desperately need. %employer%, seeing your failure a step ahead of the laymen, meets you at the town entrance and talks to you in whispers.%SPEECH_ON%I take it you do not have the %item%.%SPEECH_OFF%You try to explain all that happened, but he does not seem to listen.%SPEECH_ON%It\'s no matter, mercenary. I can\'t pay you, obviously, and the townsfolk shan\'t hear of your shortcomings lest we have them lose their minds. They depend upon idols to find comfort in this world. I will have to come up with my own solution and, well, pray it works. Good day.%SPEECH_OFF% | %employer% meets you beside a host of geese. He\'s feeding them out of hand while, quite casually, a boy will occasionally come by and simply pick up one of the birds and go off with it for a slaughtering. The man smiles warmly at you, but his excitement quickly sours.%SPEECH_ON%I do not see the relic. Am I right to believe you do not have it?%SPEECH_OFF%A simple nod is all you give as an answer. He opens his arms, somewhat confused.%SPEECH_ON%Then why have you come? The townsfolk know you. They know you were out there looking for it. You should leave before they see you\'ve returned without their godly idol.%SPEECH_OFF% | You Retournez à %employer% emptyhanded. He takes you by the side and whispers.%SPEECH_ON%And why have you come at all? Do you not understand what import these townsfolk have put upon the idol? Without it to worship, they\'ll have nothing to believe in. Men of strong faith needs somewhere to put it. If he can\'t find it, all he finds is himself. And, like an ugly brute staring into a mirror, we needn\'t rush to see the anger and confusion in the reflection of the idol\'s absence. Leave, sellsword, before the people see you\'ve not returned with the %item%.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Oh well...",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to obtain " + this.Flags.get("ItemName"));
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"location",
			this.m.Flags.get("DestinationName")
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive() ? "" : this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Destination.getTile())]
		]);
		_vars.push([
			"item",
			this.m.Flags.get("ItemName")
		]);
		_vars.push([
			"risk",
			this.m.RiskItem != null ? this.m.RiskItem.getName() : ""
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull() && this.m.Destination.isAlive())
			{
				this.m.Destination.getSprite("selection").Visible = false;
				this.m.Destination.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
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

		if (this.m.RiskItem != null)
		{
			_out.writeBool(true);
			_out.writeI32(this.m.RiskItem.ClassNameHash);
			this.m.RiskItem.onSerialize(_out);
		}
		else
		{
			_out.writeBool(false);
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

		local hasItem = _in.readBool();

		if (hasItem)
		{
			this.m.RiskItem = this.new(this.IO.scriptFilenameByHash(_in.readI32()));
			this.m.RiskItem.onDeserialize(_in);
		}

		this.contract.onDeserialize(_in);
	}

});


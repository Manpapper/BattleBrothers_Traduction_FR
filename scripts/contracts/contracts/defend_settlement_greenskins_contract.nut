this.defend_settlement_greenskins_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Reward = 0,
		Kidnapper = null,
		Militia = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.defend_settlement_greenskins";
		this.m.Name = "Defend Settlement";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 5.0;
		this.m.MakeAllSpawnsResetOrdersOnContractEnd = false;
		this.m.MakeAllSpawnsAttackableByAIOnceDiscovered = true;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 900 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Defendez %townname% et ses alentours contre les groupes de pillards"
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
				local nearestOrcs = this.Contract.getNearestLocationTo(this.Contract.m.Home, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getSettlements());
				local nearestGoblins = this.Contract.getNearestLocationTo(this.Contract.m.Home, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getSettlements());

				if (nearestOrcs.getTile().getDistanceTo(this.Contract.m.Home.getTile()) + this.Math.rand(0, 6) <= nearestGoblins.getTile().getDistanceTo(this.Contract.m.Home.getTile()) + this.Math.rand(0, 6))
				{
					this.Flags.set("IsOrcs", true);
				}
				else
				{
					this.Flags.set("IsGoblins", true);
				}

				if (this.Math.rand(1, 100) <= 25 && this.Contract.getDifficultyMult() >= 0.95)
				{
					this.Flags.set("IsMilitia", true);
				}

				local number = 1;

				if (this.Contract.getDifficultyMult() >= 0.95)
				{
					number = number + this.Math.rand(0, 1);
				}

				if (this.Contract.getDifficultyMult() >= 1.1)
				{
					number = number + 1;
				}

				local locations = this.Contract.m.Home.getAttachedLocations();
				local targets = [];

				foreach( l in locations )
				{
					if (l.isActive() && !l.isMilitary() && l.isUsable())
					{
						targets.push(l);
					}
				}

				number = this.Math.min(number, targets.len());
				this.Flags.set("ActiveLocations", targets.len());

				for( local i = 0; i != number; i = ++i )
				{
					local party;

					if (this.Flags.get("IsGoblins"))
					{
						party = this.Contract.spawnEnemyPartyAtBase(this.Const.FactionType.Goblins, this.Math.rand(80, 110) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					}
					else
					{
						party = this.Contract.spawnEnemyPartyAtBase(this.Const.FactionType.Orcs, this.Math.rand(80, 110) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					}

					party.setAttackableByAI(false);
					local c = party.getController();
					c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
					c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
					local t = this.Math.rand(0, targets.len() - 1);

					if (i > 0)
					{
						local wait = this.new("scripts/ai/world/orders/wait_order");
						wait.setTime(4.0 * i);
						c.addOrder(wait);
					}

					local move = this.new("scripts/ai/world/orders/move_order");
					move.setDestination(targets[t].getTile());
					c.addOrder(move);
					local raid = this.new("scripts/ai/world/orders/raid_order");
					raid.setTime(40.0);
					raid.setTargetTile(targets[t].getTile());
					c.addOrder(raid);
					targets.remove(t);
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
				this.Contract.m.Home.getSprite("selection").Visible = true;
				this.World.FactionManager.getFaction(this.Contract.getFaction()).setActive(false);
			}

			function update()
			{
				if (this.Contract.m.UnitsSpawned.len() == 0 || this.Flags.get("IsEnemyHereDialogShown"))
				{
					local isEnemyGone = true;

					foreach( id in this.Contract.m.UnitsSpawned )
					{
						local p = this.World.getEntityByID(id);

						if (p != null && p.isAlive() && p.getDistanceTo(this.Contract.m.Home) <= 1200.0)
						{
							isEnemyGone = false;
							break;
						}
					}

					if (isEnemyGone)
					{
						if (this.Flags.get("HadCombat"))
						{
							this.Contract.setScreen("ItsOver");
							this.World.Contracts.showActiveContract();
						}

						this.Contract.setState("Return");
						return;
					}
				}

				if (!this.Flags.get("IsEnemyHereDialogShown"))
				{
					local isEnemyHere = false;

					foreach( id in this.Contract.m.UnitsSpawned )
					{
						local p = this.World.getEntityByID(id);

						if (p != null && p.isAlive() && p.getDistanceTo(this.Contract.m.Home) <= 700.0)
						{
							isEnemyHere = true;
							break;
						}
					}

					if (isEnemyHere)
					{
						this.Flags.set("IsEnemyHereDialogShown", true);

						foreach( id in this.Contract.m.UnitsSpawned )
						{
							local p = this.World.getEntityByID(id);

							if (p != null && p.isAlive())
							{
							}
						}

						if (this.Flags.get("IsGoblins"))
						{
							this.Contract.setScreen("GoblinsAttack");
						}
						else
						{
							this.Contract.setScreen("OrcsAttack");
						}

						this.World.Contracts.showActiveContract();
					}
				}
				else if (this.Flags.get("IsKidnapping") && !this.Flags.get("IsKidnappingInProgress") && this.Contract.m.UnitsSpawned.len() == 1)
				{
					local p = this.World.getEntityByID(this.Contract.m.UnitsSpawned[0]);

					if (p != null && p.isAlive() && !p.isHiddenToPlayer() && !p.getController().hasOrders())
					{
						local c = p.getController();
						c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(true);
						c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(true);
						this.Contract.m.Kidnapper = this.WeakTableRef(p);
						this.Flags.set("IsKidnappingInProgress", true);
						this.Flags.set("KidnappingTooLate", this.Time.getVirtualTimeF() + 60.0);
						this.Contract.setScreen("Kidnapping1");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("Kidnapping");
					}
				}

				if (this.Flags.get("IsMilitia") && !this.Flags.get("IsMilitiaDialogShown"))
				{
					this.Flags.set("IsMilitiaDialogShown", true);
					this.Contract.setScreen("Militia1");
					this.World.Contracts.showActiveContract();
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Flags.set("HadCombat", true);
			}

			function onCombatVictory( _combatID )
			{
				this.Flags.set("HadCombat", true);
			}

		});
		this.m.States.push({
			ID = "Kidnapping",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Sauvez les prisonniez qui sont enlevés",
					"Retournez à " + this.Contract.m.Home.getName()
				];
				this.Contract.m.Home.getSprite("selection").Visible = false;
				this.World.FactionManager.getFaction(this.Contract.getFaction()).setActive(false);

				if (this.Contract.m.Kidnapper != null && !this.Contract.m.Kidnapper.isNull())
				{
					this.Contract.m.Kidnapper.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.m.Kidnapper == null || this.Contract.m.Kidnapper.isNull() || !this.Contract.m.Kidnapper.isAlive())
				{
					if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() <= 5.0)
					{
						this.Flags.set("IsKidnapping", false);
						this.Contract.setScreen("Kidnapping2");
					}
					else
					{
						this.Contract.setScreen("Kidnapping3");
					}

					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
				else if (this.Contract.m.Kidnapper.isHiddenToPlayer() && this.Time.getVirtualTimeF() > this.Flags.get("KidnappingTooLate"))
				{
					this.Contract.setScreen("Kidnapping3");
					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Flags.set("HadCombat", true);
			}

			function onCombatVictory( _combatID )
			{
				this.Flags.set("HadCombat", true);
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
				this.World.FactionManager.getFaction(this.Contract.getFaction()).setActive(true);

				if (this.Contract.m.Kidnapper != null && !this.Contract.m.Kidnapper.isNull())
				{
					this.Contract.m.Kidnapper.getSprite("selection").Visible = false;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					local locations = this.Contract.m.Home.getAttachedLocations();
					local numLocations = 0;

					foreach( l in locations )
					{
						if (l.isActive() && !l.isMilitary() && l.isUsable())
						{
							numLocations = ++numLocations;
						}
					}

					if (numLocations == 0 || this.Flags.get("ActiveLocations") - numLocations >= 2)
					{
						if (this.Flags.get("IsKidnapping") && this.Flags.get("IsKidnappingInProgress"))
						{
							this.Contract.setScreen("Failure2");
						}
						else
						{
							this.Contract.setScreen("Failure1");
						}
					}
					else if (this.Flags.get("ActiveLocations") - numLocations >= 1)
					{
						if (this.Flags.get("IsKidnapping") && this.Flags.get("IsKidnappingInProgress"))
						{
							this.Contract.setScreen("Success4");
						}
						else
						{
							this.Contract.setScreen("Success2");
						}
					}
					else if (this.Flags.get("IsKidnapping") && this.Flags.get("IsKidnappingInProgress"))
					{
						this.Contract.setScreen("Success3");
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
			Title = "Négociations",
			Text = "[img]gfx/ui/events/event_20.png[/img]{When you see %employer% he\'s got sweat pouring down his face and dabbing it with a nicely embroidered cloth that seems to achieve nothing in stemming the tide.%SPEECH_ON%Mercenary, it is oh so good  to see you! Please, please come in and listen to what I have to say.%SPEECH_OFF%You cautiously walk into the room and take a seat, glancing momentarily to make sure nobody was hiding behind the crook of the door or behind one of the bookshelves lining the walls. %employer% pushes a map across his table.%SPEECH_ON%See those green markings? Those are greenskin movements, tracked by my scouts. Sometimes they tell me by word, sometimes they don\'t tell me at all. Those scouts just... poof, disappear. It doesn\'t take a genius to know what really happened to them though, does it?%SPEECH_OFF%You ask what the man wants. He slams the map, his fist landing square on %townname%.%SPEECH_ON%Can you not see? They\'re coming this way and I need you to help defend us!%SPEECH_OFF% | %employer%\'s nervously picking his nails when you find him. He\'s got them down to nubs by this point, just flecks of skin and blood shaving away at this point.%SPEECH_ON%Thank you for coming, sellsword. I\'ll be frank with you, the greenskins are coming.%SPEECH_OFF%Using a hand for height measurements, you ask what sort of greenskin, the ones yeigh big, or the ones about hmmm, big. %employer% shrugs.%SPEECH_ON%I\'ve no idea. My scouts keep disappearing and the villagers that keep arriving aren\'t exactly the most accurate of witnesses to depend upon. All you need to know is that we need your help, because those greenskins are coming this way.%SPEECH_OFF% | %employer%\'s drunk and nestled deep into his chair. He thumbs toward an opened book on his table.%SPEECH_ON%Have you heard of the Battle of Many Names? It went down about ten years ago when the orcs came streaming into man\'s land, and when man fielded his armies and said, No.%SPEECH_OFF%You nod, knowing the battle well, and the war it helped end. The man continues.%SPEECH_ON%Unfortunately, we have reason to believe that they\'re coming back. Greenskins, don\'t know what type, don\'t know how tall or what sort, but this way they do indeed come.%SPEECH_OFF%He throws back the rest of his drink, swallowing as though it were to be the last thing that\'d go down his throat before an executioner removed his head.%SPEECH_ON%Will you stay here and protect us? For the right price, of course. I haven\'t forgotten your station yet.%SPEECH_OFF% | %employer%\'s by his window when you enter.%SPEECH_ON%You hear that?%SPEECH_OFF%A throng of people are practically baying in the streets, a mix of apathetic moans and outright horrified crying.%SPEECH_ON%That\'s what you hear when the greenskins are coming.%SPEECH_OFF%The man shutters the windows and turns to you.%SPEECH_ON%I know it\'s a lot to ask, but we do have money so I\'ll go ahead and ask anyway. Will you help protect %townname%?%SPEECH_OFF% | %employer%\'s fighting off a crowd when you find him.%SPEECH_ON%Everyone calm down! Just calm down!%SPEECH_OFF%Someone throws an onion, battering the man upside the head with a tearjerking rap of sour vegetable. Someone else quickly scurries to pick it up and take a bite. %employer% points you out in the crowd.%SPEECH_ON%Sellsword! I am so glad you came!%SPEECH_OFF%He fights through the crowd. He leans in close to your ear, yet still has to shout to be heard.%SPEECH_ON%We have money! We have what you need! Just help protect this town from the greenskins!%SPEECH_OFF% | %employer%\'s employees are rummaging about his room, collecting scrolls and books alike before hurrying off to who knows where. The man himself is simply sitting in his chair, occasionally drinking from a goblet while perusing a map. He waves you in.%SPEECH_ON%Take a seat. Don\'t mind my workers.%SPEECH_OFF%You do as asked, but it\'s hard to ignore the frenzy around you. %employer% sits back, tenting his fingers atop his belly.%SPEECH_ON%I\'m sure you\'ve noticed things are rather unusual around here. That\'s because a large band of greenskins have been spotted and they\'re heading this way, murdering and destroying all that stands before them. Obviously, I\'d like you to help defend %townname% before we all end up in some scribe\'s footnote, understand?%SPEECH_OFF% | You enter %employer%\'s abode and can\'t help but notice there\'s mud all over the floor and a squelched fire in his pit. Some of his workers hurry about with scrolls stuffed in their arms. You can barely even see their heads over all the paper. You see %employer% standing in the midst of the chaos, simply directing his employees to do this or that. When you walk up to him he simply nods.%SPEECH_ON%Greenskins are coming. What kind? I don\'t know. What I do know is what will happen if I can\'t help defend this town which is why we\'re doing a little bit of prep work here, understand?%SPEECH_OFF%You nod in return, but then ask what else he wants.%SPEECH_ON%Help us fight these greenskins, of course. There\'s plenty of money in it for you, obviously.%SPEECH_OFF% | Peasants have come to %employer%\'s abode. They\'re carrying armfuls of belongings, a litter of it trailing behind their every step, so urgent to flee they don\'t even bother picking up any of it. %employer% himself sees you through one of his window\'s and waves you to come in through a side door. When you sneak in, he simply plops down in his chair and pours you a drink.%SPEECH_ON%Greenskins are coming and I don\'t believe there are enough men on hand to defend %townname%. Obviously, I\'m willing to call on and pay for your services to help keep %townname% safe from this green menace.%SPEECH_OFF% | A man is standing outside %employer%\'s abode, two painted slabs of wood dressed over himself. On each board is written some prophetic doomsayer\'s tale. You ignore the man and enter the house. %employer% is standing there, laughing and shaking his head.%SPEECH_ON%That guy standing out there ain\'t wrong. My scouts have been reporting greenskins moving through the area for a while. I should have listened for how my scouts haven\'t said anything for a good week, presumably because those very same greenskins got their hands on them. Now I got the commonfolk coming to me with horror stories of what is going on out there, and how a large horde of those awful creatures are coming this way.%SPEECH_OFF%He turns to you, grinning, madness spinning in his grin.%SPEECH_ON%So what say you and I broker a deal and shut up that doomsayer\'s shrill crying? Will you help protect %townname%?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Combien est prêt à payer %townname% pour leur sécurité? | Ça devrait valoir une bonne quantité de couronnes pour vous, non ? | Fighting greenskins won\'t come cheap.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{J\'ai bien peur que vous allez devoir vous débrouiller seul. | I\'m afraid this isn\'t worth it for the %companyname%. | Je vous souhaite bonne chance, mais nous ne participerons pas à cela.}",
					function getResult()
					{
						if (this.Math.rand(1, 100) <= 60)
						{
							this.World.Contracts.removeContract(this.Contract);
							return 0;
						}
						else
						{
							return "Plea";
						}
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Plea",
			Title = "Négociations",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Leaving %employer% with a rejection, you come across a man who laughs and shakes his head.%SPEECH_ON%Hey now, the greenskins ain\'t that way, unless, of course, that was in your plan you no good coward.%SPEECH_OFF%You draw out your sword, letting its steel scratch the scabbard good and long. The man laughs.%SPEECH_ON%Oh, and what are you going to do with that? Run me through? Alright. Go ahead. Do worse than the greenskins, I dare ya.%SPEECH_OFF%A woman rushes out, grabbing the man and dragging him back.%SPEECH_ON%Get the children, would ya? We need to leave, now!%SPEECH_OFF%The huddled pair shuffles off, but your head is still swimming with the peasant\'s accusation of cowardice. | The peasants are already packing the road to get the hell out of %townname%. A few glance at you and one even steps forward, an old man with a stick of a cane.%SPEECH_ON%See, this is what it\'s like in today\'s world! All the good men are dead, and only those left are the cowards like this so called swordsman here.%SPEECH_OFF%%randombrother% steps forward, heaving his weapon out and looking ready to kill.%SPEECH_ON%You dare insult %companyname%? I\'ll have your tongue and then your head, old man!%SPEECH_OFF%You grab the mercenary by the shoulder. The last thing these people need is violence, but the man spoke good and loud. Now you wonder who heard him and who will live to spread the weight behind his words. | A woman clutches onto you as you try and get back to the company.%SPEECH_ON%Mister, please! You mustn\'t leave us to this fate! You know not what the greenskins will do to us!%SPEECH_OFF%You actually have a very strong notion, but keep it to yourself. The woman drops to her knees and clutches both your ankles. You manage to step out of her grasp. For a brief moment she scrambles after you, slopping through the mud, then stops and begins sobbing.%SPEECH_ON%You don\'t know what it\'s like. It don\'t ever seem to get better for us. For me.%SPEECH_OFF%By the gods that is pathetic, but you find a tiny bit of sympathy welling up within you. | As you leave %employer% with the rejection, a man steps out from his dwelling. He\'s petting a chicken and there\'s tears in his eyes.%SPEECH_ON%Sir, if you\'d stay, you can have her.%SPEECH_OFF%The peasant kisses the chicken. It squawks mindlessly, not exactly mirroring the anguish in its owner\'s face.%SPEECH_ON%Just stay and help save this town. You can have her. Just stay, please.%SPEECH_OFF%Oh boy, is this really what it\'s going to come down to? | A disheveled and very old man steps toward you.%SPEECH_ON%So, you decided not to help? I suppose I can\'t fault that.%SPEECH_OFF%He fans an arm out to a few peasants standing nearby. They have crates of goods with them, stuffed belongings that range from moldy vegetables to a chicken or two, or maybe those two chickens are one just tiny and squawky lamb.%SPEECH_ON%Those people would like to you to stay and help. But I understand why you wouldn\'t. I was there at the Battle of Many Names. I know what it\'s like to fight those beasts. I won\'t fault you. It takes a man of great measure to take them on. So it is, so it is, yessir, and I won\'t fault ya, not one bit.%SPEECH_OFF%He slowly hobbles away and it is then that you notice that one of his legs is replaced by a wooden peg. A few children run to him and he speaks with the group of peasants. He looks back at you, then back to them, and shakes his head. You can almost feel the sadness and disappointment wash over you.}",
			Image = "",
			List = [],
			ShowEmployer = false,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Damn, we can\'t leave these people to die. | Fine, fine, we won\'t leave %townname%. Let\'s talk payment, at least.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{I\'m sure you\'ll pull through. Make way. | I won\'t risk the %companyname% to save some starved peasants.}",
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
			ID = "OrcsAttack",
			Title = "Near %townname%",
			Text = "[img]gfx/ui/events/event_49.png[/img]The greenskins are in sight! Prepare for battle and protect the town!",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To arms!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "GoblinsAttack",
			Title = "Near %townname%",
			Text = "[img]gfx/ui/events/event_48.png[/img]The greenskins are in sight! Prepare for battle and protect the town!",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To arms!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ItsOver",
			Title = "Near %townname%",
			Text = "[img]gfx/ui/events/event_22.png[/img]{The fighting\'s over. %employer% will no doubt be pleased to see you again. | The fighting is over and the men idle in a welcome respite. %employer% will be waiting for you back in town. | With the battle over, you survey the corpses littered across the field. It is a gruesome sight, yet for some reason it spurs you with energy. The ghastly hills of dead only remind you of the vitality you\'ve yet to yield to this horrid world. People like %employer% should come and see it, but he won\'t, so you\'ll have to go and see him instead. | Flesh and bone scattered across the field, hardly discernible from one owner to the next. Black buzzards cycle overhead, halos of chevron shadows rippling over the dead, the birds waiting for the mourners to clear out. %randombrother% comes to your side and asks if they should start the return trip to %employer%. You leave the sight of the battlefield behind and nod. | A peaceful sort of ruin is made of the dead. Like it was their natural state, stiffened and at a permanent loss, and their whole living was but a fleeting fit of an accident finally come to an end. %randombrother% comes up and asks if you\'re alright. You\'re not sure, to be honest, and simply answer that it is time to go see %employer%. | Misshapen men and crooked corpses litter the ground for battle gives the dead no sovereignty over how one comes to a final rest. The bodiless heads look at most peace, for in battle no man or beast has time to truly hack a neck away, it only comes by the quickest and sharpest of blade swings. A part of you hopes to go with such instant finality, but another part hopes you get the chance to take your killer down with you.\n\n %randombrother% comes to your side and asks for orders. You turn away from the field and tell the %companyname% to get ready to Retournez à %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We head back to the townhall!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ItsOverDidNothing",
			Title = "Near %townname%",
			Text = "[img]gfx/ui/events/event_30.png[/img]Smoke fills the air, smoke and the caustic smell of burning wood, burning livelihoods. %townname%\'s folk put all their hopes into hiring the %companyname%, a fatal mistake.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "That didn\'t go as planned...",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Militia1",
			Title = "À %townname%",
			Text = "[img]gfx/ui/events/event_80.png[/img]{While preparing to defend %townname%, the local militia has come to your side. They submit to your orders, only asking that you send them where you think they are most needed. | It appears the local militia have joined the battle! A ragtag group of men, but they\'ll be useful nonetheless. Now the question is, where to send them? | %townname%\'s militia has joined the fight! Although a shoddy band of poorly armed men, they are eager to defend home and hovel. They submit to your command, trusting that you will send them to where they are most needed. | You\'re not alone in this fight! %townname%\'s militia have joined you. They\'re eager to fight and ask you where they are needed most.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Fall in line, you\'ll be under my command.",
					function getResult()
					{
						return "Militia2";
					}

				},
				{
					Text = "Go and defend the townhall of %townname%.",
					function getResult()
					{
						local home = this.Contract.m.Home;
						local party = this.World.FactionManager.getFaction(this.Contract.getFaction()).spawnEntity(home.getTile(), home.getName() + " Militia", false, this.Const.World.Spawn.Militia, home.getResources() * 0.7);
						party.getSprite("banner").setBrush(home.getBanner());
						party.setDescription("Brave men defending their homes with their lives. Farmers, craftsmen, artisans - but not one real soldier.");
						party.setFootprintType(this.Const.World.FootprintsType.Militia);
						this.Contract.m.Militia = this.WeakTableRef(party);
						local c = party.getController();
						local guard = this.new("scripts/ai/world/orders/guard_order");
						guard.setTarget(home.getTile());
						guard.setTime(300.0);
						local despawn = this.new("scripts/ai/world/orders/despawn_order");
						c.addOrder(guard);
						c.addOrder(despawn);
						return 0;
					}

				},
				{
					Text = "Go and defend the outskirts of %townname%.",
					function getResult()
					{
						local home = this.Contract.m.Home;
						local party = this.World.FactionManager.getFaction(this.Contract.getFaction()).spawnEntity(home.getTile(), home.getName() + " Militia", false, this.Const.World.Spawn.Militia, home.getResources() * 0.7);
						party.getSprite("banner").setBrush(home.getBanner());
						party.setDescription("Brave men defending their homes with their lives. Farmers, craftsmen, artisans - but not one real soldier.");
						party.setFootprintType(this.Const.World.FootprintsType.Militia);
						this.Contract.m.Militia = this.WeakTableRef(party);
						local c = party.getController();
						local locations = home.getAttachedLocations();
						local targets = [];

						foreach( l in locations )
						{
							if (l.isActive() && !l.isMilitary() && l.isUsable())
							{
								targets.push(l);
							}
						}

						local guard = this.new("scripts/ai/world/orders/guard_order");
						guard.setTarget(targets[this.Math.rand(0, targets.len() - 1)].getTile());
						guard.setTime(300.0);
						local despawn = this.new("scripts/ai/world/orders/despawn_order");
						c.addOrder(guard);
						c.addOrder(despawn);
						return 0;
					}

				},
				{
					Text = "Go hide somewhere and stay out of our way.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Militia2",
			Title = "À %townname%",
			Text = "[img]gfx/ui/events/event_80.png[/img]Now that you\'ve decided to take some of the locals under your command, they ask how they should arm themselves for the battle to come.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Take bows, you\'ll be shooting from the back.",
					function getResult()
					{
						for( local i = 0; i != 4; i = ++i )
						{
							local militia = this.World.getGuestRoster().create("scripts/entity/tactical/humans/militia_guest_ranged");
							militia.setFaction(1);
							militia.setPlaceInFormation(19 + i);
							militia.assignRandomEquipment();
						}

						return 0;
					}

				},
				{
					Text = "Take sword and shield, you\'ll be fighting in the front.",
					function getResult()
					{
						for( local i = 0; i != 4; i = ++i )
						{
							local militia = this.World.getGuestRoster().create("scripts/entity/tactical/humans/militia_guest");
							militia.setFaction(1);
							militia.setPlaceInFormation(19 + i);
							militia.assignRandomEquipment();
						}

						return 0;
					}

				},
				{
					Text = "Arm yourselves however you want.",
					function getResult()
					{
						for( local i = 0; i != 4; i = ++i )
						{
							local militia;

							if (this.Math.rand(0, 1) == 0)
							{
								militia = this.World.getGuestRoster().create("scripts/entity/tactical/humans/militia_guest");
							}
							else
							{
								militia = this.World.getGuestRoster().create("scripts/entity/tactical/humans/militia_guest_ranged");
							}

							militia.setFaction(1);
							militia.setPlaceInFormation(19 + i);
							militia.assignRandomEquipment();
						}

						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "MilitiaVolunteer",
			Title = "Near %townname%",
			Text = "[img]gfx/ui/events/event_80.png[/img]{The fighting over, one of the militiamen that helped in the defense comes to you personally, bending low and offering his sword.%SPEECH_ON%Sir, my time with the town of %townname% is at an end. But the prowess of the %companyname% is truly an amazing sight. If you would permit it, sir, I would love to fight alongside you and your men.%SPEECH_OFF% | With the battle over, one of the militiamen from %townname% states that he will gladly come and fight for the %companyname%. Partly because he was most impressed with the mercenary band\'s fighting, and partly because being conscripted into the town\'s defense is neither financially or physically healthy.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Welcome to the %companyname%!",
					function getResult()
					{
						return 0;
					}

				},
				{
					Text = "This is no place for you.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Kidnapping1",
			Title = "Near %townname%",
			Text = "[img]gfx/ui/events/event_30.png[/img]{While keeping watch for the greenskins, a peasant comes up telling you that a group of the beasts attacked nearby and they seem to have made off with a good lot of hostages. You shake your head in disbelief. How were the brutes able to sneak in and do this? The layman shakes his head, too.%SPEECH_ON%I thought y\'all were supposed to help us. Why didn\'t you do anything?%SPEECH_OFF%You ask if the greenskins have gotten far. The peasant shrugs, but he thinks they\'re still close enough to catch. Looks like you still have a shot to get those poor people back before the gods know what happens to them. | A man wearing rags and carrying a broken pitchfork sprints up to your company. He drops and wails at your feet.%SPEECH_ON%The greenskinns attacked! Ohh, they were just like my grandfather said they was! And where were you? They killed people... burned some... and... I think they ate a few... oh by the gods. But that\'s not the worst of it! The greenskins took some poor folks prisoner! Please, go and save them!%SPEECH_OFF%You eye %randombrother% and nod.%SPEECH_ON%Get the men ready. We need to chase these foul beasts down before they escape entirely.%SPEECH_OFF% | You have your eyes peeled to the horizons, looking for any sight or sound of the foul greenskins. Suddenly, %randombrother% comes to you with a woman by his side. He pushes her forward and nods. Clutching her chest, she sobs and tells a story about how the greenskins already attacked, tearing through a nearby hamlet. She explains that they didn\'t just kill people, though, but instead grabbed a few as prisoners. The mercenary nods.%SPEECH_ON%Looks like they snuck past us, sir.%SPEECH_OFF%You\'ve only one choice now - go and get those people back! | Stationing yourself close to %townname%, you await the greenskins\' assault. You thought this would be easy, but the sudden arrival of a crazed layman says otherwise. The peasant explains that the foul marauders have already ambushed a small village in the hinterland. They slaughtered everyone they could, then, with their bloodlust satiated, made off with a few men, women, and children. The peasant, either drunk or in shock, slurs his pleas.%SPEECH_ON%Get... get them back, would ya?%SPEECH_OFF% | A few angry peasants take the roads, storming toward you in a swirl of mobly anger.%SPEECH_ON%I thought we were paying you to protect us! Where were you?%SPEECH_ON%They are covered in blood. Some are half-clothed. One man cradles an arm against his chest. The limb is missing a hand. You ask the group what it is they are talking about. A woman steps forward with children huddled around her feet. She covers their ears.%SPEECH_ON%What is it we\'re talking about? You damned sellswords! The greenskins came, who else? You were s\'posed to protect us, but must\'ve been too busy wanking one another off and shatting the bed to realize they\'d already slipped through! We escaped, but those who couldn\'t got taken prisoner! Do you know what happens to those taken by the greenskins? Because, well, I mean I don\'t, but I suspect it ain\'t songs and pie!\n\n You tell the woman to shut it before her mouth starts plucking chickens her body can\'t eat.%SPEECH_ON%We\'ll get them back.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Let\'s get them!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Kidnapping2",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Sheathing your sword, you order %randombrother% to go free the prisoners. A litany of bewildered peasants are freed from leather leashes, chains, and dog cages. They thank you for your timely arrival. One scratches the wounds on his wrists where the chains used to be.%SPEECH_ON%Appreciate it, sellsord.%SPEECH_OFF%He nods to a spit where a shriveled black corpse is hanging over a spent fire.%SPEECH_ON%Shame you didn\'t arrive in time to rescue her. She was a real looker. Now, well, look at \'er.%SPEECH_OFF%The man smiles wryly before bursting into tears. | The damned greenskins are slaughtered. You set your men out to go rescue every peasant they can find. Each one comes together, hugging and crying, mad with happiness that they have survived this horrifying ordeal. | After killing the last greenskin, you tell the company to go around freeing the hostages. Each one comes to you in turn, some kissing your hand, others your feet. You only tell them to get back to the townhall of %townname%, as you will be heading there, too. | Having slain the last greenskin, you order the men to free the hostages. They clamber out, completely in shock as they stumble about the ruins of the battle. A few dig through the greenskins\' encampment. You watch as a {man | woman} picks up a pile of smoking, charred bones. They simply stare at the remains, put them down, then get up and walk further into the wilds.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Looks like this is over.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Kidnapping3",
			Title = "Near %townname%",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Unfortunately, the greenskins got away with the hostages. May the gods be with those sorry souls. | You couldn\'t do it - you couldn\'t save those poor peasants. Now only the gods know what will happen to them. Actually, you do too, but you\'ll play dumb just so you can sleep at night. | Sadly, the foul beasts got away with their human cargo in tow. Those poor folks will have to fend for themselves now. The stories you hear, however, tell you they will not fare well at all. | The greenskins got away, their prisoners alongside with them. You\'ve no idea what will happen to those people now, but you know it isn\'t good. Slavery. Torture. Death. You\'re not sure which is the worst. | The greenskins and their unfortunate hostages got away. You wish those people the best, but as the wind curls around, blowing an empty and stiff song, you know damn well that no wish or prayer is going to save those sorry souls. | Well, the greenskins got away. The trail of gnawed human bones and piles of peeled flesh speak volumes about your failure. | You pick up a scrap of clothing to find it had been resting atop a pile of bones.%SPEECH_ON%Well, shit.%SPEECH_OFF%There\'s a trail of \'food\' scraps leading away from the site. The greenskins got away and the poor prisoners have disappeared along with them. | %randombrother% calls you over. When you stand next to him he points at a pile of shite on the ground. You shrug.%SPEECH_ON%Yeah. It smells. What else?%SPEECH_OFF%He kicks a piece of white, lifting what appears to be a bone from the goop.%SPEECH_ON%That\'s a human bone. Them prisoners been ate, sir.%SPEECH_OFF%You look about the grass and see even more remains. Footprints lead away from the site, the greenskins clearly having escaped your chase. You sigh and tell the men to get ready to leave.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{They won\'t like that in %townname%... | I hope it will be a quick death for them.}",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% welcomes your return with a chest of %reward% crowns.%SPEECH_ON%You\'ve earned this one, sellsword, I\'ll say that much. Not a single part of this town, well nothing important anyway, was touched.%SPEECH_OFF%He pauses as you stare at the chest. It was hard fought and hard earned. You just expected more of it. Sometimes the simplicity of being a mercenary really bugs you. | You find %employer% feeding some of his dogs. He pets one over and over as it chows down.%SPEECH_ON%I really thought I\'d have to give this up.%SPEECH_OFF%He gives the mutt one final pat before turning his eyes to you.%SPEECH_ON%Thank you, sellsword. You did more than just protect this town, you protected a way of life. Without you, we either would have all died or, worse, lived to see the horridness that tomorrow surely would have brought.%SPEECH_OFF%You nod and step forward to give one of the dogs a pat, but it leers up at you and growls. %employer% laughs.%SPEECH_ON%Please forgive his ignorance.%SPEECH_OFF% | %employer%\'s got a gang of men and women surrounding him. When you enter the room they turn to you in almost creepy unison. They stare for a moment before breaking into celebrations and rushing to you, hugs and tears and all. Fighting them off, you find %employer% standing there with a satchel in hand.%SPEECH_ON%This is for saving %townname%, sellsword. If I\'m being honest, it ain\'t as heavy as it should be, but it\'s all we got.%SPEECH_OFF% | %employer%\'s looking out his window when you Retournez à him. Outside, militiamen are running about and the towns people are hugging one another.%SPEECH_ON%Not a greenskin entered the town commons.%SPEECH_OFF%He smiles as he hands over a satchel of goods.%SPEECH_ON%You went above and beyond this day, sellsword.%SPEECH_OFF% | Finding %employer% wasn\'t easy: the entire town is in an uproar of celebrations. They\'re plucking chickens so fast the birds sometimes manage to escape, running half-cocked and half-feathered down the roads while children give chase. %employer% manages to sneak up on you in the midst of the festivities.%SPEECH_ON%There is plenty of mourning to do, but we shall save that for tomorrow. For today, we celebrate life, and your deeds, sellsword.%SPEECH_OFF%The man hands over a satchel of goods and it weighs down in your grip. | You find %employer% rearranging a bookshelf. He seems to be restocking his wares, carefully counting and numbering his goods like a shopkeep. He jumps when the door slams shut behind you.%SPEECH_ON%Ah, sellsword! You spooked me there.%SPEECH_OFF%He grabs a chest off one of the book shelves and hands it over to you.%SPEECH_ON%I\'d plan to take all these books, all these scrolls, and run for it. Now, though, I shan\'t need to and that\'s all thanks to you.%SPEECH_OFF%His smiles sour for just a moment.%SPEECH_ON%Not everyone was so lucky as to see this day, and your victory. Tonight I must see to it that the fallen get a proper burial.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{The %companyname% will make good use of this. | Payment for a hard day\'s work.}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Defended the town against greenskins");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isGreenskinInvasion())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCommonContract);
						}

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
			Text = "[img]gfx/ui/events/event_30.png[/img]{%employer%\'s head is in his hands. You point out his window.%SPEECH_ON%Town\'s saved, why you having a tear, huh?%SPEECH_OFF%He lifts his eyes to you.%SPEECH_ON%Yeah, most of the people made it, I suppose that\'s true. But that doesn\'t mean the greenskins didn\'t tear a hole through a good lot of this damn town.%SPEECH_OFF%He pushes a chest of goods across his table before thumbing his brow.%SPEECH_ON%Apologies for being so somber, but I\'m sure you understand how it is, sellsword. At least, I hope you do.%SPEECH_OFF%You do, but you pretend you don\'t give a good god damn. | You find %employer% behind his abode. He\'s got a shovel in hand and he\'s sending off a few peasants. There\'s fresh mounds of dirt here and there.%SPEECH_ON%You\'re a sight for sore eyes, sellsword.%SPEECH_OFF%He borrows his weight onto the shaft of the shovel.%SPEECH_ON%Just, uh, burying those who didn\'t make it. You did a damned good job, and I don\'t want you to think otherwise, but many people didn\'t make it. I\'m not blaming you at all, the greenskins are a fierce opponent and against them it wouldn\'t be wise of me to expect perfection.%SPEECH_OFF%You nod and the man nods in return. He picks up a satchel that\'d been laying amongst a pile of muddied shovels. It leaves a trail of mud as it flies through the air. You catch it and nod again before leaving the man to his task. You can hear the schkk, schkk of his shovel driving into the earth as you walk away. | %employer%\'s studying a map when you return. He puts a finger on one spot, then practically uses his words to navigate the finger along.%SPEECH_ON%This place didn\'t make it. This home got burned. These people are dead. We found these folks in the woods. I think they were trying to hide, but they just had a newborn. I suspect that\'s what gave them away.%SPEECH_OFF%He leans forward, knuckling his hands on the table.%SPEECH_ON%You did well, mercenary, but not everyone could be saved. It is what it is, as they say, and I shan\'t hold it against you. Not while I and many others still breathe.%SPEECH_OFF%He throws a satchel of crowns at you. You take it and nod back. It is what it is, and what it is, is a good payday. | You find %employer% slowly crawling a long scroll through his plying fingers. He\'s nodding and humming to himself.%SPEECH_ON%Do you know what it\'s like to read the names of dead neighbors?%SPEECH_OFF%You do, but don\'t bother interrupting.%SPEECH_ON%It\'s a strange feeling. I know them, but now, I can\'t see their faces. I just recognize their names, like words, no more extraordinary than any other. They\'re just a bunch of vocabulary now. Descriptions of a memory, I suppose.%SPEECH_OFF%He looks up at you, then throws the scroll aside to fetch you a satchel of crowns.%SPEECH_ON%Hell, I don\'t mean to bother you like that, mercenary. Here\'s your reward as promised.%SPEECH_OFF% | %employer%\'s directing a man with a paint brush. Their canvas is a mix of thick paper and what appears to be glass. Curious, you ask what\'s going on.%SPEECH_ON%I\'m enshrining the battle. Memorializing it.%SPEECH_OFF%He points at a segment where a building is burning.%SPEECH_ON%See that? When you went off to fight the greenskins, they burned that place down. And that one, too. We\'ll remember it all lest we forget.%SPEECH_OFF%The man gives you a satchel of crowns before quickly returning to the artistry. Staring at the picture, you don\'t see your company anywhere in it.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{That\'s just half of what we agreed to! | It is what it is...}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() / 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractPoor, "Defended the town against greenskins");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() / 2;
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] Couronnes"
				});
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success3",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% welcomes your return with a chest of %reward% crowns.%SPEECH_ON%You\'ve earned this one, sellsword, I\'ll say that much. Unfortunately, the greenskins managed to abduct a few of our own. I\'m withholding some of your pay to help compensate those who trusted their lives with you.%SPEECH_OFF%He pauses as you stare at the chest. You nod, both understanding of the peasants\' plight, but realizing that any arguments here would not suit your future prospects. | You find %employer% feeding some of his dogs. He pets one over and over as it chows down on dinner scraps.%SPEECH_ON%I really thought I\'d have to give all this up.%SPEECH_OFF%He gives the mutt one final pat before turning his eyes to you.%SPEECH_ON%But not all of us made it. Your pay is in the corner, but it will be less than agreed upon. I must see to the comforts of those who were abducted, I\'m sure you understand why I\'m taking that pay from you.%SPEECH_OFF% | %employer%\'s got a gang of men and women surrounding him. When you enter the room they turn to you in creepy unison. %employer% is handing them crowns. He speaks to you as he does this.%SPEECH_ON%Your pay is outside with one of my guards. It will be light, for I have taken some to help comfort those who were lost in the battle.%SPEECH_OFF%You glance at the poor souls lingering about the room. They must be related to those the greenskins kidnapped. | %employer%\'s looking out his window when you Retournez à him. Outside, militiamen are running about and the towns people are hugging one another.%SPEECH_ON%The town proper has been spared, but I must regret to tell you that there will be fewer people treading its roads in the coming days.%SPEECH_OFF%He smiles as he hands over a satchel of crowns that feels a little bit lighter than it should.%SPEECH_ON%You went above and beyond this day, sellsword, but not all could be saved. Those who were taken by the greenskins left behind family, and those families I will seek to comfort in these dire times.%SPEECH_OFF% | Finding %employer% wasn\'t easy: the entire town is in an uproar of celebrations. They\'re plucking chickens so fast the birds sometimes manage to escape, running half-cocked and half-feathered down the roads while children giddily give chase. %employer% manages to sneak up on you in the midst of the festivities. The man hands over a satchel of goods and it weighs down in your grip.%SPEECH_ON%Not everyone can be so jovial, sellsword. Those kidnapped souls whom you cannot save? They left behind families, and to those families goes some of your pay. I\'m sure you understand.%SPEECH_OFF% | You find %employer% rearranging a bookshelf. He seems to be restocking his wares, carefully counting and numbering his goods like a shopkeep. He jumps when the door slams shut behind you.%SPEECH_ON%Ah, sellsword! You spooked me there.%SPEECH_OFF%He grabs a chest off one of the bookshelves and hands it over to you.%SPEECH_ON%I had planned to take all these books, all these scrolls, and run for it. Now, though, I shan\'t need to and that\'s all thanks to you.%SPEECH_OFF%His smile sours.%SPEECH_ON%Not everyone was so lucky to see this day. Locals have told me what happened, that the greenskins kidnapped some of our own and you could not save them. Failing them is understandable, but I\'m sure you personally understand, then, that I took some of your pay to help those surviving families along.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{That\'s just half of what we agreed to! | It is what it is...}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() / 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractPoor, "Defended the town against greenskins");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() / 2;
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] Couronnes"
				});
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success4",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_30.png[/img]{%employer% welcomes your return with a lighter than expected satchel. He explains.%SPEECH_ON%The outskirts were nearly destroyed and a great number of people kidnapped. I\'m sorry, sellsword, but I needed the money to help this town recover. You can threaten me if you want, but it is what it is.%SPEECH_OFF%You decide to accept the losses and move on. | You find %employer% surveying the town. A few fires burn along the outskirts, piping black smoke into the skies. Weary peasants trudge along the roads. They carry what things they can, some carrying one another for their wounds are horrid. %employer% nods at the scene.%SPEECH_ON%A great deal of destruction, sellsword. You and I both know that I was paying you to save the town in whole, and to keep its people safe. Neither truly happened, but at the very least we\'re still talking, so you\'ll still be getting a piece of the reward, as promised.%SPEECH_OFF%He hands over a satchel of crowns. It is, indeed, lighter than what was agreed upon, but for the sake of future prospects you don\'t argue over it. | %employer%\'s found looking out his window. He\'s got a scroll and pen in each hand, making notes here and then. He speaks without looking at you.%SPEECH_ON%Well, we\'re alive and well, that\'s good. What\'s not good are those fires ravaging the outskirts of town, are the horrid news that the greenskins kidnapped some of our own.%SPEECH_OFF%Finally, he pauses writing just long enough to turn and stare at you.%SPEECH_ON%Your pay is out in the hall. It\'s less than what you were expecting. If you want to argue about it, I\'m all, and will only be, ears.%SPEECH_OFF%You realize it would be pointless arguing over the pay and simply take what you\'ve earned.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{That\'s just half of what we agreed to! | It is what it is...}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() / 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(0);
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() / 2;
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] Couronnes"
				});
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_30.png[/img]{When you enter %employer%\'s room, he tells you to close the door behind you. Just as the latch clicks, the man slams you with a stream of obscenities which you couldn\'t hope to keep track of. Calming down, his voice - and language - Retournez à some level of normalcy.%SPEECH_ON%Every bit of our outskirts were destroyed. What is it, exactly, did you think I was paying you for? Get out of here.%SPEECH_OFF% | %employer%\'s slamming back goblets of wine when you enter. There\'s the din of angry peasants squalling outside his window.%SPEECH_ON%Hear that? They\'ll have my head if I pay you, sellsword. You had one job, one job! Protect this town. And you couldn\'t do it. So now you could do one thing right and it comes free: get the hell out of my sight.%SPEECH_OFF% | %employer% clasps his hands over his desk.%SPEECH_ON%What is it, exactly, are you expecting to get here? I\'m surprised you returned to me at all. Half the town is on fire and the other half is already ash. I didn\'t hire you to produce smoke and desolation, sellsword. Get the hell out of here.%SPEECH_OFF% | When you Retournez à %employer%, he\'s holding a mug of ale. His hand his shaking. His face is red.%SPEECH_ON%It\'s taking everything in me to not throw this in your face right now.%SPEECH_OFF%Just in case, the man finishes the drink in one big gulp. He slams it on his desk.%SPEECH_ON%This town expected you protect them. Instead, the greenskins swarmed the outskirts like they were taking a goddam leisure trip! I\'m not in the business of giving greenskins a good ol\' time in destroying my town, sellsword. Get the farkin\' hell out of here!%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{Damn this peasantfolk! | We should have asked for more payment in advance... | Damnit!}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to defend the town against greenskins");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Failure2",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_30.png[/img]{%employer% is nowhere to be found. One of his guards comes up to you.%SPEECH_ON%If you\'re looking for my boss, you best give up. Half this town is destroyed and he\'s out there trying to fix it.%SPEECH_OFF%You inquire about your pay. The man bursts into sad, rough laughter.%SPEECH_ON%Pay? Sorry, you sword-selling bum. He wasn\'t paying you to fail. And that money is going right back into the town, anyway.%SPEECH_OFF% | You search the burning wastes of %townname% in search of %employer%. He\'s found pulling black bodies out of a smoldering ruin that was once a house. Dropping a charred corpse at his feet, he just about stares a hole through you.%SPEECH_ON%What is it you want, sellsword? I hope it isn\'t pay because this shit right here is not what I was paying you to do.%SPEECH_OFF% | %employer%\'s found staring out his window. The entire horizon is aflame, as though there were two suns to set on this world. He shakes his head when he sees you.%SPEECH_ON%The hell you doing here? Did we agree to pay you for letting the town go to ash? I don\'t think so, sellsword. Get out of here.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{Damn this peasantfolk! | We should have asked for more payment in advance... | Damnit!}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to defend the town against greenskins");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"reward",
			this.m.Reward
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/greenskins_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.World.FactionManager.getFaction(this.getFaction()).setActive(true);
			this.m.Home.getSprite("selection").Visible = false;

			if (this.m.Kidnapper != null && !this.m.Kidnapper.isNull())
			{
				this.m.Kidnapper.getSprite("selection").Visible = false;
			}

			if (this.m.Militia != null && !this.m.Militia.isNull())
			{
				this.m.Militia.getController().clearOrders();
			}

			this.World.getGuestRoster().clear();
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
		local nearestOrcs = this.getNearestLocationTo(this.m.Home, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getSettlements());
		local nearestGoblins = this.getNearestLocationTo(this.m.Home, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getSettlements());

		if (nearestOrcs.getTile().getDistanceTo(this.m.Home.getTile()) > 20 && nearestGoblins.getTile().getDistanceTo(this.m.Home.getTile()) > 20)
		{
			return false;
		}

		local locations = this.m.Home.getAttachedLocations();

		foreach( l in locations )
		{
			if (l.isUsable() && l.isActive() && !l.isMilitary())
			{
				return true;
			}
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.m.Flags.set("KidnapperID", this.m.Kidnapper != null && !this.m.Kidnapper.isNull() ? this.m.Kidnapper.getID() : 0);
		this.m.Flags.set("MilitiaID", this.m.Militia != null && !this.m.Militia.isNull() ? this.m.Militia.getID() : 0);
		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.contract.onDeserialize(_in);
		this.m.Kidnapper = this.WeakTableRef(this.World.getEntityByID(this.m.Flags.get("KidnapperID")));
		this.m.Militia = this.WeakTableRef(this.World.getEntityByID(this.m.Flags.get("MilitiaID")));
	}

});


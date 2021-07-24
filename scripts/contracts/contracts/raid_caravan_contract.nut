this.raid_caravan_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		LastCombatTime = 0.0
	},
	function setEnemyNobleHouse( _h )
	{
		this.m.Flags.set("EnemyNobleHouse", _h.getID());
	}

	function create()
	{
		this.contract.create();
		this.m.Type = "contract.raid_caravan";
		this.m.Name = "Raid Caravan";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 800 * this.getPaymentMult() * this.getDifficultyMult() * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		local myTile = this.World.State.getPlayer().getTile();
		local enemyFaction = this.World.FactionManager.getFaction(this.m.Flags.get("EnemyNobleHouse"));
		local settlements = enemyFaction.getSettlements();
		local lowest_distance = 99999;
		local highest_distance = 0;
		local best_start;
		local best_dest;

		foreach( s in settlements )
		{
			if (s.isIsolated())
			{
				continue;
			}

			local d = s.getTile().getDistanceTo(myTile);

			if (d < lowest_distance)
			{
				lowest_distance = d;
				best_dest = s;
			}

			if (d > highest_distance)
			{
				highest_distance = d;
				best_start = s;
			}
		}

		this.m.Flags.set("InterceptStart", best_start.getID());
		this.m.Flags.set("InterceptDest", best_dest.getID());
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Attaquez la caravane partant de %start% vers %dest%",
					"Retournez à %townname%"
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
				this.Flags.set("Survivors", 0);

				if (r <= 10)
				{
					this.Flags.set("IsBribe", true);
					this.Flags.set("Bribe1", this.Contract.beautifyNumber(this.Contract.m.Payment.Pool * (this.Math.rand(70, 150) * 0.01)));
					this.Flags.set("Bribe2", this.Contract.beautifyNumber(this.Contract.m.Payment.Pool * (this.Math.rand(70, 150) * 0.01)));
				}
				else if (r <= 15)
				{
					if (this.Contract.getDifficultyMult() >= 1.0)
					{
						this.Flags.set("IsSwordmaster", true);
					}
				}
				else if (r <= 20)
				{
					if (this.Contract.getDifficultyMult() >= 1.0)
					{
						this.Flags.set("IsUndeadSurprise", true);
					}
				}
				else if (r <= 25)
				{
					this.Flags.set("IsWomenAndChildren", true);
				}
				else if (r <= 35)
				{
					this.Flags.set("IsCompromisingPapers", true);
				}

				local enemyFaction = this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse"));
				local best_start = this.World.getEntityByID(this.Flags.get("InterceptStart"));
				local best_dest = this.World.getEntityByID(this.Flags.get("InterceptDest"));
				local party = enemyFaction.spawnEntity(best_start.getTile(), "Caravan", false, this.Const.World.Spawn.NobleCaravan, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.getSprite("base").Visible = false;
				party.getSprite("banner").setBrush(enemyFaction.getBannerSmall());
				party.setMirrored(true);
				party.setVisibleInFogOfWar(true);
				party.setImportant(true);
				party.setDiscovered(true);
				party.setDescription("A caravan with armed escorts transporting something worth protecting between settlements.");
				party.setFootprintType(this.Const.World.FootprintsType.Caravan);
				party.setAttackableByAI(false);
				party.getFlags().add("ContractCaravan");
				this.Contract.m.Target = this.WeakTableRef(party);
				this.Contract.m.UnitsSpawned.push(party);
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

				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local move = this.new("scripts/ai/world/orders/move_order");
				move.setDestination(best_dest.getTile());
				move.setRoadsOnly(true);
				local despawn = this.new("scripts/ai/world/orders/despawn_order");
				c.addOrder(move);
				c.addOrder(despawn);
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onTargetAttacked.bindenv(this));
					this.Contract.m.Target.setVisibleInFogOfWar(true);
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull())
				{
					if (this.Flags.get("IsWomenAndChildren"))
					{
						this.Contract.setScreen("WomenAndChildren1");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsCompromisingPapers"))
					{
						this.Contract.setScreen("CompromisingPapers1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setState("Return");
					}
				}
				else if (this.Contract.isEntityAt(this.Contract.m.Target, this.World.getEntityByID(this.Flags.get("InterceptDest"))))
				{
					this.Contract.setScreen("Failure3");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerAt(this.Contract.m.Target))
				{
					this.onTargetAttacked(this.Contract.m.Target, false);
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (!this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);

					if (this.Flags.get("IsBribe"))
					{
						this.Contract.setScreen("Bribe1");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsSwordmaster"))
					{
						this.Contract.setScreen("Swordmaster");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsUndeadSurprise"))
					{
						this.Contract.setScreen("UndeadSurprise");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.onTargetAttacked(_dest, true);
					}
				}
				else if (this.Time.getVirtualTimeF() >= this.Contract.m.LastCombatTime + 5.0)
				{
					local enemyFaction = this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse"));
					enemyFaction.setIsTemporaryEnemy(true);
					this.Contract.m.LastCombatTime = this.Time.getVirtualTimeF();
					this.World.Contracts.showCombatDialog(_isPlayerAttacking);
				}
			}

			function onActorRetreated( _actor, _combatID )
			{
				if (!_actor.isNonCombatant() && _actor.getFaction() == this.Flags.get("EnemyNobleHouse") && this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("Survivors", this.Flags.get("Survivors") + 1);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Contract.m.LastCombatTime = this.Time.getVirtualTimeF();
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Retournez à %townname%"
				];
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					if (this.Flags.get("IsCompromisingPapers"))
					{
						if (this.Flags.get("IsExtorting"))
						{
							this.Contract.setScreen("CompromisingPapers2");
							this.World.Contracts.showActiveContract();
						}
						else
						{
							this.Contract.setScreen("CompromisingPapers3");
							this.World.Contracts.showActiveContract();
						}
					}
					else if (this.Flags.get("Survivors") == 0)
					{
						this.Contract.setScreen("Success1");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Math.rand(1, 100) < this.Flags.get("Survivors") * 15)
					{
						this.Contract.setScreen("Failure1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("Failure2");
						this.World.Contracts.showActiveContract();
					}
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{You take a seat as %employer% folds out a map before you. He drags a finger along one of the poorly drawn roads.%SPEECH_ON%A caravan travels this route. I need it attacked, but wait!%SPEECH_OFF%He holds up the finger.%SPEECH_ON%I need it to look like the work of brigands. No one must know that its destruction came by my order, understand?%SPEECH_OFF% | %employer% explains that he needs a caravan destroyed. You inquire as to why, exactly, a nobleman such as himself would have such a task to complete, but the man is scarce on details. His primary demand is simple enough, destroy the caravan and kill everyone there. It must look like the work of {brigands | vandals | vagabonds | greenskins}, otherwise the nobleman might be incriminated.%SPEECH_ON%Did you get that last part, sellsword? Of course you did. You\'re a smart guy, right?%SPEECH_OFF% | You take a seat as %employer% takes a large book from his shelf and opens it before you. Its width encompasses the entire table and the pages are filled with very detailed maps. The nobleman points to a line on one of the topographies.%SPEECH_ON%That\'s the route of a caravan I need destroyed. Don\'t ask me anymore questions, I just need it destroyed. Now, all I ask is that you make it look like the work of brigands, alright? It can\'t be known that I gave the order here. Does that sound doable to you?%SPEECH_OFF% | %employer% greets you with a handshake, but when you try to get your hand back he holds firm.%SPEECH_ON%What I\'m about to say can\'t leave this room, understand?%SPEECH_OFF%You nod and just like that get your hand back.%SPEECH_ON%Good. I need a caravan destroyed, but... no one must know it was you, mercenaries, who did it. If they do, they\'ll easily track it back to me. I need it to look like the work of brigands. No one must survive, alright?%SPEECH_OFF%You shrug as if to say, \'easily done.\'%SPEECH_ON%Good, so then we have a deal?%SPEECH_OFF% | As you take a seat in %employer%\'s study, a stranger comes in behind you and whispers into the nobleman\'s ear. Then, just like that, the mysterious man turns and makes his leave. %employer% stands and pours himself a goblet of wine. He doesn\'t offer you any.%SPEECH_ON%I need a caravan destroyed, but I need this done with a certain amount of discretion. It cannot be known that I, %employer%, told you to do this. No, it was the work of brigands, those bastards... got it? Do you understand? Let\'s talk numbers if you do.%SPEECH_OFF% | As you take a seat, %employer% inquires as to how familiar you are with the work of brigands. You state that their lives are not too dissimilar from your own, only that you\'re smarter and have the ear of people who pay better than what you get for robbing peasants. %employer% nods.%SPEECH_ON%Good, because I need you to pretend to be a brigand for a day and destroy a caravan. No one must survive. No one must know that you, a mercenary, did it. Understand? If you do, let\'s talk numbers.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{What\'s this worth to you? | Let\'s talk pay.}",
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
			ID = "Bribe1",
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/event_41.png[/img]{While closing in on the caravan, one of the guards spots you and everyone draws their weapons. A man, shouting and running with his hands in the air, asks everyone to put their weapons down. He has a satchel in hand, heavy with %bribe% crowns, and says you can take it if you simply let them go. You wonder aloud why you would take the bribe when you could kill them all and take it anyway. The man shrugs.%SPEECH_ON%Well, it\'d certainly save you the trouble of \'killing\' us, seeing as how we\'re not gonna go down without a fight. Just take it and walk, sellsword.%SPEECH_OFF% | As your men approach the caravan, one of the guards spots you and blows a horn, alarming the rest to your presence. Soon, an entire armed guard stands before you, ready to fight. The head of the wagon train comes through their line, holding his hands up.%SPEECH_ON%Stay your weapons, men! Sellsword, I\'d like to make you an offer. You take this satchel of %bribe% crowns and walk and nobody has to die here.%SPEECH_OFF%You open your mouth to respond, but the man holds a finger up and keeps talking.%SPEECH_ON%Whoa, think carefully, mercenary. You no longer have the drop on us and I hired these men to protect these wagons for good reason - they\'re killers, just like you.%SPEECH_OFF% | With your men on the approach, the destruction of the caravan seems to be at hand. Unfortunately, you watch as one of the mercenaries missteps, sliding his foot on a rolling tree limb that sends him skittering and rolling down a small hillside. The disturbance is loud enough to alert the entire wagon train to your presence and you watch as armed guards stream out to meet you. Their lieutenant runs in between the two war bands, his arms in the air.%SPEECH_ON%Wait. Just wait. Before we commence the killin\' and slaughterin\', let\'s exchange a few words, shall we? I have here %bribe% crowns.%SPEECH_OFF%The man holds up a satchel and waves it toward you.%SPEECH_ON%You take this, walk, and we can all go on our ways. No need for men to be impasses upon one another, right? I\'d say it\'s a mighty fine deal, sellsword, seeing as how you ain\'t got your sneaking ways on your side anymore - it\'s gonna be man against man. So what say you?%SPEECH_OFF% | Just as you think your men are about to begin the assault on the caravan, a guard watching the wagons spots them. He hurries to an alarm bell, sounding it loudly just as %randombrother% caves his skull in. Unfortunately, a great number of the guard\'s compatriots fly out, weapons raised. Their leader is beside them, holding the order back for them to charge.%SPEECH_ON%Ho\', men! Not yet. Let us, perhaps, discuss a less... violent end to this here junction.%SPEECH_OFF%He glances at the stoved in head of the guard.%SPEECH_ON%Well, for the rest of us, anyway. I have here in my hand %bribe% crowns. It\'s yours, ambusher, assassin, whatever you call yourself, if you simply take it and walk. And I\'d suggest you do just that - you no longer have the drop on us and I paid good money for these men to watch my goods, understand?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{So be it. Hand over the crowns. | A fair offer, we\'ll take it.}",
					function getResult()
					{
						return "Bribe2";
					}

				},
				{
					Text = "Nothing personal, but this caravan is going to burn. And you with it.",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Bribe2",
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/event_41.png[/img]{As you begin to leave, the caravan leader grabs you by the arm.%SPEECH_ON%Hey, I\'m curious about something, and I bet you got something to scratch that curiosity.%SPEECH_OFF%You angrily retrieve your arm from his grip. He apologizes, but quickly goes into his question.%SPEECH_ON%I\'d like to know just who sent you. How does %bribe2% more crowns sound to make my ears privy to such information?%SPEECH_OFF% | The caravan leader catches you before you can depart.%SPEECH_ON%I\'m wonderin\' something, sellsword, and I know you got the answer for me: who sent you?%SPEECH_OFF%You glance around. He laughs and then slaps you on the shoulder.%SPEECH_ON%Obviously I ain\'t gonna take an answer for free. How does %bribe2% more crowns in that there satchel sound? Just for a few words that shape to be what they call \'a name.\' So how about you give me that name, mercenary.%SPEECH_OFF% | The leader calls out to you before you can leave. He\'s got his arms crossed, his feet mindlessly kicking rocks.%SPEECH_ON%Ya know, I can\'t just let you leave quite yet. There\'s some rather pertinent information I\'d like to learn of and I\'m willing to drop %bribe2% crowns in that satchel there to learn said information.%SPEECH_OFF%You look around, making there isn\'t an ambush waiting for you. Then you turn back to the man and nod.%SPEECH_ON%You want to know who sent me.%SPEECH_OFF%The leader grins and clasps his hands together.%SPEECH_ON%Boy, you are certainly a quick learner! Why, yes! I do!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{Hand over the crowns, then. | Very well, not that it makes a difference at this point. | A good deal just got even sweeter.}",
					function getResult()
					{
						return "Bribe3";
					}

				},
				{
					Text = "I won\'t betray our reputation like this, we\'ll be leaving.",
					function getResult()
					{
						return "Bribe4";
					}

				}
			],
			function start()
			{
				this.World.Assets.addMoney(this.Flags.get("Bribe1"));
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail * 2);
				this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Flags.get("Bribe1") + "[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "Bribe3",
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/event_41.png[/img]{You take the extra crowns, sacking them away, and then give the leader the name: %employer%. He bounces it on his tongue like some sort of poisoned nut.%SPEECH_ON%%employer%. %employer%! Yech, that name. %employer%, like some sort of... well, I won\'t bore you with my sudden urge to stoop my language into the pits. I thank you, sellsword, and bid you farewell.%SPEECH_OFF%You nod and make your leave. | Sacking the extra crowns, you tell the leader the word of the day: %employer%. The man laughs upon hearing it and nods repeatedly as though he expected it all along.%SPEECH_ON%You\'ve done good, sellsword. What a day though, right? First you come here to put a sword through me, but a few minutes later and we are leaving on such good terms. Truly you are a man of business. A shame you decided to put that skill behind a blade instead of a pen. Farewell and godspeed.%SPEECH_OFF% | {In for an ounce, in for a pound. | In for an inch, in for a mile.} You take the man\'s offer and spill the beans on %employer%\'s doings. The caravan leader nods solemnly.%SPEECH_ON%You know, we men of business don\'t wield weapons like you do, but trust me, it\'s just as cutthroat. Godspeed, sellsword.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Payment without having to kill anyone. I can get used to that.",
					function getResult()
					{
						this.World.Contracts.removeContract(this.Contract);
						return 0;
					}

				}
			],
			function start()
			{
				this.World.Assets.addMoney(this.Flags.get("Bribe2"));
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail * 2);
				this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().set("Betrayed", true);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Flags.get("Bribe2") + "[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "Bribe4",
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/event_41.png[/img]{You tell the man to bugger off. He\'s already gotten lucky enough. The man nods, agreeing, though his narrowed face tells you all you need to know about your rejection. | You shake your head.%SPEECH_ON%I\'ll be letting you go, but I can\'t take it that far. I still need the employment %employer% offers, understand?%SPEECH_OFF%The man nods.%SPEECH_ON%A smart decision, though a poor one for me, obviously. But yes, I understand you, sellsword. May the old gods be with you in your travels. Shall we meet again, I hope it is under better terms!%SPEECH_OFF% | Betraying %employer% probably isn\'t the best of ideas and you tell the man as much. He nods, understanding.%SPEECH_ON%Well, alright then. I can\'t blame you for keeping those cards in your hand, but damned if I wish you\'d have shown them all the same. Godspeed, mercenary.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We\'re moving out!",
					function getResult()
					{
						this.World.Contracts.removeContract(this.Contract);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Swordmaster",
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/event_35.png[/img]{While preparing to assault the caravan, %randombrother% comes to your side and points to one of the men in the wagontrain.%SPEECH_ON%Know who that is?%SPEECH_OFF%You shake your head.%SPEECH_ON%That\'s %swordmaster%.%SPEECH_OFF%Slimming your eyes to get a clearer picture, all you see is an ordinary looking man. The mercenary explains that he\'s a renowned swordmaster who has killed untold numbers of men. He thumbs his nose and spits.%SPEECH_ON%Still want to attack?%SPEECH_OFF% | You glass the caravan with some spectacles and spot a familiar face: %swordmaster%. A man you saw compete in a jousting tournament in %randomtown% a few years back. If you recall correctly, he won with an arm tied behind his back. Anyone who met him off the horses was quickly slain as he displayed expert swordsmanship. This fellow is a dangerous one and should be approached carefully. | Scouting the wagontrain, you see a face that gives you\'ve seen before. %randombrother% joins you, picking his fingernails with a knife.%SPEECH_ON%That\'s %swordmaster%, the swordmaster. He\'s killed twenty men this year.%SPEECH_OFF%A voice barks from behind you.%SPEECH_ON%I heard fifty! Sixty maybe. Forty-five if we\'re being realistic...%SPEECH_OFF%Hmm, it appears there is a most dangerous opponent in that caravan\'s guard...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To Arms!",
					function getResult()
					{
						this.Const.World.Common.addTroop(this.Contract.m.Target, {
							Type = this.Const.World.Spawn.Troops.Swordmaster
						}, true, this.Contract.getDifficultyMult() >= 1.1 ? 5 : 0);
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "UndeadSurprise",
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/event_29.png[/img]{Ordering the assault, your men launch across the grass. The caravan guards are already running your way, but they look scared. Behind them follow a throng of garish looking creatures. It\'s safe to say this is going to be the strangest of meetings... | As the %companyname% sprints toward the caravan, weapons drawn, a few men slow down to point out that there\'s an even larger party approaching the wagon train from the other side. Pausing to get a good eye at it, you realize that there is a horde of undead converging on this very spot! | Well, it looks like this won\'t be as easy as you\'d thought: as your men begin the attack on the caravan, %randombrother% spots a horde of ghastly undead approaching from the other side! Undead or soon-to-be-dead, it doesn\'t matter. You\'re here to do what %employer% paid you to do.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To Arms!",
					function getResult()
					{
						local enemyFaction = this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse"));
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos(), true);
						p.CombatID = "UndeadSurprise";
						p.Music = this.Const.Music.UndeadTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.TemporaryEnemies = [
							this.Flags.get("EnemyNobleHouse")
						];
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];
						p.EnemyBanners = [
							enemyFaction.getBannerSmall(),
							this.Const.ZombieBanners[0]
						];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Necromancer, 100 * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "WomenAndChildren1",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_97.png[/img]{As your men clean the field of any wounded, %randombrother% comes to you with a line of women and children being toted behind him. You raise your sword and ask what is this.%SPEECH_ON%Looks like they brought their families with them. What do you want us to do?%SPEECH_OFF%If you let them go, there\'s a good chance they\'ll spread word of your being here. If you kill them, well, that\'s got a cost that\'ll weigh heavy on any mind... | Having won the battle, your men spread out to collect the goods and make sure every caravan guard is good and dead. Unfortunately, not everyone you come across is dead - and not all of them grown men. A throng of women and children emerge from the ruins of the fight, slowly approaching with all the frailty of a wounded dog. Some are covered in blood, others have been shielded from the combat. %randombrother% asks what should be done with them.%SPEECH_ON%We should probably let them go because, well, look at them. But... they might tell someone. You know women and their big mouths.%SPEECH_OFF%The mercenary laughs nervously. One of the women clutches her bosom.%SPEECH_ON%We shan\'t tell a soul, we swear!%SPEECH_OFF% | The fighting over, you stumble across a party of women and children in the ruins of the caravan. They saunter over, seeming to understand that if they just took off running you\'d have reason to chase. One of the women, clutching a babe close to her chest, pleads.%SPEECH_ON%Please, you\'ve already done so much hurt and pain. Our fathers, husbands, brothers, you already killed them all. Is that not enough? Let us go.%SPEECH_OFF%%randombrother% spits.%SPEECH_ON%Them children seen what we did. They gonna grow up remembering it, too. And those women, well, they\'ll be telling everybody. That\'s what they do.%SPEECH_OFF%He looks toward you, gesturing toward a half-cocked blade.%SPEECH_ON%What do you want us to do, sir?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We\'re paid to leave no one alive, so that\'s what we\'ll do.",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-5);
						return "WomenAndChildren2";
					}

				},
				{
					Text = "To hell with it - let them leave.",
					function getResult()
					{
						this.World.Assets.addMoralReputation(2);
						this.Flags.set("Survivors", this.Flags.get("Survivors") + 3);
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "WomenAndChildren2",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{You nod to %randombrother%. He steps forward, weapon in hand, and with a quick slash removes a woman\'s head. A geyser of crimson fountains forth and her children are too blinded by the blood to see the rest of the blades coming.  The screams gradually die down as your brothers hack their way through the horrified crowd, dwindling their numbers into scattered whimpers. Your men double check their work until the victims are mute and the silence is dripping. | With a quick flick of your hand, you give the order. %randombrother% doesn\'t take but a moment to drive a blade through a kid\'s face, pegging the child against its mother\'s womb before slicing upward to claim her life as well. The rest of the men fan out, some reluctant while others yet go about with reverent diligence.\n\n As the horrific shrieks fill the air, you get the sense that some mercenaries are hacking and slashing simply to drive the noise out of their heads. The violence consumes all, an orgy of madness you know not whether to claim the pinnacle or nadir of man\'s doings for all meaning is lost in the event and the words to describe it have yet to be found in your tongue or any that is ancestral or beyond the dimly lit reckoning of what your eye can see. It is simply a happening. | Unfortunately, none can be allowed to live. You bark out an order and the mercenaries jump to the task. A woman approaches, seemingly having misheard you, and asks for directions to the nearest town. %randombrother% answers by stoving her head in with a stone. Frightened children fan out in a winding scatter that reminds you of your rabbit hunting days. Your quickest mercenaries give chase while the rest stay behind to make short work of the parents. It is a gruesome sight indeed.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Well, it\'s not a pretty job, but that\'s what we\'re being paid for.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CompromisingPapers1",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{As the caravan burns, your men pick through the remains. %randombrother% comes to you with some papers in hand.%SPEECH_ON%These might be of some interest, sir.%SPEECH_OFF%You unfurl one of them and take a read. It appears %employer% had a very, very ulterior motive for attacking this particular wagon train. It would be a shame if anyone were to find out these details... | The wagons still burning, you come to a wooden chest and kick it open. Scrolls pop out, unfurling and scattering in the wind. You catch one and give it a read. It\'s a report on the earnings - or lack thereof - of %employer%\'s territory. It appears to have been intended to reveal the man\'s financial fragility. You could, if you wanted, use this against him... | You find a cache of papers in the ruins of the caravan. One of the scrolls reveals something about %employer% that, more than likely, he knew was traveling with the wagons. This must be the reason why he had you attack it... it could also be used against him. You doubt he expected it to fall into your hands. You\'re just a stupid sellsword, after all...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Burn them with the rest.",
					function getResult()
					{
						this.Flags.set("IsCompromisingPapers", false);
						this.Contract.setState("Return");
						return 0;
					}

				},
				{
					Text = "We shall give them to our employer as a token of loyalty.",
					function getResult()
					{
						this.Flags.set("IsCompromisingPapers", true);
						this.Contract.setState("Return");
						return 0;
					}

				},
				{
					Text = "Our employer will have to pay us extra to get these.",
					function getResult()
					{
						this.Flags.set("IsCompromisingPapers", true);
						this.Flags.set("IsExtorting", true);
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CompromisingPapers2",
			Title = "On your return...",
			Text = "[img]gfx/ui/events/event_63.png[/img]{You Retournez à %employer% and hold the papers up. He almost instantly seems to recognize a seal on one of the scrolls.%SPEECH_ON%What... what are those?%SPEECH_OFF%Lowering the papers, and about to explain, the man takes a lunge, trying to snatch them from you. He falls short as you pull back. He straightens up, seeming to correct a loss of composure.%SPEECH_ON%Alright sellsword. I see where this is going. How much more do you want?%SPEECH_OFF%With the doors closed, the two of you hash out a deal. | %employer% welcomes your return, turning around with two mugs of wine in hand, but his smile quickly fades.%SPEECH_ON%What\'s that in your hand? Where did you get that?%SPEECH_OFF%You stuff one of the incriminating papers away and nod, answering.%SPEECH_ON%I think you know exactly where I got it. And I think you know exactly where this is going. Now... let\'s you and I talk business, yeah?%SPEECH_OFF%The man drinks one of the mugs, then downs the other.%SPEECH_ON%Yeah. Alright. Close the door, would ya?%SPEECH_OFF% | You enter %employer%\'s room and throw the incriminating papers on his desk. He looks at them and then laughs.%SPEECH_ON%What a mistake!%SPEECH_OFF%He crumbles the papers up and stuffs them under his table. You laugh in return and retrieve another set of scrolls.%SPEECH_ON%How stupid do you think I am?%SPEECH_OFF%The man quickly takes his stuffed notes back out and stares at them. He realizes you only put one page in there, the rest just blank spaces. Grinning, you lay out the ground rules.%SPEECH_ON%Now that I know how important these are to you, let us talk business so that ALL of them may Retournez à you, yeah?%SPEECH_OFF%The man takes a solemn seat and nods. He retrieves a personal satchel of crowns and sets it on his desk before gesturing toward the entryway.%SPEECH_ON%Please, close the door.%SPEECH_OFF% | When you return, %employer% immediately notices the seal on the papers you\'ve brought. He has a few guards in his room, but quickly hurries them out, telling them to chase the rabbits from his gardens. He closes the door and turns to you.%SPEECH_ON%I see I\'ve been found out.%SPEECH_OFF%You nod. The man licks his lips and nods in return.%SPEECH_ON%Alright then. Nothing on those papers can leave this room. How much do you want?%SPEECH_OFF%You lift a leg over the edge of his table and take a seat, putting the papers beside you and clasping your hands together. Grinning, you answer.%SPEECH_ON%Everything is worth what the purchaser is willing to pay for it, is it not, nobleman?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "A good payday at last.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() * 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail * 2, "Extorted Money");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() * 2 + "[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "CompromisingPapers3",
			Title = "On your return...",
			Text = "[img]gfx/ui/events/event_63.png[/img]{You Retournez à %employer% and he turns to you, seemingly angry.%SPEECH_ON%You know folks are speaking about what you did, right?%SPEECH_OFF%Smiling, you hold up the incriminating papers.%SPEECH_ON%Would you rather they speak about this instead?%SPEECH_OFF%The man almost gasps before settling down into his chair.%SPEECH_ON%Alright, are you extorting me?%SPEECH_OFF%You put the papers on his table and shake your hand.%SPEECH_ON%I thought about it, but I\'d rather not bite the hand that feeds just because it so happens to be holding something tasty this one time.%SPEECH_OFF% | %employer% waves you into his room.%SPEECH_ON%The peasantfolk are talking of ya. People in that caravan got away and between still drawing breath they saw fit to speak of what they experienced.%SPEECH_OFF%You nod and agree.%SPEECH_ON%That is quite understandable.%SPEECH_OFF%The man growls and points a finger, but you point the incriminating papers back in his face. He seizes up in rather strained silence.%SPEECH_ON%I... I see... Are you wanting more money?%SPEECH_OFF%You toss him the papers.%SPEECH_ON%No. You forget one of my faults, and I forget one of yours. Fair enough, right?%SPEECH_OFF%The man hastily stuffs the papers into his coat and nods. | You find %employer% tending to his garden. A few guard stand a ways off, and you imagine one of the handful of peasants lingering is really just a guard in disguise.%SPEECH_ON%Sellsword! It is good to see you, except for one little thing.%SPEECH_OFF%He waves you close and lowers his voice.%SPEECH_ON%You let a few of those caravan folk get away. I don\'t remember that being part of the deal.%SPEECH_OFF%You hold up the incriminating papers.%SPEECH_ON%I don\'t remember this being part of the deal either.%SPEECH_OFF%%employer% leers back, then composes himself so his guards don\'t get suspicious.%SPEECH_ON%Alright, I take those, and I forget about the whole letting people live who should be dead ordeal, alright?%SPEECH_OFF%You hand the papers over.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Crowns well earned.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Procured compromising papers");
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
			ID = "Success1",
			Title = "On your return...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{You Retournez à %employer% with news of your success. He\'s got a warm greeting - a satchel heavy with crowns.%SPEECH_ON%Good job sellsword. Did you, uh, see anything else while down there?%SPEECH_OFF%It\'s an odd question, but you don\'t pursue it. You tell the man it went down just as the results show. He nods and quickly thanks you before returning to his work. | %employer%\'s standing by a window when you return. He\'s drinking a goblet of wine, swishing it around in both cup and mouth.%SPEECH_ON%My little birds tell me the caravan was destroyed. The songs they sing, are they true?%SPEECH_OFF%You nod and tell him of the news. He hands over a chest of crowns, thanking you for your service before returning to the window. You catch a wry grin on the side of his face just before you leave. | %employer%\'s petting a dog as you return. His hand his shaking through the fur.%SPEECH_ON%I take it the wagon train is destroyed?%SPEECH_OFF%You tell him the details. He nods, but his petting hand comes to a rest.%SPEECH_ON%Did you by any chance... find something interesting?%SPEECH_OFF%You think it over, but can\'t come up with anything out of the ordinary. The man grins and returns to petting his dog.%SPEECH_ON%Thank you for services, sellsword.%SPEECH_OFF% | %employer%\'s writing when you enter his room. He drops the quill pen in a hurry and stands up.%SPEECH_ON%So it\'s destroyed then? The caravan, I mean.%SPEECH_OFF%You report the results of your \'services.\' He laughs and claps his hands together.%SPEECH_ON%Excellent! Most excellent, sellsword! You\'ve no idea what your work has done for me today. Of course, your payment, as promised...%SPEECH_OFF%He hands over a satchel of %reward_completion% crowns. It\'s all there, but you have to wonder why the man was so giddy about something so seemingly ordinary... did you miss something? | %employer%\'s talking to his council when you return. He shoos them out. It is a strange sight - seeing these powerful figures making way for a motley sellsword. You stand a little taller as you report the news of the caravan\'s destruction.%SPEECH_ON%Thank you, mercenary. This is the sort of news I\'ve been waiting for. And your payment, of course...%SPEECH_OFF%He heaves a wooden chest onto his desk and pushes it across. Its heavy enough to leave a mark.%SPEECH_ON%%reward_completion% crowns, as we agreed upon.%SPEECH_OFF%You\'re curious as to why the nobleman would excuse his council to take in a sellsword, but decide not to dwell on it.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Destroyed a caravan");
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
			Title = "On your return...",
			Text = "[img]gfx/ui/events/event_45.png[/img]{You Retournez à find %employer% sitting at his desk, tented hands before him, his thumbs practically plugged into his forehead. His hands fall forward when he begins to talk.%SPEECH_ON%You let... them live...%SPEECH_OFF%You raise a finger and make your case: not all of them lived.%SPEECH_ON%By the old gods\' endless might, what on earth did I hire you for?%SPEECH_OFF%He pauses, then shrugs.%SPEECH_ON%Alright, I\'ll give you half of what we agreed to. You did destroy the wagon train, after all, I\'ll give you that.%SPEECH_OFF% | %employer% welcomes your return with his feet up on his desk, the bottom of his muddied shoes greeting you with a drip of slop.%SPEECH_ON%So, mercenary, explain to me what it was that I hired you for?%SPEECH_OFF%He throws a hand out as if to say, \'go ahead.\' You state that you were hired to destroy a caravan and leave no survivors. The man shoots a finger up.%SPEECH_ON%Repeat that last part.%SPEECH_OFF%You do. The man grins, satisfied with himself, but then the smile sours to your failure.%SPEECH_ON%Alright, you didn\'t do what I asked. That\'s fine. You did do... some of it, I suppose. The caravan is destroyed...%SPEECH_OFF%He shrugs and throws you a satchel. It\'s half of what you were owed. You figure better that than nothing. | %employer%\'s talking to his guards when you return. He fans them away, though one lingers just outside the hall, his eyes nearly poking around his head to check in on you from time to time. You drag out one of %employer%\'s chairs, but he tells you to keep standing.%SPEECH_ON%This\'ll be brief. You didn\'t do all that I asked, sellsword. People are talking, talking about you. How are they talking about you if I asked that you kill all witnesses? A little curious, no? I suppose it\'s because you didn\'t kill all those witnesses, which means you didn\'t do what I asked.%SPEECH_OFF%He pauses, rubbing two knuckles into his forehead.%SPEECH_ON%Alright, this is what I\'ll do. I\'ll give you half of what we agreed. Half to you for destroying the caravan, half to me because I gotta pay for the cover-up. Hope that suits you.%SPEECH_OFF%The guard leers in. You nod and take the payment. | %employer% waves you in. He\'s standing with a scribe who looks ready to spin a tale. Your employer crosses his arms.%SPEECH_ON%People are talking of what you did...%SPEECH_OFF%The man gestures toward the scribe who, surprisingly, doesn\'t begin writing.%SPEECH_ON%I\'ve had to make some payments to keep lips sealed, understand? So that means you\'re only getting half of what we agreed upon.%SPEECH_OFF%The elder scribe grins. You notice a ring on his finger. It looks newly minted. %employer%\'s almost scowling, but the scribe isn\'t writing anything so you take that for a good sign. You take your pay and make your leave. | A group of grinning men are leaving %employer%\'s room when you arrive. He asks you to shut the door behind you then immediately opens up.%SPEECH_ON%Recognize those faces? They were the men who found out what you did. Do you realize how many crowns it took for them to keep their lips sealed? Do you know where those crowns came from?%SPEECH_OFF%You shrug. The man continues.%SPEECH_ON%Your pay, of course. You\'re only getting half. Do you understand why?%SPEECH_OFF%You nod. Business is business. As you turn to leave, %employer% catches you.%SPEECH_ON%And don\'t dare think about killing one of those men to get the other half of your pay back, sellsword!%SPEECH_OFF%Damn.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Could have been worse...",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() / 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Failed to destroy a caravan without letting anyone escape");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() / 2 + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "Failure2",
			Title = "On your return...",
			Text = "[img]gfx/ui/events/event_45.png[/img]{You Retournez à find %employer% sitting at his desk with his elbows on its edge, forearms cocked, his thumbs practically plugged into his forehead. His hands fall forward as he begins to talk.%SPEECH_ON%You let... them live...%SPEECH_OFF%You raise a finger and make your case: not all of them lived.%SPEECH_ON%By the old gods\' endless might, what on earth did I hire you for?%SPEECH_OFF%He pauses, then bursts with anger.%SPEECH_ON%Like I give a shite? You let enough of them that it\'s the talk of this godforsaken village. Get the hell out of my sight before I get one of my guards to take you out.%SPEECH_OFF% | The soles of %employer%\'s feet welcome your return, his legs up on his desk. You notice that there\'s blood on his boots.%SPEECH_ON%So, mercenary, explain to me what it was that I hired you for?%SPEECH_OFF%He throws a hand out as if to say, \'go ahead.\' You state that you were hired to destroy a caravan and leave no survivors. The man shoots a finger up.%SPEECH_ON%Repeat that last part.%SPEECH_OFF%You do. The man grins, satisfied with himself.%SPEECH_ON%Alright, you didn\'t do what I asked. So, what are you doing here? Shall I fetch one of my guards or will you excuse yourself willingly? Because you and I no longer have business together.%SPEECH_OFF% | %employer%\'s talking to his guards when you return. He fans a few away while ordering the biggest of the bunch to stay put. He eyes you down as you enter.\n\nYou drag out one of %employer%\'s chairs, but he tells you to keep standing.%SPEECH_ON%This\'ll be brief. You didn\'t do all that I asked, sellsword. People are talking, talking about you. How are they talking about you if I asked that you kill all witnesses? A little curious, no? Last I recall, a dead witness doesn\'t talk at all, which leads me to believe that these witnesses were very much left alive. Curious indeed, as that is not what I was paying you to do. Now before I ask my fellow guard here to take out his sword and run you through with it, why don\'t you just turn right around and get the hell out of my sight?%SPEECH_OFF% | %employer% waves you in. He\'s standing with a scribe who looks ready to spin a tale. Your employer crosses his arms.%SPEECH_ON%People are talking of what you did...%SPEECH_OFF%The man gestures toward the scribe who, surprisingly, doesn\'t begin writing.%SPEECH_ON%I\'ve had to make some payments to keep lips sealed, understand? So that means you\'re only getting half of what we agreed upon.%SPEECH_OFF%The elder scribe grins. You notice a ring on his finger. It looks newly minted. %employer%\'s almost scowling, but the scribe isn\'t writing anything so you take that for a good sign. You take your pay and make your leave. | A group of grinning men are leaving %employer%\'s room when you arrive. He asks you to shut the door behind you, but not before a guard steps in. He and %employer% exchange a nod and a glance, and you then shut the door. Your employer speaks frankly.%SPEECH_ON%Recognize those people who just walked out of here? They were the men who found out what you did. Do you realize how many crowns it took for them to keep their lips sealed? Do you know where those crowns came from?%SPEECH_OFF%You shrug. The man continues.%SPEECH_ON%Your pay, of course. To keep all their traps shut I had to pay a pretty penny indeed.%SPEECH_OFF%You nod. Business is business and, in this case, you\'ll be getting none. As you turn to leave, %employer% catches you.%SPEECH_ON%And don\'t dare think about killing one of those men to get your pay back, sellsword!%SPEECH_OFF%Damn.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Damn this contract!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Failed to destroy a caravan without letting anyone escape");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Failure3",
			Title = "Along the way...",
			Text = "[img]gfx/ui/events/event_75.png[/img]{Awaiting the caravan, a pair of travelers come up from where the convoy should be going. They remark in detail about a cart which is no doubt the one which you were supposed to be hunting down. No point in returning to %employer%. | Word on the road hints that the caravan you were supposed to be hunting down has given you the slip and reached its destination. The company shouldn\'t bother reaching %employer%.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Damn this contract!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Failed to destroy a caravan");
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
			"bribe",
			this.m.Flags.get("Bribe1")
		]);
		_vars.push([
			"bribe2",
			this.m.Flags.get("Bribe2")
		]);
		_vars.push([
			"start",
			this.World.getEntityByID(this.m.Flags.get("InterceptStart")).getName()
		]);
		_vars.push([
			"dest",
			this.World.getEntityByID(this.m.Flags.get("InterceptDest")).getName()
		]);
		_vars.push([
			"swordmaster",
			this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (this.World.FactionManager.isGreaterEvil())
		{
			return false;
		}

		return true;
	}

	function onSerialize( _out )
	{
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
		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		this.contract.onDeserialize(_in);
	}

});


this.intercept_raiding_parties_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Objectives = [],
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.intercept_raiding_parties";
		this.m.Name = "Intercept Raiding Parties";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
		this.m.MakeAllSpawnsAttackableByAIOnceDiscovered = true;
		this.m.MakeAllSpawnsResetOrdersOnContractEnd = false;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		local f = this.World.FactionManager.getFaction(this.getFaction());
		local towns = [];

		foreach( s in f.getSettlements() )
		{
			if (s.isIsolated() || s.isCoastal() || s.isMilitary() || !s.isDiscovered())
			{
				continue;
			}

			if (s.getActiveAttachedLocations().len() < 2)
			{
				continue;
			}

			if (this.World.getTileSquare(s.getTile().SquareCoords.X, s.getTile().SquareCoords.Y - 12).Type == this.Const.World.TerrainType.Ocean)
			{
				continue;
			}

			towns.push(s);
		}

		towns.sort(function ( _a, _b )
		{
			if (_a.getTile().SquareCoords.Y < _b.getTile().SquareCoords.Y)
			{
				return -1;
			}
			else if (_a.getTile().SquareCoords.Y > _b.getTile().SquareCoords.Y)
			{
				return 1;
			}

			return 0;
		});
		this.m.Destination = this.WeakTableRef(towns[this.Math.rand(0, this.Math.min(1, towns.len() - 1))]);
		this.m.Payment.Pool = 1300 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
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

		this.m.Flags.set("LastLocationDestroyed", "");
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Interceptez tous les groupes de pillards du Sud autour de %objective%",
					"Ne les laissez bruler aucun emplacement"
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

				if (r <= 10)
				{
					this.Flags.set("IsAssassins", true);
				}
				else if (r <= 50)
				{
					this.Flags.set("IsSlavers", true);
				}

				if (this.Math.rand(1, 100) <= 50)
				{
					this.Flags.set("IsThankfulVillagers", true);
				}

				local cityStates = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState);

				foreach( c in cityStates )
				{
					c.addPlayerRelation(-99.0, "Took sides in the war");
				}

				this.Contract.m.Destination.setLastSpawnTimeToNow();
				local locations = [];

				foreach( a in this.Contract.m.Destination.getActiveAttachedLocations() )
				{
					if (a.isUsable() && a.isActive())
					{
						locations.push(a);
					}
				}

				local cityState = cityStates[this.Math.rand(0, cityStates.len() - 1)];

				for( local i = 0; i < 2; i = ++i )
				{
					local r = this.Math.rand(0, locations.len() - 1);
					this.Contract.m.Objectives.push(locations[r].getID());
				}

				local g = this.Contract.getDifficultyMult() > 1.1 ? 3 : 2;

				for( local i = 0; i < g; i = ++i )
				{
					local tile = this.Contract.getTileToSpawnLocation(this.World.getTileSquare(this.Contract.m.Destination.getTile().SquareCoords.X, this.Contract.m.Destination.getTile().SquareCoords.Y - 12), 0, 10);
					local party;

					if (i == 0 && this.Flags.get("IsAssassins"))
					{
						party = cityState.spawnEntity(tile, "Regiment of " + cityState.getNameOnly(), true, this.Const.World.Spawn.Southern, this.Math.rand(70, 90) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						this.Contract.addUnitsToEntity(party, this.Const.World.Spawn.Assassins, this.Math.rand(30, 40) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						party.getFlags().set("IsAssassins", true);
					}
					else if (i == 0 && this.Flags.get("IsSlavers"))
					{
						party = cityState.spawnEntity(tile, "Slavers", true, this.Const.World.Spawn.Southern, this.Math.rand(60, 80) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						this.Contract.addUnitsToEntity(party, this.Const.World.Spawn.NorthernSlaves, 50 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						party.getFlags().set("IsSlavers", true);
					}
					else
					{
						party = cityState.spawnEntity(tile, "Regiment of " + cityState.getNameOnly(), true, this.Const.World.Spawn.Southern, this.Math.rand(100, 130) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + cityState.getBannerString());

						if (this.Math.rand(1, 100) <= 33)
						{
							this.Contract.addUnitsToEntity(party, this.Const.World.Spawn.NorthernSlaves, this.Math.rand(10, 30));
						}
					}

					party.setDescription("Conscripted soldiers loyal to their city state.");
					party.setAttackableByAI(false);
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
					c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
					c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
					local wait = this.new("scripts/ai/world/orders/wait_order");
					wait.setTime(80.0 + i * 12.0);
					c.addOrder(wait);

					for( local j = 0; j < 2; j = ++j )
					{
						local raid = this.new("scripts/ai/world/orders/raid_order");
						raid.setTargetTile(j == 0 ? locations[0].getTile() : locations[1].getTile());
						raid.setTime(60.0);
						c.addOrder(raid);
					}

					this.Contract.m.UnitsSpawned.push(party.getID());
				}

				this.Flags.set("ObjectivesAlive", 2);
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

				foreach( i, id in this.Contract.m.UnitsSpawned )
				{
					local p = this.World.getEntityByID(id);

					if (p != null && p.isAlive())
					{
						p.getSprite("selection").Visible = true;
						p.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
					}
				}
			}

			function update()
			{
				local alive = 0;

				foreach( i, id in this.Contract.m.Objectives )
				{
					local p = this.World.getEntityByID(id);

					if (p != null && p.isAlive())
					{
						if (p.isActive())
						{
							alive = ++alive;
						}
						else
						{
							this.Flags.set("LastLocationDestroyed", p.getRealName());
						}
					}
				}

				if (alive < this.Flags.get("ObjectivesAlive"))
				{
					this.Flags.set("ObjectivesAlive", alive);
					this.Contract.setScreen("LocationDestroyed");
					this.World.Contracts.showActiveContract();
				}
				else if (alive == 0 || this.Contract.m.UnitsSpawned.len() == 0)
				{
					if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() < 4.0 && alive > 0)
					{
						if (this.Flags.get("IsThankfulVillagers") && this.Contract.isPlayerNear(this.Contract.m.Destination, 500))
						{
							this.Contract.setScreen("ThankfulVillagers");
						}
						else
						{
							this.Contract.setScreen("PartiesDefeated");
						}
					}
					else
					{
						this.Contract.setScreen("Lost");
					}

					this.World.Contracts.showActiveContract();
				}
				else
				{
					foreach( i, id in this.Contract.m.UnitsSpawned )
					{
						local p = this.World.getEntityByID(id);

						if (p == null || !p.isAlive())
						{
							this.Contract.m.UnitsSpawned.remove(i);
							break;
						}
					}
				}
			}

			function onDestinationAttacked( _dest, _isPlayerInitiated )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerInitiated;

				if (!this.Flags.get("IsEngagementDialogShown"))
				{
					this.Flags.set("IsEngagementDialogShown", true);

					if (_dest.getFlags().has("IsAssassins"))
					{
						this.Contract.setScreen("Assassins");
					}
					else if (_dest.getFlags().has("IsSlavers"))
					{
						this.Contract.setScreen("Slavers");
					}
					else
					{
						this.Contract.setScreen("InterceptParty");
					}

					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog(_isPlayerInitiated, true, true);
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
					local alive = 0;

					foreach( id in this.Contract.m.Objectives )
					{
						local p = this.World.getEntityByID(id);

						if (p != null && p.isAlive() && p.isActive())
						{
							alive = ++alive;
						}
					}

					if (alive == 0)
					{
						this.Contract.setScreen("Lost");
					}
					else if (alive == 1)
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer%\'s room is dark and quiet. It would be black and silent were it not for a few candles flickering and birds chirping. Standing in the shadows, the nobleman speaks.%SPEECH_ON%The southern shits have been sending raiding parties north. It is a troublesome affair, you know, to have a couple of bronzed looking mutts mucking around, looting, pillaging, killing, raping. They wish to have me draw my main forces to the rear, but I won\'t have it. That is why you are here, sellsword. I need you to seek out these interloping saboteurs and kill them all. There\'s %reward% crowns awaiting you if you\'re up to the task.%SPEECH_OFF% | You find %employer% in talk with his lieutenants. He has two stack of chips, one much higher than the other. He takes from the taller stack and puts it upon the smaller.%SPEECH_ON%And if I allotted this many?%SPEECH_OFF%The lieutenants shake their heads.%SPEECH_ON%That is precisely what the southerners want. If we draw men from the frontline, then they will surely know and use it as the time to attack.%SPEECH_OFF%All the men suddenly look up at you. %employer% grins.%SPEECH_ON%Ah-ha, it seems our savior is none other than a mercenary! Oh, I dare say a sellsword may take care of this for us. You there, captain, I need fighters to stay around %townname% and defend it from southern saboteurs and raiders. You\'ll have %reward% crowns waiting a proper completion of this task!%SPEECH_OFF%The army lieutenants look hesitant to make this offer to a mercenary such as yourself, but you get the feeling times are grim. | You are directed to %employer%\'s library where you find him reading over scrolls. He holds one up.%SPEECH_ON%During times such as these, what is it that you think I am reading about?%SPEECH_OFF%You guess military matters. The man shakes his head.%SPEECH_ON%Agrarianism. You see, I am currently in a war. But wars are not just fought with men, but with supply chains, logistics, food. And it is all these things which the homefront provides. The southern mutts understand this concept as well as we do, and they have sent raiders and infiltrators to destroy the homefront. To distract me, to distract my soldiers. I need you to root out these bastards and protect our homes, our shops, our farms. For proper completion, I will offer you %reward% crowns.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{This may just be the right kind of work for us. | Repel invaders from the south? This here company answers the call! | Very well. Let\'s discuss payment further.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Ça ne vaut pas le coup. | On est demandé autre part. | This will take too much of our time.}",
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
			ID = "LocationDestroyed",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_30.png[/img]{Smoke rises in the distance. Screams beneath the clouds, and flighty silhouettes in the fires that produced them. It is the %location% at %objective%, and it has no doubt been destroyed.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We need to stop this before it\'s too late.",
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
			ID = "InterceptParty",
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/event_156.png[/img]{The southerners appear as though in geographic transition, half-dressed in their own clothes and that of northern garb, while also laden with chests of pillaged loot. One man playfully twirls around in a northern wedding dress. It would seem a friendly party on approach were they not also covered in blood and ash. To battle! | You find the raiding party of northbound southerners. Judging by the blood on them, you wager they\'ve already paved a road of chaos through the homesteaders in the hinterland. To battle!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Prepare to engage them.",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "PartiesDefeated",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_87.png[/img]{You find the last breathing southerner and grab him by his hair and hold him up for all to see. Peasants and farmers alike watch as you cut from throat to neck until his body falls free and his head holds high in your hands. The crowd cheers.%SPEECH_ON%Our savior!%SPEECH_OFF%No doubt %employer% will be happy to hear of your work. | The southerners are slain, and any who survived their injuries are set upon by the locals. It is a torturous affair, with plenty of skin flaying, cock cutting, and general bloody creativity. But you\'ve no sympathy for the outlanders. %employer%\'s awaiting payment, however, does garner a bit of interest for you. | With the last of the southerners put to the grave, you know %employer% will be more than happy to pay you what you\'re worth. As you depart, you find a few of the locals mutilating the corpses of the raiders, as is tradition in this part and all other parts of this world. | With a terrifying cry betraying his former sense of control in this world, the last raider is put to the blade and ended. His fellow brothers in arms are dragged about by the locals, the corpses either chopped to pieces or set afire. You watch for a time, but ultimately move on, knowing that %employer% is going to be waiting. | Luckiest amongst the raiders are the dead, for the gravely wounded are shown no mercy. The locals and homesteaders file into the battlefield to claim their victims, some even exchanging crowns for it, and the selected raiders are then defiled, mutilated, and tortured. You don\'t see any outright killed, and in fact in one case a healer seems to be present just to extend the suffering. It\'s quite the sight, but an even better one would be %employer% dropping a large reward in your coffers.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Get the men ready to move out.",
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
			ID = "Lost",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_94.png[/img]{The enemy is gone, but their work is finished. Smoke lingers around buildings burned to the ground, and those who haven\'t been taken as indebted to be sold down south lie dead in the streets.\n\nThere is little point in you returning to your employer, for you stand little chance to get paid for failure. Best to look for new work elsewhere.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We failed.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Failed to defend " + this.Contract.m.Destination.getName() + " from southern raiders");
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
			ID = "Assassins",
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/event_165.png[/img]{You find a farmer dead in the road with a curved dagger in his back. Nobody leaves a dagger that nice behind, and just as you suspect his murderers are still here: a group of southern assassins. They shift around like shades, and their sharpened steel blade glint with every twist and turn. To battle! | A woman hurriedly rushes to you, her shredded dress flailing, arms swaying, eyes wide, the whites of them pitted in a sea of red blood like shells on a crimson beach. Before she can say a word she grunts and drops to the ground in an instant. A dagger is in the back of her skull, and further behind her a man in black stands with a company of assassins!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To arms!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Slavers",
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{The southern raiding party looks a collective of all the world\'s men. It is upon closer inspection that you realize it is because they are slavers! The mishmash of masters and slaves moves on the %companyname%, a flailing formation of trained and untrained alike. You can see that there are northern faces amongst the crowd, but sadly they are a broken lot and will sooner raise arms against the company than fight for freedom. | You come across the southerners, but they are not raiders at all - they are slavers! They\'ve carts of women and children, and upon your discovering them the slavers hurriedly start decapitating any recently enslaved man who poses a threat while the rest of the group charges the %companyname%. With carnage in the air, you bear down on the group with impunity!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To arms!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "ThankfulVillagers",
			Title = "At %objective%",
			Text = "[img]gfx/ui/events/event_79.png[/img]{You put down the last of the southern raiders. As you order the company to collect what\'s of value, a couple of villagers come out with goods of their own.%SPEECH_ON%We thought it the end of the world, and yet here you are, our knights.%SPEECH_OFF%While you\'re not a knight, you\'re not averse to taking a knight\'s praise - and a knight\'s reward: the villagers give you gifts! | With the raiders dispatched, you find yourself slowly surrounded by villagers. They look haggard and afraid, yet they carry with them baskets of goods. You are offered these as rewards for saving them. They seem to confuse you for %employer%\'s own soldiers, but you don\'t even think to reveal that you are a mercenary. You take the offerings and even tip your hat and say it\'s just your job, which it is.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "It\'s nice to be appreciated.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				local p = this.Contract.m.Destination.getProduce();

				for( local i = 0; i < 2; i = ++i )
				{
					local item = this.new("scripts/items/" + p[this.Math.rand(0, p.len() - 1)]);
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
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% waves you in, though it isn\'t as beaming a welcoming as you\'d hope. His tone is somewhere in the realm of fatherly disappointment.%SPEECH_ON%You got a couple of the southern brigandines. Not great, but not terrible either. I\'ll pay you per each party stopped, but I\'d only wished you\'d done better.%SPEECH_OFF%You almost want to apologize, but you know any sign of weakness are your end might result in some shortchanging and keep it to yourself. He pays the %reward% as earned. | %employer% has a few guards with him when you enter, though there are some faces missing amongst the crowd. The man speaks somberly.%SPEECH_ON%You did what you could, sellsword. It wasn\'t likely that you could have gotten all the raiders. That I realize now. I am, of course, offering a bit of rational respite for you here. For all I know I hired the wrong man, but I will not decide that this day. There is too much to rebuild. You %reward%, as agreed upon per raiding party destroyed.%SPEECH_OFF% |  You enter %employer%\'s room to find your reward of %reward% crowns already accounted for and on the table. He points at it with a flippant turn of his hand.%SPEECH_ON%The raiders came, a few you took care of, the rest pillaged and looted and murdered. So. Take your pay of %reward% crowns, sellsword. It is in accordance to the quality of your work, so please do not be surprised if you find the crowns stacked a little short.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Crowns well deserved.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractPoor);
						this.World.Assets.addMoney(this.Math.round(this.Contract.m.Payment.getOnCompletion() / 2));
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractPoor, "Defended " + this.Contract.m.Destination.getName() + " from southern raiders");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isHolyWar())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCommonContract);
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{You find %employer% not in his war room, but in his side office with a number of ladies milling about. They\'re attending to the cobwebs amongst the corners, filing scrolls into a bookshelf, or dusting the furniture. And they\'re all naked, naturally. The man opens his arms.%SPEECH_ON%I thought it well that I should celebrate, for %townname% has been saved, saved by the likes of you, sellsword!%SPEECH_OFF%He is drunk, and the women gently move out of his way as he veers about the room.%SPEECH_ON%Now... now -hic- now I assure you, that, that I did not take a loan from you %reward% crowns. It is all there -hic- there as promised. The peasantry is pleased, and I am pleased. Most pleased.%SPEECH_OFF%He gives one of the women a squeeze and she responds about as lively as a mottled rug. You grab the purse and go and a few of the lasses slip out the door with you as %employer% falls into a mumbling stupor. | You find %employer% outside his war room and in his library of which there are perhaps more shelves than books. But he seems impressed with himself all the same.%SPEECH_ON%Your work out there was splendid, sellsword. Absolutely splendid. Of course, there were casualties, but in the whole all things are where they should be and them southern shits have been sent running. With your help, our frontlines did not have to slacken to tend to the homes. Here, your %reward% crowns as promised.%SPEECH_OFF%When the man moves out of the way, you see he has stocked a freshly slickened skull on the shelf. He points at it with childish charm.%SPEECH_ON%It\'s one of their skulls. I\'m going to drink wine out of it, or piss into it. Haven\'t decided yet.%SPEECH_OFF% | %employer% is sitting at his desk with a pyramid of three skulls. His hand rests atop it as though one would be patting the head of a dog. You notice that there are still strips of flesh and even hair on them, the bleaching process presumably hurried. The man speaks happily.%SPEECH_ON%My soldiers may stay upon the frontlines because of you, sellsword. Having handled these raiders not only saved the lives of many here, but perhaps prevented the fall of the first domino in a series of many. Without your help, the fathers and brothers and sons on the front may have fallen back to tend to their families and this whole war would have gone all fucked.%SPEECH_OFF%With his free hand, he pushes forward a purse.%SPEECH_ON%Your %reward% crowns. A well earned weight of coin, I\'d say.%SPEECH_OFF%He smiles grimly and cocks his head at the skulls.%SPEECH_ON%I\'d think they would agree, though I must say that in this affair I will be speaking for them.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Defended " + this.Contract.m.Destination.getName() + " from southern raiders");
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

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"objective",
			this.m.Destination.getName()
		]);
		_vars.push([
			"location",
			this.m.Flags.get("LastLocationDestroyed")
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

			foreach( id in this.m.UnitsSpawned )
			{
				local p = this.World.getEntityByID(id);

				if (p != null && p.isAlive())
				{
					p.getSprite("selection").Visible = false;
					p.setOnCombatWithPlayerCallback(null);
				}
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

		local f = this.World.FactionManager.getFaction(this.getFaction());

		foreach( s in f.getSettlements() )
		{
			if (s.isIsolated() || s.isCoastal() || s.isMilitary() || !s.isDiscovered())
			{
				continue;
			}

			if (s.getActiveAttachedLocations().len() < 2)
			{
				continue;
			}

			if (this.World.getTileSquare(s.getTile().SquareCoords.X, s.getTile().SquareCoords.Y - 12).Type == this.Const.World.TerrainType.Ocean)
			{
				continue;
			}

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

		_out.writeU8(this.m.Objectives.len());

		for( local i = 0; i < this.m.Objectives.len(); i = ++i )
		{
			_out.writeU32(this.m.Objectives[i]);
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

		local numObjectives = _in.readU8();

		for( local i = 0; i < numObjectives; i = ++i )
		{
			this.m.Objectives.push(_in.readU32());
		}

		this.contract.onDeserialize(_in);
	}

});


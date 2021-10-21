this.escort_caravan_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Caravan = null,
		NobleHouseID = 0,
		NobleSettlement = null,
		IsEscortUpdated = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.escort_caravan";
		this.m.Name = "Escort Caravan";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
		this.m.MakeAllSpawnsAttackableByAIOnceDiscovered = true;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		local nobleHouses = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);

		foreach( i, h in nobleHouses )
		{
			if (h.getSettlements().len() == 0)
			{
				continue;
			}

			if (this.m.Home.getOwner() != null && this.m.Home.getOwner().getID() == h.getID())
			{
				nobleHouses.remove(i);
				break;
			}
		}

		if (nobleHouses.len() != 0)
		{
			this.m.NobleHouseID = nobleHouses[this.Math.rand(0, nobleHouses.len() - 1)].getID();
		}

		local name = this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)] + " von " + this.World.FactionManager.getFaction(this.m.NobleHouseID).getNameOnly();
		this.m.Flags.set("NobleName", name);
		local settlements = this.World.EntityManager.getSettlements();
		local bestDist = 9000;
		local best;

		foreach( s in settlements )
		{
			if (!s.isDiscovered() || !s.isMilitary())
			{
				continue;
			}

			if (s.getID() == this.m.Destination.getID())
			{
				continue;
			}

			if (s.getOwner() != null && s.getOwner().getID() == this.m.NobleHouseID)
			{
				local d = this.getDistanceOnRoads(s.getTile(), this.m.Home.getTile());

				if (d < bestDist)
				{
					bestDist = d;
					best = s;
				}
			}
		}

		if (best != null)
		{
			this.m.NobleSettlement = this.WeakTableRef(best);
			this.m.Flags.set("NobleSettlement", best.getID());
		}

		this.contract.start();
	}

	function setup()
	{
		local settlements = this.World.EntityManager.getSettlements();
		local candidates = [];

		foreach( s in settlements )
		{
			if (s.getID() == this.m.Origin.getID())
			{
				continue;
			}

			if (!s.isAlliedWith(this.getFaction()))
			{
				continue;
			}

			if (this.m.Origin.isIsolated() || s.isIsolated() || !this.m.Origin.isConnectedToByRoads(s) || this.m.Origin.isCoastal() && s.isCoastal())
			{
				continue;
			}

			local d = this.m.Origin.getTile().getDistanceTo(s.getTile());

			if (d <= 12 || d > 100)
			{
				continue;
			}

			local distance = this.getDistanceOnRoads(this.m.Origin.getTile(), s.getTile());
			local days = this.getDaysRequiredToTravel(distance, this.Const.World.MovementSettings.Speed * 0.6, true);

			if (days > 7 || distance < 15)
			{
				continue;
			}

			if (this.World.getTime().Days <= 10 && days > 4)
			{
				continue;
			}

			if (this.World.getTime().Days <= 5 && days > 2)
			{
				continue;
			}

			candidates.push(s);
		}

		if (candidates.len() == 0)
		{
			this.m.IsValid = false;
			return;
		}

		this.m.Destination = this.WeakTableRef(candidates[this.Math.rand(0, candidates.len() - 1)]);
		local distance = this.getDistanceOnRoads(this.m.Origin.getTile(), this.m.Destination.getTile());
		local days = this.getDaysRequiredToTravel(distance, this.Const.World.MovementSettings.Speed * 0.6, true);

		if (days >= 5)
		{
			this.m.DifficultyMult = this.Math.rand(115, 135) * 0.01;
		}
		else if (days >= 2)
		{
			this.m.DifficultyMult = this.Math.rand(95, 105) * 0.01;
		}
		else
		{
			this.m.DifficultyMult = this.Math.rand(70, 85) * 0.01;
		}

		this.m.Payment.Pool = this.Math.max(150, distance * 7.0 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult());
		local r = this.Math.rand(1, 3);

		if (r == 1)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else if (r == 2)
		{
			this.m.Payment.Count = 0.25;
			this.m.Payment.Completion = 0.75;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		local maximumHeads = [
			15,
			20,
			25,
			30
		];
		this.m.Payment.MaxCount = maximumHeads[this.Math.rand(0, maximumHeads.len() - 1)];
		this.m.Flags.set("HeadsCollected", 0);
		this.m.Flags.set("Distance", distance);
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Escortez la caravane jusqu\'à %objective% à environ %days% %direction%",
					"Des provisions pour la route sont donnés à vos hommes"
				];
				local isSouthern = this.World.FactionManager.getFaction(this.Contract.getFaction()).getType() == this.Const.FactionType.OrientalCityState;

				if (!isSouthern && this.Math.rand(1, 100) <= this.Const.Contracts.Settings.IntroChance)
				{
					this.Contract.setScreen("Intro");
				}
				else if (isSouthern)
				{
					this.Contract.setScreen("TaskSouthern");
				}
				else
				{
					this.Contract.setScreen("Task");
				}
			}

			function end()
			{
				local isSouthern = this.World.FactionManager.getFaction(this.Contract.getFaction()).getType() == this.Const.FactionType.OrientalCityState;
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 5)
				{
					if (this.World.Assets.getBusinessReputation() > 700 && !isSouthern)
					{
						this.Flags.set("IsStolenGoods", true);
						this.Flags.set("IsEnoughCombat", true);

						if (this.Contract.m.Home.getOwner() != null)
						{
							this.Contract.m.NobleHouseID = this.Contract.m.Home.getOwner().getID();
						}
						else if (this.Contract.m.Destination.getOwner() != null)
						{
							this.Contract.m.NobleHouseID = this.Contract.m.Destination.getOwner().getID();
						}
						else
						{
							local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
							this.Contract.m.NobleHouseID = nobles[this.Math.rand(0, nobles.len() - 1)].getID();
						}
					}
				}
				else if (r <= 10)
				{
					if (this.World.Assets.getBusinessReputation() > 1000 && this.Contract.getDifficultyMult() >= 0.95)
					{
						this.Flags.set("IsVampires", true);
						this.Flags.set("IsEnoughCombat", true);
					}
				}
				else if (r <= 15)
				{
					this.Flags.set("IsValuableCargo", true);
				}
				else if (r <= 20)
				{
					if (this.Contract.m.NobleHouseID != 0 && this.Flags.has("NobleName") && this.Flags.has("NobleSettlement") && !isSouthern)
					{
						this.Flags.set("IsPrisoner", true);
					}
				}
				else if (this.Contract.getDifficultyMult() < 0.95 || this.World.Assets.getBusinessReputation() <= 500 || this.Contract.getDifficultyMult() <= 1.1 && this.Math.rand(1, 100) <= 20)
				{
					this.Flags.set("IsEnoughCombat", true);
				}

				this.Contract.spawnCaravan();
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
				this.World.State.setCampingAllowed(false);
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

				if (this.Contract.m.Payment.Count != 0)
				{
					if (this.Contract.m.BulletpointsObjectives.len() >= 2)
					{
						this.Contract.m.BulletpointsObjectives.remove(1);
					}

					this.Contract.m.BulletpointsObjectives.push("Soyez payé pour la tête de chaque attaquant que vous tués (%killcount%/%maxcount%)");
				}

				this.World.State.setEscortedEntity(this.Contract.m.Caravan);
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
				else if (this.Contract.isPlayerAt(this.Contract.m.Destination))
				{
					if (this.Flags.get("IsCaravanHalfDestroyed"))
					{
						this.Contract.setScreen("Success2");
					}
					else
					{
						this.Contract.setScreen("Success1");
					}

					this.World.Contracts.showActiveContract();
				}
				else if (!this.Flags.get("IsEnoughCombat"))
				{
					if (this.Contract.spawnEnemies())
					{
						this.Flags.set("IsEnoughCombat", true);
					}
				}
				else
				{
					local parties = this.World.getAllEntitiesAtPos(this.World.State.getPlayer().getPos(), 400.0);
					local numParties = 0;

					foreach( party in parties )
					{
						numParties = ++numParties;
					}

					if (numParties > 2)
					{
						return;
					}

					if (this.Flags.get("IsStolenGoods") && this.World.State.getPlayer().getTile().HasRoad)
					{
						if (!this.TempFlags.get("IsStolenGoodsDialogTriggered") && this.Contract.getDistanceToNearestSettlement() >= 6 && this.Math.rand(1, 1000) <= 1)
						{
							this.TempFlags.set("IsStolenGoodsDialogTriggered", true);
							this.Contract.setScreen("StolenGoods1");
							this.World.Contracts.showActiveContract();
						}
					}
					else if (this.Flags.get("IsVampires") && !this.World.getTime().IsDaytime)
					{
						if (!this.TempFlags.get("IsVampiresDialogTriggered") && this.Contract.getDistanceToNearestSettlement() >= 6 && this.Math.rand(1, 1000) <= 2)
						{
							this.TempFlags.set("IsVampiresDialogTriggered", true);
							this.Contract.setScreen("Vampires1");
							this.World.Contracts.showActiveContract();
						}
					}
					else if (this.Flags.get("IsValuableCargo"))
					{
						if (!this.TempFlags.get("IsValuableCargoDialogTriggered") && this.Contract.getDistanceToNearestSettlement() >= 6 && this.Math.rand(1, 1000) <= 1)
						{
							this.TempFlags.set("IsValuableCargoDialogTriggered", true);
							this.Contract.setScreen("ValuableCargo1");
							this.World.Contracts.showActiveContract();
						}
					}
					else if (this.Flags.get("IsPrisoner"))
					{
						if (!this.TempFlags.get("IsPrisonerDialogTriggered") && this.Contract.getDistanceToNearestSettlement() >= 6 && this.Math.rand(1, 1000) <= 1)
						{
							this.TempFlags.set("IsPrisonerDialogTriggered", true);
							this.Contract.setScreen("Prisoner1");
							this.World.Contracts.showActiveContract();
						}
					}
				}
			}

			function onCombatVictory( _combatID )
			{
				this.Flags.set("IsEnoughCombat", true);

				if (_combatID == "StolenGoods")
				{
					this.Flags.set("IsStolenGoods", false);
					this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).addPlayerRelation(this.Const.World.Assets.RelationAttacked, "Killed some of their men");
				}
				else if (_combatID == "Vampires")
				{
					this.Flags.set("IsVampires", false);
				}

				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Flags.set("IsEnoughCombat", true);
				this.Flags.set("IsFleeing", true);
				this.Flags.set("IsStolenGoods", false);
				this.Flags.set("IsVampires", false);

				if (_combatID == "StolenGoods")
				{
					this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).addPlayerRelation(this.Const.World.Assets.RelationAttacked, "Attacked some of their men");
				}

				if (this.Contract.m.Caravan != null && !this.Contract.m.Caravan.isNull())
				{
					this.Contract.m.Caravan.die();
					this.Contract.m.Caravan = null;
				}

				this.start();
				this.World.State.getWorldScreen().updateContract(this.Contract);
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getType() == this.Const.EntityType.CaravanDonkey && _actor.getWorldTroop() != null && _actor.getWorldTroop().Party.getID() == this.Contract.m.Caravan.getID())
				{
					this.Flags.set("IsCaravanHalfDestroyed", true);
				}
				else
				{
					this.Contract.addKillCount(_actor, _killer);
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

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
				}

				this.Contract.clearSpawnedUnits();
			}

		});
		this.m.States.push({
			ID = "Running_Prisoner",
			function start()
			{
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
				}

				if (this.Contract.m.NobleSettlement != null && !this.Contract.m.NobleSettlement.isNull())
				{
					this.Contract.m.NobleSettlement.getSprite("selection").Visible = true;
				}

				this.Contract.m.BulletpointsObjectives = [
					"Raccompagnez %noble% sain et sauf à %noblesettlement% %nobledirection%"
				];
				this.Contract.m.BulletpointsPayment = [];
				this.Contract.m.BulletpointsPayment.push("Recevez une récompense en arrivant");
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.NobleSettlement))
				{
					if (this.Flags.get("IsPrisonerLying"))
					{
						this.Contract.setScreen("Prisoner4");
					}
					else
					{
						this.Contract.setScreen("Prisoner3");
					}

					this.World.Contracts.showActiveContract();
				}
			}

		});
	}

	function createScreens()
	{
		this.importScreens(this.Const.Contracts.NegotiationPerHeadAtDestination);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Task",
			Title = "Negotiations",
			Text = "[img]gfx/ui/events/event_98.png[/img]{%employer%\'s study is lit by a warm fire. He offers you a seat and a goblet of wine, both of which you take.%SPEECH_ON%Sellsword, you\'re familiar with how dangerous the roads are these days?%SPEECH_OFF%By the gods, that is some good wine. You nod and try to hide your astonishment. %employer% smiles tersely and continues.%SPEECH_ON%Good, then you\'ll understand this task I have for you. I need a caravan escorted along the roads to %objective% about %days% from here. Pretty simple, right? Do you have the time for it? Let\'s talk if you do.%SPEECH_OFF% | You find %employer% studying a few maps on his desk. He trails a finger to the edge of one map and continues it onto another.%SPEECH_ON%I need an escort for a caravan to %objective%, %days% %direction% of here. Will it be dangerous? Of course. That\'s why I go to you, sellsword. Are you interested?%SPEECH_OFF% | %employer%\'s crosses his arms and purses his lips.%SPEECH_ON%Ordinarily I wouldn\'t ask some sellswords to guard a caravan, but my usual crew is a little out of it - sickness, drunkenness, licentiousness... I think you get it. What\'s important is that I have important cargo going to %objective% about %days% to the %direction% and I need someone watching it. Are you interested?%SPEECH_OFF% | %employer% stares out his window, watching a group of men loading cargo into a number of wagons. He talks without looking your way.%SPEECH_ON%I have an important delivery heading out to %objective% roughly %days% %direction% of here. Unfortunately, a competitor outbid me in acquiring a local band of caravan guards. Now I need your services. Let\'s talk numbers if you\'re interested.%SPEECH_OFF% | %employer% grabs a chest off his shelf and puts it on his desk. When he opens it, a bevy of papers pop out, almost scurrying to get free. He grabs one and lays it out. On one side, there\'s a contract, and the other a small drawing of a map.%SPEECH_ON%It\'s real simple, sellsword. I have been contracted to deliver some... particular cargo to %objective%. I have the goods, but I don\'t have the guards. If you\'re interested in being caravan guards for a time, maybe %days% or so, let me know and we can hash out some numbers.%SPEECH_OFF% | You look out %employer%\'s window and watch men load a few wagons with goods. %employer% joins you, two goblets of wine in hand. You take one and drink it all in one swig. The man stares at you.%SPEECH_ON%That wasn\'t cheap. You\'re supposed to enjoy it.%SPEECH_OFF%You shrug.%SPEECH_ON%Sorry. Can I have another to get it right?%SPEECH_OFF%%employer% turns around and goes to his desk.%SPEECH_ON%So, I need a caravan guarded to %objective%. It\'s %days% to the %direction% of here. Pretty simple, right? There\'s plenty of crowns in it for you if you\'re interested.%SPEECH_OFF% | %employer% looks at some of his books, perusing what appear to be a good deal of numbers.%SPEECH_ON%I got a shipment of particular goods going to %objective% and they\'re leaving soon. I need a bunch of sturdy swordsmen to help make sure it gets there safely. Should take you about %days% of travelling. Are you up for it?%SPEECH_OFF% | %employer% cuts right to the point.%SPEECH_ON%I\'ve got a shipment of... well, what it is doesn\'t concern you. It\'s going to %objective% and, like many folks, I\'m worried about brigands on the road. I need you to watch the caravan to make sure it arrives safe and sound in about %days%. Does that sound something you\'d be interested in?%SPEECH_OFF% | %employer% looks out his window.%SPEECH_ON%We both know that brigands and the gods know what else are terrorizing these parts, and they all are quite fond of the roads. After a particularly bad run, my old caravan guards lost the heart for the job. Now I need someone else to watch my shipment. Next one out is going to %objective% to the %direction%, maybe %days% or so from here. Does that sound like a place you\'d like to be paid to go to?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Parlons argent. | De combien de Couronnes parle-t-on? | Combien ça paie?}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Pas intéressé. | Ce n\'est pas le type de travail que nous recherchons.}",
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
			ID = "TaskSouthern",
			Title = "Negotiations",
			Text = "[img]gfx/ui/events/event_98.png[/img]{Nested in towers and aviaries, bells and birds alike echo in the air like the rattled voluntaries of a caged city. Beneath the noise, in the dull marbled halls of a palace, you find %employer% ordering the death of a servant. The offense is unknown to you, not that it bothers the Vizier in the slightest as he approaches you with a smile and clean hands.%SPEECH_ON%A number of councilmen are sending goods to %objective%, a good %days% to the %direction%. These goods must arrive in a shape that is passable to the awaiting merchants. I believe a Crownling such as yourself can see to this task, yes?%SPEECH_OFF% | You find a few of the councilmen and aldermen of %employer%, the resident Vizier. They approach you with a document stamped with his emblem.%SPEECH_ON%We shall soon be off for to %objective% with a caravan of goods. The city guard refuse to aide us in defending our wares, however we are still bright beneath the Gilder\'s eye, and our pockets full of shine. We\'ll pay you, Crownling, to help us to our destination for the next %days%.%SPEECH_OFF% | A servant boy carries a leash of slaves in one hand and a note in the other. He presents the latter which carries written instruction to meet with a set of merchants. They announce that they are traveling to %objective%, around %days% to the %direction%, under orders of the Gilder and Vizier alike, and need protection. For this, your services are needed and will be paid for quite handsomely. | The town\'s merchant square is rife with business and, apparently, you are wanted to be a part of it. A few of the Vizier\'s \'finest\' peddlers are wanting to take a caravan of goods to %objective%, a good %days% of travel. One explains tersely.%SPEECH_ON%If the Gilder might look the other way, I pray the so-called \'soldiers\' of this town find the world of shade. You, Crownling, I suspect you\'d be willing to help us where others are not? For coin, of course.%SPEECH_OFF% | You watch as slaves bundle goods and load them into a series of wagons. The caravan\'s owners spot you and seek you out, pushing their workforce out of the way or smacking them for apparently no reason at all other than it brings some unknown pleasure to do so. One beams with delight as he greets you. He puts one hand out, but you do not shake it.%SPEECH_ON%Ah, Crownling, it is true that this hand has profaned itself with the flesh of an indebted, but you shouldn\'t be so shy. We are all bright beneath the Gilder\'s eye, are we not? We\'ve a task for you, one of some import given the governance of our suzerain %employer%. The caravan is heading to %objective%, a good %days%\'s travel, and requires a fair bit of guard so that it may arrive in good health. Is this task amenable to your coin-seeking interests?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Parlons argent. | De combien de Couronnes parle-t-on? | Combien ça paie?}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Pas intéressé. | Ce n\'est pas le type de travail que nous recherchons.}",
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
			ID = "StolenGoods1",
			Title = "Along the road...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{A group of men flying the banner of %noblehouse% appear on the road. Their horses are off to the side, their reins pitched to the dirt. Looks like they\'ve been waiting for you. One of them steps forward, hands on his hips.%SPEECH_ON%You are transporting stolen goods, friends. Stolen goods that belong to %noblehouse%. Hand them over immediately or pay the consequences.%SPEECH_OFF%Hmm, you should have known %employer% would be transporting something fishy. | A few men step out onto the road. They carry the banner of %noblehouse% which probably is not a good sign of what\'s to come. Their lieutenant confronts you all.%SPEECH_ON%Greetings! Unfortunately, you are transporting stolen goods that belong to %noblehouse%. Step aside from the caravan, turn back, and go the way you came. Do that, and you live. Stay, and you will die here today.%SPEECH_OFF% | Well, it looks like %employer% wasn\'t completely honest with you: a group of bannermen from %noblehouse% are inquiring as to what you are doing transporting goods that were stolen from them. Their lieutenant shouts at you all.%SPEECH_ON%If you wish to live to see tomorrow, turn over the goods and go back the way you came. I understand you are just doing your jobs. However, your job is not to disobey me. Do that and, I promise, you will all die here today.%SPEECH_OFF% | A man steps out into the road and doesn\'t appear ready to move. One of the caravan drivers seizes up on his reins and just as he does, a large group of other armed men join the loner on the road. They carry the sigil of %noblehouse%.%SPEECH_ON%So, this is where %noblehouse%\'s goods have gone. You fellas are transporting goods which belong to our noble house. If you wish to live, turn them all over. If you wish to die, well, just don\'t do what I ask and see what happens.%SPEECH_OFF%%randombrother% walks up to you, whispering.%SPEECH_ON%We shouldn\'t have trusted that rat %employer%.%SPEECH_OFF% | You really should push harder to learn what you are transporting. A group of men has accosted you on the road, demanding you turn over the caravan and go back the way you came. When you inquire as to whom exactly is making this demand, they state they are from %noblehouse% and that every good you are transporting was stolen a week ago. Their lieutenant makes the option for a peaceful passage clear.%SPEECH_ON%Leave and you shall live. I have no qualms with you people, only with your taskmaster. However, you impede our reacquisitions here and you shall die. Don\'t die over goods that don\'t belong to you. It\'s not worth it.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Banner = "",
			Options = [
				{
					Text = "I don\'t think so. We\'ll defend it if need be.",
					function getResult()
					{
						return "StolenGoods2";
					}

				},
				{
					Text = "We aren\'t paid enough to make enemies of %noblehouse%. Take them.",
					function getResult()
					{
						return "StolenGoods3";
					}

				}
			],
			function start()
			{
				this.Banner = this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).getUIBannerSmall();

				if (this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).getPlayerRelation() >= 80)
				{
					this.Options.push({
						Text = "Your lords won\'t appreciate their allies, the %companyname%, to be held up like this.",
						function getResult()
						{
							return "StolenGoods4";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "StolenGoods2",
			Title = "Along the road...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{You nod.%SPEECH_ON%That sounds well and all, but unfortunately we are being paid to protect these goods, not figure out who they belong to.%SPEECH_OFF%The lieutenant also nods, almost understandingly.%SPEECH_ON%Alright then.%SPEECH_OFF%He draws out his sword. You draw out yours. The man holds up his hand, ready to give the order.%SPEECH_ON%A shame it came to this. Charge!%SPEECH_OFF% | You draw out your sword.%SPEECH_ON%I\'m not here to parlay between noble houses. I\'m here to guard this caravan to %objective%. If you want to get in the way of that then, yes, some people are going to die here today.%SPEECH_OFF% | You throw your hands toward the line of wagons.%SPEECH_ON%%employer%\'s ordered that I guard his goods to their destination. That\'s just what I plan to do.%SPEECH_OFF%Looking at the lieutenant, you slowly unsheathe your sword. He does the same, nodding.%SPEECH_ON%A shame it has to come to this.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Banner = "",
			Options = [
				{
					Text = "To arms!",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos(), true);
						p.CombatID = "StolenGoods";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.IsAutoAssigningBases = false;
						p.TemporaryEnemies = [
							this.Contract.m.NobleHouseID
						];
						p.EnemyBanners = [
							this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).getPartyBanner()
						];

						foreach( e in p.Entities )
						{
							if (e.Faction == this.Contract.getFaction())
							{
								e.Faction = this.Const.Faction.PlayerAnimals;
							}
						}

						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.m.NobleHouseID);
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
				this.Banner = this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "StolenGoods3",
			Title = "Along the road...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{%employer% isn\'t going to like this, but if he was shipping stolen goods he should have told you. With a flick of your hand, you order your men to step aside. The bannermen immediately converge on the caravan, unloading its goods while hapless daytalers and merchants watch on. | You\'re not going to have a nasty fight over goods you could care less about. Stepping aside, you invite the bannermen to take the goods that rightfully belong to them. %randombrother% says %employer% won\'t be happy about this. You nod.%SPEECH_ON%Well, that\'s his problem.%SPEECH_OFF% | You\'re not in the market of transporting stolen goods or killing bannermen who have no qualm with you. Against the protest of a few merchants, you step aside, letting the caravan and its goods Retournez à its rightful owners. One merchant shakes his fist, letting you know that %employer% will be most unhappy to hear you did not own up to your contract.}",
			Image = "",
			List = [],
			Banner = "",
			Options = [
				{
					Text = "Tough luck.",
					function getResult()
					{
						this.Flags.set("IsStolenGoods", false);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to protect a caravan");
						this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).addPlayerRelation(this.Const.World.Assets.RelationNobleContractPoor, "Cooperated with their soldiers");
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.updateAchievement("NeverTrustAMercenary", 1, 1);
				this.Banner = this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "StolenGoods4",
			Title = "Along the road...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{You tell the men that you are good friends with their %noblehouse% and have no intention of souring those relations. One of the attackers is given pause.%SPEECH_ON%Dammit, he could be lying, but if he ain\'t... this isn\'t worth the trouble. Let\'s get out of here.%SPEECH_OFF% | With a few terse words, you tell the men that you\'re quite familiar with the %noblehouse% family, naming a few of the lineage by name. The men settle their swords, not wishing to muddy the situation any further. Better safe than sorry in this world. | You let the men know that you\'re in good with the %noblehouse% family. They ask you to prove it, and you do by telling them every noble name you can, and a little about the particular proclivities of some of them. The proof is sufficient - the attackers put down their weapons and leave you alone.}",
			Image = "",
			List = [],
			Banner = "",
			Options = [
				{
					Text = "We move on!",
					function getResult()
					{
						this.Flags.set("IsStolenGoods", false);
						return 0;
					}

				}
			],
			function start()
			{
				this.Banner = this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).getUIBannerSmall();
			}

		});
		this.m.Screens.push({
			ID = "ValuableCargo1",
			Title = "During camp...",
			Text = "[img]gfx/ui/events/event_55.png[/img]{As the caravan rests, %randombrother% takes you by the arm and secretly leads you to the back of one of the wagons. Peeking around to make sure no one is looking, he lifts the lid on a crate. Gems shuck about inside, shimmering sharply in what little light there is. He closes the lid.%SPEECH_ON%What do you wanna do? That\'s a lot of dosh, sir.%SPEECH_OFF% | While the caravan stops to fix a wagon wheel, an axle snaps and slams the wagon onto its side. A crate clatters out onto the ground, the lid jarring open. You grab a hammer and go to nail it back shut when you notice that a number of gems had spilled out of the box. %randombrother% sees it, too, and puts a hand on his weapon.%SPEECH_ON%That\'s, uh, a particularly loud cargo, sir. Should we keep things quiet or...?%SPEECH_OFF% | The caravan leader begins screaming. You watch as he chases and quickly tackles a man trying to run off. The two spin and spiral into the ground, a tornado of limbs from which flies a brown bag. It lands at your feet and gems shoot from its uncinched opening. %randombrother% leans down and picks a few up. He stands straight, his other hand now on his weapon. He stares at you.%SPEECH_ON%There\'s plenty here to, you know, make it worth it...%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Get back to work before I beat you there. We have a contract to fulfill.",
					function getResult()
					{
						this.Flags.set("IsValuableCargo", false);
						return 0;
					}

				},
				{
					Text = "Finally, luck smiles upon us. We take the gems for ourselves!",
					function getResult()
					{
						return "ValuableCargo2";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ValuableCargo2",
			Title = "During camp...",
			Text = "[img]gfx/ui/events/event_50.png[/img]{A caravan guard comes up.%SPEECH_ON%Hey men, let\'s get this show back on the road, yeah?%SPEECH_OFF%You nod at your mercenary. He nods back, then quickly turns around and spikes a dagger through the guard\'s chin. The rest of the company, realizing what\'s happening, quickly draw their weapons and set upon the guards. They don\'t stand a chance and once the bloodletting is over you are the new owner of some mighty fine gems. | The power of gems overcomes you! With a quick nod and shout, you order the %companyname% to kill all the guards. It\'s a quick process, seeing as how they trusted you to help them, and a few go down still questioning why exactly they were being so brutally betrayed. | Those gems are worth more than any contract could afford you. Shouting as loud as you can, you order the %companyname% to kill every guard in sight. They\'re quick and unquestioning while the guards are slow and confused. It isn\'t but a mere moment later that you are in possession of the gems. %employer% won\'t be happy, but to hell with him, you got gems now.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Those should be worth a pretty crown.",
					function getResult()
					{
						this.Flags.set("IsValuableCargo", false);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationBetrayal, "Slaughtered a caravan tasked to protect");
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
						this.World.Assets.addMoralReputation(-10);
						this.Contract.m.Caravan.die();
						this.Contract.m.Caravan = null;
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				local n = this.Math.min(this.Math.max(1, this.World.Assets.getBusinessReputation() / 1000), 3) + 1;

				for( local i = 0; i != n; i = ++i )
				{
					local gems = this.new("scripts/items/trade/uncut_gems_item");
					this.World.Assets.getStash().add(gems);
					this.List.push({
						id = 10,
						icon = "ui/items/" + gems.getIcon(),
						text = "You gain " + gems.getName()
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Prisoner1",
			Title = "Along the road...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{While moving alongside the caravan, you come across a few guards spitting into a cage. A man dwells inside of it, clothed in rags and muddied feet. He spots you through the thick of hatred and pleads.%SPEECH_ON%Please, sellsword! My name is %noble% of %noblehouse%. You kill all these men and you will be most rewarded!%SPEECH_OFF%One of the guards laughs.%SPEECH_ON%Don\'t believe his lies, mercenary.%SPEECH_OFF% | You walk past a wagon when suddenly something grabs you arm. You wheel around, sword in hand, and the clutching hand reels back into the darkness of the wagon bed. Carefully, you lift the tarp to see a man shackled there. His voice is horrid, as if his first words should have been begging for water.%SPEECH_ON%Ignore the rags upon me, mercenary, for I am %noble% of %noblehouse%. Kill every one of these guards, free me, and ensure I get home. For that, I shall see to it that you are appropriately compensated.%SPEECH_OFF%A guard interrupts his speech, the prisoner shrinking back into his holding. The guard laughs.%SPEECH_ON%Has that little bastard been spreading lies again? Let\'s go, mercenary, we\'ve more road yet ahead of us.%SPEECH_OFF% | You hear retching coming from one of the wagons. Investigating, you come across a man in rags, keeled over with a guard grinning overhead.%SPEECH_ON%Speak to me in that tone again and you\'ll be shitting your teeth. Got it, prisoner?%SPEECH_OFF%The downed man nods and scoots back. He sees you then nods weakly.%SPEECH_ON%Sellsword, I am %noble% of %noblehouse%. I\'m sure you\'ve heard my name. If you kill this weak fark here and all the rest of his like, then I will see to it that you are rewarded most handsomely.%SPEECH_OFF%The guard smiles nervously.%SPEECH_ON%Don\'t give purchase to a word that man says, sellsword!%SPEECH_OFF% | %SPEECH_ON%Mercenary! Might I have a word?%SPEECH_OFF%You turn to, surprisingly, find a man in the back of one of the wagons. He\'s covered in chains.%SPEECH_ON%I\'ll have you know that I am %noble% of %noblehouse%. Clearly I am in a wee bit of trouble, but that shan\'t stop you, right? Kill all these guards and return me to my family. I think they will pay a fair bit more than whatever you\'ll get for keeping an eye on this shitstain of a caravan.%SPEECH_OFF%One of the guards walks up, laughing.%SPEECH_ON%Oy, is the varmint spitting lies again? Pay his dribble no mind, sellsword. C\'mon, let\'s get back to work.%SPEECH_OFF% | You hear the distinct sound of chains, that uncoiling brittleness that the links make, the snickering of metal that makes one think they could so easily be free. Instead, a very not-free man pleads at you.%SPEECH_ON%Finally, I can get a word with you. Sellsword, look, you may not believe this but I am %noble% of %noblehouse%. I know not why these men have taken me, but it doesn\'t matter. What matters is that you own up to your name, particularly the \'sell\' part. If you kill all these guards and take me home, I\'ll ensure you are rewarded handsomely!%SPEECH_OFF%A guard walks up.%SPEECH_ON%Quiet down ye bastard! Pay him no mind, mercenary. We\'ve got work to do, c\'mon.%SPEECH_OFF% | When the caravan takes a quick break, you come to find a man resting with his leg dangling from the bed of a wagon. Except his feet aren\'t free - they are bound together by chains and his arms in no better of a state. He sees you.%SPEECH_ON%You recognize me? I am %noble% of %noblehouse%, a prisoner of some value, as I\'m sure my name alludes. But as a freed man I am of even greater value. Kill these guards, take me home, and you won\'t be able to walk you\'ll have so many crowns in your pockets!%SPEECH_OFF%A guard walks up and slaps his scabbard against the man\'s shins.%SPEECH_ON%Quiet, you! Come on, mercenary, we\'re about ready to hit the road again. And pay this bastard no mind, would ya? He\'s got nothing but lies for you.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Don\'t waste your breath. I don\'t give a shite who you are.",
					function getResult()
					{
						this.Flags.set("IsPrisoner", false);
						return 0;
					}

				},
				{
					Text = "This better be worth it. I\'ll hold you to your promises once I\'ve freed you.",
					function getResult()
					{
						this.updateAchievement("NeverTrustAMercenary", 1, 1);
						return "Prisoner2";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Prisoner2",
			Title = "Along the road...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{You spit and clear you throat, then you quickly clear your sword of its sheath and strike the caravan guard down. %randombrother% sees this and quickly barks out an order for the rest of the %companyname% to follow suit. There\'s a brief, confused carnage, the caravan guards unsure of what\'s going on as your men set upon them.\n\n Freeing the prisoner, he thanks you profusely then tells you to lead the way.%SPEECH_ON%Once we get to %noblesettlement%, and they see my lively and grinning face, you will be washed in crowns!%SPEECH_OFF% | You draw your sword and slash the guard across the face. He spins around and you crash the blade of your weapon through his brainpain, his organ frothing between slanted boneshards like a burst souffle. %randombrother% sees this and calls the rest of the company to combat. They make short work of the rest of the caravan guards. When you free %noble%, he points down the road.%SPEECH_ON%To %noblesettlement% where my family shall reward you like you cannot believe!%SPEECH_OFF% | As the caravan guard turns around, you take a dagger and jam it beneath his arm pit and directly into his heart. He muffles something, then falls to the ground. Another guard comes around, sees this, then sees your sword disembowel him. His cries, however, are not muffled. A battle soon commences, though it is completely lopsided as the %companyname% makes short work of the caravan guards.\n\n Once it is all said and done, %noble% is freed. Rubbing his purpled wrists, he points you toward %noblesettlement%.%SPEECH_ON%Onward, return me to my family so that I can fill your pockets for this incredible bravery!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "I see my pocket filled with crowns already!",
					function getResult()
					{
						this.Flags.set("IsPrisoner", false);
						this.Flags.set("IsPrisonerLying", this.Math.rand(1, 100) <= 33);
						this.Contract.setState("Running_Prisoner");
						this.World.State.setCampingAllowed(true);
						this.World.State.getPlayer().setVisible(true);
						this.World.Assets.setUseProvisions(true);

						if (!this.World.State.isPaused())
						{
							this.World.setSpeedMult(1.0);
						}

						this.World.State.m.LastWorldSpeedMult = 1.0;
						this.Contract.m.Caravan.die();
						this.Contract.m.Caravan = null;
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationAttacked, "Slaughtered a caravan tasked to protect");
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
						this.World.Assets.addMoralReputation(-5);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Prisoner3",
			Title = "At %noblesettlement%",
			Text = "[img]gfx/ui/events/event_31.png[/img]{You reach %noblesettlement%. A well-armored guard spies %noble% and shouts an order that is quickly barked further and further into the town. Soon, a few horses race up, their riders quickly dismounting. It appears the man was not lying after all. %noblehouse% rewards you just as the prisoner promised they would. | Before you can even enter %noblesettlement%, a few riders come out to meet you. They\'ve got royal cloths flying in the wind behind them. There\'s a large contingent of heavily armed guards not far off, either. Little speculation is needed as they quickly welcome the prisoner back into their ranks. One of them returns from the frenzy of a good welcome home to hand you your reward. They say little else to the lowborn responsible for keeping the highborn\'s head on his shoulders. Oh well. | The prisoner wasn\'t lying, but you get a quick refreshment to keep your place in society: a very heavily armed guard hands you your reward. Even though you rescued one of their bloodline, it appears %noblehouse% wants no part in talking to you themselves. It is what it is.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "A good payday at least.",
					function getResult()
					{
						this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).addPlayerRelation(this.Const.World.Assets.RelationFavor, "Freed an imprisoned member of the house");
						this.World.Assets.addMoney(3000);
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
					text = "You are rewarded with [color=" + this.Const.UI.Color.PositiveValue + "]3000[/color] Crowns"
				});
				this.List.push({
					id = 10,
					icon = "ui/icons/relations.png",
					text = "Your relations to " + this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).getName() + " improve"
				});
			}

		});
		this.m.Screens.push({
			ID = "Prisoner4",
			Title = "At %noblesettlement%",
			Text = "[img]gfx/ui/events/event_31.png[/img]{As you near %noblesettlement%, %noble% darts off behind some bushes.%SPEECH_ON%Excuse me, fair friends, for I\'ve a shite to take.%SPEECH_OFF%You nod and wait. And wait. And wait. Realizing your mistake, you dart behind the bush to see the man completely gone and there\'s shit on your shoes. | %noble% asks that you stop. He darts to a creekbed.%SPEECH_ON%Hold on, men. Lemme clean up so that my family shan\'t have to see me in such a sorry state!%SPEECH_OFF%Makes sense. You leave the man to it, but when you Retournez à check on him he\'s gone. Muddied footprints lead up a hill and you follow them. The other side reveals a field of farmers and a thick crop through which any liar could easily slip. %randombrother% joins your side.%SPEECH_ON%Fark.%SPEECH_OFF%Fark indeed. | There\'s a few peasants along the road to %noblesettlement%. They\'re giving each other haircuts and this seems to capture the attention of %noble%.%SPEECH_ON%Excuse me, men, for I need to clean up. Won\'t want the old lady seeing me in this state, ya know.%SPEECH_OFF%You nod and go to count inventory to pass the time. When you Retournez à the peasants you ask where the nobleman is gone. One stares at you.%SPEECH_ON%I ain\'t seen no nobleman.%SPEECH_OFF%You explain he was dressed in rags, then quickly describe him. They shrug.%SPEECH_ON%I saw that bugger run into the fields yonder, then get on a horse, then ride further and further yonder. We thought him wrong in the head seeing as how he t\'was laughing the whole time.%SPEECH_OFF%Anger overcomes you. | You bring %noble% to %noblesettlement%. He\'s almost shaking when you enter the town.%SPEECH_ON%Ah, I\'m just a bit nervous.%SPEECH_OFF%None of the guards recognize the man, but that\'s easily forgiven considering his state of dress. You walk up to a very well-armored man and ask him to bring someone from the noble family. He tilts toward you, barely leaving his station of upright guardsmanship.%SPEECH_ON%And for whom am I calling their attention?%SPEECH_OFF%You turn and point.%SPEECH_ON%Why, it\'s... that... uh...%SPEECH_OFF%%noble% is nowhere to be seen. You glance around. %randombrother%\'s attention is taken by a wench and the rest of the company is milling about. A throng of townspeople move to and fro, a grey wash into which a liar could so easily disappear. You ball your hands into fists. The guard pushes you back.%SPEECH_ON%If you have no business here, then I ask you to leave the premises or we shall remove you by force.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Damnit!",
					function getResult()
					{
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Vampires1",
			Title = "Along the road...",
			Text = "[img]gfx/ui/events/event_33.png[/img]{While the caravan is stopped for a rest, you hear an odd noise, like a man biting into an apple and sucking in the juices. Walking autour de end of a cart, you find a pale figure drooped over a dead caravan guard, the strange creature\'s fangs plunged deep into the man\'s neck. You can see the flesh lifting to the bite, the bloodslaked creature grinning as it drinks.\n\n Drawing your sword, you scream out to your mercenaries.%SPEECH_ON%Foul beasts! To arms, men!%SPEECH_OFF% | The lid of a box shifts around. You stare at it, exchanging a glance with a caravan guard.%SPEECH_ON%Y\'all shipping dogs around?%SPEECH_OFF%Suddenly, the box lid explodes, splinters cascading from a source of great, angry power. Moaning, a creature rises up from the box, arms crossed over its chest. The face is pale, the skin taut and clearly cold. That\'s... a...\n\n The caravan guard runs away shouting.%SPEECH_ON%The cargo is loose! The cargo is loose!%SPEECH_OFF%Cargo? Who would dare call such horrors \'cargo\'? | You watch as one of the caravan guards lifts a cat from a crate. The creature mewls as its legs dangle, kicking around for some footing, and then angrily kicking around to scratch what has lofted it just so. Interested, you inquire as to what the man is doing. He shrugs, lifting up the lid of a box and dropping the cat in.%SPEECH_ON%Feeding.%SPEECH_OFF%The cat shrieks, its feline squalls as fierce as its fight, but soon enough you hear nothing at all. Just as the caravan guard turns to leave the box, its lid bursts open and a pale creature shifts upward, almost incorporeal in its movement, and closes its arms autour de man. It plunges its fangs into his neck. The guard\'s neck glows purple, then quickly begins to fade, his veins pressing out of his forehead as if trying to help his blood escape consumption.\n\n Backing away, you draw out your sword and alert your men to this newfound horror. | While taking a rest, a young caravan guard almost sneaks up on you.%SPEECH_ON%Hey sellsword, wanna see something?%SPEECH_OFF%You\'ve got the time and time\'s got you bored, so yeah, of course you do. He takes you to one of the carts and lifts back a lid on a box. A pale figure is inside, arms crossed over its chest, its face colorless and taut in some sleepy content. You jump back, though, because that\'s no ordinary corpse. The caravan guard laughs.%SPEECH_ON%What, ya a little scared of the dead?%SPEECH_OFF%And just then, the creature\'s arm shoots up, grabbing the kid and dragging him into the box. You don\'t bother saving the idiot, but instead go to rally the battle brothers, all the while more boxes springing open all around you as you run. | Resting beside the road, you hear a horrid scream somewhere down the line of wagons. Drawing your sword, you quickly rush to the noise. A caravan guard limps past you, clutching his neck. His eyes are wide, his mouth frozen agape and speechless.%SPEECH_ON%They got out! They got out!%SPEECH_OFF%Another guard sprints by, not even bothering to stop to help the other. You look ahead to see a group of pale figures leaping from guard to guard, wrapping black cloaks autour deir victims to shade them into gruesome deaths. Before they can get to you, you turn back and alert the company of this horrifying danger. | While the wagontrain takes a break, you go around to check the carts and make sure everything is tidied up. The last wagon, though, is tilted into the ground, its draught animal dead in the mud. Nearby are two dead guards. They are completely white, yet posed in a freshly manner. Taking your gaze up, you find blood-faced creatures hunched atop the wagon, and they\'ve got men dangling from their mouths!\n\n%randombrother% comes up behind you, weapon in hand, and pushes you back.%SPEECH_ON%Let\'s alert the men, sir!%SPEECH_OFF%That\'s about as good of an idea as one can have at the moment. You shout as loud as you can, ushering the rest of your men to combat. | You go to take a piss when a horrid shriek gives you pause. Dressing yourself, you turn back around and rush to the disturbance. There you find a caravan guard falling forward, his legs scissoring and stumbling before he falls on his face. Behind him, a pale creature is wiping blood from its mouth. And on the wagons there are boxes opening up, pallid shapes rising up out of them with bloodlust in their eyes.\n\n You\'ve seen more than enough and go to alert the men.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Defend the caravan!",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos(), true);
						p.CombatID = "Vampires";
						p.Music = this.Const.Music.UndeadTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Vampires, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
						this.World.Contracts.startScriptedCombat(p, false, false, false);
						return 0;
					}

				},
				{
					Text = "Run for your lives! Run! Run!",
					function getResult()
					{
						this.Contract.m.Caravan.die();
						this.Contract.m.Caravan = null;
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to protect a caravan");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "At %objective%",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Reaching %objective%, the caravan leader turns to you, a large satchel in hand.%SPEECH_ON%Thanks for getting us here, sellsword.%SPEECH_OFF%You take it and hand it over to %randombrother% for counting. He nods when he\'s finished. The caravan leader smiles.%SPEECH_ON%Also thanks for not betraying us and, you know, slaughtering us to a man and all that.%SPEECH_OFF%Mercenaries get thanked in the strangest ways. | Having reached %objective%, the caravan\'s wagons are immediately unloaded and their goods taken to a nearby warehouse. Once it\'s all cleared out, the leader of the group hands you a satchel of crowns and thanks you for making sure their passage was a safe one. | %objective% greets you with a swarm of daytalers looking for work. The caravan leader doles out crowns to men here and there, their grubby hands going to the carts to unload the cargo. When he\'s finished with the throngs of men, the leader turns to you. He\'s got a satchel in hand.%SPEECH_ON%And this is for you, mercenary.%SPEECH_OFF%You take it. A few of the daytalers watch the exchange of monies like cats would a dangling mouse. | You\'ve made it, having delivered the caravan just as you\'d promised %employer% you would. The caravan leader thanks you with a payment of crowns. He seems rather thankful for the fact that he\'s alive, briefly regaling you with a tale of when he barely escaped an ambush by brigands. You nod as if you give two shits about what\'s happened to this man. | The wagontrain drives into %objective%, each cart bumbling and tumbling their tall wheels over mounds of dried mud. The caravan hands work to unload the cargo, a few of them fighting off a beggar or two. The leader of the train hands you a satchel and that\'s about all he does. He\'s too busy with his work to say much more to you. The silence is appreciated. | Reaching %objective%, the caravan leader strikes up a conversation as if you two might have something in common. He talks of his younger days, when he was a spry young man who could have done this or that. He, apparently, missed out on a lot of fighting. What a shame. Bored with his talk, you ask the man to pay you so you can get on out of this wretched place.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Crowns well deserved.",
					function getResult()
					{
						local money = this.Contract.m.Payment.getOnCompletion() + this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected");
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(money);

						if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getType() == this.Const.FactionType.OrientalCityState)
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Protected a caravan as promised");
						}
						else
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Protected a caravan as promised");
						}

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
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/well_supplied_situation"), 3, this.Contract.m.Destination, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "At %objective%",
			Text = "[img]gfx/ui/events/event_04.png[/img]{You have to wonder if a place like %objective% is worth losing some lives over. You did get there, but not every cart made it. The leader of the wagon train walks up to with a somewhat lighter than expected satchel in hand.%SPEECH_ON%I\'d pay you more, sellsword, because I know perfection in this world ain\'t easy, but %employer% insisted I make subtractions based on... well, our losses. Surely you understand?%SPEECH_OFF%He seems fearful that you will carry out some retribution on him, but you simply take the money and go. Business is business. | Reaching %objective%, the caravan leader turns to you, satchel in hand.%SPEECH_ON%It\'s lighter than you expected.%SPEECH_OFF%It is. He continues.%SPEECH_ON%Not every cart made it.%SPEECH_OFF%They didn\'t.%SPEECH_ON%I\'m just the messenger for %employer%. Please don\'t kill me.%SPEECH_OFF%You won\'t. Although... nah. | Having reached %objective%, the leader of the wagon train has the caravan hands begin unloading the goods. They\'re a few men short, and a few carts short as well. Coming to you with the payment, the leader explains the situation.%SPEECH_ON%%employer% made sure I pay you according to the product that arrived. Unfortunately, we lost some...%SPEECH_OFF%You nod and take the reward. A deal is a deal, after all. | The head of the wagon train almost seems to cry as you reach %objective%. He says he lost some good men back there, and the lost carts will cost them dearly going into the future. You don\'t care, but you offer him the support of a solitary nod.%SPEECH_ON%I guess I should thank you anyway, sellsword. We didn\'t all die, after all. Unfortunately... I can only pay you so much. %employer% demanded any losses come out of your pocket.%SPEECH_OFF%You nod again and take what payment you have earned.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "That didn\'t go well...",
					function getResult()
					{
						local money = this.Contract.m.Payment.getOnCompletion() + this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected");
						money = this.Math.floor(money / 2);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(money);

						if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getType() == this.Const.FactionType.OrientalCityState)
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractPoor, "Protected a caravan, albeit poorly");
						}
						else
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractPoor, "Protected a caravan, albeit poorly");
						}

						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				local money = this.Contract.m.Payment.getOnCompletion() + this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected");
				money = this.Math.floor(money / 2);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "Après la bataille",
			Text = "[img]gfx/ui/events/event_60.png[/img]{You started the journey in the company of caravan hands and a few merchants all of whom trusted you. Now, their bodies are strewn across the land, arms outstretched, fingers danced upon by flies. The sun will make a ruinous smell out of your failure. Time to move on. | Wagons lay on their sides. Men and limbs are scattered. A moan rises from the ruin, but it is a dying one as you never hear it again. Dark shadows ripple over the grass, above you a growing flock of buzzards. Best to let them feast for there is nothing else you can do here. | The merchant who hired you lies dead at your feet. He is not exactly face down, for that part of him no longer exists. Blood flows across the ground in spurts as you can\'t help but stare at the summation of your failure. One of your men spots a twitch, but you know better. Nothing can be done. The rest of the caravan is in even worse shape. There is no point in staying here. | The battle subsides, but you find the merchant leaning against a tipped-over wagon. Wide-eyed he desperately clutches a slashed neck. Ropes of blood squirt between his fingers and before anything can be done the man collapses. You try to revive him, but it is too late. Glassy eyes look up at you. %randombrother%, one of your men, closes them before getting up to pick through the remains of the caravan. | You stumble autour de remains of the wagons. It isn\'t hard to see: the merchant\'s head had been stoved in by some kind of chest, perhaps the very thing behind which he sought protection during the heat of battle. Alas, none of the caravan is in better shape. The battle had proved vicious, even by your standards, and the resulting carnage has a few of your brothers heaving. If the nightmares come then let them come. You deserve little else for your failure.}",
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

						if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getType() == this.Const.FactionType.OrientalCityState)
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Failed to protect a caravan");
						}
						else
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to protect a caravan");
						}

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

		if (!_actor.isAlliedWithPlayer() && !_actor.isResurrected())
		{
			this.m.Flags.set("HeadsCollected", this.m.Flags.get("HeadsCollected") + 1);
		}
	}

	function spawnCaravan()
	{
		local faction = this.World.FactionManager.getFaction(this.getFaction());
		local party;

		if (faction.hasTrait(this.Const.FactionTrait.OrientalCityState))
		{
			party = faction.spawnEntity(this.m.Home.getTile(), "Trading Caravan", false, this.Const.World.Spawn.CaravanSouthernEscort, this.m.Home.getResources() * this.Math.rand(10, 25) * 0.01);
		}
		else
		{
			party = faction.spawnEntity(this.m.Home.getTile(), "Trading Caravan", false, this.Const.World.Spawn.CaravanEscort, this.m.Home.getResources() * 0.4);
		}

		party.getSprite("banner").Visible = false;
		party.getSprite("base").Visible = false;
		party.setMirrored(true);
		party.setDescription("A trading caravan from " + this.m.Home.getName() + " that is transporting all manner of goods between settlements.");
		party.setMovementSpeed(this.Const.World.MovementSettings.Speed * 0.6);
		party.setLeaveFootprints(false);

		if (this.m.Home.getProduce().len() != 0)
		{
			for( local j = 0; j != 3; j = ++j )
			{
				party.addToInventory(this.m.Home.getProduce()[this.Math.rand(0, this.m.Home.getProduce().len() - 1)]);
			}
		}

		party.getLoot().Money = this.Math.rand(0, 100);
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(this.m.Destination.getTile());
		move.setRoadsOnly(true);
		local unload = this.new("scripts/ai/world/orders/unload_order");
		local despawn = this.new("scripts/ai/world/orders/despawn_order");
		local wait = this.new("scripts/ai/world/orders/wait_order");
		wait.setTime(4.0);
		c.addOrder(move);
		c.addOrder(unload);
		c.addOrder(wait);
		c.addOrder(despawn);
		this.m.Caravan = this.WeakTableRef(party);
	}

	function spawnEnemies()
	{
		local tries = 0;
		local myTile = this.m.Destination.getTile();
		local tile;

		while (tries++ == 0)
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
			local goblins_dist = nearest_goblins != null ? nearest_bandits.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local orcs_dist = nearest_orcs != null ? nearest_bandits.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local barbarians_dist = nearest_barbarians != null ? nearest_barbarians.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local nomads_dist = nearest_nomads != null ? nearest_nomads.getTile().getDistanceTo(tile) + this.Math.rand(0, 10) : 9000;
			local party;
			local origin;

			if (bandits_dist <= goblins_dist && bandits_dist <= orcs_dist && bandits_dist <= barbarians_dist && bandits_dist <= nomads_dist)
			{
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).spawnEntity(tile, "Brigands", false, this.Const.World.Spawn.BanditRaiders, this.Math.rand(80, 100) * this.getDifficultyMult() * this.getScaledDifficultyMult());
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
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).spawnEntity(tile, "Goblin Raiders", false, this.Const.World.Spawn.GoblinRaiders, this.Math.rand(80, 100) * this.getDifficultyMult() * this.getScaledDifficultyMult());
				party.setDescription("A band of mischievous goblins, small but cunning and not to be underestimated.");
				party.setFootprintType(this.Const.World.FootprintsType.Goblins);
				party.getLoot().ArmorParts = this.Math.rand(0, 10);
				party.getLoot().Medicine = this.Math.rand(0, 2);
				party.getLoot().Ammo = this.Math.rand(0, 30);
				local r = this.Math.rand(1, 4);

				if (r == 1)
				{
					party.addToInventory("supplies/strange_meat_item");
				}
				else if (r == 2)
				{
					party.addToInventory("supplies/roots_and_berries_item");
				}
				else if (r == 3)
				{
					party.addToInventory("supplies/pickled_mushrooms_item");
				}

				origin = nearest_goblins;
			}
			else if (barbarians_dist <= goblins_dist && barbarians_dist <= bandits_dist && barbarians_dist <= orcs_dist && barbarians_dist <= nomads_dist)
			{
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).spawnEntity(tile, "Barbarians", false, this.Const.World.Spawn.Barbarians, this.Math.rand(80, 100) * this.getDifficultyMult() * this.getScaledDifficultyMult());
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
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).spawnEntity(tile, "Nomads", false, this.Const.World.Spawn.NomadRaiders, this.Math.rand(80, 100) * this.getDifficultyMult() * this.getScaledDifficultyMult());
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
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).spawnEntity(tile, "Orc Marauders", false, this.Const.World.Spawn.OrcRaiders, this.Math.rand(80, 100) * this.getDifficultyMult() * this.getScaledDifficultyMult());
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
		local days = this.getDaysRequiredToTravel(this.m.Flags.get("Distance"), this.Const.World.MovementSettings.Speed * 0.6, true);
		_vars.push([
			"objective",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.m.Destination.getName()
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Destination.getTile())]
		]);
		_vars.push([
			"noblehouse",
			this.World.FactionManager.getFaction(this.m.NobleHouseID).getName()
		]);
		_vars.push([
			"noble",
			this.m.Flags.get("NobleName")
		]);
		_vars.push([
			"noblesettlement",
			this.m.NobleSettlement == null || this.m.NobleSettlement.isNull() ? "" : this.m.NobleSettlement.getName()
		]);
		_vars.push([
			"nobledirection",
			this.m.NobleSettlement == null || this.m.NobleSettlement.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.NobleSettlement.getTile())]
		]);
		_vars.push([
			"killcount",
			this.m.Flags.get("HeadsCollected")
		]);
		_vars.push([
			"days",
			days <= 1 ? "un jour" : days + " jours"
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

			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
			}

			if (this.m.NobleSettlement != null && !this.m.NobleSettlement.isNull())
			{
				this.m.NobleSettlement.getSprite("selection").Visible = false;
			}
		}
	}

	function onIsValid()
	{
		if (this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive() || !this.m.Destination.isAlliedWith(this.getFaction()))
		{
			return false;
		}

		return true;
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

		if (this.m.Caravan != null && !this.m.Caravan.isNull())
		{
			_out.writeU32(this.m.Caravan.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		_out.writeU32(this.m.NobleHouseID);
		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		local caravan = _in.readU32();

		if (caravan != 0)
		{
			this.m.Caravan = this.WeakTableRef(this.World.getEntityByID(caravan));
		}

		this.m.NobleHouseID = _in.readU32();

		if (!this.m.Flags.has("Distance"))
		{
			this.m.Flags.set("Distance", 0);
		}

		if (!this.m.Flags.has("HeadsCollected"))
		{
			this.m.Flags.set("HeadsCollected", 0);
		}

		this.contract.onDeserialize(_in);

		if (this.m.Flags.has("NobleSettlement"))
		{
			local e = this.World.getEntityByID(this.m.Flags.get("NobleSettlement"));

			if (e != null)
			{
				this.m.NobleSettlement = this.WeakTableRef(e);
			}
		}
	}

});


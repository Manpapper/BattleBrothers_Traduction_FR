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
		this.m.Name = "Escorte de Caravane";
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
					"Escortez la caravane jusqu\'?? %objective% ?? environ %days% %direction%",
					"Des provisions pour la route sont donn??s ?? vos hommes"
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

					this.Contract.m.BulletpointsObjectives.push("Soyez pay?? pour la t??te de chaque attaquant que vous tu??s (%killcount%/%maxcount%)");
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
					"Raccompagnez %noble% sain et sauf ?? %noblesettlement% %nobledirection%"
				];
				this.Contract.m.BulletpointsPayment = [];
				this.Contract.m.BulletpointsPayment.push("Vous recevez une r??compense en arrivant");
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
			Title = "N??gociations",
			Text = "[img]gfx/ui/events/event_98.png[/img]{Le bureau de %employer% est ??clair?? par un feu chaleureux. Il vous offre un si??ge et un gobelet de vin, que vous prenez tous les deux.%SPEECH_ON%Mercenaire, vous savez ?? quel point les routes sont dangereuses de nos jours ?%SPEECH_OFF%Par les dieux, c\'est du bon vin. Vous acquiescez et tentez de cacher votre ??tonnement. %employer% sourit s??chement et poursuit.%SPEECH_ON%Bien, alors vous comprendrez la t??che que j\'ai pour vous. J\'ai besoin qu\'une caravane soit escort??e sur les routes jusqu\'?? %objective% ?? environ %days% d\'ici. Plut??t simple, non ? Avez-vous le temps de le faire ? Si c\'est le cas, parlons-en.%SPEECH_OFF% | Vous trouvez %employer% en train d\'??tudier quelques cartes sur son bureau. Il laisse tra??ner un doigt sur le bord d\'une carte et le poursuit sur une autre.%SPEECH_ON%J\'ai besoin d\'une escorte pour une caravane jusqu\'?? %objective%, %days% %direction% d\'ici. ??a sera dangereux ? Bien s??r. C\'est pourquoi je m\'adresse ?? vous, mercenaire. ??tes-vous int??ress?? ?%SPEECH_OFF% | %employer% croise les bras et pince les l??vres.%SPEECH_ON%D\'ordinaire, je ne demanderais pas ?? des mercenaires de garder une caravane, mais mon personnel habituel n\'est pas au point - maladie, ivrognerie, d??bauche... Je pense que vous l\'avez compris. Ce qui est important, c\'est que j\'ai une cargaison importante ?? destination de %objective% ?? environ %days%  %direction% et j\'ai besoin de quelqu\'un pour la surveiller. Vous ??tes int??ress?? ?%SPEECH_OFF% | %employer% regarde par la fen??tre un groupe d\'hommes qui chargent des marchandises dans plusieurs wagons. Il parle sans regarder dans votre direction.%SPEECH_ON%J\'ai une livraison importante en route vers %objective% ?? environ %days% %direction% d\'ici. Malheureusement, un concurrent a surench??ri en acqu??rant une bande locale de gardes de caravanes. J\'ai donc besoin de vos services. Parlons chiffres si vous ??tes int??ress??s.%SPEECH_OFF% | %employer% prend un coffre sur son ??tag??re et le pose sur son bureau. Quand il l\'ouvre, une multitude de papiers en sortent, se pr??cipitant presque pour se lib??rer. Il en saisit un et l\'??tale. D\'un c??t??, il y a un contrat, de l\'autre le dessin d\'une carte.%SPEECH_ON%C\'est tr??s simple, mercenaire. J\'ai ??t?? engag?? pour livrer une... cargaison particuli??re ?? %objective%. J\'ai la marchandise, mais je n\'ai pas les gardes. Si vous ??tes int??ress??s pour devenir des gardes de la caravane pour un temps, peut-??tre %days% ou plus, faites-le moi savoir et nous pourrons discuter des chiffres.%SPEECH_OFF% | Vous regardez par la fen??tre de %employer% et vous voyez des hommes charger quelques chariots de marchandises. %employer% vous rejoint, deux gobelets de vin ?? la main. Vous en prenez un et le buvez d\'un trait. L\'homme vous regarde fixement.%SPEECH_ON%Ce n\'??tait pas donn??. Vous ??tes cens?? en profiter.%SPEECH_OFF%Vous haussez les ??paules.%SPEECH_ON%D??sol??. Je peux en avoir un autre pour que ce soit bien ?%SPEECH_OFF%%employer% se retourne et va ?? son bureau.%SPEECH_ON%Donc, j\'ai besoin d\'une caravane gard??e jusqu\'?? %objective%. C\'est ?? %days%  %direction% d\'ici. Plut??t simple, non ? Il y a plein de couronnes pour vous si vous ??tes int??ress??s.%SPEECH_OFF% | %employer% regarde certains de ses livres, parcourant ce qui semble ??tre une bonne quantit?? de chiffres.%SPEECH_ON%J\'ai une cargaison de marchandises particuli??res ?? destination de %objective% et elles partent bient??t. J\'ai besoin d\'un groupe d\'??p??istes robustes pour m\'aider ?? faire en sorte qu\'elle arrive ?? bon port. Cela devrait vous prendre environ %days% de voyage. ??tes-vous pr??t ?? le faire ?%SPEECH_OFF% | %employer% va droit au but.%SPEECH_ON%J\'ai une cargaison de... eh bien, ce que c\'est ne vous concerne pas. Elle est ?? destination de %objective% et, comme beaucoup de gens, je m\'inqui??te des brigands sur la route. J\'ai besoin que vous surveilliez la caravane pour vous assurer qu\'elle arrive saine et sauve dans environ %days%. Est-ce que cela vous int??resse ?%SPEECH_OFF% | %employer% regarde par sa fen??tre.%SPEECH_ON%Nous savons tous deux que les brigands et les dieux savent quoi d\'autre terrorisent ces r??gions, et ils sont tous assez friands des routes. Apr??s une course particuli??rement mauvaise, mes anciens gardes de caravane ont perdu le c??ur ?? l\'ouvrage. Maintenant j\'ai besoin de quelqu\'un d\'autre pour surveiller ma cargaison. Le prochain d??part se fera vers %objective% %direction%, peut-??tre %days% d\'ici. Est-ce que ??a ressemble ?? un endroit o?? vous aimeriez ??tre pay?? pour aller ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Parlons argent. | De combien de Couronnes parle-t-on? | Combien ??a paie?}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Pas int??ress??. | Ce n\'est pas le type de travail que nous recherchons.}",
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
			Title = "N??gociations",
			Text = "[img]gfx/ui/events/event_98.png[/img]{Nich??s dans des tours et des voli??res, les cloches et les oiseaux font ??cho dans l\'air comme les cliquetis d\'une ville en cage. Sous le bruit, dans les salles marbr??es d\'un palais, vous trouvez %employer% ordonnant la mort d\'un serviteur. Vous ne savez pas de quoi il s\'agit, mais cela ne d??range pas le Vizir qui s\'approche de vous avec un sourire et les mains propres.%SPEECH_ON%Un certain nombre de marchands envoient des marchandises ?? %objective%, ?? %days%  %direction%. Ces marchandises doivent arriver sous une forme qui soit encore vendable pour les marchands sur place. Je crois qu\'un mercenaire tel que vous peut s\'acquitter de cette t??che, non ?%SPEECH_OFF% | You find a few of the councilmen and aldermen of %employer%, the resident Vizier. They approach you with a document stamped with his emblem.%SPEECH_ON%We shall soon be off for to %objective% with a caravan of goods. The city guard refuse to aide us in defending our wares, however we are still bright beneath the Gilder\'s eye, and our pockets full of shine. We\'ll pay you, Crownling, to help us to our destination for the next %days%.%SPEECH_OFF% | A servant boy carries a leash of slaves in one hand and a note in the other. He presents the latter which carries written instruction to meet with a set of merchants. They announce that they are traveling to %objective%, around %days% to the %direction%, under orders of the Gilder and Vizier alike, and need protection. For this, your services are needed and will be paid for quite handsomely. | The town\'s merchant square is rife with business and, apparently, you are wanted to be a part of it. A few of the Vizier\'s \'finest\' peddlers are wanting to take a caravan of goods to %objective%, a good %days% of travel. One explains tersely.%SPEECH_ON%If the Gilder might look the other way, I pray the so-called \'soldiers\' of this town find the world of shade. You, Crownling, I suspect you\'d be willing to help us where others are not? For coin, of course.%SPEECH_OFF% | You watch as slaves bundle goods and load them into a series of wagons. The caravan\'s owners spot you and seek you out, pushing their workforce out of the way or smacking them for apparently no reason at all other than it brings some unknown pleasure to do so. One beams with delight as he greets you. He puts one hand out, but you do not shake it.%SPEECH_ON%Ah, Crownling, it is true that this hand has profaned itself with the flesh of an indebted, but you shouldn\'t be so shy. We are all bright beneath the Gilder\'s eye, are we not? We\'ve a task for you, one of some import given the governance of our suzerain %employer%. The caravan is heading to %objective%, a good %days%\'s travel, and requires a fair bit of guard so that it may arrive in good health. Is this task amenable to your coin-seeking interests?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Parlons argent. | De combien de Couronnes parle-t-on? | Combien ??a paie?}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Pas int??ress??. | Ce n\'est pas le type de travail que nous recherchons.}",
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
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{Un groupe d\'hommes portant la banni??re de %noblehouse% appara??t sur la route. Leurs chevaux sont sur le c??t??, les chevaux sont attach??s On dirait qu\'ils vous attendaient. L\'un d\'eux s\'avance, les mains sur les hanches.%SPEECH_ON%Vous transportez des biens vol??s, mes amis. Des biens vol??s qui appartiennent ?? %noblehouse%. Remettez-les imm??diatement ou faites face aux cons??quences.%SPEECH_OFF%Hmm, vous auriez d?? savoir que %employer% transporterait quelque chose de louche. | Quelques hommes s\'avancent sur la route. Ils portent la banni??re de %noblehouse%, ce qui n\'est probablement pas un bon signe de ce qui est ?? venir. Leur lieutenant vous fait face.%SPEECH_ON%Salutations ! Malheureusement, vous transportez des biens vol??s qui appartiennent ?? %noblehouse%. ??cartez-vous de la caravane, faites demi-tour et reprenez votre chemin. Faites-le, et vous vivrez. Restez, et vous mourrez ici aujourd\'hui.%SPEECH_OFF% | On dirait que %employer% n\'a pas ??t?? tout ?? fait honn??te avec vous : un groupe de porte-banni??re de %noblehouse% vous demande ce que vous faites ?? transporter des biens qui leur ont ??t?? vol??s. Leur lieutenant vous crie dessus.%SPEECH_ON%Si vous voulez vivre pour voir demain, rendez les marchandises et repartez par o?? vous ??tes venus. Je comprends que vous ne faites que votre travail. Cependant, votre travail n\'est pas de me d??sob??ir. D??sob??issez et, je vous le promets, vous mourrez tous ici aujourd\'hui.%SPEECH_OFF% | Un homme s\'avance sur la route et ne semble pas pr??t ?? bouger. L\'un des conducteurs de la caravane saisit ses r??nes et, au m??me moment, un grand groupe d\'autres hommes arm??s rejoint le solitaire sur la route. Ils portent le sceau de %noblehouse%.%SPEECH_ON%Donc, c\'est ici que les biens de %noblehouse% sont partis. Vous transportez des biens qui appartiennent ?? notre noble maison. Si vous voulez vivre, retournez-les tous. Si vous voulez mourir, ne faites pas ce que je demande et voyez ce qui se passe.%SPEECH_OFF%%randombrother% s\'approche de vous en chuchotant.%SPEECH_ON%On n\'aurait pas d?? faire confiance ?? ce rat de %employer%.%SPEECH_OFF% | Vous devriez vraiment vous efforcer d\'apprendre ce que vous transportez. Un groupe d\'hommes vous a accost?? sur la route, exigeant que vous rendiez la caravane et retourniez sur vos pas. Lorsque vous demandez qui fait cette demande, ils d??clarent qu\'ils viennent de %noblehouse% et que toutes les marchandises que vous transportez ont ??t?? vol??es il y a une semaine. Leur lieutenant fait comprendre l\'option d\'un passage pacifique.%SPEECH_ON%Partez et vous vivrez. Je n\'ai aucun probl??me avec vous, seulement avec votre employeur. Cependant, si vous entravez nos r??quisitions ici, vous mourrez. Ne mourez pas pour des biens qui ne vous appartiennent pas. ??a n\'en vaut pas la peine.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Banner = "",
			Options = [
				{
					Text = "Je ne pense pas. Nous la d??fendrons s\'il le faut.",
					function getResult()
					{
						return "StolenGoods2";
					}

				},
				{
					Text = "On n\'est pas assez pay??s pour se faire des ennemis de %noblehouse%. Prenez-les.",
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
						Text = "Vos seigneurs n\'appr??cieront pas que leurs alli??s, de %companyname%, soient retenus de la sorte.",
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
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{Vous acquiescez.%SPEECH_ON%C\'est bien beau tout ??a, mais malheureusement, nous sommes pay??s pour prot??ger ces biens, pas pour savoir ?? qui ils appartiennent.%SPEECH_OFF%Le lieutenant acquiesce ??galement, presque de mani??re compr??hensive.%SPEECH_ON%Tr??s bien, alors.%SPEECH_OFF%Il sort son ??p??e. Vous sortez la v??tre. L\'homme l??ve la main, pr??t ?? donner l\'ordre.%SPEECH_ON%C\'est dommage d\'en arriver l??. Chargez !%SPEECH_OFF% | Vous sortez votre ??p??e.%SPEECH_ON%Je ne suis pas ici pour parlementer entre les maisons nobles. Je suis ici pour garder cette caravane vers %objective%. Si vous voulez vous mettre en travers de ce chemin, alors, oui, des gens vont mourir ici aujourd\'hui.%SPEECH_OFF% | Vous pointez vos mains vers la ligne de wagons.%SPEECH_ON%%employer% nous a pay?? de garder ses biens jusqu\'?? leur destination. C\'est exactement ce que nous avons l\'intention de faire.%SPEECH_OFF%Regardant le lieutenant, vous d??gainez lentement votre ??p??e. Il fait de m??me, en hochant la t??te.%SPEECH_ON%C\'est dommage qu\'il faille en arriver l??.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Banner = "",
			Options = [
				{
					Text = "Aux Armes!",
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
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{%employer% ne va pas aimer ??a, mais s\'il transportait des marchandises vol??es, il aurait d?? vous le dire. D\'un geste de la main, vous ordonnez ?? vos hommes de s\'??carter. Les portes banni??res convergent imm??diatement vers la caravane, d??chargeant ses marchandises sous le regard des malheureux marchands et des travailleurs. | Vous n\'allez pas vous battre pour des biens dont vous ne vous souciez pas. En vous ??cartant, vous invitez les portes-banni??res ?? prendre les biens qui leur appartiennent de droit. %randombrother% dit que %employer% ne sera pas content de cela. Vous acquiescez.%SPEECH_ON%Eh bien, c\'est son probl??me.%SPEECH_OFF% | Vous n\'avez pas l\'intention de transporter des marchandises vol??es ou de tuer des portes-banni??res qui ne vous en veulent pas. Contre les protestations de quelques marchands, vous vous ??cartez, laissant la caravane et ses marchandises retournez ?? leurs propri??taires l??gitimes. Un marchand secoue le poing, vous faisant savoir que %employer% sera tr??s m??content d\'apprendre que vous n\'avez pas respect?? votre contrat.}",
			Image = "",
			List = [],
			Banner = "",
			Options = [
				{
					Text = "Pas de chance.",
					function getResult()
					{
						this.Flags.set("IsStolenGoods", false);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "N\'a pas prot??g?? la caravane");
						this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).addPlayerRelation(this.Const.World.Assets.RelationNobleContractPoor, "A Coop??r?? avec leurs soldats");
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
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{Vous dites aux hommes que vous ??tes de bons amis de %noblehouse% et que vous n\'avez pas l\'intention d\'envenimer ces relations. L\'un des attaquants marque un temps d\'arr??t.%SPEECH_ON%Bon sang, il pourrait mentir, mais s\'il ne ment pas... ??a ne vaut pas la peine de se battre. Partons d\'ici.%SPEECH_OFF% | Avec quelques mots laconiques, vous dites aux hommes que vous connaissez bien la famille %noblehouse%, en nommant quelques membres de la lign??e. Les hommes posent leurs ??p??es, ne souhaitant pas envenimer davantage la situation. Mieux vaut pr??venir que gu??rir dans ce monde. | Vous faites savoir aux hommes que vous ??tes en bons termes avec la famille %noblehouse%. Ils vous demandent de le prouver, et vous le faites en leur donnant tous les noms de nobles que vous pouvez, et un peu sur les penchants particuliers de certains d\'entre eux. La preuve est suffisante - les attaquants d??posent leurs armes et vous laissent tranquille.}",
			Image = "",
			List = [],
			Banner = "",
			Options = [
				{
					Text = "On passe ?? autre chose !",
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
			Text = "[img]gfx/ui/events/event_55.png[/img]{Alors que la caravane se repose, %randombrother% vous prend par le bras et vous conduit secr??tement ?? l\'arri??re de l\'un des wagons. Jetant un coup d\'??il pour s\'assurer que personne ne regarde, il soul??ve le couvercle d\'une caisse. Des pierres pr??cieuses s\'agitent ?? l\'int??rieur et brillent dans le peu de lumi??re qu\'il y a. Il referme le couvercle.%SPEECH_ON%Qu\'est-ce que vous voulez faire ? C\'est beaucoup d\'argent, capitaine.%SPEECH_OFF% | Alors que la caravane s\'arr??te pour r??parer une roue de chariot, un essieu se brise et fait basculer le chariot sur le c??t??. Une caisse s\'??crase sur le sol, le couvercle s\'ouvre avec fracas. Vous attrapez un marteau et vous allez le clouer quand vous remarquez qu\'un certain nombre de gemmes se sont r??pandues hors de la bo??te. %randombrother% le voit aussi, et met la main sur son arme.%SPEECH_ON%C\'est, euh, une cargaison particuli??rement bruyante, capitaine. Devrions-nous garder les choses tranquilles ou... ?%SPEECH_OFF% | Le chef de la caravane se met ?? crier. Vous le voyez poursuivre et plaquer rapidement un homme qui tente de s\'enfuir. Les deux tournent et tombent en spirale sur le sol, formant une tornade de membres d\'o?? s\'envole un sac brun. Il atterrit ?? vos pieds et des pierres pr??cieuses jaillissent de son ouverture non ferm??e. %randombrother% se penche et en ramasse quelques-unes. Il se tient droit, son autre main ??tant maintenant sur son arme. Il vous regarde fixement.%SPEECH_ON%Il y en a assez ici pour, vous savez, que ??a en vaille la peine...%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Retourne au travail avant que je ne t\'y oblige. Nous avons un contrat ?? remplir.",
					function getResult()
					{
						this.Flags.set("IsValuableCargo", false);
						return 0;
					}

				},
				{
					Text = "Finalement, la chance nous sourit. Nous prenons les pierres pr??cieuses pour nous !",
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
			Text = "[img]gfx/ui/events/event_50.png[/img]{Un garde de la caravane s\'approche.%SPEECH_ON%H?? les gars, remettons nous sur la route, ok ?%SPEECH_OFF%Vous faites un signe de t??te ?? votre mercenaire. Il acquiesce, puis se retourne rapidement et plante une dague dans le menton du garde. Le reste de la compagnie, r??alisant ce qui se passe, sort rapidement ses armes et s\'attaque aux gardes. Ils n\'ont aucune chance et une fois le bain de sang termin??, vous ??tes le nouveau propri??taire de quelques pierres pr??cieuses. | Le pouvoir des pierres pr??cieuses vous envahit ! D\'un signe de t??te rapide et d\'un cri, vous ordonnez ?? %companyname% de tuer tous les gardes. C\'est un processus rapide, vu qu\'ils vous ont fait confiance pour les aider, et quelques uns tombent en se demandant encore pourquoi ils ont ??t?? si brutalement trahis. | Ces pierres pr??cieuses valent plus qu\'aucun contrat ne pourrait vous offrir. En criant aussi fort que possible, vous ordonnez ?? %companyname% de tuer tous les gardes en vue. Ils sont rapides et sans h??sitation alors que les gardes sont lents et confus. Ce n\'est que quelques instants plus tard que vous ??tes en possession des pierres pr??cieuses. %employer% ne sera pas content, mais qu\'il aille au diable, vous avez les gemmes maintenant.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "??a devrait valoir un bon paquet couronne.",
					function getResult()
					{
						this.Flags.set("IsValuableCargo", false);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationBetrayal, "A massacr?? une caravane dont vous ??tiez charg??s de prot??ger");
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
						text = "Vous recevez " + gems.getName()
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Prisoner1",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{En vous d??pla??ant le long de la caravane, vous rencontrez quelques gardes qui crachent dans une cage. Un homme y habite, v??tu de haillons et les pieds couverts de boue. Il vous rep??re ?? travers l\'??paisseur de la haine et vous supplie.%SPEECH_ON%S\'il vous pla??t, mercenaire ! Mon nom est %noble% de %noblehouse%. Si vous tuez tous ces hommes, vous serez r??compens?? !%SPEECH_OFF%Un des gardes rit.%SPEECH_ON%Ne croyez pas ses mensonges, mercenaire.%SPEECH_OFF% | Vous passez devant un chariot quand soudain quelque chose vous attrape le bras. Vous vous retournez, l\'??p??e ?? la main, et la main qui vous agrippe vous ram??ne dans l\'obscurit?? du chariot. Avec pr??caution, vous soulevez la b??che pour voir un homme encha??n??. Sa voix est horrible, comme si ses premiers mots avaient ??t?? pour demander de l\'eau.%SPEECH_ON%Ignore les haillons sur moi, mercenaire, car je suis %noble% de %noblehouse%. Tuez tous ces gardes, lib??rez-moi et assurez-vous que je rentre chez moi. Pour cela, je veillerai ?? ce que vous soyez convenablement r??mun??r??.%SPEECH_OFF%Un garde interrompt son discours, la poigne du prisonier sur votre bras se d??sserre. Le garde rit.%SPEECH_ON%Est-ce que ce petit b??tard a encore r??pandu des mensonges ? Allons-y, mercenaire, nous avons encore de la route ?? faire.%SPEECH_OFF% | Vous entendez des vomissements provenant d\'un des wagons. En enqu??tant, vous tombez sur un homme en haillons, effondr??, avec un garde qui sourit au-dessus de lui.%SPEECH_ON%Parle-moi encore une fois sur ce ton et tu chieras tes dents. Compris, prisonnier ?%SPEECH_OFF%L\'homme ?? terre acquiesce et recule. Il vous voit et hoche faiblement la t??te.%SPEECH_ON%Mercenaire, je suis %noble% de %noblehouse%. Je suis s??r que vous avez entendu mon nom. Si vous tuez ce pauvre type et tous ceux qui lui ressemblent, je veillerai ?? ce que vous soyez g??n??reusement r??compens??.%SPEECH_OFF%Le garde sourit nerveusement.%SPEECH_ON%Ne croyez pas un mot de ce que dit ce rat, mercenaire !%SPEECH_OFF% | %SPEECH_ON%Mercenaire ! Puis-je vous parler ?%SPEECH_OFF%Vous vous retournez pour, ??tonnamment, trouver un homme ?? l\'arri??re de l\'un des wagons. Il est couvert de cha??nes.%SPEECH_ON%Il faut que tu saches que je suis %noble% de %noblehouse%. J\'ai manifestement des ennuis, mais ??a ne vous arr??tera pas, hein ? Tuez tous ces gardes et rendez-moi ?? ma famille. Je pense qu\'ils paieront un peu plus que ce que vous obtiendrez en gardant un oeil sur cette caravane de merde.%SPEECH_OFF%Un des gardes s\'approche en riant.%SPEECH_ON%Oh, la vermine crache encore des mensonges ? Ne fais pas attention ?? son baratin, mercenaire. Allez, on se remet au travail.%SPEECH_OFF% | Vous entendez le bruit distinct des cha??nes, la fragilit?? des maillons qui se d??font, le cliquetis du m??tal qui fait penser que l\'on pourrait si facilement ??tre libre. Au lieu de cela, un homme qui n\'est pas libre vous supplie.%SPEECH_ON%Enfin, je peux vous parler. Mercenaire, ??coutez, vous ne le croirez peut-??tre pas mais je suis %noble% de %noblehouse%. Je ne sais pas pourquoi ces hommes m\'ont enlev??, mais ??a n\'a pas d\'importance. Ce qui importe, c\'est que vous assumiez votre nom, surtout la partie \"vendu\". Si vous tuez tous ces gardes et me ramenez chez moi, je m\'assurerai que vous soyez g??n??reusement r??compens?? !%SPEECH_OFF%Un garde s\'approche.%SPEECH_ON%Silence, salaud ! Ne faites pas attention ?? lui, mercenaire. Nous avons du travail ?? faire, allez.%SPEECH_OFF% | Lorsque la caravane fait une petite pause, vous trouvez un homme qui se repose, la jambe pendante, sur le lit d\'un chariot. Sauf que ses pieds ne sont pas libres - ils sont li??s par des cha??nes et ses bras ne sont pas dans un meilleur ??tat. Il vous voit.%SPEECH_ON%Vous me reconnaissez ? Je suis %noble% de %noblehouse%, un prisonnier de valeur, comme mon nom l\'indique. Mais en tant qu\'homme libre, j\'ai encore plus de valeur. Tuez ces gardes, ramenez-moi chez moi, et vous ne pourrez plus marcher tant vous aurez de couronnes dans vos poches !%SPEECH_OFF%Un garde s\'approche et tape son fourreau contre les tibias de l\'homme.%SPEECH_ON%Silence, toi ! Allez, mercenaire, on est pr??ts ?? reprendre la route. Et ne faites pas attention ?? ce b??tard, d\'accord ? Il n\'a que des mensonges pour vous.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ne gaspillez pas votre salive. J\'en ai rien ?? foutre de qui vous ??tes.",
					function getResult()
					{
						this.Flags.set("IsPrisoner", false);
						return 0;
					}

				},
				{
					Text = "J\'esp??re que ??a en vaut la peine. Je vous ferai tenir vos promesses une fois que je vous aurai lib??r??.",
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
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Vous crachez et vous ??claircissez votre gorge, puis vous sortez rapidement votre ??p??e de son fourreau et frappez le garde de la caravane. %randombrother% voit cela et aboie rapidement un ordre pour que le reste de %companyname% fasse de m??me. C\'est un bref et confus carnage, les gardes de la caravane ne sachant pas ce qui se passait tandis que vos hommes se jetaient sur eux.\n\n En lib??rant le prisonnier, il vous remercie abondamment puis vous demande de montrer le chemin.%SPEECH_ON%Une fois que nous serons ?? %noblesettlement%, et qu\'ils verront mon visage vif et souriant, vous serez couverts de couronnes !%SPEECH_OFF% | Vous d??gainez votre ??p??e et tailladez le garde en plein visage. Il se retourne et vous plantez la lame de votre arme dans son cerveau, son organe commence ?? ressortir entre les os inclin??s comme un souffl?? ??clat??. %randombrother% voit ??a et appelle le reste de la compagnie au combat. Ils font un travail rapide sur le reste des gardes de la caravane. Quand vous lib??rez %noble%, il montre la route.%SPEECH_ON%?? %noblesettlement% o?? ma famille vous r??compensera comme vous ne pourriez pas l\'imaginer !%SPEECH_OFF% | Lorsque le garde de la caravane se retourne, vous prenez une dague et la plantez sous son bras, directement dans son c??ur. Il murmure quelque chose, puis tombe au sol. Un autre garde se retourne, voit cela, puis voit votre ??p??e l\'??ventrer. Ses cris, cependant, ne sont pas ??touff??s. Une bataille s\'engage alors, mais elle est compl??tement d??s??quilibr??e, car %companyname% ne fait qu\'une bouch??e des gardes de la caravane.\n\n Une fois que tout est dit et fait, %noble% est lib??r??. En frottant ses poignets violac??s, il vous indique la direction de %noblesettlement%.%SPEECH_ON%En avant, ramenez-moi ?? ma famille afin que je puisse remplir vos poches pour cette incroyable bravoure !%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Je vois d??j?? ma poche remplie de couronnes !",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationAttacked, "A massacr?? une caravane dont vous ??tiez charg??s de prot??ger");
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
						this.World.Assets.addMoralReputation(-5);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Prisoner3",
			Title = "?? %noblesettlement%",
			Text = "[img]gfx/ui/events/event_31.png[/img]{Vous atteignez %noblesettlement%. Un garde bien arm?? espionne %noble% et crie un ordre qui est rapidement aboy?? de plus en plus loin dans la ville. Bient??t, quelques chevaux arrivent, leurs cavaliers descendent rapidement. Il semble que l\'homme ne mentait pas apr??s tout. %noblehouse% vous r??compense comme le prisonnier l\'avait promis. | Avant m??me que vous puissiez entrer dans %noblesettlement%, quelques cavaliers viennent ?? votre rencontre. Ils ont des v??tements royaux qui volent au vent derri??re eux. Il y a ??galement un grand contingent de gardes lourdement arm??s non loin de l??. Peu de sp??culations sont n??cessaires car ils accueillent rapidement le prisonnier dans leurs rangs. L\'un d\'entre eux revient de la fr??n??sie d\'un bon accueil pour vous remettre votre r??compense. Ils ne disent pas grand-chose d\'autre ?? la personne responsable d\'avoir emp??cher que le noble ne perde sa t??te. Eh bien. | Le prisonnier ne mentait pas, mais on rappelle rapidement votre place dans la soci??t?? : un garde tr??s lourdement arm?? vous remet votre r??compense. Bien que vous ayez sauv?? un membre de leur lign??e, il semble que %noblehouse% ne veuille pas vous parler lui-m??me. Les choses sont ce qu\'elles sont.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Un bon jour de paie au moins.",
					function getResult()
					{
						this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).addPlayerRelation(this.Const.World.Assets.RelationFavor, "Lib??rer un membre de la maison emprisonn??");
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
					text = "Vous ??tes r??compens?? avec [color=" + this.Const.UI.Color.PositiveValue + "]3000[/color] Couronnes"
				});
				this.List.push({
					id = 10,
					icon = "ui/icons/relations.png",
					text = "Vos relations avec " + this.World.FactionManager.getFaction(this.Contract.m.NobleHouseID).getName() + " se sont am??lior??s"
				});
			}

		});
		this.m.Screens.push({
			ID = "Prisoner4",
			Title = "?? %noblesettlement%",
			Text = "[img]gfx/ui/events/event_31.png[/img]{Alors que vous vous approchez de %noblesettlement%, %noble% part en direction de buissons.%SPEECH_ON%Excusez-moi, chers amis, j\'ai besoin d\'aller chier.%SPEECH_OFF%Vous acquiescez et attendez. Et vous attendez. Et vous attendez. R??alisant votre erreur, vous vous pr??cipitez derri??re le buisson pour voir que l\'homme a compl??tement disparu et qu\'il y a de la merde sur vos chaussures. | %noble% demande que vous vous arr??tiez. Il se dirige vers le lit d\'un ruisseau.%SPEECH_ON%Attendez, les gars. Laissez-moi me nettoyer pour que ma famille n\'ait pas ?? me voir dans un tel ??tat !%SPEECH_OFF%C\'est logique. Vous laissez l\'homme s\'en occuper, mais quand vous revenez pour v??rifier, il a disparu. Des traces de pas boueuses m??nent ?? une colline et vous les suivez. De l\'autre c??t??, vous d??couvrez un champ de fermiers et une ??paisse culture ?? travers laquelle n\'importe quel menteur pourrait facilement se glisser. %randombrother% vous rejoint.%SPEECH_ON%Connard.%SPEECH_OFF%Connard en effet. | Il y a quelques paysans sur la route de %noblesettlement%. Ils se font des coupes de cheveux et cela semble attirer l\'attention de %noble%.%SPEECH_ON%Excusez-moi, messieurs, car je dois me nettoyer. Je ne veux pas que ma m??re me voit dans cet ??tat, vous savez.%SPEECH_OFF%Vous acquiescez et allez faire l\'inventaire pour passer le temps. Lorsque vous retournez chez les paysans, vous demandez o?? est pass?? le noble. L\'un d\'eux vous regarde fixement.%SPEECH_ON%Je n\'ai pas vu de noble.%SPEECH_OFF%Vous expliquez qu\'il ??tait v??tu de haillons, puis vous le d??crivez rapidement. Ils haussent les ??paules.%SPEECH_ON%J\'ai vu ce bougre courir dans les champs au loin, puis monter sur un cheval, et chevaucher de plus en plus loin au loin. On pensait qu\'il ??tait fou, vu qu\'il riait tout le temps.%SPEECH_OFF%La col??re vous envahit. | Vous amenez %noble% ?? %noblesettlement%. Il tremble presque lorsque vous entrez dans la ville.%SPEECH_ON%Ah, je suis juste un peu nerveux.%SPEECH_OFF%Aucun des gardes ne reconna??t l\'homme, mais c\'est facilement pardonnable vu son ??tat vestimentaire. Vous vous approchez d\'un homme tr??s bien arm?? et lui demandez d\'amener quelqu\'un de la famille noble. Il s\'incline vers vous, quittant ?? peine son poste de garde.%SPEECH_ON%Et pourquoi je devrais leur donner ce nom ?%SPEECH_OFF%Vous vous tournez et vous pointez du doigt.%SPEECH_ON%Pourquoi, c\'est... que... euh...%SPEECH_OFF%%noble% n\'est nulle part. Vous regardez autour de vous. L\'attention de %randombrother% est retenue par une jeune fille et le reste de la compagnie s\'agite. Une foule de citadins va et vient, un flot gris dans lequel un menteur pourrait si facilement dispara??tre. Vous transformez vos mains en poings. Le garde vous repousse.%SPEECH_ON%Si vous n\'avez rien ?? faire ici, alors je vous demande de quitter les lieux ou nous vous ferons sortir par la force.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Merde !",
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
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_33.png[/img]{Alors que la caravane est arr??t??e pour se reposer, vous entendez un bruit ??trange, comme si un homme mordait dans une pomme et en aspirait le jus. En marchant autour d\'une charrette, vous trouvez une silhouette p??le pench??e sur un garde de la caravane mort, les crocs de l\'??trange cr??ature plong??s profond??ment dans le cou de l\'homme. Vous pouvez voir la chair se soulever sous la morsure, la cr??ature sanguinaire grima??ant en buvant.\n\n D??gainant votre ??p??e, vous criez ?? vos mercenaires.%SPEECH_ON%B??tes immondes ! Aux armes, messieurs !%SPEECH_OFF% | Le couvercle d\'une bo??te bouge. Vous le fixez, ??changeant un regard avec un garde de la caravane.%SPEECH_ON%Vous transportez des chiens ?%SPEECH_OFF%Soudain, le couvercle de la bo??te explose, des ??clats tombant en cascade d\'une source de grande puissance en col??re. En g??missant, une cr??ature s\'??l??ve de la bo??te, les bras crois??s sur sa poitrine. Le visage est p??le, la peau tendue et clairement froide. C\'est... un...\n\n Le garde de la caravane s\'enfuit en criant.%SPEECH_ON%La cargaison s\'est enfuie ! La cargaison s\'est enfuie !%SPEECH_OFF%Cargaison ? Qui oserait appeler de telles horreurs \"Cargaison\" ? | Vous regardez l\'un des gardes de la caravane soulever un chat d\'une caisse. La cr??ature g??mit tandis que ses pattes pendent, donnant des coups de pied pour trouver un point d\'appui, puis des coups de pied rageurs pour gratter ce qui l\'a soulev?? de la sorte. Int??ress??, vous demandez ce que fait l\'homme. Il hausse les ??paules, soul??ve le couvercle d\'une bo??te et y d??pose le chat.%SPEECH_ON%Alimentation.%SPEECH_OFF%Le chat hurle, ses cris de f??lin aussi f??roces que son combat, mais bient??t on n\'entend plus rien du tout. Au moment o?? le garde de la caravane se retourne pour s\'??loigner de la boite, le couvercle s\'ouvre et une cr??ature p??le en sort, presque incorporelle dans son mouvement, et ferme ses bras autour de l\'homme. Elle plonge ses crocs dans son cou. Le cou du gardien devient violet, puis commence rapidement ?? s\'??teindre, ses veines sortant de son front comme si elles essayaient d\'aider son sang ?? ??chapper ?? la consommation.\n\n En reculant, vous d??gainez votre ??p??e et pr??venez vos hommes de cette nouvelle horreur. | Alors que vous vous reposez, un jeune garde de la caravane vous surprend presque.%SPEECH_ON%H?? mercenaire, vous voulez voir quelque chose ?%SPEECH_OFF%Vous avez le temps et le temps vous ennuie, alors oui, bien s??r que vous le faites. Il vous emm??ne vers l\'un des chariots et soul??ve le couvercle d\'une bo??te. Une silhouette p??le est ?? l\'int??rieur, les bras crois??s sur la poitrine, le visage incolore et tendu dans un certain contentement endormi. Vous faites un bond en arri??re, car ce n\'est pas un cadavre ordinaire. Le garde de la caravane rit.%SPEECH_ON%Quoi, vous avez peur des morts ?%SPEECH_OFF%Et juste ?? ce moment-l??, le bras de la cr??ature se l??ve, attrape le gamin et le tra??ne dans la bo??te. Vous ne donnez pas la peine de sauver l\'idiot, mais allez plut??t rallier vos hommes, alors que d\'autres bo??tes s\'ouvrent autour de vous pendant que vous courez. | En vous reposant au bord de la route, vous entendez un cri horrible quelque part dans la file de chariots. D??gainant votre ??p??e, vous vous pr??cipitez rapidement vers le bruit. Un garde de la caravane passe devant vous en boitant, serrant son cou. Il a les yeux ??carquill??s, la bouche fig??e et sans voix.%SPEECH_ON%Ils sont sortis ! Ils sont sortis !%SPEECH_OFF%Un autre garde passe en courant, sans m??me prendre la peine de s\'arr??ter pour aider l\'autre. Vous regardez devant vous pour voir un groupe de silhouettes p??les sauter d\'un garde ?? l\'autre, enveloppant leurs victimes d\'une cape noire pour leur faire subir une mort atroce. Avant qu\'ils ne puissent vous atteindre, vous faites demi-tour et pr??venez la compagnie de cet horrible danger. | Pendant que le convoi fait une pause, vous faites le tour des chariots pour v??rifier que tout est bien en ordre. Le dernier wagon, cependant, est inclin?? vers le sol, son animal de trait mort dans la boue. A proximit?? se trouvent deux gardes morts. Ils sont compl??tement blancs, mais ils ont l\'air d\'??tre morts r??cemment. En levant les yeux, vous trouvez des cr??atures au visage de sang, courb??es sur le chariot, du sang d??goulinant de leurs bouches !\n\n%randombrother% arrive derri??re vous, arme ?? la main, et vous pousse en arri??re.%SPEECH_ON%Alertez les hommes, monsieur !%SPEECH_OFF%C\'est ?? peu pr??s la meilleure id??e qu\'on puisse avoir ?? ce moment. Vous criez aussi fort que vous le pouvez, appelant le reste de vos hommes au combat. | Vous allez pisser quand un hurlement horrible vous fait h??siter. Vous vous habillez, vous faites demi-tour et vous vous pr??cipitez vers la perturbation. Vous y trouvez un garde de la caravane qui tombe en avant, ses jambes s\'entrechoquent et tr??buchent avant de tomber sur le visage. Derri??re lui, une cr??ature p??le essuie le sang de sa bouche. Et sur les chariots, des caisses s\'ouvrent, des formes blafardes en sortent, la soif de sang dans les yeux.\n\n Vous en avez vu plus qu\'assez et vous allez alerter les hommes.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "D??fendez la caravane !",
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
					Text = "Courez pour vos vies ! Courez ! Courez !",
					function getResult()
					{
						this.Contract.m.Caravan.die();
						this.Contract.m.Caravan = null;
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "N\'a pas prot??g?? la caravane");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "?? %objective%",
			Text = "[img]gfx/ui/events/event_04.png[/img]{En atteignant %objective%, le chef de la caravane se tourne vers vous, une grande sacoche ?? la main.%SPEECH_ON%Merci de nous avoir amen??s ici, mercenaire.%SPEECH_OFF%Vous la prenez et la remettez ?? %randombrother% pour qu\'il le compte. Il hoche la t??te quand il a termin??. Le chef de la caravane sourit.%SPEECH_ON%Merci aussi de ne pas nous avoir trahis et, vous savez, de ne pas nous avoir massacr??s et tout ??a.%SPEECH_OFF%Les mercenaires sont remerci??s de la fa??on la plus ??trange qui soit. | Apr??s avoir atteint %objective%, les wagons de la caravane sont imm??diatement d??charg??s et leurs marchandises transport??es dans un entrep??t voisin. Une fois que tout a ??t?? vid??, le chef du groupe vous remet une sacoche de couronnes et vous remercie d\'avoir assur?? la s??curit?? de leur voyage. | %objective% vous accueille avec un essaim de travailleurs en qu??te de travail. Le chef de la caravane distribue des couronnes aux hommes ici et l??, leurs mains sales se dirigeant vers les charrettes pour d??charger la cargaison. Quand il en a fini avec la foule, le chef se tourne vers vous. Il a une sacoche ?? la main.%SPEECH_ON%Et ceci est pour vous, mercenaire.%SPEECH_OFF%Vous le prenez. Quelques-uns des marchands regardent l\'??change d\'argent comme des chats le feraient avec une souris. | Vous avez r??ussi, vous avez livr?? la caravane comme vous l\'aviez promis ?? %employer%. Le chef de la caravane vous remercie en vous remettant des couronnes. Il semble plut??t reconnaissant d\'??tre en vie, vous racontant bri??vement une histoire o?? il a ??chapp?? de justesse ?? une embuscade de brigands. Vous hochez la t??te comme si vous vous souciiez de ce qui est arriv?? ?? cet homme. | Le convoi de chariots entre dans %objective%, chaque chariot faisant tr??bucher ses grandes roues sur des monticules de boue s??ch??e. Les ouvriers de la caravane s\'affairent ?? d??charger la cargaison, quelques-uns d\'entre eux se battant contre un ou deux mendiants. Le chef du convoi vous remet une sacoche et c\'est ?? peu pr??s tout ce qu\'il fait. Il est trop occup?? par son travail pour vous en dire plus. Le silence est appr??ci??. | En atteignant %objective%, le chef de la caravane entame une conversation comme si vous aviez quelque chose en commun. Il parle de ses jeunes ann??es, quand il ??tait un jeune homme plein de vie qui aurait pu faire ceci ou cela. Apparemment, il a rat?? beaucoup de combats. Quel dommage. Lass?? par son discours, vous demandez ?? l\'homme de vous payer pour que vous puissiez sortir de ce mis??rable endroit.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Des couronnes bien m??rit??es.",
					function getResult()
					{
						local money = this.Contract.m.Payment.getOnCompletion() + this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected");
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(money);

						if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getType() == this.Const.FactionType.OrientalCityState)
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "A prot??g?? une caravane comme promis");
						}
						else if (this.Flags.get("IsStolenGoods"))
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess * 2.0, "A prot??g?? une caravane contenant des biens vol??s comme promis");
						}
						else
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "A prot??g?? une caravane comme promis");
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
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
				});
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/well_supplied_situation"), 3, this.Contract.m.Destination, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "?? %objective%",
			Text = "[img]gfx/ui/events/event_04.png[/img]{On peut se demander si un endroit comme %objective% vaut la peine de perdre des vies. Vous y ??tes arriv??s, mais tous les chariots n\'y sont pas parvenus. Le chef du convoi de chariots s\'approche, une sacoche un peu plus l??g??re que pr??vu ?? la main.%SPEECH_ON%Je vous aurais bien pay?? plus, mercenaire, parce que je sais que la perfection dans ce monde n\'est pas facile, mais %employer% a insist?? pour que je fasse des soustractions bas??es sur... eh bien, nos pertes. Vous comprenez ?%SPEECH_OFF%Il semble craindre que vous vous vengiez de lui, mais vous prenez simplement l\'argent et vous partez. Les affaires sont les affaires. | En atteignant %objective%, le chef de la caravane se tourne vers vous, sacoche en main.%SPEECH_ON%C\'est plus l??ger que vous ne le pensiez.%SPEECH_OFF%Effectivement. Il poursuit.%SPEECH_ON%Tous les chariots n\'y sont pas parvenus.%SPEECH_OFF%Ils ne l\'ont pas fait.%SPEECH_ON%Je suis juste le messager de %employer%. S\'il vous pla??t, ne me tuez pas.%SPEECH_OFF%Vous ne le ferez pas. Bien que... nah. | Ayant atteint %objective%, le chef du convoi de chariots demande aux hommes de la caravane de commencer ?? d??charger les marchandises. Il leur manque quelques hommes et quelques chariots. En venant vers vous avec le paiement, le chef explique la situation.%SPEECH_ON%%employer% s\'est assur?? que je vous paye selon le mat??riel qui est arriv??. Malheureusement, nous en avons perdu quelques-uns...%SPEECH_OFF%Vous acquiescez et prenez la r??compense. Un march?? est un march??, apr??s tout. | Le chef du convoi de chariots semble presque pleurer lorsque vous atteignez %objective%. Il dit qu\'il a perdu de bons hommes l??-bas, et que les chariots perdus vont leur co??ter cher. Vous vous en moquez, mais vous lui offrez le soutien d\'un hochement de t??te solitaire.%SPEECH_ON%Je suppose que je devrais quand m??me vous remercier, mercenaire. Nous ne sommes pas tous morts, apr??s tout. Malheureusement... Je ne peux pas vous payer plus. %employer% a demand?? que toutes les pertes soient pay??es de votre poche.%SPEECH_OFF%Vous acquiescez ?? nouveau et prenez le paiement que vous avez m??rit??.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "??a ne s\'est pas bien pass??...",
					function getResult()
					{
						local money = this.Contract.m.Payment.getOnCompletion() + this.Contract.m.Payment.getPerCount() * this.Flags.get("HeadsCollected");
						money = this.Math.floor(money / 2);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(money);

						if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getType() == this.Const.FactionType.OrientalCityState)
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractPoor, "A prot??g?? une caravane, bien que faiblement");
						}
						else if (this.Flags.get("IsStolenGoods"))
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractPoor * 2.0, "A prot??g?? une caravane contenant des biens vol??s, bien que faiblement");
						}
						else
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractPoor, "A prot??g?? une caravane, bien que faiblement");
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
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "Apr??s la bataille",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Vous avez commenc?? le voyage en compagnie de caravaniers et de quelques marchands qui vous ont tous fait confiance. Maintenant, leurs corps sont ??parpill??s sur la terre, bras tendus, les doigts utilis??s par les mouches. Le soleil fera de votre ??chec une odeur de ruine. Il est temps de passer ?? autre chose. | Les chariots sont couch??s sur le c??t??. Des hommes et des membres sont ??parpill??s. Un g??missement s\'??l??ve de la ruine, mais il est agonisant car on ne l\'entend plus jamais. Des ombres sombres ondulent sur l\'herbe, et au-dessus de vous, une bande croissante de buses. Il vaut mieux les laisser festoyer car il n\'y a rien d\'autre ?? faire ici. | Le marchand qui vous a engag?? g??t mort ?? vos pieds. Il n\'est pas exactement face contre terre, car cette partie de lui n\'existe plus. Le sang coule sur le sol en gicl??es alors que vous ne pouvez vous emp??cher de regarder le r??sum?? de votre ??chec. L\'un de vos hommes per??oit un tressaillement, mais vous le savez. Il n\'y a rien ?? faire. Le reste de la caravane est dans un ??tat encore pire. Il n\'y a aucune raison de rester ici. | La bataille se calme, mais vous trouvez le marchand appuy?? contre un chariot renvers??. Les yeux ??carquill??s, il s\'agrippe d??sesp??r??ment ?? son cou entaill??. Des cordons de sang giclent entre ses doigts et avant que rien ne puisse ??tre fait, l\'homme s\'effondre. Vous essayez de le r??animer, mais il est trop tard. Des yeux vitreux vous regardent. %randombrother%, l\'un de vos hommes, les referme avant de se lever pour aller fouiller dans les restes de la caravane. | Vous tr??buchez autour des restes des chariots. Ce n\'est pas difficile ?? voir : la t??te du marchand a ??t?? enfonc??e par une sorte de coffre, peut-??tre la chose m??me derri??re laquelle il cherchait ?? se prot??ger dans le feu de l\'action. H??las, aucun membre de la caravane n\'est en meilleur ??tat. La bataille s\'est av??r??e vicieuse, m??me selon vos standards, et le carnage qui en r??sulte a provoqu?? des soul??vements chez certains de vos conf??res. Si les cauchemars arrivent, qu\'ils arrivent. Vous ne m??ritez gu??re plus pour votre ??chec.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Fais chier",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);

						if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getType() == this.Const.FactionType.OrientalCityState)
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "N\'a pas r??ussi ?? prot??ger une caravane");
						}
						else
						{
							this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "N\'a pas r??ussi ?? prot??ger une caravane");
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
		party.setDescription("Une caravane commerciale de " + this.m.Home.getName() + " qui transporte toutes sortes de marchandises entre les villes.");
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


this.marauding_greenskins_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Objective = null,
		Target = null,
		IsPlayerAttacking = true,
		LastRandomEventShown = 0.0
	},
	function setObjective( _h )
	{
		if (typeof _h == "instance")
		{
			this.m.Objective = _h;
		}
		else
		{
			this.m.Objective = this.WeakTableRef(_h);
		}
	}

	function setOrcs( _o )
	{
		this.m.Flags.set("IsOrcs", _o);
	}

	function create()
	{
		this.contract.create();
		this.m.Type = "contract.marauding_greenskins";
		this.m.Name = "Marauding Greenskins";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		if (this.m.Home == null)
		{
			this.setHome(this.World.State.getCurrentTown());
		}

		local myTile = this.m.Origin.getTile();
		local orcs = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(myTile);
		local goblins = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(myTile);

		if (myTile.getDistanceTo(orcs.getTile()) + this.Math.rand(0, 8) < myTile.getDistanceTo(goblins.getTile()) + this.Math.rand(0, 8))
		{
			this.m.Flags.set("IsOrcs", true);
		}
		else
		{
			this.m.Flags.set("IsOrcs", false);
		}

		local bestDist = 9000;
		local best;
		local settlements = this.World.EntityManager.getSettlements();

		foreach( s in settlements )
		{
			if (s.isMilitary() || s.isSouthern() || !s.isDiscovered())
			{
				continue;
			}

			if (s.getID() == this.m.Origin.getID() || s.getID() == this.m.Home.getID())
			{
				continue;
			}

			local d = this.getDistanceOnRoads(s.getTile(), this.m.Origin.getTile());

			if (d < bestDist)
			{
				bestDist = d;
				best = s;
			}
		}

		if (best != null)
		{
			local distance = this.getDistanceOnRoads(best.getTile(), this.m.Origin.getTile());
			this.m.Flags.set("MerchantReward", this.Math.max(150, distance * 5.0 * this.getPaymentMult()));
			this.setObjective(best);
			this.m.Flags.set("MerchantID", best.getFactionOfType(this.Const.FactionType.Settlement).getRandomCharacter().getID());
		}

		this.m.Payment.Pool = 800 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Kill marauding greenskins around %origin%"
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

				if (r <= 5 && this.World.Assets.getBusinessReputation() >= 2250)
				{
					if (this.Flags.get("IsOrcs") == true)
					{
						this.Flags.set("IsWarlord", true);
					}
					else
					{
						this.Flags.set("IsShaman", true);
					}
				}
				else if (r <= 10 && this.Contract.m.Objective != null)
				{
					this.Flags.set("IsMerchant", true);
				}

				local originTile = this.Contract.m.Origin.getTile();
				local tile = this.Contract.getTileToSpawnLocation(originTile, 5, 10);
				local party;

				if (this.Flags.get("IsOrcs"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).spawnEntity(tile, "Orc Marauders", false, this.Const.World.Spawn.OrcRaiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					party.setDescription("A band of menacing orcs, greenskinned and towering any man.");
					party.getLoot().ArmorParts = this.Math.rand(0, 25);
					party.getLoot().Ammo = this.Math.rand(0, 10);
					party.addToInventory("supplies/strange_meat_item");
					local enemyBase = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(this.Contract.getOrigin().getTile());
					party.getSprite("banner").setBrush(enemyBase.getBanner());
				}
				else
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).spawnEntity(tile, "Goblin Raiders", false, this.Const.World.Spawn.GoblinRaiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					party.setDescription("A band of mischievous goblins, small but cunning and not to be underestimated.");
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

					local enemyBase = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(this.Contract.getOrigin().getTile());
					party.getSprite("banner").setBrush(enemyBase.getBanner());
				}

				this.Contract.m.UnitsSpawned.push(party.getID());
				this.Contract.m.Target = this.WeakTableRef(party);
				party.setAttackableByAI(false);
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setPivot(this.Contract.m.Origin);
				roam.setMinRange(3);
				roam.setMaxRange(8);
				roam.setAllTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
				roam.setTerrain(this.Const.World.TerrainType.Shore, false);
				roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
				c.addOrder(roam);
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
				}

				this.Contract.m.Origin.getSprite("selection").Visible = true;
			}

			function update()
			{
				local playerTile = this.World.State.getPlayer().getTile();

				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive())
				{
					if (this.Flags.get("IsMerchant") && this.Contract.m.Objective != null && !this.Contract.m.Objective.isNull())
					{
						this.Contract.setScreen("Merchant");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsOrcs"))
					{
						this.Contract.setScreen("BattleWonOrcs");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("Return");
					}
					else
					{
						this.Contract.setScreen("BattleWonGoblins");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("Return");
					}
				}
				else if (playerTile.getDistanceTo(this.Contract.m.Target.getTile()) <= 10 && this.Contract.m.Target.isHiddenToPlayer() && this.Time.getVirtualTimeF() - this.Contract.m.LastRandomEventShown >= 30.0 && this.Math.rand(1, 1000) <= 1)
				{
					this.Contract.m.LastRandomEventShown = this.Time.getVirtualTimeF();

					if (!this.Flags.get("IsBurnedFarmsteadShown") && playerTile.Type == this.Const.World.TerrainType.Plains || playerTile.Type == this.Const.World.TerrainType.Hills || playerTile.Type == this.Const.World.TerrainType.Tundra || playerTile.Type == this.Const.World.TerrainType.Steppe)
					{
						this.Flags.set("IsBurnedFarmsteadShown", true);
						this.Contract.setScreen("BurnedFarmstead");
						this.World.Contracts.showActiveContract();
					}
					else if (!this.Flags.get("IsCaravanShown") && playerTile.HasRoad)
					{
						this.Flags.set("IsCaravanShown", true);
						this.Contract.setScreen("DestroyedCaravan");
						this.World.Contracts.showActiveContract();
					}
					else if (!this.Flags.get("IsDeadBodiesOrcsShown") && this.Flags.get("IsOrcs") == true)
					{
						this.Flags.set("IsDeadBodiesOrcsShown", true);
						this.Contract.setScreen("DeadBodiesOrcs");
						this.World.Contracts.showActiveContract();
					}
					else if (!this.Flags.get("IsDeadBodiesGoblinsShown") && this.Flags.get("IsOrcs") == false)
					{
						this.Flags.set("IsDeadBodiesGoblinsShown", true);
						this.Contract.setScreen("DeadBodiesGoblins");
						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (this.Flags.get("IsWarlord") && !this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					this.Const.World.Common.addTroop(this.Contract.m.Target, {
						Type = this.Const.World.Spawn.Troops.OrcWarlord
					}, false);
					this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
					this.Contract.setScreen("Warlord");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsShaman") && !this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					this.Const.World.Common.addTroop(this.Contract.m.Target, {
						Type = this.Const.World.Spawn.Troops.GoblinShaman
					}, false);
					this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
					this.Contract.setScreen("Shaman");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog(_isPlayerAttacking);
				}
			}

		});
		this.m.States.push({
			ID = "Running_Merchant",
			function start()
			{
				this.Contract.m.Origin.getSprite("selection").Visible = false;

				if (this.Contract.m.Objective != null && !this.Contract.m.Objective.isNull())
				{
					this.Contract.m.Objective.getSprite("selection").Visible = true;
				}

				this.Contract.m.BulletpointsObjectives = [
					"Ramenez le marchand sain et sauf à %objective% %objectivedirection%"
				];
				this.Contract.m.BulletpointsPayment = [];
				this.Contract.m.BulletpointsPayment.push("Recevez %reward_merchant% Couronnes en arrivant");
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Objective))
				{
					this.Contract.setScreen("Success2");
					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
			}

			function end()
			{
				if (this.Contract.m.Objective != null && !this.Contract.m.Objective.isNull())
				{
					this.Contract.m.Objective.getSprite("selection").Visible = false;
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
				this.Contract.m.BulletpointsPayment = [];

				if (this.Contract.m.Payment.Advance != 0)
				{
					this.Contract.m.BulletpointsPayment.push("Recevez " + this.Contract.m.Payment.getInAdvance() + " Couronnes d\'avance");
				}

				if (this.Contract.m.Payment.Completion != 0)
				{
					this.Contract.m.BulletpointsPayment.push("Recevez " + this.Contract.m.Payment.getOnCompletion() + " Couronnes à l'achèvement du contrat");
				}

				this.Contract.m.Home.getSprite("selection").Visible = true;
				this.Contract.m.Origin.getSprite("selection").Visible = false;
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
	}

	function createScreens()
	{
		this.importScreens(this.Const.Contracts.NegotiationDefault);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Task",
			Title = "Negotiations",
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer%\'s slouched posture and occasional groan tells a lot about how his day is going. He massages his temples before addressing you in a shaky voice. %SPEECH_ON%A greenskin horde is terrorizing and plundering the region around %origin%. They spare no one or thing. {My men are too scared to do anything about it. | Too many of my men are wandering the land. | My men won\'t do it without obscene pay.} You are the people\'s last hope to stop these brutes. If they are allowed to go where they please, we may never find the time to rebuild!%SPEECH_OFF%He slowly closes his eyes and sighs before continuing.%SPEECH_ON%They\'re greenskins. They leave tracks everywhere they go. Shouldn\'t be hard to find, right? Kill them all and avenge the good people of %origin%!%SPEECH_OFF% | Staring out his window, %employer% asks a simple question.%SPEECH_ON%Do you know what a greenskin does when it gets its hands on an infant?%SPEECH_OFF%You turn your head. A guard in the corner shrugs. You address the question.%SPEECH_ON%Yes.%SPEECH_OFF%The nobleman nods to himself and returns to his desk, taking a belabored seat there.%SPEECH_ON%There is a horde of them terrorizing %origin%. I need you to find them and slay them all. I can\'t... They can\'t... Well, just kill them all, alright?%SPEECH_OFF% | %employer% carries a candle close to one of his books, his eyes dimming to the light and focusing in on some scripts you can\'t read.%SPEECH_ON%They say the greenskins have a long, long history in this land. Do you believe that?%SPEECH_OFF%You shrug and answer to the best of your knowledge.%SPEECH_ON%If you wanna stay awhile in this world you gotta fight, and the greenskins do seem to have been around a long while.%SPEECH_OFF%The man nods, seemingly appreciative of your observation.%SPEECH_ON%We have a number of them marauding around %origin%. They\'re burning everything they come across, killing everyone... that\'s all quite obvious, I\'m sure. What\'s also obvious is that I need you, sellsword, to find and destroy them. Are you interested?%SPEECH_OFF% | %employer%\'s laughing to himself in his chair - he\'s also got his head buried in his hands, like some sort of jester hiding a giggle. Not the best look for a man. He turns up to you, weary eyed.%SPEECH_ON%Greenskins are rampaging again. I don\'t know where they are, only where they\'ve been. You know those signs, right?%SPEECH_OFF%You nod and answer.%SPEECH_ON%They leave a large footprint, and I\'m not just talking about their feet.%SPEECH_OFF%The man laughs again, but it\'s a pained one.%SPEECH_ON%Well, I clearly need you to do something about them. Are you up to it?%SPEECH_OFF% | %employer% gets up and goes to his window, stops, shakes his head, and returns to his table. He takes a slow, measured seat.%SPEECH_ON%At first I got word that it was brigands. Then I heard it were raiders from the coasts. Then the survivors began to talk. Now you know what my problem is?%SPEECH_OFF%You shrug.%SPEECH_ON%Does it matter?%SPEECH_OFF%The man raises an eyebrow.%SPEECH_ON%Greenskins, sellsword. That\'s who it is. They are rampaging around %origin% and I need you to stop them. Does it matter now?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{We could hunt them down if the pay is right. | Fighting greenskins doesn\'t come cheap. | Let\'s talk crowns.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{This isn\'t worth it. | We have other obligations.}",
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
			ID = "DestroyedCaravan",
			Title = "Along the way...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{A caravan. Obviously, not one in good shape. The carts have been tipped over and their drivers slain. You chase off the buzzards to pick through the evidence. If the carnage didn\'t speak of greenskins, then the gnarled footprints certainly do. You\'re on the right path. | Well, the path of the greenskins wasn\'t hard to follow. You stumble upon a line of burning caravan carts. The fires are fresh, still enjoying the wood of the wagons. The bodies of the caravan hands and merchants are fresh, too, and seemed to have died in a fright. Keep going and you might catch up to those green bastards yet. | A man is hanging from the limbs of a lonely tree, as though he\'d fallen from the skies and skewered himself there. At the trunk are two dead donkeys. Further along, a cart wrecked from all sides, its wheels spilled and splintered. Cargo and goods are strewn everywhere. An old campfire licks around, looking for something to stay alive as it shrinks ever smaller.\n\n This is the work of greenskins, you\'ve no doubt. It won\'t be long until you are upon them.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We must be close.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BurnedFarmstead",
			Title = "Along the way...",
			Text = "[img]gfx/ui/events/event_71.png[/img]{Tendrils of smoke curl and slip out of the ruins of the farmstead. A body is at what used to be the front door. Half of it is missing. The half you are left with carries a horrified face, a burnt arm reaching out to something, or someone, that is no longer there. A few footprints scatter amongst the mud and grass. Greenskins. You\'re getting close. | The little farmstead didn\'t stand a chance. You find farmhands slain left and right, pitchfork-weaponry still grasped. One of the prongs has blood on it. Definitely not human. You follow the trail, knowing that you\'ll soon be upon the perpetrators of this here crime. | A dead dog. Another. Sheepdogs, if you were to guess, though the brutality makes them hard to decipher. Their handlers aren\'t far - it appears they ran while the hounds pulled rearguard. Unfortunately, the footprints tell you that these farmers ran into greenskins. The dogs put up a good fight, and their owners a good flight.\n\nYou\'re close. Keep going and you\'ll run into those bastards yet.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We must be close.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "DeadBodiesOrcs",
			Title = "Along the way...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{The work of an orc isn\'t hard to figure out: does it look precise and accurate? If so, it wasn\'t an orc. What you\'re looking at is a string of bodies and body parts, owners and lenders all mixed together. It\'d take a week just to piece them back together. If you keep going, you\'ll be sure to run into the orcs now. | You find a man cut in half. Another split vertically. Another\'s got no head for it has been smashed right into his chest. Another\'s bruised and battered, and when you go to investigate it, every bone inside jostles and moves, utterly broken. This is the work of orcs. You are very much on their trail. | A body is bent backwards, the head touching its heels. You find another with an enormous hole in the chest and yet another that appears to have been disemboweled by something jagged and rough. There\'s nothing clean about any of this. It is, undoubtedly, the work of orcs.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Looks like we\'re hunting orcs.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "DeadBodiesGoblins",
			Title = "Along the way...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{You stumble across a man leaning against a signpost. When you ask if he\'s seen any greenskins, he simply slopes forward and falls to the ground. There are darts in his back. I guess that answers your question. It also means you\'re behind goblins, not orcs. | Orcs don\'t leave messes like this. You\'ve found a series of peasants and their dogs dead and slain. But there\'s little mess. Stab wounds here, small puncture wounds there. A few darts here and there. Poison on the tips. This is the work of... goblins. They must not be far. | A man is laying in the grass, a dart in his neck. His face is purpled, his tongue retched out. His hands are firmly clenched, almost as if they were clutching themselves. The work of a nasty, paralyzing poison, no doubt. And no doubt not the work of orcs, but goblins. They must be close...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Looks like we\'re hunting goblins.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BattleWonOrcs",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_81.png[/img]{As your men fell the last of the orcs, you take a look around. The greenskins put up a hell of a fight. Time to check on the company and prepare a Retournez à your employer, %employer%. | %employer%\'s men could never do what you just did. Only the %companyname% could deal with these greenskins. You\'re proud of the company, but try not to show it. | The battle is settled, as is a wager or two the men had. As it turns out, an orc will stop gnashing if you remove its head from its neck! Your employer, %employer%, probably doesn\'t care about such brutish experiments, but he will pay you for the work you\'ve done today. | The orcs put up a fight that the holy men might have even dared to call righteous. But they are no better than the %companyname%, not on this day! | Your employer, %employer%, wanted you to slay the greenskins and you\'ve done exactly that. Now it\'s time to check on the men and prepare a Retournez à get your hard-earned pay. | Battles with the orcs is never an easy task and this one was no different. %employer%\'s pay, though, will make the %companyname%\'s hardships a little bit easier to swallow. | Your employer, %employer%, better pay damn well for you to fight these brutes - they didn\'t go down easy! Check on your men and prepare a Retournez à your employer.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Back to %townname%!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BattleWonGoblins",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_83.png[/img]{For being such small gits, the goblins sure know how to put up a good fight! Your employer, %employer%, shall be pleased with the work you\'ve accomplished here today. | You\'ve heard people scoff at the size of the goblins. Well, they may have been small but they gave it their all.\n\nTake count of your men and prepare a Retournez à your employer, %employer%, for your payday. | The gobbos fought like starving mutts. Starving, crafty, murderous mutts. Unfortunate that their savviness couldn\'t be put to better use. Ah well, %employer% will appreciate the news of what was done here. | You\'re not sure if it was a good thing your employer, %employer%, wasn\'t entirely sure if there were goblins afoot. Had he known, would he have paid you less? The goblins sure seem ineffectual when you look at them, but goddam do they know how to put up a fight.\n\n Regardless, it\'s time to take account of your company and Retournez à your employer. | The goblins lay dead. What a nuisance. Your employer, %employer%, should be pleased with what you\'ve done here today. | A stack of dead goblins is still not tall enough to reach the overwhelming height of an orcish berserker. And yet... they put up just as good of a fight! A shame their efforts are wasted in such tiny bodies. Then again, if their wits and craftiness were fitted to an orc\'s body... by the old gods, it is a scary thought!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Back to %townname%!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Warlord",
			Title = "Before the attack...",
			Text = "[img]gfx/ui/events/event_49.png[/img]{As you approach the orcish warband, you spot the unmistakable silhouette of a brutish warlord. It appears your time with the greenskins will be more difficult than originally thought. | The orcs have a huge warlord in their midst. This changes nothing. Well, it changes things a little, but the end goal remains: kill them all. | What unfortunate news! An orcish warlord has been sighted standing tall amongst the orc ranks. Unfortunate for the warlord, that is. You\'re sure he worked hard to get where he is. A shame %companyname% is about to go and ruin that. | A warlord amongst the greenskins! His size and growl would be unmistakable - you\'d hear it even if a bear were grinning its way into your face! No matter, the greenskin shall die just like the rest. | A warlord. A lord of war. A fearsome orc. You\'ve heard them all. One such enormity stands about the greenskins\' camp. One of their leaders. One of their best fighters. What does it matter? It matters none at all. Of course not! None at all. Everything will go according to plan.}",
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
			ID = "Shaman",
			Title = "Before the attack...",
			Text = "[img]gfx/ui/events/event_48.png[/img]{While approaching, you spot a strange smoke clambering upward. It is not ashy or grey, but purple, with tendrils of seemingly living green slipping and looping through it. Goblins are here, and they have a shaman with them! | A shaman! You\'d recognize one of those crafty goblins anywhere - the bony jewelry, the sloped eyes, the sense of sapience usually unseen in a gobbo\'s dumb face. These are dangerous greenskins, be wary! | Oy, watch yer step. A goblin shaman is standing amongst the enemy ranks! This is a most dangerous enemy combatant! Do not take its small shape or size lightly... | You\'ve heard stories of some shamans being able to draw a man\'s dreams from his ears. You\'re not so sure if that\'s true, but you do know they make for crafty combatants, and you\'re about to face one! | A shamanistic goblin... you\'d know that bony garb anywhere, and the camouflaging cloak, too! Keep calm and carry on - killing all these greenskins, that is! | Shaman. One goblin shaman... You\'ve heard horror stories about their \'magicks\', but this isn\'t the time or place. Prepare the men to attack! | A goblin shaman. You\'ve heard stories of these foul gits being able to trick the minds of men. You now wonder if %employer%, your employer, was fooled into bringing you here.\n\n...nah. Surely not, right? | A goblin shaman! You\'ve heard stories of these nefarious things. One was that they feed wasps into the ears of their prisoners! One man, admittedly having a few drinks in his belly, told you that he watched bees turn a man\'s brains into a honeycomb! Bet that honey smarted the tongue!}",
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
			ID = "Merchant",
			Title = "After the battle...",
			Text = "{The battle over, you discover a surprising captive amongst the ruins of the battle: a merchant. Clothed in bloodied silks, he approaches you ever thankful. He asks if perhaps you could take him to %objective%. Clearly, he is not safe on the roads. You shrug and look the other way. The man quickly pipes up, offering %reward_merchant% crowns if you simply help him. That\'s a little more to your liking... | A man emerges from a heap of dead greenskins. He is not one of your mercenaries, but in fact a merchant with his hands tied behind his back. You inquire as to how he came into such \'company\', and he shrugs, stating he\'s rarely heard of greenskins taking prisoners. How lucky for him.\n\n Glancing around, the man pipes back up.%SPEECH_ON%I must thank you, sellsword, but if it weren\'t obvious then I must state that I no longer feel safe traveling these roads. If you were to get me to %objective% in one piece, I\'d be willing to, uh, depart with %reward_merchant% crowns. Does that sound good to you?%SPEECH_OFF% | After the battle, you notice a merchant off to the side sitting ugly on his dead horse. Some wayward violence put an end to the creature and now the merchant is shit out of luck. He looks at the battlefield, then at you. Crossing his arms over the pommel of his saddle, he inquires loudly.%SPEECH_ON%Would you, sir warrior, be willing to escort me to %objective%? As you can see, my mode of travel has shat out beneath me, felled by a battle... not that it is your fault! No sir! However, I really must get to that town.%SPEECH_OFF%He pauses and dangles a small purse before you.%SPEECH_ON%I\'ve got %reward_merchant% crowns in it for ya. How does that sound?%SPEECH_OFF% | While you survey the battlefield, a man walks up to you and inquires as to what happened here. Wiping blood off your blade, you tell him to take a good look. He slims his eyes and, for whatever reason, leans forward on the tips of his toes.%SPEECH_ON%Ah, greenskins. A shameful event. Well...%SPEECH_OFF%He falls back on his heels.%SPEECH_ON%Wait a old gods-damned minute. Greenskins? What in the hells are they doing here? By the mercy of the heavens, I can\'t be safe in these parts! Soldier! I\'ll pay you %reward_merchant% crowns if you escort me to %objective%. I promise it\'s not far from here, but I can\'t afford to go alone.%SPEECH_OFF%He cuts a thumb across his neck and points at a dead greenskin.%SPEECH_ON%I don\'t think anyone can afford that price, understand?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Very well, we\'ll take you to %objective%.",
					function getResult()
					{
						this.Contract.setState("Running_Merchant");
						return 0;
					}

				},
				{
					Text = "Just go and stay out of our way.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				if (this.Flags.get("IsOrcs"))
				{
					this.Text = "[img]gfx/ui/events/event_81.png[/img]" + this.Text;
				}
				else
				{
					this.Text = "[img]gfx/ui/events/event_22.png[/img]" + this.Text;
				}

				local merchant = this.Tactical.getEntityByID(this.Flags.get("MerchantID"));
				this.Characters.push(merchant.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "On your return...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{You Retournez à %employer% and throw a greenskin\'s head on his table. He scoots away from it.%SPEECH_ON%Excuse me?%SPEECH_OFF%Nodding at it, you explain that the foul things are dead. He snaps a handkerchief from his pockets and starts mopping up the blood.%SPEECH_ON%Yes, I can see that. That mess was meant to stay there, not be brought to my feet! Farkin\' sellswords... your pay is in the corner! And hail my servant when you leave. Someone\'s gotta clean this up!%SPEECH_OFF% | %employer%\'s regaling a woman with tales when you return. Her giggles turn to a longing stare as you enter. He sees this and quickly scoots her out, lest the presence of a real man give her the fainting fits.%SPEECH_ON%Sellsword! What news do you have?%SPEECH_OFF%You bring the head of a greenskin out of a burlap sack. %employer% gazes at it, purses his lips, smiles, frowns, seems not sure what do with what he\'s looking at.%SPEECH_ON%Right... right. Well, your pay is here, as promised.%SPEECH_OFF%He heaves a wooden chest onto the table.%SPEECH_ON%Bring that girl back in here when you leave.%SPEECH_OFF% | You plant a greenskin\'s head on %employer%\'s desk. He straightens up and unfurls a scroll, comparing a drawing of a greenskin to the very real one.%SPEECH_ON%Hmm, I will have to tell the scholars they\'re a bit... wrong.%SPEECH_OFF%You ask as to how.%SPEECH_ON%They colored them grey. This one is clearly green.%SPEECH_OFF%You wonder aloud if the scholarly pens even come in green. The man purses his lips and nods.%SPEECH_ON%Huh. Good point. Well the guard outside the door will have your pay. Leave me to this... specimen.%SPEECH_OFF% | A robed man is beside %employer% when you enter. He\'s face deep into a scroll and doesn\'t even take a glance at your arrival. Shrugging, you take a greenskin\'s head from a sack and lay it on your employer\'s table. Now the stranger takes notice, and he also takes the head! He snatches it and immediately rushes out of the room, almost howling with giddiness. You ask what the hell that was. %employer% laughs.%SPEECH_ON%The scholars have been antsy about your return. They\'ve been wanting something new to study for awhile now.%SPEECH_OFF%The man takes a satchel out and hands it over. Counting crowns, you ask if the eggheads will pay you, too. %employer% shrugs.%SPEECH_ON%If you can catch \'em. And I don\'t mean physically - those men are so deep in their thoughts they act as if the rest of us don\'t even exist!%SPEECH_OFF% | %employer%\'s got a bird in his hand and a stone in the other. You ask what he\'s doing.%SPEECH_ON%I\'m trying to figure out which one\'s worth more. A bird in the hand, or... or a stone... wait...%SPEECH_OFF%You\'ve no time for this and slam a greenskin\'s head on his table, asking how much it is worth. The man frees the bird and sets the stone on his bookshelf. He turns back around with your payment in hand.%SPEECH_ON%I take it by this here... curiosity, that my problems have been taken care of. Your pay, as promised.%SPEECH_OFF%You do wonder how the hell the man managed to catch that bird, but decide not to dwell on it. | %employer%\'s having a coughing fit when you return. He glances at you, fisted hand borrowed to his lips.%SPEECH_ON%Surely your presence is not another bad omen?%SPEECH_OFF%You shrug and place a greenskin\'s head on his table, explaining that all of them were taken care of. %employer% glances at it.%SPEECH_ON%So my illness must have been caused by something else... but what? {Women? It\'s probably the women. Let\'s be honest, it\'s always the women. | Dogs. People say those mangy mutts are harbingers of madness. | Black cats! Yes, of course! I will have them all killed! | Children. The children have been rather loud lately. What is it they are planning behind the giggles and laughter? | Maybe it was that undercooked meat I ate... or... no I\'m pretty sure it\'s that crazy woman living on the hill. | I did eat bread that I had unwittingly shared with a rat. It\'s either that, or a woman. You know how those things are, always diseasing and rotting us, those damned women!}%SPEECH_OFF%The man pauses, then shakes his head.%SPEECH_ON%Ah, no matter. Your pay is being held by a guard outside. It is the amount we agreed to, though feel free to count it. The gods know I may have miscount in my current state!%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "A successful hunt.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Took care of marauding greenskins");
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
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Crowns"
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Origin, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "At %objective%...",
			Text = "[img]gfx/ui/events/event_20.png[/img]{Having reached %objective% in safekeeping, the merchant turns \'round and thanks you. He hands over a satchel of crowns, just as promised, and quickly makes his way into the town. | %objective% is a sight for sore eyes, and merry merchants as well - the man you were escorting cries out, ecstatic to either be alive or about to make some money or whatever it is that gets men of business going. He runs to a nearby inn and quickly returns, a satchel of crowns in hand.%SPEECH_ON%As promised, sellsword. I owe you much more.%SPEECH_OFF%You slyly ask how much the man would pay. He laughs.%SPEECH_ON%I wouldn\'t dare price my own head for I guarantee someone out there would want to purchase it!%SPEECH_OFF%You nod, understanding, and being quite fine with the payment as is. | Having reached %objective%, the merchant pays you the amount you two agreed upon. He then quickly rushes off, going on about how he\'s going to make so many crowns and bed so many women. | You safely get the merchant to %objective%. He thanks you then hurries off to a nearby tavern. When he returns, he\'s lugging a satchel of crowns like a grapefruit in a sock. He heaves it toward you.%SPEECH_ON%Your payment, mercenary. You have my gratitude and, of course, my crowns. Now excuse me...%SPEECH_OFF%He straightens his shirt and trousers, and lifts his chin up.%SPEECH_ON%...for I have money to make.%SPEECH_OFF%He turns and marches off, a little bit of penny pinching pep in his step.}",
			Image = "",
			List = [],
			Characters = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Easy crowns.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Flags.get("MerchantReward"));
						return 0;
					}

				}
			],
			function start()
			{
				local merchant = this.Tactical.getEntityByID(this.Flags.get("MerchantID"));
				this.Characters.push(merchant.getImagePath());
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Flags.get("MerchantReward") + "[/color] Crowns"
				});
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"objective",
			this.m.Objective != null ? this.m.Objective.getName() : ""
		]);
		_vars.push([
			"objectivedirection",
			this.m.Objective == null || this.m.Objective.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Objective.getTile())]
		]);
		_vars.push([
			"reward_merchant",
			this.m.Flags.get("MerchantReward")
		]);
	}

	function onOriginSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Origin.addSituation(this.new("scripts/entity/world/settlements/situations/greenskins_situation"));
		}
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

			if (this.m.Objective != null && !this.m.Objective.isNull())
			{
				this.m.Objective.getSprite("selection").Visible = false;
			}

			this.m.Origin.getSprite("selection").Visible = false;
			this.m.Home.getSprite("selection").Visible = false;
		}

		if (this.m.Origin != null && !this.m.Origin.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Origin.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(4);
			}
		}
	}

	function onIsValid()
	{
		if (this.m.Origin.getOwner().getID() != this.m.Faction)
		{
			return false;
		}

		return true;
	}

	function onIsTileUsed( _tile )
	{
		if (this.m.Objective != null && !this.m.Objective.isNull() && _tile.ID == this.m.Objective.getTile().ID)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		if (this.m.Target != null && !this.m.Target.isNull() && this.m.Target.isAlive())
		{
			_out.writeU32(this.m.Target.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		if (this.m.Objective != null && !this.m.Objective.isNull() && this.m.Objective.isAlive())
		{
			_out.writeU32(this.m.Objective.getID());
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

		local objective = _in.readU32();

		if (objective != 0)
		{
			this.m.Objective = this.WeakTableRef(this.World.getEntityByID(objective));
		}

		this.contract.onDeserialize(_in);
	}

});


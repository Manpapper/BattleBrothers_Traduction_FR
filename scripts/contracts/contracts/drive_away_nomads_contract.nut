this.drive_away_nomads_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		Reward = 0
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.drive_away_nomads";
		this.m.Name = "Drive Off Nomads";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		local banditcamp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getNearestSettlement(this.m.Home.getTile());
		this.m.Destination = this.WeakTableRef(banditcamp);
		this.m.Flags.set("DestinationName", banditcamp.getName());
		this.m.Payment.Pool = 600 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Repoussez les nomades à  " + this.Flags.get("DestinationName") + " %direction% de %origin%"
				];
				this.Contract.setScreen("Task");
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

				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.NomadDefenders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setLootScaleBasedOnResources(110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
				this.Contract.m.Destination.setDiscovered(true);
				this.Contract.m.Destination.resetDefenderSpawnDay();
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				local r = this.Math.rand(1, 100);

				if (r <= 10)
				{
					if (this.Contract.getDifficultyMult() >= 0.95 && this.World.Assets.getBusinessReputation() > 700)
					{
						this.Flags.set("IsSandGolems", true);
					}
				}
				else if (r <= 25)
				{
					if (this.Contract.getDifficultyMult() >= 0.95 && this.World.Assets.getBusinessReputation() > 300)
					{
						this.Flags.set("IsTreasure", true);
						this.Contract.m.Destination.clearTroops();
						this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.NomadDefenders, 150 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					}
				}
				else if (r <= 35)
				{
					if (this.World.Assets.getBusinessReputation() > 800)
					{
						this.Flags.set("IsAssassins", true);
					}
				}
				else if (r <= 45)
				{
					if (this.World.getTime().Days >= 3)
					{
						this.Flags.set("IsNecromancer", true);
						this.Contract.m.Destination.clearTroops();
						local zombies = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies);
						this.World.FactionManager.getFaction(this.Contract.m.Destination.getFaction()).removeSettlement(this.Contract.m.Destination);
						this.Contract.m.Destination.setFaction(zombies.getID());
						zombies.addSettlement(this.Contract.m.Destination.get(), false);
						this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.NecromancerSouthern, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					}
				}
				else if (r <= 50)
				{
					this.Flags.set("IsFriendlyNomads", true);
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

					if (this.Flags.get("IsNecromancer"))
					{
						this.Contract.m.Destination.m.IsShowingDefenders = false;
					}
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					if (this.Flags.get("IsTreasure"))
					{
						this.Flags.set("IsTreasure", false);
						this.Contract.setScreen("Treasure2");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setState("Return");
					}
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (this.Flags.get("IsSandGolems"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("SandGolems");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.Music = this.Const.Music.OrientalBanditTracks;
						properties.EnemyBanners.push(this.Contract.m.Destination.getBanner());
						local e = this.Math.max(1, 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult() / this.Const.World.Spawn.Troops.SandGolem.Cost);

						for( local i = 0; i < e; i = ++i )
						{
							properties.Entities.push({
								ID = this.Const.EntityType.SandGolem,
								Variant = 0,
								Row = -1,
								Script = "scripts/entity/tactical/enemies/sand_golem",
								Faction = this.Const.Faction.Enemy
							});
						}

						this.World.Contracts.startScriptedCombat(properties, true, true, true);
					}
				}
				else if (this.Flags.get("IsTreasure") && !this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					this.Contract.setScreen("Treasure1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsNecromancer") && !this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					this.Contract.setScreen("Necromancer");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsAssassins"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("Assassins");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.Music = this.Const.Music.OrientalBanditTracks;
						properties.EnemyBanners.push(this.Contract.m.Destination.getBanner());
						local e = this.Math.max(1, 30 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult() / this.Const.World.Spawn.Troops.Assassin.Cost);

						for( local i = 0; i < e; i = ++i )
						{
							properties.Entities.push({
								ID = this.Const.EntityType.Assassin,
								Variant = 0,
								Row = 2,
								Script = "scripts/entity/tactical/humans/assassin",
								Faction = this.Contract.m.Destination.getFaction()
							});
						}

						this.World.Contracts.startScriptedCombat(properties, true, true, true);
					}
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
					"Retournez à " + this.Contract.m.Home.getName()
				];
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
	}

	function createScreens()
	{
		this.importScreens(this.Const.Contracts.NegotiationDefault);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Task",
			Title = "Negotiations",
			Text = "[img]gfx/ui/events/event_163.png[/img]{There are no horns, no confetti, no cheers, but there\'s still yet a certain level of pomp when you enter %employer%\'s room. It is so decorated with golds and silvers, intricate jewelries made by genuine craftsmen, and a harem of nothing but the most attractive women, that one can\'t help but be spurred to do whatever is asked if only to have a chance to partake in the seemingly day-to-day festivities. %employer% sits upon a pile of cushions.%SPEECH_ON%Ah, Crownling. I\'ve been expecting you. Please, come no closer, you will scare my attractions. I have a simple task for you. Nomads have been plundering my caravans, hereat, I am with fewer coins in my coffers. I\'m sure you understand what it is like to be deprived of in any manner, yes? Ah, you seem so dumb. So blank. So, well, involved with what you do. I need those nomads killed, and I\'m willing to pay %reward% crowns to have it done. Does this language please whatever resides between those ears?%SPEECH_OFF% | %employer% is partly sitting on a throne of silken cushions, and partly on the bodies of a harem of attractive women. He puts his hand up.%SPEECH_ON%If you step further, Crownling, then you will grow in sight but diminish in view, understand? A smart man knows his place. I have a simple task for your swordhand. Nomads outside %townname% have taken to thievery and thuggery. For a handsome handsel, I need you to annihilate these men who have made my life uncomfortable.%SPEECH_OFF% | You find %employer% feeding a bird in a cage. The bird is a collage of colors some of which you\'re not sure you have even seen before. Suspecting your presence, or perhaps smelling it, %employer% turns with a hint of disgust.%SPEECH_ON%You are scaring my bird, Crownling, so I will make this brief for her sake. There are nomads roaming the peripheral of my lands and I need them destroyed. I\'m sure a man of your, eh, station, would be willing to undertake such a simple, easy task?%SPEECH_OFF% | You enter %employer%\'s room. He\'s feeding on fruits and his lower half is submerged in a sea of flesh, a harem of caretakers who are noisily at work. Standing idly for far too long, you open your mouth but the man throws a hand up. He points at one of his servants and snaps his fingers. The servant skirts across the marble floor on sandals with silken soles. He presents to you a piece of paper. It reads:%SPEECH_ON%To Crownlings who are interested, nomads have taken to disturbing the peace around %townname%. They are to be dealt with posthaste for a reward of %reward% crowns. Uninterested parties are to leave immediately.%SPEECH_OFF%The servant looks at you for an answer. | %employer% sighs as you enter his room.%SPEECH_ON%Ah, a Crownling, I\'d almost forgotten I had requested your sort to come ruin my day.%SPEECH_OFF%You stare at the Vizier as he is far too belabored to extricate himself from a sea of cushions and the harem of women who are there to fluff each and every one.%SPEECH_ON%Well, I suppose I shall sully an hour if only to get this matter settled. Nomads are ravaging my caravans, as they are wont to do, and hereat my markets are deprived of certain goods which I wish to have. I offer %reward% crowns to find and destroy these sand ridden mites.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Let\'s talk some more about payment. | I can make this problem disappear.}",
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
			ID = "Treasure1",
			Title = "Before the attack...",
			Text = "[img]gfx/ui/events/event_54.png[/img]{The nomads are surprisingly stationary and suprisingly many, but it appears there\'s a reason for that: you find the sand dwellers huddled around a hole in the ground. They\'ve constructed pullies around it and are working feverishly to drag up whatever it is they\'ve found in the desert. Based upon the grin of the man overseeing the operation, it is no doubt a trove of treasure.\n\nYou could attack now, and face more opposition, or you could wait until they\'re done and have left with whatever they\'re digging up.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We attack now!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				},
				{
					Text = "We\'ll wait until they\'re done and the camp is less well defended.",
					function getResult()
					{
						return "Treasure1A";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Treasure1A",
			Title = "Before the attack...",
			Text = "[img]gfx/ui/events/event_54.png[/img]{You wait for the nomads to pull the treasure out. As expected, it is a chest. When they break it open there is a hint of satisfaction on their faces. And, as also expected, the nomads split off, with a contingent of their strongest men moving off with the treasure, presumably to sell it somewhere. The nomads\' camp is weaker now and far more vulnerable to attack...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Prepare the attack!",
					function getResult()
					{
						this.Flags.set("IsTreasure", false);
						this.Contract.m.Destination.clearTroops();
						this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.NomadDefenders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Treasure2",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_168.png[/img]{The nomads slain, you, naturally, go see what the hell they were digging out of the earth. You stand over the pulley they rigged up and stare into the hole. A chest can be seen with ropes already bound around it. You thank the dead nomads for all the work they\'ve done, then turn to easily pull the chest up and out of the ground. You open it to find...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Treasure!",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				local e = 2;

				for( local i = 0; i < e; i = ++i )
				{
					local item;
					local r = this.Math.rand(1, 4);

					switch(r)
					{
					case 1:
						item = this.new("scripts/items/loot/ancient_gold_coins_item");
						break;

					case 2:
						item = this.new("scripts/items/loot/silverware_item");
						break;

					case 3:
						item = this.new("scripts/items/loot/jade_broche_item");
						break;

					case 4:
						item = this.new("scripts/items/loot/white_pearls_item");
						break;
					}

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
			ID = "SandGolems",
			Title = "Before the attack...",
			Text = "[img]gfx/ui/events/event_160.png[/img]{As you prepare to attack, a man suddenly rises up out of the sands. Startled, he jerks away and screams, rolling down the sand dune toward the nomads\' camp. You chase after him with a weapon out ready to kill. In your bouncing peripheral you can see the nomads clambering over one another and toppling tents to get to their weapons. When you look back at the spotter, he suddenly disappears in sandy clasp, and the arm attached to the dunes extends out of the earth and rises before you, dust and sand and earth falling off its shapes.\n\nYou\'re hardly able to understand what you\'re seeing, but the nomads all seem to be screaming the same thing: \'Ifrit! Ifrit! Ifrit!\' And this faceless, seemingly endless, \'Ifrit\' has no allegiances in the combat to come. | You charge down the dunes at the nomads. Startled, they bark out orders and run for their weapons. As you near the camp, a wave of sand blasts the corner of the camp and a few of the nomads go flying. One second later and a boulder comes sailing out of the dust cloud and pulverizes a nomad entirely. A huge, earthen creature bellows and stomps forward. \'Ifrit! Ifrit!\' the nomads scream, and you surmise that this \'Ifrit\' will be on no man\'s side.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To arms!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Assassins",
			Title = "Before the attack...",
			Text = "[img]gfx/ui/events/event_165.png[/img]{You charge the camp just in time to see a man in black clothes step out of one of the tents. He is shaking hands with the nomads\' leader which is probably not the best sign. Both men pausing mid-handshake and staring at your attack is presumably just as sour a result. The nomad leader calls out, demanding his assassins earn their keep. The blackened killer nods and draws out a blade, and a troop of fellow assassins stream out of the tent in turn to join the nomads in the battle!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Charge!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Necromancer",
			Title = "Before the attack...",
			Text = "[img]gfx/ui/events/event_161.png[/img]{Shredded tents. Baskets unwoven. Clothes rolling across the sands. And in the middle of it all sits a man in a black cloak, his ghastly face peering from its hooded shade.%SPEECH_ON%You are both late and right on time.%SPEECH_OFF%He says and gets to his feet. The tarps rustle, the baskets tilt, and the clothes jerk aside, the land riffling with liveliness. Suddenly, the sand slips into cavernous channels and inimical nomads empty from the earth, climbing out, some leaping forth as though to revivify themselves on fresh air, others tilting upward from heel to toe, bodies straight like flagpoles. They move unnervingly, stilted and tilted, and the man in black grins behind their shambling formation. He is no ordinary blaggard, but a necromancer!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To arms!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{A servant heads you off from meeting %employer%. He hands you a scroll as well as a satchel. Despite having already handed you the paper, the servant puts his hands behind his back and looks at the ceiling as he recites.%SPEECH_ON%The Crownling is rewarded %reward_completion% crowns as per prior arrangements. Having taken his reward, he is dismissed from the property posthaste.%SPEECH_OFF%The servant looks down at you and nods.%SPEECH_ON%Leave.%SPEECH_OFF%He says. | You try to enter %employer%\'s room but a large, scarred guard lowers the business end of a polearm across the door.%SPEECH_ON%No visitors.%SPEECH_OFF%You state that you have business with the Vizier. The guard shakes his head. A servant comes up behind you and puts a satchel in your arms and then departs just as fast. The guard returns the polearm to his side.%SPEECH_ON%Your trivialities with the Vizier concluded when you first departed his presence. You are not to poison his mood any further. Leave. Now. Before you poison mine.%SPEECH_OFF% | En vous approchant %employer%\'s room, a woman claps from across the lobby. You look over and she\'s already far too close. Four birds perch upon her shoulders and they sway with her every step.%SPEECH_ON%Crownling.%SPEECH_OFF%She produces a satchel and hands it over.%SPEECH_ON%%employer% need not smell you once more, this far into his home is sufficient. Count it if you wish to insult us, leave if you wish to please us.%SPEECH_OFF%She turns on her heels and walks away, her otherworldly dress flowing side to side. One of the birds rotates on her shoulder and squawks at you.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Well, we got paid.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Destroyed a nomad encampment");
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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
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
		if (this.m.SituationID == 0 && this.World.getTime().Days > 3 && this.Math.rand(1, 100) <= 50)
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

				if (this.m.Flags.get("IsNecromancer"))
				{
					local nomads = this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits);
					this.World.FactionManager.getFaction(this.m.Destination.getFaction()).removeSettlement(this.m.Destination);
					this.m.Destination.setFaction(nomads.getID());
					nomads.addSettlement(this.m.Destination.get(), false);
				}
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
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		this.contract.onDeserialize(_in);
	}

});


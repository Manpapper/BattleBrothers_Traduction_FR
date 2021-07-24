this.hunting_serpents_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		Dude = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hunting_serpents";
		this.m.Name = "Hunting Serpents";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
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
					"Chassez les serpents aux alentours de " + this.Contract.m.Home.getName()
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 10)
				{
					if (this.Const.DLC.Lindwurm && this.Contract.getDifficultyMult() >= 1.15 && this.World.getTime().Days >= 30)
					{
						this.Flags.set("IsLindwurm", true);
					}
				}
				else if (r <= 20)
				{
					this.Flags.set("IsCaravan", true);
				}

				this.Flags.set("StartTime", this.Time.getVirtualTimeF());
				local disallowedTerrain = [];

				for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
				{
					if (i == this.Const.World.TerrainType.Oasis)
					{
					}
					else
					{
						disallowedTerrain.push(i);
					}
				}

				local playerTile = this.World.State.getPlayer().getTile();
				local mapSize = this.World.getMapSize();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 5, 14, disallowedTerrain);
				local party;
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Serpents", false, this.Const.World.Spawn.Serpents, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.setDescription("Giant serpents slithering about.");
				party.setFootprintType(this.Const.World.FootprintsType.Serpents);
				party.setAttackableByAI(false);
				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_beasts_01");
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				local wait = this.new("scripts/ai/world/orders/wait_order");
				wait.setTime(999999);
				c.addOrder(wait);
				this.Contract.m.Home.setLastSpawnTimeToNow();
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

				this.Contract.m.BulletpointsObjectives = [
					"Chassez les serpents dans les marais %direction% de " + this.Contract.m.Home.getName()
				];
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive())
				{
					if (this.Flags.get("IsCaravan"))
					{
						this.Contract.setScreen("Caravan2");
					}
					else
					{
						this.Contract.setScreen("Victory");
					}

					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
				else if (!this.Flags.get("IsBanterShown") && this.Contract.m.Target.isHiddenToPlayer() && this.Contract.isPlayerNear(this.Contract.m.Target, 700) && this.Math.rand(1, 100) <= 1 && this.Flags.get("StartTime") + 10.0 <= this.Time.getVirtualTimeF())
				{
					this.Flags.set("IsBanterShown", true);
					this.Contract.setScreen("Banter");
					this.World.Contracts.showActiveContract();
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (this.Flags.get("IsLindwurm"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("Lindwurm");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.Music = this.Const.Music.BeastsTracks;
						properties.EnemyBanners.push(this.Contract.m.Target.getBanner());
						properties.Entities.push({
							ID = this.Const.EntityType.Lindwurm,
							Variant = 0,
							Row = -1,
							Script = "scripts/entity/tactical/enemies/lindwurm",
							Faction = this.Const.Faction.Enemy
						});
						this.World.Contracts.startScriptedCombat(properties, true, true, true);
					}
				}
				else if (this.Flags.get("IsCaravan"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("Caravan1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local f = this.Contract.m.Home.getFaction();
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "HuntingSerpentsCaravan";
						properties.Music = this.Const.Music.BeastsTracks;
						properties.EnemyBanners.push(this.Contract.m.Target.getBanner());
						properties.Entities.push({
							ID = this.Const.EntityType.CaravanDonkey,
							Variant = 0,
							Row = 3,
							Script = "scripts/entity/tactical/objective/donkey",
							Faction = f
						});

						for( local i = 0; i < 2; i = ++i )
						{
							properties.Entities.push({
								ID = this.Const.EntityType.CaravanHand,
								Variant = 0,
								Row = 3,
								Script = "scripts/entity/tactical/humans/conscript",
								Faction = f
							});
						}

						this.World.Contracts.startScriptedCombat(properties, true, true, true);
					}
				}
				else
				{
					this.World.Contracts.showCombatDialog(_isPlayerAttacking);
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getType() == this.Const.EntityType.CaravanDonkey && _combatID == "HuntingSerpentsCaravan")
				{
					this.Flags.set("IsCaravan", false);
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
					this.Contract.setScreen("Success");
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
			Text = "[img]gfx/ui/events/event_162.png[/img]{%employer% welcomes you into his room which is a space of ultimate luxury - there are numerous fineries ranging from silks, pelts, women, and gems. So many gems.%SPEECH_ON%Crownling, about time you\'d come here. We have an economic matter that needs settling. Serpents are nastily assailing the population near wetlands %direction% of here. But more importantly, we desire the scales of these serpents. They make the utmost...%SPEECH_OFF%The man kisses his fingers.%SPEECH_ON%Bags and shoes. Look at these women, do they not show their desire for said scales?%SPEECH_OFF%The women are staring at their hands or talking amongst themselves. The Vizier claps his hands.%SPEECH_ON%Handbags, my sweet, beautiful doves, handbags made from serpent scales! Yes, smile. There you go. See? How hard was that? Alright, Crownling. The offer to return these scales is %reward% crowns. For such a price do you agree to dispatch yourself upon this task?%SPEECH_OFF% | You find %employer% petting a wildly tall bird with pink feathers and long black legs. He is feeding it crickets, which the bird doesn\'t seem to much care for.%SPEECH_ON%Ahh, I have spoiled you, Little Doveling.%SPEECH_OFF%He begins to feed the strange creature long silvered fish which he pulls, alive, out of a golden bucket. He talks without looking at you as the bird gulps down fish after fish.%SPEECH_ON%We here have acquired knowledge that serpents are in the wetlands %direction% of here. The scales of said serpents is worth a considerable amount, not in gold, of course, but in our fine tastes. We desire that you head there and herd said scales into your backpacks and trot your little legs back here.%SPEECH_OFF%The man raises a finger, raises it even further, then points it at the tiles beneath his feet.%SPEECH_ON%And for that, we will pay you %reward% crowns.%SPEECH_OFF%The pink bird prunes itself and seemingly stares at you in the stead of its caretaker. | %employer% is setting on what seems like the ledge of a sauna, but his feet are buried in the hands of women laying in what is some sort of indoor aqueduct. They are using reeds to breathe, and from what you can tell they are massaging the man\'s feet. It is an absurd sight, but the Vizier pays it as much mind as he does you.%SPEECH_ON%Ah the Crownling arrives. We desire, as we always have desired, the scales of serpents for which we use to gild our luxuries. These scales can be found upon the serpents, who themselves, hmmm, yes, can be found %direction% of here. In the, ahhh, wetlands.%SPEECH_OFF%The man leans back and briefly raises his toes out of water. They wiggle as he stares at you.%SPEECH_ON%The offer is %reward% crowns, are you in agreement with such a fine, fair offer?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{I\'m interested.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{This doesn\'t sound like our kind of work. | That\'s not the kind of work we\'re looking for.}",
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
			ID = "Banter",
			Title = "Along the way...",
			Text = "[img]gfx/ui/events/event_161.png[/img]{You find a long sheath of dried scales, fat enough to stick your arm through, an unsettling sight as it is a feeling. The serpents are no doubt not far from these husks. | A man with green chew in his mouth stops you. He has a dagger sheathed in his belt, it has scales for a handle and there\'s a golden snake head for a pommel.%SPEECH_ON%Serpent hunters, are ya? I\'d do it myself, as you can tell my fascinating swagger and my delicious dagger, but alas, I now prefer to watch others at work. I\'ll say this much, they are quite close, these little snakes.%SPEECH_OFF%You bid the man farewell as fast as you can. | There\'s a few children playing in a swampy puddle, mud caked up to their knees and elbows alike. They look at you and ask what you\'re up to. When you state your business, the kids laugh.%SPEECH_ON%Serpents! They\'re small game! Nothing with which to concern yourself as far as I am concerned.%SPEECH_OFF% | You find a pile of snake skins wrapped around a wetland\'s tree trunk. The serpents no doubt used the trunk to shed the scales. And the size of the scales, each one far bigger than an arrowhead, are enough evidence you need that the serpents are close.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Keep your eyes peeled.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_169.png[/img]{The last of the serpents is dead. You step on its head, then raise your foot realizing it\'s actually the tail. You step along the length of the snake and get to its head and there chop it clean off. It\'s a lot easier now that it\'s not writhing and slipping about. %employer% will be wanting to see you return with the head and all the scales with it. | You go autour de field slinging snakes into a knapsack, the body of which bulges with their girth, and even in death they seem to writhe amongst each other in the sack. Having collected each serpent, you ready a Retournez à %employer%. | The serpents are all dead, strongly indicated by their unmoving status. Just to be sure, though, you go around chopping all their heads off. Sufficiently assured nothing can survive such strokes of damage, you sling the serpents into a knapsack and ready a Retournez à %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Let\'s be done with this, we have crowns to collect.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Lindwurm",
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/event_129.png[/img]You see the first serpent writhing about what looks like a fallen wetland tree. As you gain on the snake, you realize there are a few more sneaking about. And then you realize the tree they\'ve taken to is no tree at all: its girth shifts and rolls over, and you see the scales, fat as your own hand, glisten in the light, and the lindwurm rears its head and turns it round, its sharp eyes focusing with slimming blackness, and then it opens its maw and roars, the wetland water rippling as its growl sears across the surface.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "A Lindwurm!",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Caravan1",
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/event_149.png[/img]{The wetlands are not ordinarily home to caravans, so it of some surprise that you find one with all its guards running about. You at first think they are unloading goods, that perhaps they\'re bandits who have arrived at their secret bolthole, but as you near you see one guard get wrapped up in a curling, murderous snake and fall down. Another guard turns around a serpent\'s maw claps over his head. The merchants are under attack!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Protect them!",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Caravan2",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_169.png[/img]{The battle over, the head of the caravan comes to you personally.%SPEECH_ON%I thank you, Crownling. A slave to the coin you may be, but not without a chain or two adorned upon what we all wish we had, a sense of doing good.%SPEECH_OFF%Well, you were just here for the serpents and the caravan was but happenstance, a welcome supplement of live bait that kept the monsters off your own men. You\'re just about to tell him this, but he cuts you off with a bag of treasures in hand.%SPEECH_ON%As reward for your intervention, Crownling. May your road to the coin be ever more gilded.%SPEECH_OFF%Nodding, you shake his hand and then go about collecting the serpent scales. The merchant asks if he may have one, but with a hand on your sword you tell him this is not a trading post he has stopped at. He gets the message.}",
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
			],
			function start()
			{
				local e = this.Math.rand(1, 2);

				for( local i = 0; i < e; i = ++i )
				{
					local item;
					local r = this.Math.rand(1, 3);

					switch(r)
					{
					case 1:
						item = this.new("scripts/items/trade/spices_item");
						break;

					case 2:
						item = this.new("scripts/items/trade/silk_item");
						break;

					case 3:
						item = this.new("scripts/items/trade/incense_item");
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
			ID = "Success",
			Title = "On your return...",
			Text = "[img]gfx/ui/events/event_162.png[/img]{A flock of women rush you. There are far too many, and the door to %employer%\'s room appears and disappears, winking behind a flurry of silken scarves, flittering feathers, glistening jewelry, and the general swirling and throwing of hair finer than any you\'ve ever seen. There is also the noise which is of considerable distraction.\n\n You are practically robbed of the scales and, being in the Vizier\'s place, do not exactly resist the purloining. As the women scatter away giggling, a much older woman is left in the wake. She holds out a satchel of crowns, your payment.%SPEECH_ON%The Vizier does not wish to speak with you, Crownling. He thinks it beneath him.%SPEECH_OFF%You ask if it is beneath her to meet with you. She nods.%SPEECH_ON%It is, but I\'d rather find myself beneath a task, than beneath the Vizier himself. Have a fine day, Crownling, and may your road to the coin be gilded.%SPEECH_OFF% | You are relieved of the serpent scales by a horde of helpers. The Vizier is at their command, staring quite sternly from the rear of the room. As they depart, he raises his hands and claps. Four helpers come over carrying one satchel. You think you are being surprised with extra pay, but when they hand it off you can hold it just fine all by yourself. You look over the lid to see the Vizier grinning sheepishly. You take the %reward_completion% crowns and make your leave. | On the Vizier\'s grounds, the serpent scales do not stay in your hands for long. You find a series of helpers that all rush to his side to come and relieve you of the goods. The Vizier himself is nearby, you just know it, probably watching from a window of some sort or through a door portal. But you never really see him. You do see his coin, though, in a satchel of %reward_completion% crowns as given by a shy helper.%SPEECH_ON%From our grace, into your graces.%SPEECH_OFF%The servant says, and then he trots away and is gone just like that.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Hunted down some giant serpents");
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
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Target.getTile())]
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0 && this.Math.rand(1, 100) <= 50)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/moving_sands_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.setAttackableByAI(true);
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}

		if (this.m.Home != null && !this.m.Home.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Home.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(3);
			}
		}
	}

	function onIsValid()
	{
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


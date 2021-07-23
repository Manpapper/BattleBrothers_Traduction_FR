this.drive_away_barbarians_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		Reward = 0,
		OriginalReward = 0
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.drive_away_barbarians";
		this.m.Name = "Drive Off Barbarians";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		local banditcamp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).getNearestSettlement(this.m.Home.getTile());
		this.m.Destination = this.WeakTableRef(banditcamp);
		this.m.Flags.set("DestinationName", banditcamp.getName());
		this.m.Flags.set("EnemyBanner", banditcamp.getBanner());
		this.m.Flags.set("ChampionName", this.Const.Strings.BarbarianNames[this.Math.rand(0, this.Const.Strings.BarbarianNames.len() - 1)] + " " + this.Const.Strings.BarbarianTitles[this.Math.rand(0, this.Const.Strings.BarbarianTitles.len() - 1)]);
		this.m.Flags.set("ChampionBrotherName", "");
		this.m.Flags.set("ChampionBrother", 0);
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
					"Repoussez les barbares à " + this.Flags.get("DestinationName") + " %direction% de %origin%"
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
				this.Contract.m.Destination.setLastSpawnTimeToNow();
				this.Contract.m.Destination.clearTroops();

				if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Destination.getLoot().clear();
				}

				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.Barbarians, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setLootScaleBasedOnResources(110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				local r = this.Math.rand(1, 100);

				if (r <= 20)
				{
					if (this.World.getTime().Days >= 10)
					{
						this.Flags.set("IsDuel", true);
					}
				}
				else if (r <= 40)
				{
					if (this.World.Assets.getBusinessReputation() >= 500 && this.Contract.getDifficultyMult() >= 1.0)
					{
						this.Flags.set("IsRevenge", true);
					}
				}
				else if (r <= 50)
				{
					this.Flags.set("IsSurvivor", true);
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
				if (this.Flags.get("IsDuelVictory"))
				{
					this.Contract.setScreen("TheDuel2");
					this.World.Contracts.showActiveContract();
					this.Flags.set("IsDuelVictory", false);
				}
				else if (this.Flags.get("IsDuelDefeat"))
				{
					this.Contract.setScreen("TheDuel3");
					this.World.Contracts.showActiveContract();
					this.Flags.set("IsDuelDefeat", false);
				}
				else if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					if (this.Flags.get("IsSurvivor"))
					{
						this.Contract.setScreen("Survivor1");
						this.World.Contracts.showActiveContract();
					}

					this.Contract.setState("Return");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (this.Flags.get("IsDuel"))
				{
					this.Contract.setScreen("TheDuel1");
					this.World.Contracts.showActiveContract();
				}
				else if (!this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					this.Contract.setScreen("Approaching");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Duel")
				{
					this.Flags.set("IsDuelVictory", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Duel")
				{
					this.Flags.set("IsDuelDefeat", true);
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
				if (this.Flags.get("IsRevengeVictory"))
				{
					this.Contract.setScreen("Revenge2");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsRevengeDefeat"))
				{
					this.Contract.setScreen("Revenge3");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsRevenge") && this.Contract.isPlayerNear(this.Contract.m.Home, 600))
				{
					this.Contract.setScreen("Revenge1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success1");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Revenge")
				{
					this.Flags.set("IsRevengeVictory", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Revenge")
				{
					this.Flags.set("IsRevengeDefeat", true);
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer% sighs as he pushes a scrap of paper toward you. It is a list of crimes. You nod, observing that it is quite a lot of wrongdoing. The man nods back.%SPEECH_ON%T\'was an affair of a mere criminal I\'d spiff a constable or maybe a bounty hunter. But I\'ve brought you here sellsword because this is the work of barbarians. All that they\'ve done, all that is listed there, I need done to them. They\'ve a village %direction% from here. I need you to pay them a visit and show that while we live with hearths and civilization, the spark of the wild has not left us yet, and that barbarian actions will be met with barbaric retribution. Understand?%SPEECH_OFF%You now notice that the page of crimes is smattered with stricken feather tips, as though the one writing it got increasingly upset by its cataloging. | A group of local knights are in the room with %employer%. They regard you plainly, as though you were a dog who had pushed the door open and moseyed in. %employer% reaches down from his chair and retrieves a scroll and throws it your way.%SPEECH_ON%Barbarians left that for me when I went to make sense of a nearby farmstead that was obliterated.%SPEECH_OFF%The paper has runic drawings and what look like depictions of a hanging. %employer% nods.%SPEECH_ON%They massacred the farmers, the men anyway. The old gods know what came of the women. Go %direction% of here, sellsword, and find the barbarians responsible. You\'ll be paid handsomely for their outright, total, and complete annihilation.%SPEECH_OFF% | %employer% is looking rather bugged when you enter the room. He states that %townname% used to have good relations with the barbarians to the north.%SPEECH_ON%But I suppose I was just fooling myself to think we could stay on even terms with those savages.%SPEECH_OFF%He states they have been attacking caravans, murdering travelers, and attacking homesteads.%SPEECH_ON%So I\'ll treat them in kind. Go %direction% of here and slaughter their village whole. You keen to doing that?%SPEECH_OFF% | %employer% laughs when you enter the room.%SPEECH_ON%Not having a jake at your expense, sellsword, only at that cruel congruity of seeking a mercenary for prompt and total erasure of barbarians. You see, just %direction% of here stands a tribe of bearskin wearin\' arsefucks that have been scalping and axing traders and travelers. I won\'t stand for it. Partly because they\'re in the wrong, but especially because I have the coin to pay someone of your ill manners to take care of it for me.%SPEECH_OFF%He laughs to himself again. You get the feeling this man has never put a sword in any breathing being.%SPEECH_ON%So what say you, sellsword, interested in slaughtering some savages?%SPEECH_OFF% | When you enter %employer%\'s room he is staring at a dog\'s head. A steady leak from the neck drips over the table\'s edge. The man is rubbing one of the ears.%SPEECH_ON%Who kills a man\'s dog, cuts off its head, and fucking sends it to him?%SPEECH_OFF%You imagine someone with a hated enemy, but say nothing. %employer% nods at one of his servants and the dog\'s head is taken away. He looks to you now.%SPEECH_ON%Savages to the %direction% did this. First they started in on the merchants and homesteaders, raping and pillaging as the barbarians do. So I sent a response, killed a few of theirs, and this is what I get in return. Well, no more of these whoresons. I want you to go their village and annihilate them to the last.%SPEECH_OFF%You almost ask if that would include the destruction of their dogs. | You find %employer% with a dirtied and mudslaked woman sat beside his chair. Her hair is matted and her flesh stricken with all manner of punishment. She sneers at you as if it was all your doing. %employer% kicks her over.%SPEECH_ON%Don\'t mind this wench, sellsword. We caught her and her friends raiding the granary. Killed the lot of the savages, I\'d say we spared her for the fun of it but beating on her is about as fun as doing it to a dog. Her mannishness just steals the joy.%SPEECH_OFF%He kicks her again and she snarls back.%SPEECH_ON%See? Well, I have news! We have located the stain she came from and I have every intention of burning it to the ground. That\'s where you come in. The barbarian village is %direction% of here. Stomp it out and you\'ll be paid very well.%SPEECH_OFF%The woman doesn\'t know what is being said, but some slack in her stare seems to indicate she\'s beginning to understand why a man of your sort walked through that door in the first place. %employer% grins.%SPEECH_ON%You interested or do I have to find a man of meaner character?%SPEECH_OFF% | %employer% has a crowd of peasants in his room. More of them than any man of his station would be comfortable with in such proximity, but they surprisingly don\'t seem to be interested in lynching him. Seeing you, %employer% calls you forward.%SPEECH_ON%Ah, finally! Our answer is here! Sellsword, the barbarians %direction% of here have been pillaging nearby villages and raping anything with a hole. We\'re sick of it and frankly I don\'t want some mangy savage cock anywhere near my arse no more than the next man.%SPEECH_OFF%The crowd of peons jeers, one man yelling out that the barbarians {cut the head off his mother | also murdered his pet goats | stole all his dogs, the bastards | ate the liver of his youngest son}. %employer% nods.%SPEECH_ON%Aye. Aye, men, aye! And so I say, sellsword, that you plot a path to the barbarians\' village and treat them to measured, appropriate, civilized justice.%SPEECH_OFF% | %employer% waves you into his room. He\'s holding a firepoke, a scalp hanging off its tip.%SPEECH_ON%The northern barbarians sent me this today. It was stuck to its messenger, a man they took the eyes and tongue out of. Such is their nature, these savages, to speak to me without a word. And so I have a feeling I shall return the favor with your help, sellsword. Go %direction% of here, find their little village, and burn it to the ground.%SPEECH_OFF%The scalp unsticks from the firepoke and slaps against the stone floor with a wet slap. | %employer% reluctantly welcomes you in, as is one is wont to do when the world has pressed them into needing a mercenary. He speaks succinctly.%SPEECH_ON%The barbarians have a village %direction% of here from which they are sending raiding parties. They rape, they pillage, they are nothing but insects and varmints in the shape of men. I want them all gone, to the very last. Are you willing to take on this task?%SPEECH_OFF% | %employer%\'s got a cat in his lap, but as you draw near you realize it\'s just the head and he\'s simply been thumbing a delimbed tail around with his thumb. He purses his lips.%SPEECH_ON%The barbarian savages did this. They also raped and pillaged a number of surrounding farmsteads and they hung a pair of twin infants from a tree, but this...%SPEECH_OFF%His palms open up and the cat\'s head rolls out and hits the stone floor with a matted clap.%SPEECH_ON%No more. I want you to go %direction% of here and find the village those savages call home and do unto it what they have done unto us!%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{How many crowns are we talking about? | What is %townname% prepared to pay for their safety? | Let\'s talk money.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Not interested. | We have more important matters to settle. | I wish you luck, but we\'ll not be part of this.}",
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
			ID = "Approaching",
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/event_138.png[/img]{You\'ve found the barbarian village and a series of cairns that lead toward it. The stones are stacked in the shapes of men, and at the top of each cairn rests a freshly hewn human head. %randombrother% nods.%SPEECH_ON%I wonder if they believe doing that gets them closer to their gods.%SPEECH_OFF%You suspect you have another way to get them closer to their gods: by killing them all. It\'s time to plan a way of attack. | You find the barbarian village and just to its outskirts lies a round stone in the snow. It\'s so large the entire company could lay foot-to-head and still not stretch across its middle. Runes have been carved into its outer rim, long divots that are caked with dried blood. In the center of the slab is a small square rise with a curve to hold the neck. %randombrother% spits.%SPEECH_ON%Looks like a sacrificial square, er, circle.%SPEECH_OFF%Looking around, you wonder aloud where they put the bodies. The sellsword shrugs.%SPEECH_ON%Dunno. Probably ate \'em.%SPEECH_OFF%It wouldn\'t surprise you if they did. You stare at the village and ponder attacking or waiting. | The barbarian village lies just a little ways away. It\'s a nomadic scene, tents surrounded by ad hoc smithy sites and tarped wagons for granaries. You get the feeling that they are not long for any particular part of the world. %randombrother% laughs.%SPEECH_ON%Look at that one. He\'s shittin\'. What a fucker.%SPEECH_OFF%Indeed, one of the savages is squatting while talking to his fellow villagers. It is almost a metaphor in and of itself for catching the entire encampment with their pants down. | The village of savages is surprisingly not the hellscape you expected. Aside from the flayed corpse hanging upside down from a wooden holy totem, it looks like any other place with ordinary folks. Aside from the heavy set clothes and every individual carrying an axe or sword of some kind. All quite normal. There\'s a guy chopping a corpse\'s legs off and feeding them to pigs, but you\'ll see that just about anywhere. %randombrother% nods.%SPEECH_ON%Well, we\'re ready to attack. Just give the word, captain.%SPEECH_OFF% | You find the barbarian village squatting in the snowy wastes. It couldn\'t have been there long: it\'s mostly tents and the tops of them don\'t carry much snow. They must set up for a time then get back on the road, either to keep hunts fresh or to avoid the retribution of those they raid. What a shame they\'ve failed to do the latter. You ready the company for action. | You find the village of savages. Though, from first glance, they look an ordinary sort. Men, women, children. There\'s a blacksmith, a tanner, a one-eyed guy making arrows, and a huge executioner disemboweling corpses and washing the offal scum on a donkey. That one. That one reminds you of why you\'re here. | You find the barbarian village. The savages are in the midst of some religious ritual. An elderly man with a tortoise shell necklace has his fist up the decapitated and shaved head. He\'s letting the blood run down his forearm where children take horsehair brushes and sweep up the \'paint\' and go to run it against a wooden holy totem that stands a good ten feet high. The primitives watch and chant in a tongue totally foreign to you. %randombrother% whispers as though out of respect for the ritual moreso than fear of them hearing.%SPEECH_ON%Well. I say we go on down there and make an introduction, yeah?%SPEECH_OFF% | You find the barbarians moseying about their village. It\'s mostly tents and impromptu snow houses. Elderly women sit in a circle weaving baskets and younger women are making arrows while throwing glances at the burly men walking around. The men themselves pretend they don\'t care, but you know a peacock in action when you see it. There are also children hurrying to and fro this task or that. And just outside the village stand a series of wooden stakes impaling naked corpses from anus to mouth, and their chest cavities have been spread apart like butterfly wings and the insides draped down like loosened embroidering.%SPEECH_ON%Horrid.%SPEECH_OFF%%randombrother% says. You nod. It is, but that\'s why you\'re here.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Prepare to attack.",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "TheDuel1",
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/event_139.png[/img]{Just as it seems the %companyname% is ready to clash with the savages, a lone figure steps out and stands between the battle lines. He\'s got a parted long beard knotted around tortoise shells and his head is sheltered beneath a sloping snout of a wolf\'s skull. The elder stands unarmed save for a long staff which clatters with tethered deer horns. Shockingly, he speaks in your tongue.%SPEECH_ON%Outsiders. Welcome to the North. We are not so inhospitable as you may think. As is our tradition, we believe that battle between two men is just as honorable and of value as that between two armies. So it is, I offer my strongest champion, %barbarianname%.%SPEECH_OFF%A burly man steps forward. He unhooks the pelts and tosses them aside to reveal a body of pure muscle, tendon, and scars. The elder nods.%SPEECH_ON%Put forth your champion, Outsiders, and we shall share a day that all our ancestors will smile upon.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "I\'d rather burn down this whole camp. Attack!",
					function getResult()
					{
						this.Flags.set("IsDuel", false);
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			],
			function start()
			{
				local raw_roster = this.World.getPlayerRoster().getAll();
				local roster = [];

				foreach( bro in raw_roster )
				{
					if (bro.getPlaceInFormation() <= 17)
					{
						roster.push(bro);
					}
				}

				roster.sort(function ( _a, _b )
				{
					if (_a.getXP() > _b.getXP())
					{
						return -1;
					}
					else if (_a.getXP() < _b.getXP())
					{
						return 1;
					}

					return 0;
				});
				local name = this.Flags.get("ChampionName");
				local difficulty = this.Contract.getDifficultyMult();
				local e = this.Math.min(3, roster.len());

				for( local i = 0; i < e; i = ++i )
				{
					local bro = roster[i];
					this.Options.push({
						Text = roster[i].getName() + " will fight your champion!",
						function getResult()
						{
							this.Flags.set("ChampionBrotherName", bro.getName());
							this.Flags.set("ChampionBrother", bro.getID());
							local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
							properties.CombatID = "Duel";
							properties.Music = this.Const.Music.BarbarianTracks;
							properties.Entities = [];
							properties.Entities.push({
								ID = this.Const.EntityType.BarbarianChampion,
								Name = name,
								Variant = difficulty >= 1.15 ? 1 : 0,
								Row = 0,
								Script = "scripts/entity/tactical/humans/barbarian_champion",
								Faction = this.Contract.m.Destination.getFaction(),
								function Callback( _entity, _tag )
								{
									_entity.setName(name);
								}

							});
							properties.EnemyBanners.push(this.Contract.m.Destination.getBanner());
							properties.Players.push(bro);
							properties.IsUsingSetPlayers = true;
							properties.BeforeDeploymentCallback = function ()
							{
								local size = this.Tactical.getMapSize();

								for( local x = 0; x < size.X; x = ++x )
								{
									for( local y = 0; y < size.Y; y = ++y )
									{
										local tile = this.Tactical.getTileSquare(x, y);
										tile.Level = this.Math.min(1, tile.Level);
									}
								}
							};
							this.World.Contracts.startScriptedCombat(properties, false, true, false);
							return 0;
						}

					});
					  // [062]  OP_CLOSE          0      7    0    0
				}
			}

		});
		this.m.Screens.push({
			ID = "TheDuel2",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_138.png[/img]{%champbrother% sheathes his weapons and stands over the corpse of the slain savage. Nodding, the victorious sellsword stares back at you.%SPEECH_ON%Finished, sir.%SPEECH_OFF%The elder comes forward again and raises his staff.%SPEECH_ON%So it is, what is it that you wish to have been solved by the violence you sought coming here?%SPEECH_OFF%You tell him that those to the south are furious and want them gone from these lands. The elder nods.%SPEECH_ON%If by battle you would have accomplished, then by honorable duel it is finished. We shall leave.%SPEECH_OFF%The savages are told in their tongue to pack up and go. Surprisingly, there\'s little backtalk or complaining. If they\'re true to their word then you can go and tell %employer% now.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A good end.",
					function getResult()
					{
						this.Contract.setState("Return");
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						return 0;
					}

				}
			],
			function start()
			{
				local bro = this.Tactical.getEntityByID(this.Flags.get("ChampionBrother"));
				this.Characters.push(bro.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "TheDuel3",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_138.png[/img]{It was a good fight, a clash between men upon the earth with those in observation silent as though in awe of some timeless and honorable rite. But. %champbrother% lies dead on the ground. Bested and killed. The elder steps forward again. He does not carry any hint of gloating or grin.%SPEECH_ON%Outsiders, the battle between two men is as such as it were between all of us combined. We have won, blessed is the Far Rock\'s gaze, and so we request that you depart these lands and do not return.%SPEECH_OFF%A few of the sellswords look to you with anger. One says he doesn\'t think the savages would abide the agreement were things the other way around, that the company should wipe these barbarians out regardless of the outcome.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We will stay true to our word and leave you in peace.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Assets.addMoralReputation(5);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Failed to destroy a barbarian encampment threatening " + this.Contract.m.Home.getName());
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				},
				{
					Text = "Everyone, charge!",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-3);
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivor1",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_145.png[/img]{The battle over, %randombrother% beckons you over. In one of the tents is a barbarian nursing a wound. Men, women, and children litter the floor around him. The sellsword points to him.%SPEECH_ON%We chased the savage in here. I think that\'s his family all around him, or someone he knows, cause he just collapsed and hasn\'t moved since.%SPEECH_OFF%You walk toward the man and crouch before him. You tap one of his deerskin boots and ask if he understand you. He nods and shrugs.%SPEECH_ON%Little. You did this. Didn\'t have to, but did. Finish me, or I fight with you. One, the other, all honorable.%SPEECH_OFF%It seems he\'s offering his hand to fight with the company, no doubt part of some northern code that\'s foreign to yourself. He\'s also offering his head if you want that, too, and he seems totally unafraid of giving it up.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We\'ll leave noone alive.",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-1);
						return "Survivor2";
					}

				},
				{
					Text = "Let him go.",
					function getResult()
					{
						this.World.Assets.addMoralReputation(2);
						return "Survivor3";
					}

				}
			],
			function start()
			{
				if (this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
				{
					this.Options.push({
						Text = "We could need a man like this.",
						function getResult()
						{
							return "Survivor4";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Survivor2",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_145.png[/img]{You unsheathe your sword and lower the blade toward the man, the corpses in the tent blurring along its metal curvature, and the surviving barbarian\'s face blobbing at the tip. He grins and grips the edges, sheathing it in his huge hands. Blood drips steadily from his palms.%SPEECH_ON%Death, killing, no dishonor. For us both. Yes?%SPEECH_OFF%Nodding, you push the blade into his chest and sink him back to the floor. The weight of him on the sword is like a stone and when you unstick him the corpse claps back against the pile of corpses. Sheathing the sword, you tell the company to round up what goods they can and to ready a Retournez à %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Time to get paid.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivor3",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_145.png[/img]{You unsheathe your blade halfway, hold it long enough that the savage sees it, then you slam it back into the scabbard. Nodding, you ask.%SPEECH_ON%Understand?%SPEECH_OFF%The barbarian stands up, briefly slumping against the tent\'s post. You turn and hold your hand out to the tent flap. He nods.%SPEECH_ON%Aye, I know.%SPEECH_OFF%He stumbles out and into the light and away into the northern wastes, his shape tottering side to side, shrinking, and is then gone. You tell the company to get ready to Retournez à %employer% for some well-earned pay.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Time to get paid.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivor4",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_145.png[/img]{You stare at the man, then take out your dagger and slice the inside of your palm. Squeezing the blood, you toss the dagger to the barbarian and then hold your hand out, the blood dripping steadily. The savage takes the blade and cuts himself in turn. He stands and puts his hand out and you shake. He nods.%SPEECH_ON%Honor, always. With you, the only way, all the way.%SPEECH_OFF%The man stumbles out of the tent. You tell the men to not kill him, but instead to arm him which raises some eyebrows. His addition to the company is unforeseen, but useful. The southern sellswords will get used to it in time, but for now the %companyname% needs to Retournez à %employer%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Welcome to the %companyname%.",
					function getResult()
					{
						this.World.getPlayerRoster().add(this.Contract.m.Dude);
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude.worsenMood(1.0, "Has seen his village being slaughtered");
						this.Contract.m.Dude.onHired();
						this.Contract.m.Dude = null;
						return 0;
					}

				}
			],
			function start()
			{
				local roster = this.World.getTemporaryRoster();
				this.Contract.m.Dude = roster.create("scripts/entity/tactical/player");
				this.Contract.m.Dude.setStartValuesEx([
					"barbarian_background"
				]);

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Revenge1",
			Title = "On your return...",
			Text = "[img]gfx/ui/events/event_135.png[/img]{A man stands out into your path. He\'s an elder and not of southern reaches.%SPEECH_ON%Ah, the Outsiders. You come to our lands and ravage an undefended village.%SPEECH_OFF%You spit and nod. %randombrother% yells out that it\'s what the savages themselves do. The old man smiles.%SPEECH_ON%So we are in cycle, and through this violence we all shall regenerate, but violence there shall be. When we are through with you, %townname% will not be spared.%SPEECH_OFF%A line of strongmen get up out of the terrain where they were hiding. By the looks of it, this is the main war party of the village you burned down. They may have been out raiding when you sacked the place. Now here they are seeking barbarian retribution.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To arms!",
					function getResult()
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Revenge";
						properties.Music = this.Const.Music.BarbarianTracks;
						properties.EnemyBanners.push(this.Flags.get("EnemyBanner"));
						properties.Entities = [];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.Barbarians, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).getID());
						this.World.Contracts.startScriptedCombat(properties, false, true, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Revenge2",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_145.png[/img]{The savages are driven from %townname%. Despite the results, it takes time for the villagers to emerge and see your victory in full. %employer% eventually comes out clapping and hollering. There\'s a retinue of sheepish lieutenants looking around, their knees muddied, stray straw and clods of earth all over them. It appears they were hiding.%SPEECH_ON%Well done, sellsword, well done! The old gods surely all of that and will reward you in good time!%SPEECH_OFF%You sheathe your sword and nod at the man\'s useless lieutenants.%SPEECH_ON%Maybe, but you better do it first anyway. The old gods would surely appreciate your acting on their behalf given that others, shall we say, could not?%SPEECH_OFF%The man purses his lips and glances at his lieutenants who glance away. Your employer smiles and nods.%SPEECH_ON%Of course, of course, sellsword. I understand you well. You shall be paid in full and then some! All well-earned, truly!%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "A hard day\'s work.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() * 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "You destroyed a barbarian encampment that threatened " + this.Contract.m.Home.getName());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "You saved " + this.Contract.m.Home.getName() + " from barbarian revenge");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() * 2;
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] Crowns"
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Revenge3",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_94.png[/img]{You\'re run off the field of battle and retreat to a safe enough spot to watch the ruination of %townname%. The savages dip into homes and start raping and murdering of both men and women. Children are collected up and heaved into cages made of bone and hide where the elder gently hands them sliced apples and cups of camphor. At the town square you watch as the primitives set upon %employer%\'s home. A few guards step forward, but they\'re cut down almost immediately. One man is laid out upon the ground and is stripped and kicked toward a pair of dogs who tear at him from every which way and he survives and uncomfortably long time. \n\n Finally, %employer% is dragged out of his home. The barbarian leader stares down at him, nods, then grabs him by the neck with one hand and covers his face with the other. In this suspension the man is suffocated. The corpse is then thrown to the warband who have it stripped, desecrated, and then impaled from anus to mouth and lifted high up in the town square. Once the pillaging is done, the savages take what look they want and depart. The last you see of them is a dog trotting with a human ribcage in its maw. %randombrother% comes to your side.%SPEECH_ON%Well. I don\'t think we\'re getting paid, sir.%SPEECH_OFF%No. You suspect not.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "All is lost.",
					function getResult()
					{
						this.World.FactionManager.getFaction(this.Contract.getFaction()).getRoster().remove(this.Tactical.getEntityByID(this.Contract.m.EmployerID));
						this.Contract.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), 4);
						this.Contract.m.Home.setLastSpawnTimeToNow();
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail * 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail * 2, "You failed to save " + this.Contract.m.Home.getName() + " from barbarians out for revenge");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "Near %townname%...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% welcomes your entrance with applause.%SPEECH_ON%My scouts tracked your company to the north and to its, dare I say, inevitable success! Splendid work murdering those savages. Surely this will make them think twice about venturing down here again!%SPEECH_OFF%The man pays you what you\'re owed. | You enter %employer%\'s room and find him slackened into his chair. He\'s watching a naked woman saunter from one side of the room to the other. Shaking his head, he talks to you while not taking his eyes from the show.%SPEECH_ON%My scouts have already told me of your doings. Said you put it to the barbarians like they\'d done their wrongs against you personally. I like that. I like the lack of restraint. Wish more of my own men had it.%SPEECH_OFF%A servant, previously unseen, quickly marches across the room. He\'s got a red candle atop his head and a chest of crowns in his hands. You take your pay and leave the room as quick as you can. | You find %employer% and a group of armored men standing around a table. A barbarian\'s corpse is on it. The flesh is greyed, but the body\'s musculature and grit has not yet been decayed. They ask if you truly fought men of this sort. You cut to the chase and ask for your pay. %employer% claps and shows you off to the group.%SPEECH_ON%Gentlemen, this is the sort of man I want in my ranks! Unfearful and always focused.%SPEECH_OFF%One of the nobles spits and says something you don\'t hear. You ask him to speak up if he\'s something to say, but %employer% rushes forward, chest of crowns in hand, and sends you on your way. | Finding %employer% proves a little difficult, a hunt that ends in a seemingly abandoned barn. You see him standing before a dead barbarian, the corpse hanging from the rafters by his legs like a fisherman\'s haul. The body has been burned, mutilated, and all else. %employer% crouches and washes his hands in a bucket.%SPEECH_ON%I\'ve to say, sellsword, you killing a whole number of these savages is most impressive. This one here lasted a good long while. Took to the pain like he was gonna pay it forward to me tenfold. But he never did. Did you?%SPEECH_OFF%The man gently slaps the barbarian\'s face and the chains clink as the body gently twists. %employer% nods.%SPEECH_ON%A servant outside will have your pay. A job well done, sellsword.%SPEECH_OFF% | You find %employer% and a group of men overseeing the defense of %townname%, no doubt preparing themselves for whatever attack may come next. Judging by the appearance of the men, their ambitions of survival will meet a reality far more cruel than they are ready for. But you keep that to yourself. %employer% thanks you for a job well done and pays you what is owed. | A few denizens of %townname% see your return with horrified confusion, mistaking you for the savages that they\'d come to know. Windows are shuttered, doors slammed closed, children hurried away, and a few braver souls step out with pitchforks. %employer% hurries out of his abode and sets them straight, explaining you are the heroes of the tale, that you went north and annihilated the savages, burned their village, and scattered them to the wastes. Windows swing wide and doors creak open and the children Retournez à their play. Just when you think order has returned, an old woman snarls.%SPEECH_ON%A sellsword is just a savage by another name!%SPEECH_OFF%Sighing, you tell %employer% to pay what is owed. | %employer% is studying a few scrolls. He\'s also penning notes into them and crossing others out. Looking up, he explains that he\'s putting you into the records as a \'hero who went to the wastes\' and \'slaughtered the savages in a fashion most proper and southernly.\' He asks you to remind him what your name is. You ask him to pay you what you\'re owed. | %employer% is in the company of a group of sobbing women. He\'s consoling them and when you enter he stands and points you out to them.%SPEECH_ON%Behold! The man who has slain those who murdered your husbands!%SPEECH_OFF%The women wail and clamber to you, one after the other, and you know what to do besides nod sternly and stoically. %employer% is the last of the crowd to find you, a chest of crowns in his arm and a wry smile on his lips. You take your pay and the man returns to the women.%SPEECH_ON%There there, fine ladies, the world will see a new dawn. Please, come with me. Does anyone want wine?%SPEECH_OFF% | %employer% welcomes you with open arms. You decline a hug and ask for your pay. He returns to his desk.%SPEECH_ON%I wasn\'t trying to hug you, sellsword.%SPEECH_OFF%He taps the chest rather despondently.%SPEECH_ON%But you did a good job slaughtering those savages. I\'ve a number of scouts who reported it as a \'splendid time\' you had out there. You\'ve earned this.%SPEECH_OFF%He pushes the chest across the desk and you take it at arm\'s length, meeting a slight bit of resistance as he holds onto it. You hurriedly leave the room without looking at him again. | You have a hard time finding %employer%, eventually finding him halfway down a well shaft plugging a hole with a stone slab. He shouts up to you.%SPEECH_ON%Ah, the sellsword. Hoist me up, men!%SPEECH_OFF%A pulley system draws up the plank upon which he sits. He swings his legs off and rests them on the rim of the wellhead.%SPEECH_ON%Our mason was killed by a donkey so I thought I\'d lend a hand myself. Nothing like a little dirty work to get a good man up in the morn\'.%SPEECH_OFF%He slaps your chest with his glove, it leaves a powdered outline. He nods and fetches a servant to go get your pay.%SPEECH_ON%A job well done, sellsword. Very, very well done. Heh.%SPEECH_OFF%You don\'t humor him. | %employer% is found giving a speech to a crowd of peasants. He describes an unnamed force of southerners that headed north and annihilated the savage scum. At no point are you or the %companyname% named. When he\'s done, the mob of peons cheer and clap and flowers are thrown and a general state of festivity takes over. %employer% seeks you out and shakes your hand while pushing a chest of crowns toward you.%SPEECH_ON%I wish I could call you the hero to these fine folk, but mercenaries are not seen in the best of light.%SPEECH_OFF%You wrap your hands autour de payment and lean forward.%SPEECH_ON%All I want is the pay. Have fun out there, %employer%.%SPEECH_OFF% | You find %employer% attending a funeral ceremony. They\'re burning a pyre weighed with three corpses and what may possibly be a fourth, smaller one. Possibly a whole family. %employer% says a few kind words and then sets the woodwork ablaze. A servant surprises you with a chest of crowns.%SPEECH_ON%%employer% does not wish to be bothered. Here is your pay, sellsword. Please count if you do not trust it is all there.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "You destroyed a barbarian encampment that threatened " + this.Contract.m.Home.getName());
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
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] Crowns"
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
			"barbarianname",
			this.m.Flags.get("ChampionName")
		]);
		_vars.push([
			"champbrother",
			this.m.Flags.get("ChampionBrotherName")
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


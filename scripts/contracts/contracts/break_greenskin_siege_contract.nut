this.break_greenskin_siege_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Troops = null,
		IsPlayerAttacking = true,
		IsEscortUpdated = false
	},
	function create()
	{
		this.contract.create();
		local r = this.Math.rand(1, 100);

		if (r <= 70)
		{
			this.m.DifficultyMult = this.Math.rand(90, 105) * 0.01;
		}
		else
		{
			this.m.DifficultyMult = this.Math.rand(115, 135) * 0.01;
		}

		this.m.Type = "contract.break_greenskin_siege";
		this.m.Name = "Break Siege";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
		this.m.MakeAllSpawnsResetOrdersOnContractEnd = false;
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

		this.m.Flags.set("ObjectiveName", this.m.Origin.getName());
		local nearest_orcs = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(this.m.Origin.getTile());
		this.m.Flags.set("OrcBase", nearest_orcs.getID());
		local nearest_goblins = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getNearestSettlement(this.m.Origin.getTile());
		this.m.Flags.set("GoblinBase", nearest_goblins.getID());
		this.m.Payment.Pool = 1500 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Voyagez jusqu\'à %objective%",
					"Brisez le siège des Peaux-Vertes"
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
				local okLocations = 0;

				foreach( l in this.Contract.m.Origin.getAttachedLocations() )
				{
					if (l.isActive())
					{
						okLocations = ++okLocations;
					}
				}

				if (okLocations < 3)
				{
					foreach( l in this.Contract.m.Origin.getAttachedLocations() )
					{
						if (!l.isActive() && !l.isMilitary())
						{
							l.setActive(true);
							okLocations = ++okLocations;

							if (okLocations >= 3)
							{
								break;
							}
						}
					}
				}

				local faction = this.World.FactionManager.getFaction(this.Contract.getFaction());
				local party = faction.spawnEntity(this.Contract.getHome().getTile(), this.Contract.getHome().getName() + " Company", true, this.Const.World.Spawn.Noble, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.getSprite("banner").setBrush(faction.getBannerSmall());
				party.setDescription("Professional soldiers in service to local lords.");
				this.Contract.m.Troops = this.WeakTableRef(party);
				party.getLoot().Money = this.Math.rand(50, 200);
				party.getLoot().ArmorParts = this.Math.rand(0, 25);
				party.getLoot().Medicine = this.Math.rand(0, 5);
				party.getLoot().Ammo = this.Math.rand(0, 30);
				local r = this.Math.rand(1, 4);

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

				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local move = this.new("scripts/ai/world/orders/move_order");
				move.setDestination(this.Contract.getOrigin().getTile());
				c.addOrder(move);
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
				}

				this.World.State.setEscortedEntity(this.Contract.m.Troops);
			}

			function update()
			{
				if (this.Flags.get("IsContractFailed"))
				{
					this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
					this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Company broke a contract");
					this.World.Contracts.finishActiveContract(true);
					return;
				}

				if (this.Contract.m.Troops != null && !this.Contract.m.Troops.isNull())
				{
					if (!this.Contract.m.IsEscortUpdated)
					{
						this.World.State.setEscortedEntity(this.Contract.m.Troops);
						this.Contract.m.IsEscortUpdated = true;
					}

					this.World.State.setCampingAllowed(false);
					this.World.State.getPlayer().setPos(this.Contract.m.Troops.getPos());
					this.World.State.getPlayer().setVisible(false);
					this.World.Assets.setUseProvisions(false);
					this.World.getCamera().moveTo(this.World.State.getPlayer());

					if (!this.World.State.isPaused())
					{
						this.World.setSpeedMult(this.Const.World.SpeedSettings.FastMult);
					}

					this.World.State.m.LastWorldSpeedMult = this.Const.World.SpeedSettings.FastMult;
				}

				if ((this.Contract.m.Troops == null || this.Contract.m.Troops.isNull() || !this.Contract.m.Troops.isAlive()) && !this.Flags.get("IsTroopsDeadShown"))
				{
					this.Flags.set("IsTroopsDeadShown", true);
					this.World.State.setCampingAllowed(true);
					this.World.State.setEscortedEntity(null);
					this.World.State.getPlayer().setVisible(true);
					this.World.Assets.setUseProvisions(true);

					if (!this.World.State.isPaused())
					{
						this.World.setSpeedMult(1.0);
					}

					this.World.State.m.LastWorldSpeedMult = 1.0;
					this.Contract.setScreen("TroopsHaveDied");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerNear(this.Contract.m.Origin, 1200))
				{
					if (this.Contract.m.Troops == null || this.Contract.m.Troops.isNull())
					{
						this.Contract.setScreen("ArrivingAtTheSiegeNoTroops");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("ArrivingAtTheSiege");
						this.World.Contracts.showActiveContract();
					}

					this.World.State.setCampingAllowed(true);
					this.World.State.setEscortedEntity(null);
					this.World.State.getPlayer().setVisible(true);
					this.World.Assets.setUseProvisions(true);

					if (!this.World.State.isPaused())
					{
						this.World.setSpeedMult(1.0);
					}

					this.World.State.m.LastWorldSpeedMult = 1.0;
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Flags.set("IsContractFailed", true);
			}

		});
		this.m.States.push({
			ID = "Running_BreakSiege",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Détruisez tous les engins de siège des Peaux-Vertes",
					"Tuez toutes les Peaux-Vertes autour de %objective%"
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = false;
				}

				foreach( id in this.Contract.m.UnitsSpawned )
				{
					local e = this.World.getEntityByID(id);

					if (e != null)
					{
						e.getSprite("selection").Visible = true;

						if (e.getFlags().has("SiegeEngine"))
						{
							e.setOnCombatWithPlayerCallback(this.onCombatWithSiegeEngines.bindenv(this));
						}
					}
				}
			}

			function update()
			{
				if (this.Contract.m.UnitsSpawned.len() == 0)
				{
					this.Contract.setScreen("TheAftermath");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.m.Origin == null || this.Contract.m.Origin.isNull() || !this.Contract.m.Origin.isAlive())
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatWithSiegeEngines( _dest, _isPlayerAttacking = true )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
				local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
				p.Music = this.Const.Music.GoblinsTracks;
				p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Edge;
				p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
				p.EnemyBanners = [
					this.World.getEntityByID(this.Flags.get("GoblinBase")).getBanner()
				];
				this.World.Contracts.startScriptedCombat(p, this.Contract.m.IsPlayerAttacking, true, true);
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Retournez à " + this.Contract.m.Home.getName()
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = false;
				}

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
			Title = "Négociations",
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% hands you a goblet of wine.%SPEECH_ON%Drink up.%SPEECH_OFF%You can almost taste the bad news on his breath. Downing the drink in one go, you nod at the man. He nods back.%SPEECH_ON%The greenskins are swarming through the region and it looks like they plan to take %objective%.%SPEECH_OFF%He pours another drink, downs it, then pours another.%SPEECH_ON%If it falls, then I think we can assume the rest of the region will go with it. I don\'t know how learned you are about what happened ten years ago the last time these brutes came through, but not many around here want to see it happen again. Now, my spies tell me the siege has just started and the greenskins are not at full strength, meaning we can attack now and break it before things get out of control. If you\'re interested, which by the old gods I surely hope you are, then I need you to go there and break that siege!%SPEECH_OFF% | The guards are around %employer%. They\'ve got their helmets off, their heads laden with sweat, and some are shaking in their armor. %employer%, seeing you through the crowd of despair, waves you forward.%SPEECH_ON%Sellsword! I have some... particularly horrible news. Perhaps you\'ve already heard, but I\'ll lay it out quick as time is running out: greenskins have possibly invaded the region and they are threatening to take %objective%. They\'re currently sieging it, but reports say the greenies aren\'t yet full strength. I need you to go there and break it before things get out of our control.%SPEECH_OFF% | %employer%\'s got a few scribes standing at side. They take turns whispering, the nobleman simply nodding to everything they say. Eventually, %employer% turns his attention to you.%SPEECH_ON%Sellsword, you ever broken a siege before? %objective% in the region is currently besieged by greenskins. We\'ve little time before they overrun the place, and then maybe take the whole damned region! After that... well, I\'m sure you know what happened ten years ago.%SPEECH_OFF%The scribes nod in unison and bow their heads. %employer% continues.%SPEECH_ON%So what do you say, interested in a bit of military action?%SPEECH_OFF% | %employer% welcomes you with a concerned face.%SPEECH_ON%We\'re in a bit of a bind, sellsword, and we need your help! %objective% has been besieged by greenskins and I don\'t have enough troops to go break it just by myself. But I think you\'re up to the task. Are you? I\'ll pay handsomely.%SPEECH_OFF% | %employer%\'s standing with arms tented on a table. His shoulders are hunched, like a crow staring down at a kill. He shakes his head.%SPEECH_ON%Sellsword, I need more bodies to help lift an army of greenskins besieging %objective%. Are you up to it? I need to know right now.%SPEECH_OFF% | %employer% stands upon your entering. There\'s sweat on his face and he gives a frantic, sideways smile.%SPEECH_ON%Sellsword! So, so glad you are here! News has come that greenskins have besieged %objective% and I need your help! Are you interested or not? I need a decision fast.%SPEECH_OFF% | You find %employer% buried deep into his chair, as though he wished the back of it would just close and shut him out of this world forever. He lazily gestures toward a map on a table.%SPEECH_ON%Well, the news is that greenskins are back and they\'re besieging %objective%. I need as many men as I can muster to go there and relieve it. The pay will be appropriate, are you in?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Combien ça vaudrait de sauvez %objective% pour vous? | Brisé un siège c\'est quelque chose que %companyname% peut faire.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Ça ne vaut pas le coup. | Nous avons d\'autres obligations.}",
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
			ID = "PreparingForBattle",
			Title = "At %townname%...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{You walk out of %employer%\'s place and prepare the company. All around you are knights and soldiers running about. A few of them are huddled around a holy man, silently preparing themselves for death.%SPEECH_ON%Gotta make reservations.%SPEECH_OFF%%randombrother% says as he joins your side. He gives you a good smirk.%SPEECH_ON%What, too dark?%SPEECH_OFF% | Outside %employer%\'s domicile there are soldiers running all over. Some are heaving supplies into the back of wagons, others are sharpening their weapons, while a handful of squires run to and fro with great armfuls of armor. You go over to your men and order them to get ready. %randombrother% nods toward all the activity.%SPEECH_ON%I guess we\'ll be having friends with us this time?%SPEECH_OFF% | There are soldiers just outside %employer%\'s room, and there are soldiers in the halls. You pass by rooms of scared women and children and blind old men that would rather be deaf. Outside, you have to fight through a busy crowd of squires swarming about with arms and armors. The %companyname% is waiting for you.%SPEECH_ON%Let\'s get going. These men here must prepare to fight, but we just come that way, don\'t we fellas?%SPEECH_OFF% | When you leave %employer%\'s place you find %randombrother% waiting for you. He\'s watching the busy battle preparations all around: squires running about with arms and armor, men heaving supplies into wagons, and holy men momentarily quelling the fears of the young men. You tell your sellsword to get ready as you will be following these soldiers out to break the siege. | You step outside to find %employer%\'s men getting ready. They\'re loading their equipment onto wagons while a holy man walks the lines. Women, children, and elders stand by the wayside. The %companyname% are standing dutifully. You head over and inform them of the task at hand. | Stepping outside, you find %employer%\'s soldiers gearing up for war. Children run amok, playing war with each other, laughing in total ignorance of the real thing. Women, some of them having already lost a husband or two, are far more pensive. You walk past the procession and go to the %companyname% to fill them in on the details of the task at hand. | %employer%\'s soldiers are getting ready for war. The young are nervous, masking their fear with faux courage and reluctant laughs. The veterans go about their tasks, their faces showing men who know of old friends who never made it back. And the crazy, the wide-eyed and bloodlusting, they are almost unnervingly giddy at the prospect of war that is afoot. You pass them all up to go and inform the %companyname% of what it must do. | As you step outside you find the soldiers of %employer%\'s army getting ready to march. Weapons are in a big pile from which the men are picking and choosing. It\'s an odd sight and shows a lack of organization. Probably not the best of signs, but you put it behind you to go and inform the %companyname% of its new contract.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Off we go!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TroopsHaveDied",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_22.png[/img]All the noble soldiers have died en route to the siege. Better them than you. The %companyname% presses on towards %objective%.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We must Continuez.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ArrivingAtTheSiege",
			Title = "Near %objective%...",
			Text = "[img]gfx/ui/events/event_68.png[/img]{You finally arrive to the siege. Greenskins surround %objective% and you watch as their war engines send flaming stones through the air. Half the town seems to already be alight and you see tiny dots of men rushing to and fro to put fight the fires. The noble soldiers\' lieutenant orders you to go and attack the siege engines. You are to then join back up and destroy any savages left. | %objective% better resembles an enormous bonfire than it does a town. You watch as the greenskins\' siege engines launch a furious bombardment, the skies filled with black stones, dead cows, and burning timber. The noble soldiers\' lieutenant orders you to destroy the siege engines. He and his men will attack the main core of the greenskins\' army and then you the two of you will link back up to finish off any stragglers. | The siege is still alive and well as %objective% is seen still holding out. It seems you came just in time, because the greenskins are launching so much destruction from their siege engines there might not be even be a town at all in a couple of hours. Seeing this action, the noble soldiers\' lieutenant orders you to flank and destroy the siege weapons. He and his men will attack the core of the savages\' army and then together you\'ll link back up to slaughter any survivors. | You hear the bombardment before you see it. The whistling of siege shots travels the air like a furious wind, and the crashing of their descent is a most cruel coda. Eventually, you top a hill to get a good look at %objective%. It is surrounded by green savages whose siege engines are lurching and lunging with action, launching stones, dead cows, bundles of human corpses, whatever the bastards can get their hands on.\n\nThe noble soldiers\' lieutenant comes to you with his plan. You are to flank and attack the siege engines. He and his men will attack the center of the greenskin army and, once successful, the two of you will link back up and annihilate whatever remains. | A young woman is found on the road with a pack of children huddling close like wolf pups in a brutal winter. Dried blood cakes the side of her head, though she hides it well with a clop of matted hair. She explains that if you\'re going to %objective% you must hurry. The greenskins have set up their siege weapons and are launching a furious bombardment. You and the noble soldiers press on, the woman left with a satchel of bread to feed the kids.\n\n Topping the next hill, you are given a sight that confirms the refugee\'s story. The noble soldiers\' lieutenant quickly dishes out orders. You and the %companyname% will attack the siege engines while the soldiers attack the core of the greenskin army. Once these tasks are completed, you will link up and annihilate any stragglers. | You and the noble soldiers top the nearest hill to %objective%. The town is still there, but damn is it closer to being a pile of rubble than it is a village. The greenskins must have been bombarding it with their shanty siege engines for some time now and they don\'t seem to be stopping any time soon.\n\n The noble soldiers\' lieutenant orders you to flank the savages and attack the siege weapons. Meanwhile, the soldiers will attack the core of the savage army. Once both tasks are completed, you\'ll link back up and destroy what few stragglers remain. | You find an old man pushing a cart down the road. In the bed, is a young man with crushed legs. He\'s passed out, his hands still clutching shattered knees. The old man says %objective% is just yonder over the nearest hill and being bombarded with siege weapons so if you\'re going to take action it\'d be best to do it quick. The %companyname% and soldiers move on ahead, leaving the old man to trundle forth.\n\n The elder wasn\'t lying: %objective% is burning and is slowly being turned into rubble with a bevy of savage siege engines. Seeing it with his own eyes, the noble soldiers\' lieutenant quickly concocts a plan of action: the %companyname% will flank and attack the siege weapons while the soldiers take on the bulk of the greenskin army. Once both tasks are done, you\'ll link back up and kill whatever\'s left alive. | You find a horde of wild dogs running down the road. They steer clear of your group, but you notice that their tails are tucked between their legs and their heads stooped low. There\'s no pause in their gait as they quickly pass you by.\n\n Topping the next hill over, you see the cause for chaos: the greenskins are relentlessly bombarding %objective% with rows of shanty siege engines. The noble soldiers\' lieutenant nods at this and quickly barks out orders. The %companyname% will flank and attack the siege weapons directly. When you\'re done, you are to loop back around and link up with the soldiers and continue on from there.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Make ready for battle!",
					function getResult()
					{
						this.Contract.setState("Running_BreakSiege");
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.spawnSiege();
			}

		});
		this.m.Screens.push({
			ID = "ArrivingAtTheSiegeNoTroops",
			Title = "Near %objective%...",
			Text = "[img]gfx/ui/events/event_68.png[/img]{You finally see %objective% and it is in dire straits. The town is being bombarded with a stream of greenskin siege engines. You order the %companyname% to prepare for action: you\'ll flank the army and attack the engines directly. | With all the noble soldiers dead, you arrive at %objective% alone. The greenskins are still at it, bombarding the poor town with shanty siege weapons. You decide the best plan of action is to flank the savages and attack their siege engines.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Make ready for battle!",
					function getResult()
					{
						this.Contract.setState("Running_BreakSiege");
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.spawnSiege();
			}

		});
		this.m.Screens.push({
			ID = "SiegeEquipmentAhead",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_68.png[/img]{The greenskins have assembled some siege weaponry close by. You\'ll have to destroy them to help lift the siege! | Your men spot a few pieces of siege equipment nearby. The greenskins must have been preparing an assault! You will need to destroy them to help lift the siege!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Engage!",
					function getResult()
					{
						this.Contract.getActiveState().onCombatWithSiegeEngines(null, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Shaman",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_48.png[/img]{En vous approchant the sieging goblins, you spot a rather unique silhouette standing amongst their ranks. It is that of a shaman. You tell your men to prepare themselves appropriately. | A rather unique profile stands tall amongst the goblins. You see it barking orders in that horrid tongue they think to be a language. The foul thing is wreathed in strange plants and what appears to be a necklace of animal bones.%SPEECH_ON%That\'s a shaman.%SPEECH_OFF%%randombrother% says as he joins our side.%SPEECH_ON%I\'ll alert the rest of the men.%SPEECH_OFF% | %randombrother% returns from scouting. He shares news that a goblin shaman is within the invading greenskins group. The man seems rather miffed.%SPEECH_ON%I love killing me some gobbos, but them pricks will give us a proper headache this time.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Engage!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Warlord",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_49.png[/img]{As you near the sieging greenskins, you identify something almost impossible to miss: the large and imposing figure of an orcish warlord. The foul thing\'s armor glints as it turns about to bark orders in its orcish tongue, spurring its fellow greenskins into a violent, frothing fervor. You tell %randombrother% to spread the news and prepare the men. | While approaching the sieging party, you recognize the tall, brutish silhouette of an orc warlord. Even at this distance you can hear him barking orders to his grunts. This fight just got a little more interesting. | You near the siege camp of greenskins only to hear the distinct growl of an orc warlord. He\'s belting out orders in their disgusting and quite loud language. His presence changes the task at hand just a little bit and you inform the men as much. | %randombrother% returns from scouting. He states that there is an orc warlord in the greenskins\' encampment. Bad news, but better knowing now and preparing then going in and being taken by surprise.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Engage!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TheAftermath",
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{The battle\'s over, the greenskins routed from the field. %objective% is saved and %employer% will be most pleased. You step over the mounds of corpses, man and beast alike, collecting your men for the march back. | Bodies litter the field, clouds of flies already starting to gather and busy themselves. You gather your men and prepare a Retournez à %employer% for your pay. | %objective% is saved! Well, what\'s left of it. Soldiers and greenskins, dead and dying, litter the ground as far as the eye wants to see. It\'s a cruel sight, so freshly produced. You order the %companyname% to prepare to Retournez à %employer% for your pay. | Mounds of corpses stacked two, three, sometimes even four bodies high. Survivors are found buried beneath these dead, six-feet under despite being above ground. It is a horrific sight, and an even worse display of sound as the wounded and dying call out for help. Spotting them in the sea of body parts is like trying to find a sailor bobbing atop a dark ocean. You turn away from the scene and gather the men of the %companyname%. %employer% should be happily awaiting your return. | The battle won and over, you watch as pike-armed men carefully traipse the field. They use the weapon-given distance to safely dispatch any wounded greenskins still lying about. The rest of the noble soldiers sink to the ground, drinking water and washing the blood from their faces. You\'ve no time for such rest and quickly gather your sellswords to Retournez à %employer%. | Blood muddies the earth and your boots sink deep into the muck. Corpses lay about, bodies rendered unfamiliar, body parts detached and spread far from their owners. Decapitated heads here and there, eyes frozen in shock. Broken arrows, splintered spears, deserted swords. Parts of shattered armor crinkling underfoot. It was one hell of a battle and it has certainly left its mark for all to come and see.\n\n With %objective% saved, you slowly gather the %companyname% to Retournez à %employer% for its big payday. | The battle over, the noble soldiers spare no time in decapitating every greenskin they can find. They stab the heads onto pikes and raise them high, mirroring the barbarity of the savages they\'d just dispatched. You\'ve no time for such theatrics. %objective% is saved and that is what you will be paid for. The %companyname% quickly gathers for a return trip to %employer%. | The battle over, you carefully step across the field. Each corpse tells a story of how it came to be. Some stabbed in the back, others without heads, their stories somewhere else, others yet have been gutted and are found clutching their innards with shocked expressions of having been witness to things not meant to be seen. Nothing new, all the same, just a different place. What matters most is that %objective% is still standing. You gather the %companyname% to Retournez à %employer% and receive your pay. | %randombrother% comes to your side. He\'s holding the head of a greenskin, but quickly tosses it away as if whatever novelty there was to it had just faded. He puts his hands to his hips and nods at the battlefield.%SPEECH_ON%Well, that\'s something.%SPEECH_OFF%Corpses, sometimes stacked three or four high, litter the ground. Limbs twisting, faces strained, blood heard leaking. Men march through it, their legs retching great sprays of pooled blood as though they were marching through a creekbed. %objective%, burning it may be, still stands in the distance and that\'s all that matters to you. The %companyname% should now Retournez à %employer% for its pay. | The siege has been lifted, though the greenskins did not give it up willingly. Dead men and beasts litter the land as far as you can see and no doubt accurately fulfill any imagination beyond. %randombrother% comes to your side. He lifts a strap of green flesh off his shoulder and whips it away like a wet rag.%SPEECH_ON%Hell of a fight, sir.%SPEECH_OFF%You nod and order him to prepare the men. %employer% should be most happy to hear that %objective% has been saved.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Victory!",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{You Retournez à %employer% with a few of his lieutenants behind you. They report the news and your employer quickly nods and hands you a large satchel of crowns. His lieutenants give you a few jealous stares as you make your leave. | The siege was broken and you report as much to %employer%. He nods and gives you a satchel of crowns.%SPEECH_ON%They\'ll speak of you. Those not yet born, I mean.%SPEECH_OFF% | You give %employer% the news of the broken siege. He stands up and shakes your hands.%SPEECH_ON%By the old gods your service here today shan\'t ever be forgotten!%SPEECH_OFF%But in your head you wonder if that exact line has been said to a man who, now, is just bone and dust. You take the reward anyway, leaving heritage and history to the philosophers. | %employer% readily welcomes your return, quickly springing to his feet and almost tripping over one of his dogs.%SPEECH_ON%Mercenary, I\'ve already heard the great news! The siege has been lifted and so you have earned a mighty reward indeed!%SPEECH_OFF%He heaves a heavy chest onto his desk. You take it, counting the crowns, then make your leave. | %employer%\'s sitting behind his desk when you enter.%SPEECH_ON%Come on in, \'hero.\' What shall they inscribe next to your name?%SPEECH_OFF%You ask what it is he is going on about.%SPEECH_ON%Sellsword, please. Don\'t be so modest, what you accomplished is worthy of being carried on the tongues of those not even born yet!%SPEECH_OFF%You nod.%SPEECH_ON%Yeah, sure. That\'s great and all. Where\'s my money?%SPEECH_OFF%Your employer\'s lips purse. He nods in return and hands the satchel over.%SPEECH_ON%A man of many tasks, I\'m sure. This one is nothing to you, but it means a lot to us!%SPEECH_OFF% | %employer%\'s looking down at his feet when you enter. There is someone under his desk and he makes no attempts to hide his mistress.%SPEECH_ON%Welcome back, sellsword! Your pay is in the corner. That corner, over there. Don\'t try and take a gander.%SPEECH_OFF%You get your reward and head for the door. %employer% calls out to you, a thumb firmly planted in the air.%SPEECH_ON%Good job, by the way.%SPEECH_OFF%You nod and leave. | You enter %employer%\'s room with a few of his lieutenants right behind you. The man stands up at the sight of your lot, but quickly waves for his soldiers to get on out. They obey and sluggishly depart. You shake your head.%SPEECH_ON%They fought, too.%SPEECH_OFF%%employer% waves you off.%SPEECH_ON%Sure they did, and they\'re already on salary. You, however, are on contract and that contract has been fulfilled. By the way, it is probably for the best that those men do not see what I pay you anyway.%SPEECH_OFF%You take your reward. It is definitely a jealousy spurring amount and you hide it as you walk the halls on your way out.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "%objective% is saved.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Broke siege of " + this.Flags.get("ObjectiveName"));
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isGreenskinInvasion())
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
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "Around %objective%",
			Text = "[img]gfx/ui/events/event_68.png[/img]{You took too long and now %objective% lies in ruin. The greenskins overran the walls with shock and awe tactics. Given the smell drifting wind-wise, it doesn\'t take much to realize that everyone inside was slaughtered. | The %companyname% did not break the siege in time and now %objective% has paid for it. They thought you were going to save them, but instead you let them all down. If there is any good news, it\'s that nobody survived to whine about your failures. Your employer, %employer%, though, is a different matter. The nobleman will no doubt be furious with your inaction. | %objective% has been overrun! The orcs drove terrifying war machines to the walls and destroyed the defenses. Murderous greenskins flooded the town, killing everything in their path, or taking them prisoner to the gods know where. Your employer, %employer%, is furious with your failure to do your job! | You did not relieve %objective% in time! The greenskins smashed in the front gates and, well, the town has been wiped out. Considering %employer% is paying you for the exact opposite result, it is safe to assume he is not happy with this development. | With you mucking about not doing your job, %objective% fell to the greenskins! May the gods have mercy on its citizens, and do not expect %employer% to be happy with this result.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "%objective% has fallen.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Failed to break the siege of " + this.Flags.get("ObjectiveName"));
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function spawnSiege()
	{
		if (this.m.Flags.get("IsSiegeSpawned"))
		{
			return;
		}

		this.m.SituationID = this.m.Origin.addSituation(this.new("scripts/entity/world/settlements/situations/besieged_situation"));
		local originTile = this.m.Origin.getTile();
		local orcBase = this.World.getEntityByID(this.m.Flags.get("OrcBase"));
		local goblinBase = this.World.getEntityByID(this.m.Flags.get("GoblinBase"));
		local numSiegeEngines;

		if (this.m.DifficultyMult >= 1.15)
		{
			numSiegeEngines = this.Math.rand(1, 2);
		}
		else
		{
			numSiegeEngines = 1;
		}

		local numOtherEnemies;

		if (this.m.DifficultyMult >= 1.25)
		{
			numOtherEnemies = this.Math.rand(2, 3);
		}
		else if (this.m.DifficultyMult >= 0.95)
		{
			numOtherEnemies = 2;
		}
		else
		{
			numOtherEnemies = 1;
		}

		for( local i = 0; i < numSiegeEngines; i = ++i )
		{
			local tile;
			local tries = 0;

			while (tries++ < 500)
			{
				local x = this.Math.rand(originTile.SquareCoords.X - 2, originTile.SquareCoords.X + 2);
				local y = this.Math.rand(originTile.SquareCoords.Y - 2, originTile.SquareCoords.Y + 2);

				if (!this.World.isValidTileSquare(x, y))
				{
					continue;
				}

				tile = this.World.getTileSquare(x, y);

				if (tile.getDistanceTo(originTile) <= 1)
				{
					continue;
				}

				if (tile.Type == this.Const.World.TerrainType.Ocean)
				{
					continue;
				}

				if (tile.IsOccupied)
				{
					continue;
				}

				break;
			}

			local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).spawnEntity(tile, "Siege Engines", false, this.Const.World.Spawn.GreenskinHorde, this.Math.rand(100, 120) * this.getDifficultyMult() * this.getScaledDifficultyMult());
			this.m.UnitsSpawned.push(party.getID());
			party.setDescription("A horde of greenskins and their siege engines.");
			local numSiegeUnits = this.Math.rand(3, 4);

			for( local j = 0; j < numSiegeUnits; j = ++j )
			{
				this.Const.World.Common.addTroop(party, {
					Type = this.Const.World.Spawn.Troops.GreenskinCatapult
				}, false);
			}

			party.updateStrength();
			party.getLoot().ArmorParts = this.Math.rand(0, 15);
			party.getLoot().Ammo = this.Math.rand(0, 10);
			party.addToInventory("supplies/strange_meat_item");
			party.getSprite("body").setBrush("figure_siege_01");
			party.getSprite("banner").setBrush(goblinBase != null ? goblinBase.getBanner() : "banner_goblins_01");
			party.getSprite("banner").Visible = false;
			party.getSprite("base").Visible = false;
			party.setAttackableByAI(false);
			party.getFlags().add("SiegeEngine");
			local c = party.getController();
			c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
			c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
			local wait = this.new("scripts/ai/world/orders/wait_order");
			wait.setTime(9000.0);
			c.addOrder(wait);
		}

		local targets = [];

		foreach( l in this.m.Origin.getAttachedLocations() )
		{
			if (l.isActive() && l.isUsable())
			{
				targets.push(l);
			}
		}

		if (targets.len() == 0)
		{
			foreach( l in this.m.Origin.getAttachedLocations() )
			{
				if (l.isUsable())
				{
					targets.push(l);
				}
			}
		}

		for( local i = 0; i < numOtherEnemies; i = ++i )
		{
			local tile;
			local tries = 0;

			while (tries++ < 500)
			{
				local x = this.Math.rand(originTile.SquareCoords.X - 4, originTile.SquareCoords.X + 4);
				local y = this.Math.rand(originTile.SquareCoords.Y - 4, originTile.SquareCoords.Y + 4);

				if (!this.World.isValidTileSquare(x, y))
				{
					continue;
				}

				tile = this.World.getTileSquare(x, y);

				if (tile.getDistanceTo(originTile) <= 1)
				{
					continue;
				}

				if (tile.Type == this.Const.World.TerrainType.Ocean)
				{
					continue;
				}

				break;
			}

			local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).spawnEntity(tile, "Greenskin Horde", false, this.Const.World.Spawn.GreenskinHorde, this.Math.rand(90, 110) * this.getDifficultyMult() * this.getScaledDifficultyMult());
			this.m.UnitsSpawned.push(party.getID());
			party.setDescription("A horde of greenskins marching to war.");
			party.getLoot().ArmorParts = this.Math.rand(0, 15);
			party.getLoot().Ammo = this.Math.rand(0, 10);
			party.addToInventory("supplies/strange_meat_item");
			party.getSprite("banner").setBrush(orcBase != null ? orcBase.getBanner() : "banner_orcs_01");
			local c = party.getController();
			local raidTarget = targets[this.Math.rand(0, targets.len() - 1)].getTile();
			c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
			local raid = this.new("scripts/ai/world/orders/raid_order");
			raid.setTime(30.0);
			raid.setTargetTile(raidTarget);
			c.addOrder(raid);
			local destroy = this.new("scripts/ai/world/orders/destroy_order");
			destroy.setTime(60.0);
			destroy.setSafetyOverride(true);
			destroy.setTargetTile(originTile);
			destroy.setTargetID(this.m.Origin.getID());
			c.addOrder(destroy);
		}

		if (this.m.Troops != null && !this.m.Troops.isNull())
		{
			local c = this.m.Troops.getController();
			c.clearOrders();
			local intercept = this.new("scripts/ai/world/orders/intercept_order");
			intercept.setTarget(this.World.getEntityByID(this.m.UnitsSpawned[this.m.UnitsSpawned.len() - 1]));
			c.addOrder(intercept);
			local guard = this.new("scripts/ai/world/orders/guard_order");
			guard.setTarget(originTile);
			guard.setTime(120.0);
		}

		this.m.Origin.spawnFireAndSmoke();
		this.m.Origin.setLastSpawnTimeToNow();
		this.m.Flags.set("IsSiegeSpawned", true);
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"objective",
			this.m.Flags.get("ObjectiveName")
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

			if (!this.m.Flags.get("IsSiegeSpawned"))
			{
				this.spawnSiege();
			}

			foreach( id in this.m.UnitsSpawned )
			{
				local e = this.World.getEntityByID(id);

				if (e != null && e.isAlive())
				{
					e.setAttackableByAI(true);

					if (e.getFlags().has("SiegeEngine"))
					{
						local c = e.getController();
						c.clearOrders();
						local wait = this.new("scripts/ai/world/orders/wait_order");
						wait.setTime(120.0);
						c.addOrder(wait);
					}
				}
			}

			if (this.m.Origin != null && !this.m.Origin.isNull())
			{
				this.m.Origin.getSprite("selection").Visible = false;
			}

			if (this.m.Home != null && !this.m.Home.isNull())
			{
				this.m.Home.getSprite("selection").Visible = false;
			}
		}

		if (this.m.Origin != null && !this.m.Origin.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Origin.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(2);
			}
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isGreenskinInvasion())
		{
			return false;
		}

		local numAttachments = 0;

		foreach( l in this.m.Origin.getAttachedLocations() )
		{
			if (l.isActive() && l.isUsable())
			{
				numAttachments = ++numAttachments;
			}
		}

		if (numAttachments < 2)
		{
			return false;
		}

		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Troops != null && !this.m.Troops.isNull())
		{
			_out.writeU32(this.m.Troops.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local troops = _in.readU32();

		if (troops != 0)
		{
			this.m.Troops = this.WeakTableRef(this.World.getEntityByID(troops));
		}

		this.contract.onDeserialize(_in);
	}

});


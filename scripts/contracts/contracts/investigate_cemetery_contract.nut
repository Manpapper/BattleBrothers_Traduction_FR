this.investigate_cemetery_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		TreasureLocation = null,
		SituationID = 0
	},
	function setDestination( _d )
	{
		this.m.Destination = this.WeakTableRef(_d);
	}

	function create()
	{
		this.contract.create();
		this.m.Type = "contract.investigate_cemetery";
		this.m.Name = "Secure Cemetery";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		if (this.m.Destination == null || this.m.Destination.isNull())
		{
			local myTile = this.World.State.getPlayer().getTile();
			local undead = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getSettlements();
			local lowestDistance = 9999;
			local best;

			foreach( b in undead )
			{
				local d = myTile.getDistanceTo(b.getTile());

				if (d < lowestDistance && (b.getTypeID() == "location.undead_graveyard" || b.getTypeID() == "location.undead_crypt"))
				{
					lowestDistance = d;
					best = b;
				}
			}

			this.m.Destination = this.WeakTableRef(best);
		}

		this.m.Flags.set("DestinationName", this.m.Destination.getName());
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
					"Securisez " + this.Flags.get("DestinationName")
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
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				this.Contract.m.Destination.clearTroops();
				this.Contract.m.Destination.setLastSpawnTimeToNow();

				if (this.Contract.getDifficultyMult() < 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Destination.getLoot().clear();
				}

				this.Contract.m.Destination.setLootScaleBasedOnResources(100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 60 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
				local r = this.Math.rand(1, 100);

				if (r <= 10 && this.World.Assets.getBusinessReputation() > 500)
				{
					this.Flags.set("IsMysteriousMap", true);
					this.logInfo("map");
					local bandits = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits);
					this.World.FactionManager.getFaction(this.Contract.m.Destination.getFaction()).removeSettlement(this.Contract.m.Destination);
					this.Contract.m.Destination.setFaction(bandits.getID());
					bandits.addSettlement(this.Contract.m.Destination.get(), false);
					this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.BanditRaiders, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				}
				else if (r <= 40)
				{
					this.logInfo("ghouls");
					this.Flags.set("IsGhouls", true);
					this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.Ghouls, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				}
				else if (r <= 70)
				{
					this.Flags.set("IsGraverobbers", true);
					this.logInfo("graverobbers");
					local bandits = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits);
					this.World.FactionManager.getFaction(this.Contract.m.Destination.getFaction()).removeSettlement(this.Contract.m.Destination);
					this.Contract.m.Destination.setFaction(bandits.getID());
					bandits.addSettlement(this.Contract.m.Destination.get(), false);
					this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.BanditRaiders, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				}
				else
				{
					this.logInfo("undead");
					this.Flags.set("IsUndead", true);
					this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.Zombies, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
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
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					if (this.Flags.get("IsUndead") && this.World.Assets.getBusinessReputation() > 500 && this.Math.rand(1, 100) <= 25 * this.Contract.m.DifficultyMult)
					{
						this.Flags.set("IsNecromancer", true);
						this.Contract.setScreen("Necromancer0");
						this.World.Contracts.showActiveContract();
					}

					this.Contract.setState("Return");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (!this.Flags.get("IsAttackDialogShown"))
				{
					this.Flags.set("IsAttackDialogShown", true);

					if (this.Flags.get("IsGhouls"))
					{
						this.Contract.setScreen("AttackGhouls");
					}
					else if (this.Flags.get("IsGraverobbers"))
					{
						this.Contract.setScreen("AttackGraverobbers");
					}
					else if (this.Flags.get("IsUndead"))
					{
						this.Contract.setScreen("AttackUndead");
					}
					else if (this.Flags.get("IsMysteriousMap"))
					{
						this.Contract.setScreen("MysteriousMap1");
					}

					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog();
				}
			}

		});
		this.m.States.push({
			ID = "Running_Necromancer",
			function start()
			{
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}

				this.Contract.m.BulletpointsObjectives = [
					"Destruisez " + this.Flags.get("DestinationName")
				];
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					this.Contract.setScreen("Necromancer3");
					this.World.Contracts.showActiveContract();
					this.Flags.set("IsNecromancerDead", true);
					this.Contract.setState("Return");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (!this.Flags.get("IsAttackDialogShown"))
				{
					this.Flags.set("IsAttackDialogShown", true);
					this.Contract.setScreen("Necromancer2");
					this.World.Contracts.showActiveContract();
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
					if (this.Flags.get("IsNecromancer"))
					{
						if (this.Flags.get("IsNecromancerDead"))
						{
							this.Contract.setScreen("Success3");
						}
						else
						{
							this.Contract.setScreen("Necromancer1");
						}
					}
					else if (this.Flags.get("IsUndead"))
					{
						this.Contract.setScreen("Success1");
					}
					else if (this.Flags.get("IsMysteriousMapAccepted"))
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							this.Contract.setScreen("Failure1");
						}
						else
						{
							this.Contract.setScreen("Failure2");
						}
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer% restlessly walks up and down while stopping now and then to address you.%SPEECH_ON%The folks are in turmoil! Graves in the cemetery have been found opened and raided. Some simpleton claims it to be the dead rising from the graves - superstitious nonsense. It\'s quite obviously some graverobbers audacious enough to come to %townname% and plague us with their greedy presence!%SPEECH_OFF%He bangs his fist on the table in anger.%SPEECH_ON%Go out to the cemetery and end this nuisance once and for all!%SPEECH_OFF% | %employer% settles down into his chair, laughing to himself as he does it.%SPEECH_ON%Don\'t be alarmed, sellsword, but they say ghosts are afoot! Yes, yes, the local peasants are poisoning my mornings with constant talk of ghosts and goblins. They say that these supposed creatures are turning the cemetery upside down, raiding the graves to enlarge their army or some such nonsense. Obviously, it\'s just the work of some spade-wielding men intent on robbing graves for jewelry. I\'ve seen it before.%SPEECH_OFF%He looks down at his hands, briefly chuckling.%SPEECH_ON%Anyway, I can\'t just let it rest because these peasants won\'t get off my back about it. So, to ease them, there\'s... you. I need you to go to the cemetery and clear out any troublemakers you find. How you do that is up to you, but I\'ll go ahead and suggest a good steel, if you know what I mean...%SPEECH_OFF% | %employer%\'s got a map of a cemetery on his desk. Half the plot squares appear to have been filled in with ink.%SPEECH_ON%Every square you see there has been robbed. Every night they come, and every night I can\'t quite seem to catch them. I\'m at my wit\'s end here so I\'ve decided to end this once and for all. I want you to go to that graveyard and kill every grave robbing fool you see. Got it?%SPEECH_OFF% | %employer%\'s standing by his window, peering out while nursing a mug of mead. He doesn\'t really seem to be focused on anything in particular and even talks as if he couldn\'t care less about the conversation.%SPEECH_ON%Graverobbers are plundering the cemetery. Again. I\'m not really asking much of you, sellsword, other than to go there and put an end to this foolish business. Go to that cemetery and kill every graverobber you see. Got it? Good.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "Parlons argent.",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "Pas intéressé.",
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
			ID = "AttackGhouls",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_69.png[/img]{Crunching. Munching. The snicker-snacker of someone - or something - enjoying a good meal. As you step through the cemetery, you stumble upon a clearing filled with Nachzehrers. They\'re huddled over the remains of what appear to have been the graverobbers you were looking for. The hideous monsters slowly turn to you, their red eyes widening at the sight of fresh meat. | Tombstones fall over as a group of Nachzehrers clamber over them. They appear to have been having something of a feast, a few of them still gnawing on this arm or that leg, presumably the limbs of your supposed graverobbers. | You hear a shrill scream and quickly turn the corner of a mausoleum to find a Nachzehrer driving his teeth into the nape of a man\'s neck. The beast, blood filling his mouth so much as to pour from his nostrils, only glances up at you. Smaller Nachzehrers surround it, stepping forward to see to it that their next meal doesn\'t get away...}",
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
			ID = "AttackGraverobbers",
			Title = "Approaching...",
			Text = "[img]gfx/ui/events/event_57.png[/img]{The graverobbers are here, just as promised. You catch them mid-dig, your brothers jumping over tombstones with their weapons raised. | Walking into the cemetery, you find the graverobbers just as %employer% thought they might be there. They spot you just as you do them. Your men fan out with weapons drawn to stop any escape. | As you step through the tombstones, a few voices murmur over the otherside of a mausoleum. When you turn the corner, you find a group of men standing over an emptied grave. They have an open coffin before them, a few of the men taking jewelry out of it. You order your men to charge. | %employer% was right: there have been graverobbers here. You spot a number of tombs turned over and their graves dug up. The mud trails lead you to find the diggers clambering around some new work.%SPEECH_ON%Don\'t mean to stop you boys, but %employer% is paying pretty well to make sure these people stay in the ground.%SPEECH_OFF%}",
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
			ID = "AttackUndead",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_57.png[/img]{The cemetery is layered in fog - that or a thick miasma given off by the dead. Wait... that IS the dead! To arms! | You eye a tombstone with a mound of soil unearthed at its base. Blots of mud lead away like a crumb trail. There are no shovels... no men... As you follow the lead, you come across a band of undead moaning and groaning... now staring at you with insatiable hunger... | A man lingers deep in the rows of tombstones. He seems to be wavering, as though ready to pass out. %randombrother% comes to your side and shakes his head.%SPEECH_ON%That\'s no man, sir. There\'s undead afoot.%SPEECH_OFF%Just as he finishes talking, the stranger in the distance slowly turns and there in the light reveals he\'s missing half his face. | You come to find many of the graves are emptied. Not just emptied, but unearthed from below. This is not the work of graverobbers...}",
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
			ID = "MysteriousMap1",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_57.png[/img]{You enter the graveyard to find the graverobbers right where %employer% thought they\'d be: knee deep in someone else\'s afterlife. Drawing your sword, you tell them to put down whatever jewelry they think they\'re going to make off with. One of the men stands up, arms raised, and makes his case.%SPEECH_ON%Before you kill us, can I just say something? We have a map... I know, it sounds like a lie, but just hear me out... We have a map that can lead to immense treasures. You let us go, and I\'ll give it to you. Kill us and well... you\'ll never see it. What do you say?%SPEECH_OFF% | Just as %employer% suspected, there are graverobbers trundling about the tombstones. You stop them mid-dig and ask them if they have any last words before they join their victims in the mud. One of the men pleads for mercy, stating he\'s got a treasure map he\'ll exchange for all their lives. | You stumble upon a few men trying to crack open a mausoleum door. Clinking your sword against your boot gets their attention.%SPEECH_ON%Evening gents. %employer% sent me.%SPEECH_OFF%One of the men drops his tools.%SPEECH_ON%Wait just one second! We have a map... yes, a map! And if you spare us, I will give it to you! But only if you spare us! If you don\'t... you\'ll never see that map, understand?%SPEECH_OFF% | You get the jump on the graverobbers, drawing swords as they slam shovels into the earth. One of the men, presumably sensing he\'s about to join the very grave he\'s got one foot already in, bargains with you. Apparently, the men have a map to a mysterious treasure. All you have to do is let them go and they\'ll let you have it. If you kill them, well, the \'map\' is hidden, too, and you\'ll never see sight of it nor the treasures it leads to.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Kill them all!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				},
				{
					Text = "Very well, hand over the map and you may leave this place alive.",
					function getResult()
					{
						this.updateAchievement("NeverTrustAMercenary", 1, 1);
						local tile = this.Contract.getTileToSpawnLocation(this.World.State.getPlayer().getTile(), 8, 18, [
							this.Const.World.TerrainType.Shore,
							this.Const.World.TerrainType.Ocean,
							this.Const.World.TerrainType.Mountains
						], false);
						tile.clear();
						this.Contract.m.TreasureLocation = this.WeakTableRef(this.World.spawnLocation("scripts/entity/world/locations/undead_ruins_location", tile.Coords));
						this.Contract.m.TreasureLocation.onSpawned();
						this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).addSettlement(this.Contract.m.TreasureLocation.get(), false);
						this.Contract.m.TreasureLocation.addToInventory("loot/silverware_item");
						this.Contract.m.TreasureLocation.addToInventory("loot/silver_bowl_item");
						return "MysteriousMap2";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "MysteriousMap2",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_57.png[/img]{Maybe %employer% was just trying to kill people after some treasure? That... that makes sense, right? You decide to let the men go in exchange for a map that shows you the way to %treasure_location% %treasure_direction% from here. | %employer% didn\'t say anything about these men having a map... maybe he was trying to erase that knowledge? Who knows. But the temptation of treasure is too much for you and you decide to let the men go in exchange for the information. Their map reveals %treasure_location%. It lies %treasure_direction% from where you stand. | When you were a kid, you used to go on treasure hunts all the time. It\'s... oddly thrilling. You don\'t know why, but the allure of revisiting that old adventure has you letting the men go. In return, they show you the map which reveals %treasure_location%, the location of a hidden cache of... who knows? All you really know is that it is due %treasure_direction% from where you stand.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "This better be worth it.",
					function getResult()
					{
						this.World.uncoverFogOfWar(this.Contract.m.TreasureLocation.getTile().Pos, 700.0);
						this.Contract.m.TreasureLocation.setDiscovered(true);
						this.World.getCamera().moveTo(this.Contract.m.TreasureLocation.get());
						this.Contract.m.Destination.fadeOutAndDie();
						this.Contract.m.Destination = null;
						this.Flags.set("IsMysteriousMapAccepted", true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Necromancer0",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_56.png[/img]{Having slain all the undead, you find a piece of cloth that glows purple in your hand. You\'re not sure what it is, but for some reason are drawn to keep it. %randombrother% thinks this is stupid, but he\'s not the one in charge. | Après la bataille, %randombrother% finds a shovelhead with what appears to be a symbol burned into it. He wonders if maybe %employer%, your employer, knows something about it. You agree, taking the scrap of metal with you to see if the local man can identify it. | With the monstrosities laid low, you sheath your sword and scour the battlefield. In your search, you find an odd talisman of crow feathers and cow leather. You pocket it, figuring %employer%, your employer, might know something about it.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Time to collect our pay.",
					function getResult()
					{
						this.Flags.set("DestinationName", this.World.EntityManager.getUniqueLocationName(this.Const.World.LocationNames.NecromancerLair));
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Necromancer1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_63.png[/img]{Returning to %employer%, you quickly explain that there were no graverobbers, but instead a group of undead. He seems shocked, but when you produce the artifact you found he purses his lips and solemnly nods.%SPEECH_ON%That\'s... that\'s from %necromancer_location%. We thought we could ignore that place, but it appears I was wrong. Go there, sellsword, and end that ghoulish domain\'s terror once and for all!%SPEECH_OFF%The man lowers the theatrics a bit.%SPEECH_ON%Oh, and I\'m prepared to pay you another %reward_completion% crowns in addition to the %reward_completion% crowns for the original job, of course.%SPEECH_OFF% | You find %employer% in his study, solemnly sipping on a goblet.%SPEECH_ON%I\'ve already heard the news. The dead are walking, oh, it\'s ghastly to even say it!%SPEECH_OFF%You nod and produce the artifact you found in the cemetery.%SPEECH_ON%You know anything about this?%SPEECH_OFF%The man glances at it as if he already knew you had it.%SPEECH_ON%Aye, that belongs to %necromancer_location%. We thought we could ignore the horror coming from there but... well, look. Maybe you can go there? Maybe you can destroy %necromancer_location% and set us free from its terror? Here\'s your original payment, as agreed upon, but if you help us with %necromancer_location% you\'ll get another %reward_completion% crowns. Does that sound good to you?%SPEECH_OFF% | You walk into %employer%\'s room and slam the artifact down on his desk. He slaps it away with his hand.%SPEECH_ON%Where did you get that?%SPEECH_OFF%Pointing a finger at it, you press the man.%SPEECH_ON%Did you know about the undead in the cemetery?%SPEECH_OFF%He sheepishly looks away, then nods.%SPEECH_ON%Yes... I knew. They, and that artifact, come from %necromancer_location%. Some kind of dark sorcerer dwells there and he\'s been giving us these... problems for a while now. Please, could you go there and destroy it? Here\'s your payment for the original contract, but you will be compensated greatly for ridding us of that damned.. whatever he is. Let\'s say... another %reward_completion% crowns?%SPEECH_OFF% | You explain to %employer% that there were no graverobbers at the cemetery, nor humans of any sort for that matter. Before he can speak, you produce the artifact, holding it in the light so he can see. He quickly backs away.%SPEECH_ON%Put that down!%SPEECH_OFF%Like a voice of fire, his shout turns the artifact alight and it burns painlessly out of your very fingertips, only swirling ash all that remains. %employer% puts his head in his hands.%SPEECH_ON%It\'s from %necromancer_location%. A... necromancer lives there, a puppeteer that holds the strings to make the dead arise. Please, mercenary, go there and destroy it. We will be so gracious...%SPEECH_OFF%He pauses to produce a satchel of crowns.%SPEECH_ON%This is for what we originally agreed upon. But if you kill that horrid man at %necromancer_location% there will be another %reward_completion% crowns waiting for you À votre retour.%SPEECH_OFF% | You present the artifact you found in the cemetery. %employer% gasps at the very sight of it, but his expression quickly turns to one of somber acceptance.%SPEECH_ON%I\'ll be honest with you, sellsword. There is a necromancer who lives in %necromancer_location% not far from here.%SPEECH_OFF%He procures a satchel of crowns and hands it over to you.%SPEECH_ON%That is for the original job. However, I will offer another %reward_completion% crowns, everything we can muster, if you go and kill that evil man right now.%SPEECH_OFF%He leans back, looking very hopeful that you\'ll accept these new terms.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Very well, we\'ll hunt that Necromancer down.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Secured the cemetery");
						local tile = this.Contract.getTileToSpawnLocation(this.World.State.getPlayer().getTile(), 8, 15, [
							this.Const.World.TerrainType.Shore,
							this.Const.World.TerrainType.Ocean,
							this.Const.World.TerrainType.Mountains
						], false);
						tile.clear();
						this.Contract.m.Destination = this.WeakTableRef(this.World.spawnLocation("scripts/entity/world/locations/undead_necromancers_lair_location", tile.Coords));
						this.Contract.m.Destination.onSpawned();
						this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).addSettlement(this.Contract.m.Destination.get(), false);
						this.Contract.m.Destination.setName(this.Flags.get("DestinationName"));
						this.Contract.m.Destination.setDiscovered(true);
						this.Contract.m.Destination.clearTroops();
						this.Contract.m.Destination.setLootScaleBasedOnResources(115 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.Necromancer, 115 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());

						if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
						{
							this.Contract.m.Destination.getLoot().clear();
						}

						this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
						this.Contract.m.Home.getSprite("selection").Visible = false;
						this.Flags.set("IsAttackDialogShown", false);
						this.Contract.setState("Running_Necromancer");
						return 0;
					}

				},
				{
					Text = "No, the company\'s done enough here.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Secured the cemetery");
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
			ID = "Necromancer2",
			Title = "En vous approchant...",
			Text = "[img]gfx/ui/events/event_57.png[/img]{The location is as gruesome as you imagined, an affair with the irreproachable, the acme of profligate putridity. You haven\'t yet spotted the necromancer so it\'d be best if you make your advance most carefully... | %necromancer_location% is right where %employer% said it would be. You find a trail of bones leading the way. Some of them are still ripe with flesh, perhaps half-borne necromantic mistakes that didn\'t quite make it from death to undeath. Ignoring the horrors, you begin planning your attack... | A place like %necromancer_location% is so overgrown with tall grass, weeds, and blackened trees that it needn\'t even have a \'keep out\' sign. But it does anyway. It comes in the form of a skeletonized puzzle, a horror of bones patched together from all manner of man and beast, glaring from a crucifix to ward off any would-be adventurers. Slugs crawl through its eye sockets and arteries of army ants pulsate along its limbs.\n\n %randombrother% walks up, a little perturbed at the sight, and asks how you wish to attack. | First you find a rodent, limbs splayed, each little hand or foot nailed with a pin to a wooden board. Then there\'s the dog, its head replaced by a cat\'s. You swear the monstrosity moved when you approached, but maybe you\'re just seeing things. And then... the people. You\'ve no words to describe what\'s happened to them, but it is a towering wonder of gore, an acme of atrocity.\n\n%randombrother% steps to your side.%SPEECH_ON%Let\'s put an end to this madman.%SPEECH_OFF%Aye, let\'s. The question is, how first to attack?}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Prepare the attack.",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Necromancer3",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_56.png[/img]{%necromancer_location%\'s been cleansed. You almost feel holy about it, but then remember you did this for pay, not some righteous cause. Not that you\'d ever prefer the latter, anyway. | The necromancer is dead and you\'ve got his head in hand. Now it\'s time to go tell that sap, %employer%, about it so he can pay you what you\'ve earned. | It wasn\'t an easy fight, but %necromancer_location% is destroyed. The necromancer died and, like any man, fell into a pile of his own flesh and bones. Curious that his wizard tricks could raise the dead, but not be cast while being dead. Curious, but not unfortunate, either. You take the heathen\'s head, just in case. | You\'ve slain the necromancer but, worried that his tricks might go beyond the grave, cut his head off his shoulders and stick it in a sack. %employer%, your employer, should be most happy to see it. | The battle over, you take a sword to the necromancer\'s neck and remove his head from his shoulders. It comes almost too freely, as though it wanted to be in your holding. Well, whatever the case, %employer%, your employer, will want to see it as proof of your doings here.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Time to collect payment for the head.",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% is grinning slyly as you return.%SPEECH_ON%Nasty business, wasn\'t it? I\'ve already heard the news - it travels fast in these parts. A shame we had to do it this way, but who knows what you\'d have charged otherwise for fighting these... things.\n\nHey... you\'re still getting paid.%SPEECH_OFF%He gestures to a wooden chest in the corner.%SPEECH_ON%%reward_completion% crowns are in there, as we agreed upon.%SPEECH_OFF% | %employer% listens to your report then slowly leans back into his chair.%SPEECH_ON%There\'s been a lot of rumors concerning those... things. The dead walking about?%SPEECH_OFF%He stares at his desk, then angrily looks at you.%SPEECH_ON%Nonsense! I won\'t believe it. You\'ll get %reward_completion% crowns as we agreed upon. You will not squeeze anymore from me with these... these lies!%SPEECH_OFF%You really should\'ve brought a head or two, but then again, a dead head looks remarkably similar to an undead one... | %employer% listens to your report of the undead and shrugs.%SPEECH_ON%What a shame.%SPEECH_OFF%He nonchalantly sips at the rim of a goblet and pitches a hand to the corner of the room.%SPEECH_ON%Your pay is in that chest. %randomname% will see you out.%SPEECH_OFF% | %employer% clasps his hands then drops them into his lap.%SPEECH_ON%I\'ve heard of these... things. These shuffling monstrosities. This is not good to hear that they\'ve come to %townname%, but I suppose if they\'re to be anywhere, the cemetery would be best! Better than the town square, anyway.%SPEECH_OFF%He laughs nervously to himself.%SPEECH_ON%%randomname% is standing out my door with your pay. Thank you, sellsword.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Des couronnes bien méritées.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Secured the cemetery");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isUndeadScourge())
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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% welcomes you into his room.%SPEECH_ON%Did you kill them all? Is it secure?%SPEECH_OFF%You shrug. %SPEECH_ON%Nobody\'ll be digging up graves anytime soon.%SPEECH_OFF% | You find %employer% nestled into his chair, holding a candlelight close to a well-worn scroll. He talks without looking up.%SPEECH_ON%My problem, did you take care of it?%SPEECH_OFF%You nod.%SPEECH_ON%I wouldn\'t be standing here if I hadn\'t.%SPEECH_OFF%%employer% tips a hand to the corner of his desk.%SPEECH_ON%Your payment. %reward_completion% crowns, as agreed upon.%SPEECH_OFF% | %employer%\'s talking to some of his men when you Retournez à his room. He parts them and asks you of the task. You report that it\'s again safe to bury %townname%\'s loved ones. %employer% smiles.%SPEECH_ON%Good. Good. Your payment.%SPEECH_OFF%He snaps his fingers and one of the men steps forward, handing you a satchel. There\'s %reward_completion% crowns in it, as promised.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Des couronnes bien méritées.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Secured the cemetery");
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
		this.m.Screens.push({
			ID = "Success3",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{You Retournez à %employer% with the head of the necromancer. It\'s so incredibly light for what is ostensibly a human head.%SPEECH_ON%Is that the foul creature who has been turning up our graves with the undead?%SPEECH_OFF%Nodding, you set the head down. The face gasps and %employer% leaps away.%SPEECH_ON%He\'s still alive!%SPEECH_OFF%You shrug and drive a dagger through the brainpan. The necromancer\'s eyes turn up toward the hilt and his teeth chatter with laughter, then the eyes recede back into their sockets and a faint tendril of red smoke spools out and then there is nothing more. %employer%, shaking, sits back down and motions toward a satchel in the corner. It\'s your payment and it\'s quite heavy. | %employer% is sitting down when you enter his study, but he immediately stands and backs away at the sight of the necromancer\'s head dangling from your hand.%SPEECH_ON%I-I take it that... that\'s him? Right? That\'s him? It\'s over?%SPEECH_OFF%You nod and toss the head onto the man\'s desk. It turns onto its face, wobbling back and forth on the pinched cheeks of a deathly grin. %employer% knocks it away with a book.%SPEECH_ON%Good. Excellent! As promised, your pay...%SPEECH_OFF%He gestures to a corner where a {wooden box | large satchel} rests. You take it, count it, and make your leave. | %employer% looks up from his book.%SPEECH_ON%By the gods, is that the necromancer\'s head in your hand?%SPEECH_OFF%You nod and toss it to the floor. A cat unspools from its bookshelf-roost and comes down to paw at it. %employer% gets up and takes a few books from the shelf, revealing a large box. He takes it and gives it to you.%SPEECH_ON%I\'d been saving this for special moments and I suppose this would be one.%SPEECH_OFF%You think it\'s going to be an item, maybe an amulet or something mysterious, but instead it\'s just a good pile of crowns. | Returning to %employer%, you\'ve got the necromancer\'s head in hand and the man quickly motions for you to give it over. No qualms doing that...\n\n%employer% lofts it up in both hands, studying it as though a man would a sick baby. After a few moments, he sets the head down in the clutching grip of a broken trident prong.%SPEECH_ON%I think it looks good there. Yes you do, don\'t you?%SPEECH_OFF%The man puts a thumb to the necromancer\'s pale chin. You clear your throat and inquire about payment, to which %employer% motions for one of his guards to come in. A satchel is brought to you from which you count %reward_completion% crowns. Satisfied, you leave %employer% to... whatever it is he\'s doing.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Des couronnes bien méritées.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractPoor, "Secured the cemetery");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isUndeadScourge())
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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_63.png[/img]{%employer% is standing at the window when you enter.%SPEECH_ON%The songbirds seemed rather angry today. As though nothing they\'d say was worth saying. I thought that was interesting. Do you?%SPEECH_OFF%He suddenly turns toward you.%SPEECH_ON%Hmm, mercenary? No? My little birds told me that the graverobbers left town. Alive. Free to go where they please, free to return as they please. What an oddity, because usually dead men aren\'t free to do anything. What did I ask you to make those graverobbers?%SPEECH_OFF%You hesitate. The man answers for you.%SPEECH_ON%I wanted you to make them dead. Now they aren\'t. Now you don\'t get paid. Ah, how simple. And now? Now you get out of my house.%SPEECH_OFF% | %employer% laughs as you enter his room.%SPEECH_ON%I\'m honestly surprised you returned. I should find it insulting, really, that you\'d think I wouldn\'t know better. The graverobbers were spotted on the road. The graverobbers I asked you to kill. Remember that? Remember when I said go and kill them? I\'m sure you do. I\'m also sure you remember when I said that\'s what I was paying you for. So... no dead graverobbers...%SPEECH_OFF%He slams his desk with a fist.%SPEECH_ON%No pay! Now get out of my home!%SPEECH_OFF% | You find %employer% in his chair, rolling an empty goblet between his hands.%SPEECH_ON%It\'s not often I run across someone who tries to cheat me. That\'s what you were going to do, coming back here, right? I know the graverobbers aren\'t dead, sellsword. I\'m no fool. Leave my sight before I have my men butcher you.%SPEECH_OFF% | %employer% is reading a book when you enter his room.%SPEECH_ON%You have ten seconds to turn around and leave. Ten. Nine. Eight...%SPEECH_OFF%You realize he knows that the graverobbers were not taken care of.%SPEECH_ON%...four... three...%SPEECH_OFF%You turn and hastily leave the room.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Damn this!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.Assets.addMoralReputation(-1);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationAttacked);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Failure2",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_63.png[/img]{%employer% purses his lips.%SPEECH_ON%You\'ve put me in an odd spot, mercenary. You tell me the graverobbers are taken care of, yet... I have no proof. Usually, dead men leave a lot of proof. Especially ones hastily slain before their time.%SPEECH_OFF%He shrugs.%SPEECH_ON%I\'ll pay you half. And you\'ll take that and then leave. Next time, bring proof. If you\'re lying... well, I\'ll figure that out on my own.%SPEECH_OFF% | You Retournez à find %employer% tending to his garden.%SPEECH_ON%Sometimes I plant for one vegetable, and yet what springs forth but another entirely? How does that happen? Did I fool myself? Are you trying to fool me? You say the graverobbers are dead, but my men have scouted the graveyard and have found no such evidence. They also haven\'t found the graverobbers, and please...%SPEECH_OFF%He holds up a hand.%SPEECH_ON%Don\'t try and tell me that you did this or that with their bodies. So this is what we\'re going to do, sellsword. I\'m going to pay you half and then I\'m going to sit here and wonder if you lied to me. Sound good? Good.%SPEECH_OFF% | %employer% smiles as you tell him his problem has been taken care of.%SPEECH_ON%That\'s good news. Unfortunately, my men scouted the cemetery and found no evidence of our dead graverobbers. An interesting development, I\'m sure, but I\'m not going to hold you here while I figure out what, exactly, happened there. So... I\'ll be paying you half. Next time, bring me proof. Or... don\'t lie. I\'m not sure which applies to you here.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Hrm.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractPoor);
						this.World.Assets.addMoralReputation(-1);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() / 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail);
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
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() / 2 + "[/color] Couronnes"
				});
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"treasure_location",
			this.m.TreasureLocation == null || this.m.TreasureLocation.isNull() ? "" : this.m.TreasureLocation.getName()
		]);
		_vars.push([
			"treasure_direction",
			this.m.TreasureLocation == null || this.m.TreasureLocation.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.TreasureLocation.getTile())]
		]);
		_vars.push([
			"necromancer_location",
			this.m.Flags.get("DestinationName")
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/terrified_villagers_situation"));
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
				local zombies = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies);
				this.World.FactionManager.getFaction(this.m.Destination.getFaction()).removeSettlement(this.m.Destination);
				this.m.Destination.setFaction(zombies.getID());
				zombies.addSettlement(this.m.Destination.get(), false);
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
			if (this.m.Destination == null || this.m.Destination.isNull())
			{
				return false;
			}

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


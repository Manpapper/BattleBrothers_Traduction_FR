this.hunting_unholds_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		Dude = null,
		IsPlayerAttacking = true
	},
	function setEnemyType( _t )
	{
		this.m.Flags.set("EnemyType", _t);
	}

	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hunting_unholds";
		this.m.Name = "Hunting Giants";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 750 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Chassez les Unholds autour de " + this.Contract.m.Home.getName()
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

				if (r <= 40)
				{
					this.Flags.set("IsDriveOff", true);
				}
				else if (r <= 50)
				{
					this.Flags.set("IsSignsOfAFight", true);
				}

				this.Flags.set("StartTime", this.Time.getVirtualTimeF());
				local playerTile = this.World.State.getPlayer().getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 6, 12, [
					this.Const.World.TerrainType.Mountains
				]);
				local nearTile = this.Contract.getTileToSpawnLocation(playerTile, 4, 8);
				local party;

				if (this.Flags.get("EnemyType") == 0)
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Unholds", false, this.Const.World.Spawn.UnholdBog, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				}
				else if (this.Flags.get("EnemyType") == 1)
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Unholds", false, this.Const.World.Spawn.UnholdFrost, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				}
				else
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Unholds", false, this.Const.World.Spawn.Unhold, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				}

				party.setDescription("One or more lumbering giants.");
				party.setFootprintType(this.Const.World.FootprintsType.Unholds);
				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);
				party.getFlags().set("IsUnholds", true);
				this.Const.World.Common.addFootprintsFromTo(nearTile, party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Unholds, 0.75);
				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_beasts_01");
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setPivot(this.Contract.m.Home);
				roam.setMinRange(2);
				roam.setMaxRange(8);
				roam.setAllTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
				roam.setTerrain(this.Const.World.TerrainType.Shore, false);
				roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
				c.addOrder(roam);
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
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive())
				{
					if (this.Flags.get("IsSignsOfAFight"))
					{
						this.Contract.setScreen("SignsOfAFight");
					}
					else
					{
						this.Contract.setScreen("Victory");
					}

					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
				else if (!this.Flags.get("IsBanterShown") && this.Contract.m.Target.isHiddenToPlayer() && this.Math.rand(1, 1000) <= 1 && this.Flags.get("StartTime") + 10.0 <= this.Time.getVirtualTimeF())
				{
					this.Flags.set("IsBanterShown", true);
					this.Contract.setScreen("Banter");
					this.World.Contracts.showActiveContract();
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (this.Flags.get("IsDriveOff") && !this.Flags.get("IsEncounterShown"))
				{
					this.Flags.set("IsEncounterShown", true);
					local bros = this.World.getPlayerRoster().getAll();
					local candidates = [];

					foreach( bro in bros )
					{
						if (bro.getBackground().getID() == "background.beast_slayer" || bro.getBackground().getID() == "background.wildman" || bro.getBackground().getID() == "background.barbarian" || bro.getSkills().hasSkill("trait.dumb"))
						{
							candidates.push(bro);
						}
					}

					if (candidates.len() == 0)
					{
						this.World.Contracts.showCombatDialog(_isPlayerAttacking);
					}
					else
					{
						this.Contract.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];
						this.Contract.setScreen("DriveThemOff");
						this.World.Contracts.showActiveContract();
					}
				}
				else if (!this.Flags.get("IsEncounterShown"))
				{
					this.Flags.set("IsEncounterShown", true);
					this.Contract.setScreen("Encounter");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog(_isPlayerAttacking);
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
					if (this.Flags.get("IsDriveOffSuccess"))
					{
						this.Contract.setScreen("SuccessPeaceful");
					}
					else
					{
						this.Contract.setScreen("Success");
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
			Text = "[img]gfx/ui/events/event_79.png[/img]{When you enter %employer%\'s room you find the man stooped beside his window, looking out it with nearly conspiratorial flinching. His eyes slim and open wide and slim again. He snaps a curtain over the window and jerks his head to look at you.%SPEECH_ON%You didn\'t happen to see a very angry woman heading my way, did you? Ah, nevermind it. Look at this.%SPEECH_OFF%He tosses you a scroll which you unfurl. There\'s a crude drawing of what looks like a man hunched over an ant or some insect. You can\'t really tell. %employer% claps his hands.%SPEECH_ON%Local farmers are reporting missing livestock. All they found were footprints large enough for a man to lay a coffin in. Sounds like hearsay and rumormongering to me, could be rivals trying to hide their misdoings, but I\'ll leave you to it. Search the surrounding lands and see what you find. If you come upon an actual giant I think you know what do.%SPEECH_OFF% | You find %employer% sitting at his desk and seemingly in congress with half the village\'s farmers. They\'re hunched over scrolls and streaking lead prints over the papers, drawing up what look like giants or fat men with horns. One man is doodling a stick figure farking another stick figure. %employer% throws you a more prescient page upon which is the visage of a monster.%SPEECH_ON%These fine gentlemen tell me that a giant is afoot. I do not wish to doubt the concerns of my peers and so I request your services, sellsword. The money\'s on the table, all you need to do is search the area round %townname% and find this beast. What say you?%SPEECH_OFF% | You find %employer% staving off a throng of peasants. They\'ve entered his room with pitchforks and unlit torches, which he must constantly warn them not to light given the all-wood architecture. Seeing you, %employer% calls out like a drowning man yelling for a raft.%SPEECH_ON%Sellsword! By the gods get over here. These fine folks state that there is a beast afoot.%SPEECH_OFF%One of the peasants stomps his pitchfork into the ground.%SPEECH_ON%Naw, no ordinary beast, but a monster ya? A giant! A biggun. A big ol\' giant. Out there. Right out that way. I seen it.%SPEECH_OFF%With a sigh and a nod, %employer% butts back in.%SPEECH_ON%Right. So, I\'m willing to offer you payment to seek this giant out. Are you up to the task?%SPEECH_OFF% | %employer% is at his desk with his head in his hands. He\'s mumbling to himself.%SPEECH_ON%Monster this, beast that. \'Oh my chicken got taken\', oh maybe you should consider putting it in a pen you damned piece of - oh hi sellsword!%SPEECH_OFF%The man rises from his chair and throws you a piece of paper. There\'s a crude drawing of a large headed beast on it.%SPEECH_ON%Folks are reporting there\'s a giant roaming autour dese parts. I\'ll pay good money to see these reports investigated properly, and of course good money to see the beast slain properly as well. Are you up for it? Please say yes.%SPEECH_OFF% | %employer% reluctantly welcomes you into his room, pretending that he doesn\'t need your help, thought it\'s clear he\'d rather not want it at all.%SPEECH_ON%Ah, mercenary. It\'s not often a place such as %townname% would seek out men of your ilk, but I\'m afraid there have been sightings of unholds scouring these lands, stealing enough livestock that the townsfolk have put in the coin to fetch a man such as yourself. Are you interested in hunting down this foul creature?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Fighting giants won\'t come cheap. | The %companyname% can help for the right price. | Let\'s talk crowns.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{This doesn\'t sound like our kind of work. | This won\'t be worth the risk.}",
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
			Title = "Sur la route...",
			Text = "[img]gfx/ui/events/event_71.png[/img]{%randombrother% returns from his reconnoiter. He reports that a nearby farm has been destroyed, a hole blown through its roof likened to someone kicking an ant pile. You ask if there are survivors. He nods.%SPEECH_ON%Of a sort. A young lad who refuses to speak a word. A woman who kept yelling at me to git. That aside, no. They\'re survivors by circumstance and good luck. This world won\'t permit them being here much longer.%SPEECH_OFF%You tell the sellsword to keep the judgments to himself and get the company moving forward again. | You find a half a cow beside the path. It has not been butchered so much as pulled apart unevenly and with great violence. Much of its innards have slopped to the ground in a pile. Footprints the size of graves lead away. The trail of carnage goes through a fence which lays sundered and further down the way you can see the wreckage of a barn. %randombrother% laughs.%SPEECH_ON%All we\'re missing is a giant pile of shit.%SPEECH_OFF%You tell him to check his boot. | A few peasants on the road warn you off.%SPEECH_ON%Get on out of here! That armor won\'t save you from a single lick!%SPEECH_OFF%You ask them about the unhold and they garner up a great description of a monstrous giant which tore through the land not long ago. It appears you\'re on the right track. | The unhold has left a giant mess in its wake. Stomped livestock, others broke apart and slurped like honeysuckles. Chickens mill about pecking the ground, a farmer keeping watch of them. He nods.%SPEECH_ON%Just missed the show.%SPEECH_OFF%Looks like you\'re getting close.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "They can\'t be far.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Encounter",
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/event_104.png[/img]{The unholds in part remind you of any group of laborers, circled around a dead fire, rubbing their bellies and looking like boulders there hunched on the ground. Of course, your arrival brings them to their feet and destroys any notion that you\'ve anything resembling them at all, except maybe similarly sized third legs. The beasts growl and stomp, but they do not attack. They throw their hands out and try and shoo you away. But the %companyname% didn\'t come this far to quit. You draw your sword and lead the men forward. | Each unhold is enormous beyond measure. They\'re bewildered at the ants come to do battle with them. One scratches his head and blithely belches, freckling the company with bovine blood. They seem to recognize the steel of your drawn sword, though, and the flash of it wakes them from their satiated slumbers. After earthshaking stomps of their feet, they stride forward to run you from the land or into it. | The %companyname% stacked from leg to head still would not size up to a single unhold. Yet here you stand, waving a sword and ready to combat the tremendous monsters. They regard you with incredulous stares, not quite sure what to make of these tiny creatures so willing to confront them. One scratches his belly and flakes of molted skin the size of dogs come twirling down. Well, there\'s no point dwelling on it any longer. You order the company forward! | The unhold sniff you out and come charging across the land to meet the %companyname%. They look like toddlers the size of mountains, legs awkwardly trundling forward yet each step sends tremors through the earth, their maws agape and slobbering for a meal. You calmly draw out your sword and put the men into formation.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Charge!",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "DriveThemOff",
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/event_104.png[/img]{As you put the men into formation, %shouter% goes running by you and right toward the unholds. He\'s hooting and hollering, his arms flailing like a sea cretin drawn up by the hook. The unholds pause and stare amongst one another. You\'re not sure whether this should be allowed to continue...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Attack them!",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				},
				{
					Text = "%shouter% knows what he\'s doing.",
					function getResult()
					{
						if (this.Math.rand(1, 100) <= 35)
						{
							return "DriveThemOffSuccess";
						}
						else
						{
							return "DriveThemOffFailure";
						}
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "DriveThemOffSuccess",
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/event_104.png[/img]{Against better judgment, you let %shouter% go. He doesn\'t stop for nothing, like he was chasing down a throng of beautiful women undressing just for him. Shockingly, the unholds take a step back. They start to retreat one by one until only a lone giant remains.\n\n%shouter% runs up to its feet like a yapping dog and lets forth some atavistic scream so hoarsely made that you wonder if every ancestor of the earth buried or otherwise had heard it. The unhold slings an arm before its face as though to shield it, then starts stepping back, further and further until it\'s gone! They\'re all gone!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "And don\'t come back!",
					function getResult()
					{
						this.Contract.m.Target.die();
						this.Contract.m.Target = null;
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Contract.m.Dude.getImagePath());
				this.Contract.m.Dude.improveMood(3.0, "Managed to drive off unholds all by himself");

				if (this.Contract.m.Dude.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[this.Contract.m.Dude.getMoodState()],
						text = this.Contract.m.Dude.getName() + this.Const.MoodStateEvent[this.Contract.m.Dude.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "DriveThemOffFailure",
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/event_104.png[/img]{Against better judgment, you let %shouter% go. He doesn\'t stop for nothing, like he was chasing down a throng of beautiful women undressing just for him. Shockingly, the unholds take a step back. They start to retreat one by one until only a lone giant remains.\n\n%shouter% runs up to its feet like a yapping dog and lets forth some atavistic scream so hoarsely made that you wonder if every ancestor of the earth buried or otherwise had heard it. The unhold slings an arm before its face and then throws it down and swats %shouter% away. The man goes cartwheeling through the air and his screams go with him like a rabbit stolen up by a hawk. His shouts somersault back to earth in an echo of dizzying whoops and he lands with a hardy thud. The giant jiggles with an earthen chuckle. It\'s amusement catches the attention of the departed unholds who all turn around and start to return.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "So much for that.",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, false);
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Contract.m.Dude.getImagePath());
				local injury;

				if (this.Math.rand(1, 100) <= 50)
				{
					injury = this.Contract.m.Dude.addInjury(this.Const.Injury.BluntBody);
				}
				else
				{
					injury = this.Contract.m.Dude.addInjury(this.Const.Injury.BluntHead);
				}

				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = this.Contract.m.Dude.getName() + " suffers " + injury.getNameOnly()
				});
				this.Contract.m.Dude.worsenMood(1.0, "Failed to drive off unholds all by himself");

				if (this.Contract.m.Dude.getMoodState() <= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[this.Contract.m.Dude.getMoodState()],
						text = this.Contract.m.Dude.getName() + this.Const.MoodStateEvent[this.Contract.m.Dude.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_113.png[/img]{The unholds slain, you order the men to take what trophies they can as proof of your work, and possibly as something to use for yourself. If man can make leather from a cow, surely there\'s something worthy of giants such as these? Either way, %employer% will be waiting. | With the giants slain to the last, %employer% should be awaiting your return now. His town will be forever safe now and no longer require the services of sellswords such as yourself. You dwell on the thought until you start a laughing fit to which none of your men understand. You tell them to ignore it and round them up for the return trip. | The ghastly monsters put up a hell of a fight, but they were no match for the collective strength, smarts, and sheer balls of the %companyname%. You tell the men to take what trophies they can and to prepare for the return march to %employer%. | With the last of the unholds slain, you round up the men. %randombrother% is found jumping on one\'s belly and seems disappointed when you tell him to quit it and get down. %employer% will be looking for killers and their trophies, not a bunch of children.}",
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
			ID = "SignsOfAFight",
			Title = "Après la bataille...",
			Text = "[img]gfx/ui/events/event_113.png[/img]{With the giants slain, you get the men ready for a Retournez à %employer%, but %randombrother% fetches your attention with a bit of quiver in his throat. You head on over to see him standing before one of the felled unholds. He points across its flesh which has been torn asunder in slices and hangs like the ears of a corn stalk. The damage is far beyond the ability of your own weaponry. The sellsword turns and looks past you with his eyes widening.%SPEECH_ON%What do you imagine did that?%SPEECH_OFF%Further along the skin are concave scars shaped like saucers with punctures rent right into the holes. You climb atop the unhold and crank your sword into one of these divots, wrenching free a tooth about the length of your forearm. Along its edges are barbs, teeth upon teeth it seems. The men see this and start muttering amongst themselves and you wished you\'d never saw it at all for you\'ve no sense to make of it.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "The wilds are dark and full of terrors.",
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
			ID = "Success",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_79.png[/img]{%employer% welcomes your return, almost immediately stating that he hasn\'t heard a single story of the unholds\' ravaging since you left. You nod and present evidence of the reason why, the slick remains of the slain giants sputtering as you bowl them across his floor. The wood is stained as though you\'d unfurled a carpet. The mayor purses his lips.%SPEECH_ON%What the hell, sellsword?%SPEECH_OFF%You cock your head and raise an eyebrow. The man lets his hands fall and he bows a bit.%SPEECH_ON%Ah, no worries! All is well! Here, your reward as promised!%SPEECH_OFF% | You Retournez à %employer% and find the man reading stories to children. He rends his hand through the air and growls like a beast. Knocking on the door, you intrude upon the theater.%SPEECH_ON%Aye, and then the ever honorable sellswords slew the monster!%SPEECH_OFF%The children cheer at your timely arrival. The mayor stands and gives you the promised reward, declaring he had a scout following your every move and he\'s already heard the reports of your success. He asks if you\'ll stick around and tell the tale for the kiddos. You tell him you don\'t work for free and leave the room. | You have to root about the town a while to find %employer%, the man himself found kept up in his room by a young lass who hides beneath the sheets you caught them in. The mayor gets dressed with no hesitation as to his own nakedness. He pitches a coin toward the girl and then speaks to you.%SPEECH_ON%Aye, sellsword, I\'ve been expecting you! Your reward, as promised!%SPEECH_OFF%He gives you the satchel, but a coin slips free and runs between the floorboards. The man purses his lips a moment then runs back to the girl and snatches the coin out of her hands and drops it in the satchel. | %employer% is found arguing with peasants about unpaid taxes and how the lords of the land will get their coin one way or another. The arrival of an armed fellow such as yourself is rather apropos and sends the peons scuttling for their coin purses. You tell them to quiet down and then address the mayor to get your money. He fetches it from a drawer, pausing only to fill it to the brim by taking a coin from a peasant, and then he hands it over to you.%SPEECH_ON%Appreciate your work, sellsword.%SPEECH_OFF% | You report to %employer% of your doings and he is, surprisingly not incredulous in the least.%SPEECH_ON%Aye, I had a scout tracking your company and he\'d beaten you back to town. Every word you say mirrors his. Your pay, as promised.%SPEECH_OFF%He hands you a satchel.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Rid the town of unholds");
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
			ID = "SuccessPeaceful",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_79.png[/img]{%employer% drives his fingers up to the corners of his eye then fans them forward.%SPEECH_ON%Let me get this straight, one of your sellswords shouted the giants into a retreat?%SPEECH_OFF%You nod and tell him the direction they went which is, rather importantly, away from %townname%. The mayor leans back in his chair.%SPEECH_ON%Well. Alright then. I guess it ain\'t my problem now. Dead or gone, all the same I suppose.%SPEECH_OFF%He hands you a satchel, but holds his hand on it a moment.%SPEECH_ON%You know if you\'re lying and they come back I\'ll send every messenger bird I got to speak of your honor.%SPEECH_OFF%You stand up, draw your sword, and tell him they\'ll have his skull to rest in when they get there. The man nods and lets the coin go.%SPEECH_ON%No bother, sellsword, only business.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Rid the town of unholds");
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
			"shouter",
			this.m.Dude != null ? this.m.Dude.getName() : ""
		]);
		_vars.push([
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Target.getTile())]
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/unhold_attacks_situation"));
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


this.destroy_orc_camp_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		Reward = 0
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.destroy_orc_camp";
		this.m.Name = "Destroy Orc Camp";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		local camp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(this.m.Origin.getTile());
		this.m.Destination = this.WeakTableRef(camp);
		this.m.Flags.set("DestinationName", this.m.Destination.getName());
		this.m.Payment.Pool = 900 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
		local r = this.Math.rand(1, 3);

		if (r == 1)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else if (r == 2)
		{
			this.m.Payment.Completion = 1.0;
		}
		else if (r == 3)
		{
			this.m.Payment.Completion = 0.5;
			this.m.Payment.Count = 0.5;
		}

		local maximumHeads = [
			20,
			25,
			30
		];
		this.m.Payment.MaxCount = maximumHeads[this.Math.rand(0, maximumHeads.len() - 1)];
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Détruisez " + this.Flags.get("DestinationName") + " %direction% de %origin%"
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
				this.Contract.m.Destination.clearTroops();
				this.Contract.m.Destination.setLastSpawnTimeToNow();

				if (this.Contract.getDifficultyMult() < 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Destination.getLoot().clear();
				}

				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.OrcRaiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setLootScaleBasedOnResources(115 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				this.Flags.set("HeadsCollected", 0);

				if (this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().get("Betrayed") && this.Math.rand(1, 100) <= 75)
				{
					this.Flags.set("IsBetrayal", true);
				}
				else
				{
					local r = this.Math.rand(1, 100);

					if (r <= 5)
					{
						this.Flags.set("IsSurvivor", true);
					}
					else if (r <= 15 && this.World.Assets.getBusinessReputation() > 800)
					{
						if (this.Contract.getDifficultyMult() >= 0.95)
						{
							this.Flags.set("IsOrcsAgainstOrcs", true);
						}
					}
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
					if (this.Flags.get("IsSurvivor") && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
					{
						this.Contract.setScreen("Volunteer1");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("Return");
					}
					else if (this.Flags.get("IsBetrayal"))
					{
						if (this.Flags.get("IsBetrayalDone"))
						{
							this.Contract.setScreen("Betrayal2");
							this.World.Contracts.showActiveContract();
						}
						else
						{
							this.Contract.setScreen("Betrayal1");
							this.World.Contracts.showActiveContract();
						}
					}
					else
					{
						this.Contract.setScreen("SearchingTheCamp");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("Return");
					}
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (this.Flags.get("IsOrcsAgainstOrcs"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("OrcsAgainstOrcs");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "OrcAttack";
						p.Music = this.Const.Music.OrcsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						p.IsAutoAssigningBases = false;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.OrcRaiders, 150 * this.Contract.getScaledDifficultyMult(), this.Const.Faction.Enemy);
						this.World.Contracts.startScriptedCombat(p, false, true, true);
					}
				}
				else
				{
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "OrcAttack";
					p.Music = this.Const.Music.OrcsTracks;
					this.World.Contracts.startScriptedCombat(p, true, true, true);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Betrayal")
				{
					this.Flags.set("IsBetrayalDone", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Betrayal")
				{
					this.Flags.set("IsBetrayalDone", true);
				}
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_combatID == "OrcAttack" || this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull() && this.World.State.getPlayer().getTile().getDistanceTo(this.Contract.m.Destination.getTile()) <= 1)
				{
					if (_actor.getFaction() == this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getID())
					{
						this.Flags.set("HeadsCollected", this.Flags.get("HeadsCollected") + 1);
					}
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
		this.importScreens(this.Const.Contracts.NegotiationPerHead);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Task",
			Title = "Negotiations",
			Text = "[img]gfx/ui/events/event_61.png[/img]{%employer% huffs and puffs.%SPEECH_ON%Goddammit.%SPEECH_OFF%He goes to his window, looking out it.%SPEECH_ON%I had a jousting tournament recently and there was a bit of a controversy. Now, none of my knights will fight for me until it\'s taken care of.%SPEECH_OFF%You ask if you want sellswords to settle a dispute amongst nobility. The man bursts into laughter.%SPEECH_ON%Gods no, lowborn. I need you to handle some greenskins that are camping %direction% of %origin%. They\'ve been terrorizing the region for awhile now and I\'d like you to return the favor. Does that sound like something you\'re interested in, or should I have to go talk to another sword for hire?%SPEECH_OFF% | %employer% kicks his feet up on his table.%SPEECH_ON%Any opinions on greenskins, sellsword?%SPEECH_OFF%You shake your head no. The man tilts his head.%SPEECH_ON%Interesting. Most say they\'re afraid, or that they\'re nasty brutes who can cleave a man in two. But you... you\'re different. I like it. What say you go %direction% of %origin% to a place the locals have dubbed %location%? We\'ve sighted a large band of orcs there that need scattering.%SPEECH_OFF% | A cat is on %employer%\'s table. He pets it, the feline scrunching up to the scratch, but then it suddenly hisses, bites the man, and sprints out the door you just came through. %employer% dusts himself off.%SPEECH_ON%Farkin\' animals. One moment they love you, the next, well...%SPEECH_OFF%He sucks on a drop of blood coming from his thumb. You ask if you should come back so he can nurse himself back to health.%SPEECH_ON%Very funny, sellsword. No, what I want you to do is go %direction% of %origin% and take on a group of greenskins inhabiting those parts. We need them destroyed, scattered, whatever word you like so long as they\'re \'gone\'. Does that sound like something you could do for us?%SPEECH_OFF% | %employer%\'s rolling up a scroll as he explains his predicament.%SPEECH_ON%A dispute amongst the nobility has me short on good, fighting men. Unfortunately, a band of greenskins have chosen this exact moment to come into these parts. They\'re camping to the %direction% of %origin%. I can\'t get the house in order while simultaneously being raided by these damned things, so I\'m mighty hopeful that this interests you, mercenary...%SPEECH_OFF% | %employer% looks you up and down.%SPEECH_ON%You fit enough to take on a greenskin? What about your men?%SPEECH_OFF%You nod and pretend the hassle would be no more than retrieving a cat from a tree. %employer% smiles.%SPEECH_ON%Good, because I got a whole bunch of them being sighted to the %direction% of %origin%. Go there and destroy them. Simple enough, right? Surely it interests a man of your... confidence.%SPEECH_OFF% | %employer% tends to his dogs, feeding each one a meal some peasants would kill for. He claps his hands of the meaty grease.%SPEECH_ON%My chef made that, can you believe it? Horrid. Disgusting.%SPEECH_OFF%You nod as though you could possibly understand what world this man lives in where shoveling good food to dogs is normal. %employer% pitches his elbows onto his table.%SPEECH_ON%Anyway, the folks who deliver meat to us are reporting that greenskins are killing their cows. Apparently, a camp has been sighted %direction% of %origin%. If you\'re interested, I\'d like you to go there and destroy them all.%SPEECH_OFF% | You find %employer% staring over some scrolls. He glances up at you and offers a chair.%SPEECH_ON%Glad you\'re here, mercenary. I\'ve got an issue with greenskins in these parts - they\'ve made camp %direction% from here.%SPEECH_OFF%He lowers one of the scrolls.%SPEECH_ON%And I can\'t afford to send my own men. Knights are rather... unexpendable. You, however, are just right for the job. What do you say?%SPEECH_OFF% | As you enter %employer%\'s office, a group of men leave. They\'re knights, their scabbards clinking just beneath their garbs. %employer% welcomes you in.%SPEECH_ON%Don\'t worry about them. They\'re just wondering what happened to the last man I hired.%SPEECH_OFF%You raise an eyebrow. The man waves it off.%SPEECH_ON%Oh don\'t give me that shit, sellsword. You know the business as well as I do, sometimes you guys fall short and you know that means...%SPEECH_OFF%You say nothing, but after a pause, give him a nod.%SPEECH_ON%Good, glad you understand. If you want to know, I\'ve got greenskins out %direction% of %origin%. They\'ve set up camp which I presume hasn\'t moved since I last, uh, sent some men there. Are you interested in rooting them out for me?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Combattre des orcs ne sera pas gratuit. | J\'imagine que vous allez payer chère pour ça. | Parlons argent.}",
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
			ID = "OrcsAgainstOrcs",
			Title = "Before the attack...",
			Text = "[img]gfx/ui/events/event_49.png[/img]{As you order your men to attack, they come across a number of orcs... fighting each other? The greenskins appear to be divided, and they are settling their differences by dividing one another in half. It\'s a gruesome display of violence. When you figure to let them fight it out, two of the orcs battle their way toward you, and soon enough every orc is staring at you. Well, no running now... to arms! | You order the %companyname% to attack, believing you\'ve gained the upperhand on the orcs. But they\'re already armed! And... fighting one another?\n\n One orc cleaves another orc in twine, and another crushes the head of another. This seems to be some sort of clan conflict. A shame you didn\'t wait a moment longer for these brutes to settle their differences, now it\'s a free for all! | The orcs are battling one another! It\'s some sort of greenskinned fracas which you\'ve made yourself a part of. Orc against orc against man, what a sight to behold! Get the men close together and you might just make it out of this goatfark alive. | By the gods, the orcs are greater numbers than you ever could have thought! Luckily, they seem to be murdering one another. You don\'t know if they\'re separate clans or if this is just greenskins\' version of a drunken brawl. Regardless, you\'re in the middle of it now!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To Arms!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Betrayal1",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{As you finish the last orc you are suddenly greeted by a heavily armed group of men. Their lieutenant steps forward, his thumbs hooked into a belt holding up a sword.%SPEECH_ON%Well, well, you really are stupid. %employer% does not forget easily - and he hasn\'t forgotten the last time you betrayed %faction%. Consider this a little... return of the favor.%SPEECH_OFF%Suddenly, all the men behind the lieutenant charge forth. Arm yourselves, this was an ambush! | Cleaning orc blood off your sword, you suddenly spot a group of men walking toward you. They\'re carrying %faction%\'s banner and are drawing their weapons. The realization that you\'ve been setup dawns on you just as the men begin to charge. They let you fight the orcs first, the bastards! Let them have it! | A man seemingly from nowhere comes to greet you. He\'s well armed, well armored, and apparently quite happy, grinning sheepishly as he approaches.%SPEECH_ON%Evening, mercenaries. Good work on those greenskins, eh?%SPEECH_OFF%He pauses to let his smile fade.%SPEECH_ON%%employer% sends his regards.%SPEECH_OFF%Just then, a group of men swarm out from the sides of the road. It\'s an ambush! That damned nobleman has betrayed you! | The battle is barely over that a group of armed men wearing the colors of %faction% fall in behind you, the group fanning out to stare at your company. Their leader sizes you up.%SPEECH_ON%I\'m going to enjoy prying that sword from your cold grip.%SPEECH_OFF%You shrug and ask why you\'ve been setup.%SPEECH_ON%%employer% doesn\'t forget those who doublecross him or his house. That\'s about all you need to know. Not like anything I say here will do you good when you\'re dead.%SPEECH_OFF%To arms, then, for this is an ambush! | Your men scour the orc camp and find not a soul. Suddenly, a few strangers appear behind you, the lieutenant of the group walking forward with ill intent. He\'s got a cloth embroidered with %employer%\'s sigil.%SPEECH_ON%A shame those orcs couldn\'t finish you off. If you\'re wondering why I\'m here, it is to pay a debt owed to %faction%. You promised a task well done. You could not own up to that promise. Now you die.%SPEECH_OFF%You unsheathe your sword and flash its blade at the lieutenant.%SPEECH_ON%Looks like %faction% is about to have another promise broken.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Take up arms!",
					function getResult()
					{
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationBetrayal);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).getFlags().set("Betrayed", false);
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "Betrayal";
						p.Music = this.Const.Music.NobleTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, 140 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Betrayal2",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{You wipe your sword on your pant leg and quickly sheathe it. The ambushers lay dead, skewered into this grotesque pose or that one. %randombrother% walks up and inquires what to do now. It appears that %faction% isn\'t going to be on the friendliest of terms. | You kick the dead body of an ambusher off the end of your sword. It appears %faction% isn\'t going to be on the friendliest of terms from now on. Maybe next time, when I agree to do something for these people, I actually do it. | Well, if nothing else, what can be learned from this is to not agree to a task you can\'t complete. The people of these land are not particularly friendly to those who fall short of their promises... | You betrayed %faction%, but that\'s not something to dwell on. They betrayed you, that\'s what is important now! And going into the future, you best be suspicious of them and anyone who flies their banner. | %employer%, judging by the dead bannermen at your feet, appears to no longer be happy with you. If you were to guess, it\'s because of something you did in the past - doublecross, failure, back-talking, sleeping with a nobleman\'s daughter? It all runs together that you try and think about it. What\'s important now is that this wedge between you two will not be easily healed. You best be wary of %faction%\'s men for a little while.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "So much for getting paid...",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SearchingTheCamp",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_32.png[/img]{The battle over, you search the orc camp. Amongst the ruins, you find what appears to be heavy armor and human weapons in a very unusable state. Sadly, you do not find those they perhaps once belonged to. | With the orcs slain, you take a look autour deir camp. It\'s full of shite. Literally, shite is everywhere. The damned things don\'t know a thing about cleanliness. %randombrother% waddles up, wiping his boot on a tentpost.%SPEECH_ON%Sir, shall we move on or keep looking...?%SPEECH_OFF%You\'ve seen, and smelled, enough. | The orc camp is a wasteland filled with all manner of depravity. You can smell their sex and waste. It\'s no wonder they\'re so warlike, for they know not even the beginnings of what a civilized man understands. | The orc camp is destroyed, but you take a moment to sift through the ruins. Amidst the ashen pit of a campfire you find a few human corpses. Judging by their arms, they seem to have been mercenaries like yourself. A shame... that none of their gear is useful now that it\'s all burned up. | A few of your mercenaries walk through the ruins of the orc camp. They pick about the remains, turning up this or that unusable trinket. %randombrother% sheathes his bloody sword.%SPEECH_ON%Naught all here, sir.%SPEECH_OFF%You nod and get the men ready to Retournez à %employer%. | The battle over, you trundle about the camp, looking for anything useful. You find nothing you can take, but you do find a stack of dead knights. Their pale, wormed and maggot-buggered faces suggest they\'d been there awhile. Who knows what the orcs were doing with them.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Time to collect our pay.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Volunteer1",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_32.png[/img]{The battle\'s over, but you still hear screaming. You tell %randombrother% to shut it, as he is somewhat predisposed to the random growl or yelp, but he shakes his head and says it\'s not him. Just then, a shackled man rises up out of a pile of ashes that used to be the orc camp.%SPEECH_ON%Evening, fine sirs! I do believe you have freed me.%SPEECH_OFF%He stumbles forth, a ghostly, twisting cloud of ash spinning off behind him.%SPEECH_ON%I am quite grateful, obviously, and I\'d like to repay the favor. You\'re mercenaries, correct? If so, I\'d like to fight for you.%SPEECH_OFF%He picks a blade up off the ground and twirls it around in hand, weaving it as though it had been his since birth. An interesting offer that just got more interesting... | Cleaning your blade, a voice pipes in from a collapsed orcish tent.%SPEECH_ON%Good sirs, you\'ve done it!%SPEECH_OFF%You watch as a grinning man emerges.%SPEECH_ON%You\'ve freed me! And I\'d like to repay that service you\'ve done by offering my hand!%SPEECH_OFF%He holds his hand out, pauses, then takes it back.%SPEECH_ON%I mean to fight for you! I\'d like to fight for you, sir! If you can do all this, then surely I\'d be in good company, right?%SPEECH_OFF%Hmm, an interesting offer. You toss him a weapon and he catches with ease. He twists the handle about, twirling it hand-over-hand before trying to sheathe it into an invisible scabbard.%SPEECH_ON%The name\'s %dude_name%.%SPEECH_OFF% | A man in tattered and dented armor comes sprinting toward you. His arms are tied behind his back.%SPEECH_ON%You did it! I can\'t believe it! Sorry, let me explain my immodesty. I was captured by the orcs a day ago as we tried to take the camp. I think they were about to put me on a spit when you showed up. I took the first moment I could to make my escape, but now I see you and your group might be worth joining.%SPEECH_OFF%You ask the man to get to the point. He does.%SPEECH_ON%I\'d like to fight for you, sir. I\'ve got experience - been with the lord\'s army, a mercenary, and... well, other things.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Welcome to the company!",
					function getResult()
					{
						this.World.getPlayerRoster().add(this.Contract.m.Dude);
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude.onHired();
						this.Contract.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "You\'ll have to find your luck elsewhere.",
					function getResult()
					{
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude = null;
						return 0;
					}

				}
			],
			function start()
			{
				local roster = this.World.getTemporaryRoster();
				this.Contract.m.Dude = roster.create("scripts/entity/tactical/player");
				this.Contract.m.Dude.setStartValuesEx(this.Const.CharacterVeteranBackgrounds);

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).setArmor(this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).getArmor() * 0.33);
				}

				if (this.Contract.m.Dude.getTitle() == "")
				{
					this.Contract.m.Dude.setTitle("the Survivor");
				}

				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "À votre retour...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{You Retournez à %employer% and report your doings. He waves you off.%SPEECH_ON%Oh please, sellsword. I already know. You don\'t think I have spies in these parts?%SPEECH_OFF%He gestures toward a satchel on the corner of his table. You take it and the man flicks his wrist.%SPEECH_ON%That should be thanks enough, now please leave my sight.%SPEECH_OFF% | You show %employer% a head of an orc. He stares at it, then at you.%SPEECH_ON%Interesting. So should I take it that you\'ve completed what I\'ve asked of you?%SPEECH_OFF%You nod. The man smiles and hands over a wooden chest with %reward% crowns inside.%SPEECH_ON%I knew I could trust you, sellsword.%SPEECH_OFF% | %employer% stares at you as you return.%SPEECH_ON%I\'ve heard of what you\'ve done.%SPEECH_OFF%It\'s a strange tone in his voice, a tone that has you quickly reviewing everything you\'ve done in the past week. Was that a noble woman at the... no, couldn\'t be.%SPEECH_ON%The orcs are dead. Good work, mercenary.%SPEECH_OFF%He slides you a satchel of %reward% crowns and a wave of relief also washes over you. | You enter %employer%\'s room and take a seat, pouring yourself a cup of wine. The nobleman stares a hole through you.%SPEECH_ON%I dare say that\'s a drawing-and-quartering offense, a hanging one if I\'m feeling kind, a burning one if I ain\'t.%SPEECH_OFF%You finish the drink and then slam an orc head on the man\'s table. The cup totters and rolls around on its side. %employer% reels back, then calms himself.%SPEECH_ON%Ah, yes, a drink well earned. That wasn\'t my best wine, anyway. %randomname%, my guard, is waiting for you outside. He\'ll have the %reward% crowns we agreed upon.%SPEECH_OFF% | You lift an orc head to show %employer%. The green maw falls open, its tongue lolling between the teeth one might mistake for tusks. %employer% nods and flicks his hand.%SPEECH_ON%Please, have some mercy for my dreams and take it away.%SPEECH_OFF%You do as told. The man shakes his head.%SPEECH_ON%How am I to get any sleep these days with things like that being lugged around? Anyhow, you have %reward% crowns already waiting for you outside with one of my guards. Thanks for your work, sellsword.%SPEECH_OFF% | You come to %employer%\'s room to find him looking at a drawing on a scroll. He stares at you, the lip of the paper folding backward.%SPEECH_ON%My daughter thinks herself an artist, can you believe that?%SPEECH_OFF%He shows you the scroll. It\'s a pretty well done drawing of a man who looks suspiciously like %employer%. The drawn figure is facing a hangman. %employer% laughs.%SPEECH_ON%Dumb girl.%SPEECH_OFF%He crumples the scrolls and tosses it aside.%SPEECH_ON%Anyway, my spies have already told me of your successes. Here is your payment as we agreed.%SPEECH_OFF%}",
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
						this.World.Assets.addMoney(this.Contract.m.Reward);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Destroyed an orc encampment");
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
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() + this.Flags.get("HeadsCollected") * this.Contract.m.Payment.getPerCount();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] Crowns"
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Origin, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"location",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.m.Destination.getName()
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.Const.Strings.Direction8[this.m.Origin.getTile().getDirection8To(this.m.Destination.getTile())]
		]);
		_vars.push([
			"dude_name",
			this.m.Dude == null ? "" : this.m.Dude.getNameOnly()
		]);
		_vars.push([
			"reward",
			this.m.Reward
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
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
				this.m.Destination.setOnCombatWithPlayerCallback(null);
			}

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
		if (this.m.IsStarted)
		{
			if (this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive())
			{
				return false;
			}

			if (this.m.Origin.getOwner().getID() != this.m.Faction)
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


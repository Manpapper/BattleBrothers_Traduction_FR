this.roaming_beasts_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		IsPlayerAttacking = true
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.roaming_beasts";
		this.m.Name = "Hunting Beasts";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 500 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Chassez ce qui terrorise " + this.Contract.m.Home.getName()
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

				if (this.Math.rand(1, 100) <= 5 && this.World.Assets.getBusinessReputation() > 500)
				{
					this.Flags.set("IsHumans", true);
				}
				else
				{
					local village = this.Contract.getHome().get();
					local twists = [];
					local r;
					r = 50;

					if (this.isKindOf(village, "small_lumber_village") || this.isKindOf(village, "medium_lumber_village"))
					{
						r = r + 50;
					}
					else if (this.isKindOf(village, "small_tundra_village") || this.isKindOf(village, "medium_tundra_village"))
					{
						r = r + 50;
					}
					else if (this.isKindOf(village, "small_snow_village") || this.isKindOf(village, "medium_snow_village"))
					{
						r = r + 50;
					}
					else if (this.isKindOf(village, "small_steppe_village") || this.isKindOf(village, "medium_steppe_village"))
					{
						r = r - 25;
					}
					else if (this.isKindOf(village, "small_swamp_village") || this.isKindOf(village, "medium_swamp_village"))
					{
						r = r - 25;
					}

					twists.push({
						F = "IsDirewolves",
						R = r
					});
					r = 50;

					if (this.isKindOf(village, "small_steppe_village") || this.isKindOf(village, "medium_steppe_village"))
					{
						r = r + 50;
					}
					else if (this.isKindOf(village, "small_farming_village") || this.isKindOf(village, "medium_farming_village"))
					{
						r = r + 25;
					}
					else if (this.isKindOf(village, "small_tundra_village") || this.isKindOf(village, "medium_tundra_village"))
					{
						r = r - 25;
					}
					else if (this.isKindOf(village, "small_snow_village") || this.isKindOf(village, "medium_snow_village"))
					{
						r = r - 50;
					}
					else if (this.isKindOf(village, "small_swamp_village") || this.isKindOf(village, "medium_swamp_village"))
					{
						r = r + 25;
					}

					twists.push({
						F = "IsGhouls",
						R = r
					});

					if (this.Const.DLC.Unhold)
					{
						r = 50;

						if (this.isKindOf(village, "small_lumber_village") || this.isKindOf(village, "medium_lumber_village"))
						{
							r = r + 100;
						}
						else if (this.isKindOf(village, "small_tundra_village") || this.isKindOf(village, "medium_tundra_village"))
						{
							r = r - 25;
						}
						else if (this.isKindOf(village, "small_steppe_village") || this.isKindOf(village, "medium_steppe_village"))
						{
							r = r - 25;
						}
						else if (this.isKindOf(village, "small_snow_village") || this.isKindOf(village, "medium_snow_village"))
						{
							r = r - 50;
						}
						else if (this.isKindOf(village, "small_swamp_village") || this.isKindOf(village, "medium_swamp_village"))
						{
							r = r + 25;
						}

						twists.push({
							F = "IsSpiders",
							R = r
						});
					}

					local maxR = 0;

					foreach( t in twists )
					{
						maxR = maxR + t.R;
					}

					local r = this.Math.rand(1, maxR);

					foreach( t in twists )
					{
						if (r <= t.R)
						{
							this.Flags.set(t.F, true);
							  // [346]  OP_JMP            0      5    0    0
						}
						else
						{
							r = r - t.R;
						}
					}
				}

				local playerTile = this.World.State.getPlayer().getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 5, 10);
				local party;

				if (this.Flags.get("IsHumans"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).spawnEntity(tile, "Direwolves", false, this.Const.World.Spawn.BanditsDisguisedAsDirewolves, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					party.setDescription("A pack of ferocious direwolves on the hunt for prey.");
					party.setFootprintType(this.Const.World.FootprintsType.Direwolves);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Direwolves, 0.75);
				}
				else if (this.Flags.get("IsGhouls"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Nachzehrers", false, this.Const.World.Spawn.Ghouls, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					party.setDescription("A flock of scavenging nachzehrers.");
					party.setFootprintType(this.Const.World.FootprintsType.Ghouls);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Ghouls, 0.75);
				}
				else if (this.Flags.get("IsSpiders"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Webknechts", false, this.Const.World.Spawn.Spiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					party.setDescription("A swarm of webknechts skittering about.");
					party.setFootprintType(this.Const.World.FootprintsType.Spiders);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Spiders, 0.75);
				}
				else
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Direwolves", false, this.Const.World.Spawn.Direwolves, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					party.setDescription("A pack of ferocious direwolves on the hunt for prey.");
					party.setFootprintType(this.Const.World.FootprintsType.Direwolves);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Direwolves, 0.75);
				}

				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);
				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_beasts_01");
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
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
					if (this.Flags.get("IsHumans"))
					{
						this.Contract.setScreen("CollectingProof");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsGhouls"))
					{
						this.Contract.setScreen("CollectingGhouls");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsSpiders"))
					{
						this.Contract.setScreen("CollectingSpiders");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("CollectingPelts");
						this.World.Contracts.showActiveContract();
					}

					this.Contract.setState("Return");
				}
				else if (!this.Flags.get("IsWorkOfBeastsShown") && this.World.getTime().IsDaytime && this.Contract.m.Target.isHiddenToPlayer() && this.Math.rand(1, 9000) <= 1)
				{
					this.Flags.set("IsWorkOfBeastsShown", true);
					this.Contract.setScreen("WorkOfBeasts");
					this.World.Contracts.showActiveContract();
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (this.Flags.get("IsHumans") && !this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					local troops = this.Contract.m.Target.getTroops();

					foreach( t in troops )
					{
						t.ID = this.Const.EntityType.BanditRaider;
					}

					this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
					this.Contract.setScreen("Humans");
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
					if (this.Flags.get("IsHumans"))
					{
						this.Contract.setScreen("Success2");
					}
					else if (this.Flags.get("IsGhouls"))
					{
						this.Contract.setScreen("Success3");
					}
					else if (this.Flags.get("IsSpiders"))
					{
						this.Contract.setScreen("Success4");
					}
					else
					{
						this.Contract.setScreen("Success1");
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
			Text = "[img]gfx/ui/events/event_43.png[/img]{While you wait for %employer% to explain what he needs your services for, you contemplate on how silent and eerie the whole settlement was when you first arrived. %employer% raises his voice %SPEECH_ON%This place is cursed by the gods and haunted by unearthly beasts! They come in the night with glowing red eyes and take lives at their whim. Most of our cattle is dead and I fear that once there are no more, we are next to be torn apart. The other day we sent our strongest lads out to find and kill the beasts but we haven\'t heard of them since.%SPEECH_OFF%He sighs deeply.%SPEECH_ON%Follow the tracks %direction% and hunt down and kill those creatures so that we can live in peace again! We are not wealthy, but all chipped in to pay for your services.%SPEECH_OFF% | %employer%\'s looking out his window when you find him. There\'s a goblet in his hand - and there\'s nothing but silence outside. He turns to you, almost somber.%SPEECH_ON%When you came here, did you realize how quiet it was?%SPEECH_OFF%You remark that you did, but you\'re a sellsword who looks the part. It\'s just what you are accustomed to. %employer% nods and takes a drink.%SPEECH_ON%Ah, of course. Unfortunately, it isn\'t that people are afraid of you. Not this time. We have had people being attacked these past weeks. Beasts of some sort are on the loose, we know not what they are, but only who they take. We\'ve pleaded with our lord, of course, but he has done nothing to help us...%SPEECH_OFF%His next drink is a long one. When he finishes, he turns to you, empty cup in hand.%SPEECH_ON%Would you go hunt these monsters down? Please, sellsword, help us.%SPEECH_OFF% | %employer%\'s listening to the talk of a few peasants when you find him. When they see you, they quickly depart, leaving the man with a satchel in hand. He holds it up.%SPEECH_ON%There\'s crowns in here. Crowns that those people are giving me to give someone, anyone, to help us. People are disappearing, sellsword, and when they are found they\'re... not just dead, but... mangled. Mutilated. Everyone is too scared to go anywhere.%SPEECH_OFF%He stares into the sack, then looks to you.%SPEECH_ON%I do hope you are interested in this task.%SPEECH_OFF% | You find %employer% reading a scroll. He throws the paper at you and asks you to read off the names. The handwriting is difficult, but not moreso than the names themselves. You stop and apologize, stating you are not from these parts. The man nods and takes the scroll back.%SPEECH_ON%Tis alright, sellsword. If you were wondering, those were the names of men, women, and children who have passed in the last week.%SPEECH_OFF%Last week? There were a lot of names on that list. The man, seeming to read you, nods somberly.%SPEECH_ON%Aye, we are in a bad way. So many lives lost. We believe this to be the work of foul creatures, beasts beyond our ability to reason. Obviously, we\'d like you to go find and destroy them. Would you be interested in such a task, mercenary?%SPEECH_OFF% | %employer%\'s got a few dogs at his feet, all tuckered out with their tongues lolling.%SPEECH_ON%They\'ve spent the past few days hunting for missing folks. Folks that are seemingly disappearing to the gods know where.%SPEECH_OFF%He leans down and pets one of the hounds, scratching it behind the ear. Usually, a dog would respond to that, but the poor thing barely even responds.%SPEECH_ON%The folks don\'t know what I know, though, which is that people ain\'t just disappearing... they\'re being taken. Horrible beasts are afoot, sellsword, and I need you to go after them. Hell, maybe you\'ll even find someone or two of the townsfolk, though I doubt it.%SPEECH_OFF%One of the mutts lets out a long, tired wheeze almost as if on cue. | %employer%\'s got a satchel with a scroll attached, but the name written on the paper is not yours. He weighs it carefully, the lumps of coin curving about his fingers, their chink and chanks muted. He turns to you.%SPEECH_ON%You recognize that name?%SPEECH_OFF%You shake your head. The man continues.%SPEECH_ON%A week ago we sent the famed %randomnoble% %direction% of here to go hunt down some foul beasts that have been terrorizing the town and surrounding farmsteads for weeks. Do you know why this satchel has remained in my ownership?%SPEECH_OFF%You shrug and answer.%SPEECH_ON%Because he hasn\'t returned?%SPEECH_OFF%%employer% nods and sets the satchel down. He sits on the edge of his table.%SPEECH_ON%Correct. Because he has not returned. Now, why do you think that is? I think it\'s because he\'s dead, but let\'s not be so negative. I think it\'s because the beasts out there require more. I think they require someone like you, sellsword. Would you be willing to help us now that this nobleman has failed?%SPEECH_OFF% | %employer% takes a book from his shelf. When he sets it on his table, dust or maybe even ash plume outward. He opens it up, thumbing slowly from page to page.%SPEECH_ON%Do you believe in monsters, sellsword? I\'m asking honestly, as I believe you\'ve had a better walk-about of this world than I.%SPEECH_OFF%You nod and speak.%SPEECH_ON%More than just a belief, yes.%SPEECH_OFF%The man thumbs another page. He looks up at you.%SPEECH_ON%Well, we believe monsters have come to %townname%. We believe that\'s why people are going missing. Understand where this is going? I need you to find these \'make believe\' creatures and kill them like any other. Are you interested?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{What\'s this worth to you? | What is %townname% prepared to pay? | Let\'s talk pay.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{This doesn\'t sound like our kind of work. | I wish you luck, but we\'ll not be part of this.}",
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
			ID = "Humans",
			Title = "Before the attack...",
			Text = "[img]gfx/ui/events/event_07.png[/img]{These aren\'t beasts at all, but men in wolf\'s clothing! Having seen the \'true\' face of this evil, the men are quite relieved that your enemy is one they know all too well. | As you close in on the monsters, you realize that the foul creatures are not beasts at all, but humans in disguise! You know not why they played such a game of dress-up, but they\'re drawing weapons. As far as you\'re concerned, beast or man, they all die the same. | You stumble upon a man removing a wolf head off his shoulders. He glances at you, the disguise still in hand, then quickly puts it back on. You draw your sword.%SPEECH_ON%It\'s a little late to be playing pretend.%SPEECH_OFF%The slash of your weapon knocks the man\'s mask off and he stumbles backward. Before you can run him through, he takes off, sprinting toward a collection of similarly skulking fellow. They draw their weapons at the very sight of you. Whatever reason these idiots were playing dress up, it doesn\'t matter now. | You come across a dead beast with a few arrows stuck in its back. The damage does not seem lethal... and when you tip your sword across the creature\'s mane, the head tips right off, revealing a human beneath.%SPEECH_ON%Didja do that?%SPEECH_OFF%A voice breaks in from ahead. There stand a few men removing their disguises: that of the beasts you were after. The one in the lead raises his voice.%SPEECH_ON%Kill them! Kill them all!%SPEECH_OFF%Nope, these are still beasts, just of a softer sort.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Prepare the attack!",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "WorkOfBeasts",
			Title = "Along the way...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{You stumble across a corpse in the grass. Ordinarily, the dead aren\'t that much of a surprise, there are people everywhere so it\'s only a matter of time until you see a body here and there. Except this one has huge gash marks down the back and its organs missing.\n\n%helpfulbrother% walks up.%SPEECH_ON%The organs are gone cause of wolves, or maybe even rabbits. What, you ain\'t ever heard of a really hungry rabbit?%SPEECH_OFF%He spits and chews on a fingernail.%SPEECH_ON%Anyhow, the markings, that ain\'t the work of no rabbit or hound or whatever. That\'s something... bigger... more dangerous.%SPEECH_OFF%You thank the man for his astute observations and tell him to rejoin the ranks. | A peasant comes up to you with his clothes in shredded rags about him. With fair modesty, he\'s got his hands covering his groin.%SPEECH_ON%Please, sirs, come take a look at this... horror.%SPEECH_OFF%When you question what he\'s talking about, he throws his hands up, thrusting his hips at you. He turns afoot like a puppet spun about and takes off running, hooting and hollering. A woman walks up to you in the wake of the man\'s madness. She\'s got her hands against her bosom.%SPEECH_ON%He\'s gone mad on account of his brother being torn apart by the beasts.%SPEECH_OFF%You turn to her, half-expecting the lady to rip off her clothes and wobble her shapes in whatever direction she pleases. Instead, she simply stares at you.%SPEECH_ON%I know %townname% has hired some men to take care of these beasts and you certainly look the part of a hired hand. Please, sir, protect us from these evils... and the evils that they spread...%SPEECH_OFF% | You come across an eviscerated cow with half of it cast atop a fenceline and the other half scattered a good distance across the grass, about as far apart as its entrails would allow. An attachment of gore if there ever was one.\n\nA farmer approaches, tipping his hat up out of his eyes.%SPEECH_ON%Beasts done that. I didn\'t see them, if you was wondering, but I did hear this goatfark of a fiasco before you. Hearing it was good enough for me to stay low and out of sight. Please, if you are here to find those creatures, do so quickly because I can\'t afford to lose anymore livestock like this.%SPEECH_OFF% | A peasant hacking firewood straightens up before you.%SPEECH_ON%By the gods it is nice to see ya, sirs. I thought I heard word of some sellswords stomping about looking for the beasts terrorizing these parts.%SPEECH_OFF%You ask if he\'s seen anything that might help. He pitches his hands over the pommel of his axe.%SPEECH_ON%Can\'t say I have, no. But I\'ve heard some things. I know a man and woman not far from here got taken. Well, they disappeared together. Word has it they dead in the woods now. Barnacled up in the trees, hanging loosely by the gut, ya know? Or, wait, maybe they just gone off on their feetsies to shack up together! Hell... hell! That gal hated her father and the kid was just a nobody with a flair of good looks and a charming tongue. Yeah, that makes sense.%SPEECH_OFF%He pauses and then glances at you.%SPEECH_ON%Anyhow, I\'m certain those monsters are afoot. Keep an eye out, sellsword.%SPEECH_OFF% | A woman runs out of her hut to stop you. Almost out of breath, she asks if you\'ve seen a boy. You shake your head no. She puts her hand out.%SPEECH_ON%He\'s about yeigh big. Mop of brown hair. Not naturally, but the kid sure likes his mud. When he smiles his teeth are like the stars, bright and scattered.%SPEECH_OFF%You shake your head no a second time.%SPEECH_ON%He can throw a good rock. Throws it far. I told him to not show his strength when the lord\'s men were \'round, lest they take him into the army.%SPEECH_OFF%She huffs, blowing a loose strand of hair out of her eyes.%SPEECH_ON%Well shite, anyway, if you see him, let me know. I think he\'s mine. Also, beware the dark. Beasts be bushwhacking folks around here.%SPEECH_OFF%Before you can say anything, the woman picks up her long clothes and trundles back to her hut. | You come across a man kneeling over a thoroughly destroyed dog. You take a knee next to him.%SPEECH_ON%Did the beasts do this?%SPEECH_OFF%He shakes his head no.%SPEECH_ON%Hell, I did this. Finally. Damned thing ain\'t gonna keep me up anymore.%SPEECH_OFF%Just then, a hut across the way opens up and a man sprints out of it screaming.%SPEECH_ON%Is that my damned dog you sonuvabitch?%SPEECH_OFF%The dogkiller quickly stands up.%SPEECH_ON%The beasts! They visited again last night!%SPEECH_OFF%You quietly leave the dispute where the dog lies.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We move on.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CollectingPelts",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_56.png[/img]{The beasts slain, you order the men to take their pelts as evidence. Your employer, %employer%, should be most happy to see them. | Having killed the foul creatures, you begin skinning and scalping them. Gruesome creatures require gruesome evidence. Your employer, %employer%, might not believe your work here otherwise. | With the battle over, you have the men start collecting pelts to take back to %employer%, your employer. | Your employer, %employer%, might not believe what happened here without evidence. You order the men to begin taking pelts, trophies, scalps, whatever might show off your victory here.}",
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
			ID = "CollectingProof",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Your men take the fools\' disguises lest your employer, %employer%, not believe your doings here. | Your employer might not believe what was going on here. You order your men to collect the disguises. %bro1%, stripping a mask off one of the slain, starts to wonder.%SPEECH_ON%So they dressed themselves up as the sort of thing to attract us, and now they\'re all dead. I hope they didn\'t think it a game.%SPEECH_OFF%%bro2% cleans his blade in the folds of one of the disguises.%SPEECH_ON%Well, if it were a game, I sure enjoyed playing it.%SPEECH_OFF% | %randombrother% nods at the slain.%SPEECH_ON%It\'s mighty likely that %employer% wouldn\'t believe a group of brigands were dressing up as beasts.%SPEECH_OFF%Agreeing, you order the men to begin collecting the masks and disguises as evidence. | You\'ll need evidence to show your employer, %employer%. These weren\'t the beasts you were looking for, but they do carry a lot of disguises that your employer would probably be most interested in seeing. One of the men wonders aloud.%SPEECH_ON%So what were they playing dress up for?%SPEECH_OFF%%bro2% folds some of the disguises over his arm as he goes about collecting them.%SPEECH_ON%Suicide by ceremony? Their dance and fun got our attention, after all.%SPEECH_OFF%He picks up one of the disguises only for the head of the dead to get slinged up with it. The sellsword laughs as he kicks the dead man\'s head out.}",
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
			ID = "CollectingGhouls",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_131.png[/img]{The fight over, you walk to a dead Nachzehrer and take a knee. Were it not for a gate of ill-shapen teeth, you could easily fit your head into the beast\'s oversized maw. Instead of admiring the dental failures at hand, you instead take out a knife and saw its head off, ripping through a very tough outer layer of skin before, surprisingly, easily cutting through the muscles and tendons. You raise the head up and order the %companyname% follow suit. %employer% will be expecting some proof, after all. | The Nachzehrers\'s dead body looks more rock than beast as it lays flat and unmoving. Flies are already coupling inside its mouth, sowing life on the frothy remains of death. You order %randombrother% to take its head, for %employer% will be expecting proof. | Dead Nachzehrers are scattered about. You take a knee beside one and look at its mouth. Whatever was in its lungs is still issuing forth, a wheeze burping out. Putting a cloth to your nose, you use the other hand to chop away at its neck with a blade, cutting off the head and holding it up. You order a few brothers to follow suit for %employer% will be expecting proof. | A dead Nachzehrer is an interesting specimen to behold. You can\'t help but wonder where it falls on the natural spectrum. Shaped like crude men, muscled like some beastly thing, and its head is gnarled with features born out of a wildman\'s nightmares. You order the %companyname% to start collecting the heads of the foul things for %employer% will surely be wanting proof.}",
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
			ID = "CollectingSpiders",
			Title = "After the battle...",
			Text = "[img]gfx/ui/events/event_123.png[/img]{You order your men to scour the field and collect as many parts as they can of the spiders. A few make the mistake of touching the hairs on the webknechts\' legs, leaving them scratching quickly forming rashes. | The spiders litter the field like they would the corner of an attic. In death, they look like giant gloves stiffly clasped together. You have the men wrench the legs apart to harvest evidence of the bestial remains. | The mercenaries scour the field, hacking and sawing at the spiders\' stiff remains to take back to %employer%. Even in death, the webknechts are ghastly, looking only a moment away from flinching back to life and wrapping themselves autour de nearest breathing animal. Their horrifying features and surreal size does not stop some sellswords from dancing around, clicking their tongues and hissing, and all around preying upon the phobias of those less inclined to go near the damned things.}",
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
			ID = "Success1",
			Title = "On your return...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{You Retournez à %employer% and lay one of the pelts clear across his desk. Its limp claws rap against the side of the oak. The man lifts one, then lets it fall again.%SPEECH_ON%I see you\'ve found those beasts we were looking for.%SPEECH_OFF%You tell him of the battle. He seems most pleased, taking a small wooden chest out from his bookshelf and handing it over.%SPEECH_ON%%reward_completion% crowns, as agreed upon. The people of %townname% deserve the reprieve you have given them from such horrors.%SPEECH_OFF% | When you step in %employer%\'s room he recoils almost instantly.%SPEECH_ON%What in the hells of the gods is in your hand, sellsword?%SPEECH_OFF%You hold up the nape of a pelt. Black blood ropes out from the neck and splatters the floor.%SPEECH_ON%One of the beasts you were looking for. If you need evidence of the rest, I got those waiting outside...%SPEECH_OFF%The man holds his hand up, staying you.%SPEECH_ON%One is sufficient for my belief. Very good work, sellsword. Your pay will be with %randomname%, a councilman you probably passed in the halls. He\'s got the ugly mug on him and he\'ll be carrying the %reward_completion% crowns, as promised.%SPEECH_OFF%The man takes another look at the beast then slowly shakes his head.%SPEECH_ON%May the dead and their survivors find peace in the passing of those foul creatures.%SPEECH_OFF% | %employer% welcomes your return with a goblet of wine.%SPEECH_ON%Drink up, beast-slayer.%SPEECH_OFF%You\'re curious as to how he already knows of your success. He waves off your curiosity.%SPEECH_ON%I\'ve many eyes and ears in this land - not spies, of course, but the common folk has a big mouth. I should know, I am one! You did well on this one, sellsword, so have a sip. It\'s mighty fine wine.%SPEECH_OFF%It\'s alright. The reward of %reward_completion% crowns you walk out with is far better, though. %employer% stops you.%SPEECH_ON%Just so you know, mercenary, those beasts killed some good men and women out there. Those people might be scared of you, being the sellsword that you are, but they are eternally grateful all the same.%SPEECH_OFF%You weigh the crowns. Quite grateful, yes... | %employer% takes a few steps back.%SPEECH_ON%Ah, uh, I see you\'ve killed the beasts. That\'s a mighty fine pelt you got there.%SPEECH_OFF%You drop what you\'ve brought: a thick, heavy mane of beastly origin collapsing into a pile of fur and flesh. The man, almost too scared to get close, tosses you a satchel.%SPEECH_ON%%reward_completion% crowns, as agreed upon. I will go to the people and tell them of your success. Finally, we can be at peace.%SPEECH_OFF% | %employer%\'s sitting at his table, legs up over a corner. His eyes are staring at the ceiling, the corners of his face pinched with withered folds. He looks at you.%SPEECH_ON%Welcome back. I\'ve been getting word of your doings... of your battles with the monsters.%SPEECH_OFF%You nod, looking around for your reward. The man shows you the door.%SPEECH_ON%%randomname%, a fellow councilman of %townname%, has your payment outside. %reward_completion% crowns as agreed upon. And the people of %townname%, fear you though they may, are blessed all the same by your arrival here. Thank you, mercenary.%SPEECH_OFF% | %employer%\'s feeding one of his dogs when you return. The mutt drops its bone to sniff at what you\'ve brought. The man points at the pelt.%SPEECH_ON%What kind of foul thing is that?%SPEECH_OFF%You shrug and toss it onto his table. The dog pokes its nose at one of the claws, growls, then begins to lick it. %employer% smiles briefly, but then goes to his bookshelf, picking up a wooden chest and handing it to you.%SPEECH_ON%%reward_completion% crowns, was it? You should know that you\'ve brought peace to the people of %townname%.%SPEECH_OFF%You nod.%SPEECH_ON%Does their happiness also come in crowns?%SPEECH_OFF%%employer% frowns at your greedy humor.%SPEECH_ON%No, it does not. Have a good day, mercenary.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Rid the town of direwolves");
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
			ID = "Success2",
			Title = "On your return...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% welcomes your return.%SPEECH_ON%I\'ve already heard the, I suppose, splendid news. I can believe it, though. A bunch of brigands playing dress up. Wolves in... wolf clothing?%SPEECH_OFF%He grins at you, expecting a laugh at his cheesy joke. You shrug. He shrugs, too.%SPEECH_ON%Ah, well. Your payment, %reward_completion% crowns, is waiting for you outside. I will tell the people of %townname% that the monsters they fear are but men.%SPEECH_OFF% | You return with the costumes of the foolish brigands. %employer% tilts the disguises left to right.%SPEECH_ON%Interesting. They\'re very well done. I\'d almost say the brigands were clever here.%SPEECH_OFF%He picks up one of the masks and looks just about ready to try it on, then pauses as though he shouldn\'t do this with an audience. He puts it back down and smiles at you.%SPEECH_ON%Well, anyway, sellsword... good work. You\'ll have %reward_completion% crowns waiting for you outside with one of %townname%\'s councilmen. He\'ll be looking out for you. Now, the people of %townname% can bury our dead and finally be at peace.%SPEECH_OFF% | %employer% reels in laughter at your reveal.%SPEECH_ON%Men? It was only men?%SPEECH_OFF%You nod, but try and get the man back on track.%SPEECH_ON%They killed a lot of peasants and they were still a dangerous lot.%SPEECH_OFF%Your employer nods.%SPEECH_ON%Of course, of course! I didn\'t mean to belittle anything or anyone. Don\'t dare assume things of me, sellsword, those are my friends and neighbors dying out there! Anyway, you did what I asked of you and for that I am very grateful.%SPEECH_OFF%He hands over a satchel of crowns. You count %reward_completion% inside before making your leave. The man hollers out to you.%SPEECH_ON%Surely you understand trying to find humor in this horrible world, right? Because it is I who went to the funerals of all those slain. I will not go into the grave with a frown on my face, no matter how hard this damned place tries to force it on me.%SPEECH_OFF% | You show %employer% the evidence of the mischievous brigands. He picks through the lumps of disguises, rubbing crusty blood off his fingers.%SPEECH_ON%That is the blood of men alright. Are you sure that they weren\'t just having fun playing pretend and the real monsters are still out there?%SPEECH_OFF%You purse your lips and explain that they attacked you with very not-pretend weapons. %employer% nods, seemingly understanding, though a little suspicious.%SPEECH_ON%Well, I suppose I could just wait and see if the monsters return. If they do, well, a man betrayed makes for a mighty fine monster in and of itself, wouldn\'t you agree?%SPEECH_OFF%You just tell the man to pay you and wait and see if he should be so untrusting. He nods, giving you %reward_completion% crowns and seeing you off.%SPEECH_ON%I truly do hope you are telling the truth, mercenary. %townname% could use a reprieve from the horrors that is constantly lashing out from this damned world.%SPEECH_OFF% | %employer% runs a finger along the edge of a disguise.%SPEECH_ON%The fur is soft to the touch. Very real...%SPEECH_OFF%He looks up at you.%SPEECH_ON%I have to wonder if they killed the original monsters, and then... decided to wear their pelts? Why, though? Do you think they were cursed?%SPEECH_OFF%You shrug and answer.%SPEECH_ON%All I can say is that they had the guise of monsters, and the cruelty of them as well. They attacked us and paid for it. Have any of your locals spotted any creatures in awhile?%SPEECH_OFF%The man brings out a satchel of %reward_completion% crowns and slides it over to you.%SPEECH_ON%No, they haven\'t. In fact, they\'re starting to venture out again. I don\'t mean down the roads, but leaving the safety of their front doors is a big step for many! You\'ve definitely brought us peace, sellsword, and for that we thank you.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Beast, men... what matters is the crowns.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Rid the town of brigands masquerading as direwolves");
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
			Title = "On your return...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{You find %employer% resting on his laurels. He stands and pulls his pants up, a servant quickly retrieving a bucket from whence he was sitting. The poor servant quickly rushes out of the room. %employer% points at the Nachzehrer head dangling from your hand.%SPEECH_ON%That is absolutely disgusting. %randomname%, give this man his pay. %reward% crowns, was it?%SPEECH_OFF% | You place the Nachzehrer head onto %employer%\'s desk. For some reason, fluids still issue from its neck, dribbling down the side of the oak and no doubt staining it. The man leans back, tenting his fingers on his belly.%SPEECH_ON%Nachzehrers? And what else, ghosts?%SPEECH_OFF%The man snickers to himself.%SPEECH_ON%Nothing is too difficult for you, sellsword.%SPEECH_OFF%He snaps his fingers and a servant comes up, handing you a satchel of %reward% crowns. | Between the battle and walking to %employer%\'s place, the maw of the Nachzehrer became filled with flies, its tongue replaced by a formless, throbbing black ball that\'s more buzz than bite. %employer% takes one look at it and puts a cloth to his mouth.%SPEECH_ON%Yes, I get it, take it away, please.%SPEECH_OFF%He waves one of his guards over and you are handed a satchel of %reward% crowns. | A steely eyed %employer% leans forward to get a good look at the Nachzehrer head you\'ve brought in.%SPEECH_ON%That is quite the sight, mercenary. I\'m happy you have brought it to me.%SPEECH_OFF%He leans back.%SPEECH_ON%Leave it on my desk. Maybe I can scare the children with it. The little gits are getting too used to fineries methinks.%SPEECH_OFF%He snaps his fingers and a servant comes to give you %reward% crowns. | You bring the Nachzehrer head to %employer% who stares at it for a long time.%SPEECH_ON%That reminds me of someone. I can\'t quite put my finger on it, and I\'m not sure I should. Excuse me, sellsword, I borrow your time without paying for it. Servant, give this man his money!%SPEECH_OFF%You are rewarded as promised. | %employer% takes the Nachzehrer head and holds it up. A few mewling cats seemingly appear out of nowhere, circling beneath it like buzzards would overhead. He throws it out the window and the felines go running.%SPEECH_ON%Good work, sellsword. %reward% crowns, as promised.%SPEECH_OFF% | You put a Nachzehrer head on %employer%\'s table. He looks up from a dinner plate, glances at the head, then at you.%SPEECH_ON%I was eating, sellsword.%SPEECH_OFF%The silverware clatters as the disgusted man shoves the plate aside. A servant whisks the food away, probably to try and eat it himself. %employer% takes a satchel out and puts it on the table.%SPEECH_ON%%reward_completion% crowns as was promised.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "A successful hunt.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Rid the town of nachzehrers");
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
			ID = "Success4",
			Title = "On your return...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{You enter %employer%\'s office carrying the dead spider on your back. The man screams and his chair squalls as it flings back across the floor. He jumps to his feet and draws a butterknife off his desk. You throw the dead webknecht from your shoulder and it clatters on its back. The townsman slowly comes forward. He sheathes the butterknife in a loaf of bread and shakes his head.%SPEECH_ON%By the old gods, you nearly gave me a heart attack.%SPEECH_OFF%Nodding, you tell the man it required more than a big boot to squash these beasts. He nods back.%SPEECH_ON%Of course, sellsword, of course! Your payment of %reward_completion% crowns is right there in the corner. And, please, take that ungodly thing with you when you leave.%SPEECH_OFF% | Cats hiss and flee the second you step into %employer%\'s room. A few dogs, always the sort for a mystery, run about your legs and sniff the spider carcass, their noses crinkling and pulling away but always coming back for more. The townsman is writing notes and he can hardly believe his eyes. He sets his quill pen down.%SPEECH_ON%Is that a giant spider?%SPEECH_OFF%You nod. He smiles and picks his quill pen back up.%SPEECH_ON%Perhaps I should have suggested you bring a very big shoe. Your payment of %reward_completion% crowns is there in the satchel. Go on, take it. It\'s all there. And you can leave the corpse. I\'d like to get a closer look at the creature.%SPEECH_OFF% | %employer% is hosting a birthday party when you enter his room with a giant dead spider and fling the corpse across the floor. Its bristly hairs hiss as they scratch across the stone and its eight legs scuttle upside down like some furniture of horror and it strays sideways and pops off the corner of a bookshelf and flips onto its toes and prongs there as though ready to pounce. Chaos breaks out as everyone screams and runs out the door or bails from the nearest open window, a litter of colorful confetti playfully twirling in their wake. The townsman stands alone amongst the emptied space and purses his lips.%SPEECH_ON%Truly, sellsword, was that necessary?%SPEECH_OFF%You nod and tell him that hiring you was necessary and that paying you will still be very necessary. The man shakes his head and gestures with a fake donkey tail to the corner of the room.%SPEECH_ON%Your satchel\'s over there with %reward_completion% crowns, as agreed upon. Now get that awful thing out of here and tell those fine folks the reveries need not be over.%SPEECH_OFF% | You don\'t think you can fit the spider corpse into %employer%\'s room, so instead you slap it against his window from the outside. You hear a horrified scream and the clatter of falling furniture. A moment later the adjacent window is thrown open. The townsman leans out.%SPEECH_ON%Oh very rich, sellsword, very rich! May the old gods serve you a thousand years of idle time for that one!%SPEECH_OFF%Nodding, you ask about your pay. He begrudgingly tosses you a satchel.%SPEECH_ON%%reward_completion% crowns is in there. Now take that awful thing and go!%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "A successful hunt.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Rid the town of webknechts");
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
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_helpful = [];
		local candidates_bro1 = [];
		local candidates_bro2 = [];
		local helpful;
		local bro1;
		local bro2;

		foreach( bro in brothers )
		{
			if (bro.getBackground().isLowborn() && !bro.getBackground().isOffendedByViolence() && !bro.getSkills().hasSkill("trait.bright") && bro.getBackground().getID() != "background.hunter")
			{
				candidates_helpful.push(bro);
			}

			if (!bro.getSkills().hasSkill("trait.player"))
			{
				candidates_bro1.push(bro);

				if (!bro.getBackground().isOffendedByViolence() && bro.getBackground().isCombatBackground())
				{
					candidates_bro2.push(bro);
				}
			}
		}

		if (candidates_helpful.len() != 0)
		{
			helpful = candidates_helpful[this.Math.rand(0, candidates_helpful.len() - 1)];
		}
		else
		{
			helpful = brothers[this.Math.rand(0, brothers.len() - 1)];
		}

		if (candidates_bro1.len() != 0)
		{
			bro1 = candidates_bro1[this.Math.rand(0, candidates_bro1.len() - 1)];
		}
		else
		{
			bro1 = brothers[this.Math.rand(0, brothers.len() - 1)];
		}

		if (candidates_bro2.len() > 1)
		{
			do
			{
				bro2 = candidates_bro2[this.Math.rand(0, candidates_bro2.len() - 1)];
			}
			while (bro2.getID() == bro1.getID());
		}
		else if (brothers.len() > 1)
		{
			do
			{
				bro2 = brothers[this.Math.rand(0, brothers.len() - 1)];
			}
			while (bro2.getID() == bro1.getID());
		}
		else
		{
			bro2 = bro1;
		}

		_vars.push([
			"helpfulbrother",
			helpful.getName()
		]);
		_vars.push([
			"bro1",
			bro1.getName()
		]);
		_vars.push([
			"bro2",
			bro2.getName()
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
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/disappearing_villagers_situation"));
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


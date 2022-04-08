this.strange_scribe_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Dude = null,
		Minstrel = null,
		Killer = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.strange_scribe";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_31.png[/img]{While in %townname%, you are approached by a person you had seen around one of the noblemen in the area. He is wearing a black cloak and he keeps his face deep in the cowl. He is the definition of suspicious. Naturally, %anatomist% the anatomist sets his eyes on him as though he were one of his objects of scientific observation. The man bows.%SPEECH_ON%I have come with great respect for the work you do, %anatomist%. We have read many of your texts.%SPEECH_OFF%You put a hand on your sword and wait to see where this is going. The man continues.%SPEECH_ON%We would like to invite you for a meal and to discuss matters of bodily import a little more...deeply.%SPEECH_OFF%Stepping between the men, you ask who this \'we\' is. The man states that he is with a group of scribes and scholars who study matters of the human body, as well as the bodies who have comported themselves well to the nature of their bestial tasks, which is to say they study the world\'s monsters.%SPEECH_ON%We, of course, have a particular interest in the beasts which are man himself...after he has lost what he himself is.%SPEECH_OFF%With so much intrigue flitting about, you\'re not surprised that the anatomist wishes to go with the strange scribe.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I\'m going with you.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				},
				{
					Text = "This is far too suspicious.",
					function getResult( _event )
					{
						return "G";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Minstrel != null)
				{
					this.Options.push({
						Text = "Does %minstrel% the minstrel know something?",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.Killer != null)
				{
					this.Options.push({
						Text = "Wait, where is our resident murderer %killer%?",
						function getResult( _event )
						{
							return "F";
						}

					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_31.png[/img]{If %anatomist% is going anywhere in this town, he sure as shit isn\'t going alone. You tag along, your hand never leaving your sword. The strange man invites you to a beautiful stone house, candlelight beaming from every window. Inside, you are quickly ushered to what should be a dinner table, but instead find slabbed across it a pale man whose skin is barely hanging on. The strange scribe bows like a chef who has delivered his finest meal.%SPEECH_ON%We believe this is a wiederganger, a man who hath died yet walks again.%SPEECH_OFF%The strange scribe rolls up his sleeve and holds it over the decrepit corpse. Its maw suddenly juts left to right, the jaw unhinged, its white eyes rolling. %anatomist% merely leans back and mentions that it is \'interesting.\' The two men begin to talk, while you nervously finger the hilt of your sword in case this \'wiederganger\' takes an interest in escaping. When the two are finished, %anatomist% and the scribe take out quill pens and put their signatures in each other\'s tomes, all the while congratulating each other on their work.\n\nThe whole affair has you cringing, and you notice what looks like a bead of sweat on the wiederganger\'s brow, but before you can comment you are ushered out from the home. Whatever they discussed, the anatomist is renewed with energy. He speaks gingerly.%SPEECH_ON%The creature was a fraud, of course, don\'t think I did not notice that. However, this has given me plenty insight into the inventive depths of the locals. There\'s something to be preened from such creativity, being that one\'s imagination draws surreptitiously from the sublime and real, and makes inferences on what it intuits yet knows not how to describe with scientific distinction. Even in the mire and fog of regional superstition and legerdemain I can make great advances.%SPEECH_OFF%Well, alright. You mention that you knew it was a fraud because the supposedly dead cretin was sweating. The anatomist nods, and says you might not have an eye for diagnostic inquiry, but the street smarts are well enough for perspicuous scrying. You simply nod, hoping he meant well by whatever that means.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s get out of here.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.improveMood(0.75, "Learned how to better deal with the laity");

				if (_event.m.Anatomist.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				local fatigueBoost = this.Math.rand(1, 3);
				_event.m.Anatomist.getBaseProperties().Stamina += fatigueBoost;
				_event.m.Anatomist.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/fatigue.png",
					text = _event.m.Anatomist.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + fatigueBoost + "[/color] Fatigue"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_97.png[/img]{You agree to let the anatomist go, but you\'re coming along. This draws the attention of the strange scribe. He seems reluctant about the matter now, having lost the energy which he had in his initial invitations. As you round a corner, he makes a sharp birdlike call, and a few men step out and you draw your sword and push %anatomist% back. One makes an attempt to attack. You\'re not in much fighting shape these days, but with a quick parry you knock him back and dissuade him of further attack. The scribe and his minions then depart in a hurry, saying you\'re not worth it. %anatomist% looks disappointed.%SPEECH_ON%Ah, I see. So it was a scam, an endeavor that was as creative as it was criminal.%SPEECH_OFF%Looking around, you realize that your coinpurse is gone. You look over just in time to see a child holding it, then throwing it skyward to be caught by another child hanging on some gutters. %anatomist% stands beside you, looking up, fascinated by the engineering effort put in by the scamps.%SPEECH_ON%It seems where one offender fails, another may take his place. So it is that by attrition the criminals may succeed. Interesting.%SPEECH_OFF%The anatomist suddenly realizes he also is a bit light on the hip and sees that his purse, too, has been yoinked. You look past him to see yet another child running off like a rat with its cheese. Another child runs past and tries to pickpocket you when there\'s nothing left to steal. Angered by his empty hands, the boy yells back.%SPEECH_ON%Get a job!%SPEECH_OFF%Sighing, you say it\'s probably time to head back to the company.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Damn scamps.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-175);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]175[/color] Crowns"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_51.png[/img]{You agree to let %anatomist% and the strange scribe talk, but before you can even head down the street %minstrel% the minstrel steps forth, grinning and pointing.%SPEECH_ON%%fakescribe%! What in the hells are you doing these days? This some new scam you\'ve got up your sleeve, huh?%SPEECH_OFF%The strange scribe clears his throat. He throws his hands out, and clears his throat again, he seems ready to speak deeply to some subject, but then sighs and throws back his cloak. A youngish and not at all scholarly looking fellow is revealed. He shakes his head.%SPEECH_ON%Life\'s been rough in the big city, %minstrel%. How are you doing?%SPEECH_OFF%The two chat for a time while you and %anatomist% look on bewildered. Eventually, the two minstrels turn to you, %minstrel% leading the way.%SPEECH_ON%Captain, this is %fakescribe%. He\'s on hard times out here in %townname%. What say he come along into the %companyname%? He\'s a lot like me, a shitass fighter, but a man of spunk, of moxy, a man who has what it takes if merely given the time to find it, especially if there\'s a woman involved.%SPEECH_OFF%%fakescribe% shakes his head.%SPEECH_ON%Ehem, ehh, with them I never, uh, find it.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Sure, he can come along.",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "We have no need of yet another charlatan.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"minstrel_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "{%name% was found deploying his minstrel talents in street scamming. Vouched for by a fellow minstrel, he joined the %companyname% to seek out a life on the road. Hopefully the charlatan-turned-sellsword will be able to \'fake it til he makes it\', as he likes to say a little too often.}";
				_event.m.Dude.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Minstrel.getImagePath());
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_51.png[/img]{You take the minstrel along free of any hiring charges. %anatomist% the anatomist looks a little sullen about the whole affair, saying that he longs for rare knowledge, yet all this world seems to have on offer are scams and falsities. Smiling, you tell him to consider this street knowledge. He smiles as well.%SPEECH_ON%Yes, perhaps I should acquire more of these...street smarts.%SPEECH_OFF%No, street knowledge. \'Street smarts\' sounds ridiculous.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Get it together, %anatomist%.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_12.png[/img]{You agree to let the anatomist and strange scribe have their conversations, yourself tagging along. The man takes you to the head of an alleyway which is considerably suspicious. He turns around with a wild grin on his face and he slowly starts to unsheathe a dagger from his sleeve, and then suddenly a knife stabs through his face, a glimmer of steel winking in his mouth. As he gargles, another knife comes in and cuts his throat in a quick slash. %killer%, the alleged killer on the run, appears from the alleyway.%SPEECH_ON%\'Ello captain and, eh, anatomist? Mortician? This \'ere fella was a murderer. And an encroacher, encroaching on my...uh...affairs.%SPEECH_OFF%He drops the body to the ground and starts stripping away the cloak to reveal that this supposed scribe was in fact well armed and armored. The killer cuts off one of the ears and pockets it, then nods.%SPEECH_ON%Hey, looks like we got some free gear, eh? We should probably hide the body though. This man puts up a great front of eminence and some may find his absence worth investigation.%SPEECH_OFF%You know not what or who to trust on the matter, but a dead body bleeding out all over your boots tends to look bad no matter the circumstances. You hide the body, after happily stripping it the gear from it, of course. %anatomist% seems leery of %killer%. He mentions that the killer on the run\'s tone of voice seemed to be one of immediately produced conjecture or, as the layman puts it, \'acting.\' Seeing as how what\'s done is done, you simply tell him to help carry the gear back to inventory.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "It is what it allegedly is.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(0.75, "Witnessed a brutal murder");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				local attackBoost = this.Math.rand(1, 3);
				local resolveBoost = this.Math.rand(1, 3);
				_event.m.Killer.getBaseProperties().MeleeSkill += attackBoost;
				_event.m.Killer.getBaseProperties().Bravery += resolveBoost;
				_event.m.Killer.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Killer.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + attackBoost + "[/color] Resolve"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Killer.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolveBoost + "[/color] Resolve"
				});
				local armors = [
					"armor/padded_leather",
					"armor/patched_mail_shirt",
					"armor/leather_lamellar"
				];
				local weapons = [
					"weapons/dagger",
					"weapons/dagger",
					"weapons/dagger",
					"weapons/rondel_dagger"
				];
				local armor = this.new("scripts/items/" + armors[this.Math.rand(0, armors.len() - 1)]);
				armor.setCondition(this.Math.max(1, armor.getConditionMax() * this.Math.rand(10, 40) * 0.01));
				this.World.Assets.getStash().add(armor);
				this.List.push({
					id = 10,
					icon = "ui/items/" + armor.getIcon(),
					text = "You gain " + armor.getName()
				});
				local weapon = this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]);
				weapon.setCondition(this.Math.max(1, weapon.getConditionMax() * this.Math.rand(10, 40) * 0.01));
				this.World.Assets.getStash().add(weapon);
				this.List.push({
					id = 10,
					icon = "ui/items/" + weapon.getIcon(),
					text = "You gain " + weapon.getName()
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Killer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_31.png[/img]{You say the situation is far too suspicious to risk. %anatomist% says that all knowledge seems suspicious to the laity. You tell him that this \'layman\' knows enough to smell a rat and that is that. The anatomist is upset, but you\'d rather he be agitated than dead.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Better wise up, wiseacre.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(1.0, "Was denied a research opportunity");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary() || t.getSize() < 2)
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomistCandidates = [];
		local minstrelCandidates = [];
		local killerCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomistCandidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.minstrel")
			{
				minstrelCandidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.killer_on_the_run")
			{
				killerCandidates.push(bro);
			}
		}

		if (minstrelCandidates.len() > 0)
		{
			this.m.Minstrel = minstrelCandidates[this.Math.rand(0, minstrelCandidates.len() - 1)];
		}

		if (killerCandidates.len() > 0)
		{
			this.m.Killer = killerCandidates[this.Math.rand(0, killerCandidates.len() - 1)];
		}

		if (anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getNameOnly()
		]);
		_vars.push([
			"minstrel",
			this.m.Minstrel != null ? this.m.Minstrel.getNameOnly() : ""
		]);
		_vars.push([
			"killer",
			this.m.Killer != null ? this.m.Killer.getName() : ""
		]);
		_vars.push([
			"fakescribe",
			this.m.Dude != null ? this.m.Dude.getNameOnly() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Dude = null;
		this.m.Minstrel = null;
		this.m.Killer = null;
		this.m.Town = null;
	}

});


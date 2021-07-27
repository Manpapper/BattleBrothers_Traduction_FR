this.graverobber_heist_event <- this.inherit("scripts/events/event", {
	m = {
		Graverobber = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.graverobber_heist";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%graverobber% the grimy graverobber enters your tent with his hands behind his back. You don\'t wish to delay what madness has been brought before you much longer, so you go ahead and ask what the man wants.%SPEECH_ON%Sir... I\'ve... I\'ve gotten word that a local baron - a wealthy man, indeed! - has been recently put to rest in a graveyard not far from here.%SPEECH_OFF%Leaning back in your chair, you give the man a shrug. He continues.%SPEECH_ON%I... I don\'t wish to ask the other men to help, for they look at me like some sort of horrid thing. But you... you\'re different. You hired me after all.%SPEECH_OFF%You lean forward, drawing your armor taught and the chair beneath you to a groaning wooden whine.%SPEECH_ON%Let me guess: you want me to help you dig up this baron\'s grave.%SPEECH_OFF%The man grins, a pathetic sight, one that reminds you of the time you scolded a dog for stealing a biscuit.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Uh, maybe some other time.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				},
				{
					Text = "I\'m not going to, and neither are you.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "I\'ll go get my shovel!",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_33.png[/img]Having excused yourself from the excavating expedition, you get back to work. Time flies, millmoths arcing in rote loops about a candle that droops lower and lower, its glassy flame so easily flicked to the wingbeats of the creatures about it. Finally, %graverobber% returns, heaving a bit of a chest into the tent. He looks more mud than man.%SPEECH_ON%I got it, sir!%SPEECH_OFF%The graverobber quickly looks behind himself, then says again, his voice a bit quieter this time.%SPEECH_ON%I got it... I got all of it. Look, I\'ll split it with you. I mean, you didn\'t help me avoid the watchman, or shovel up the earth, or drag the body out, or drag the chest out, or put the coffin back in its place, or put the dirt back on the coffin, or avoid the watchman a second time, or drag the chest all the way into camp... but you did let me do it!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "That\'s right.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
				local money = this.Math.rand(50, 150);
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Crowns"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_33.png[/img]Having excused yourself from the excavating expedition, you get back to work. Time flies, millmoths arcing in rote loops about a candle that droops lower and lower, its glassy flame so easily flicked to the wingbeats of the creatures about it. Finally, %graverobber% returns, the first sign of him the edge of your tent flap moving just so. You set your quillpen down and ask the man to enter. He does so, rather tentatively, as a man about to cross a threshold he\'d rather not. Even in the dim candlelight you can see the colors darkness is so ordinarily good at hiding: purples and blues and dark reds. He grins sheepishly.%SPEECH_ON%They, uh, caught me sir.%SPEECH_OFF%You nod.%SPEECH_ON%Yes, I can see that.%SPEECH_OFF%The man quickly raises a finger, a slop of mud flying waywardly into nowhere but a wet sound.%SPEECH_ON%But next time!%SPEECH_OFF%You stop the man with a raised hand.%SPEECH_ON%How about you go get patched up and then we\'ll talk about this \'next time\', yeah?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "And see that you don\'t fling anymore mud around on your way out.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());

				if (this.Math.rand(1, 100) <= 50)
				{
					local injury2 = _event.m.Graverobber.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury2.getIcon(),
						text = _event.m.Graverobber.getName() + " suffers " + injury2.getNameOnly()
					});
				}
				else
				{
					_event.m.Graverobber.addLightInjury();
					this.List.push({
						id = 10,
						icon = "ui/icons/days_wounded.png",
						text = _event.m.Graverobber.getName() + " suffers light wounds"
					});
				}

				_event.m.Graverobber.worsenMood(0.5, "Got beaten up in " + _event.m.Town.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Graverobber.getMoodState()],
					text = _event.m.Graverobber.getName() + this.Const.MoodStateEvent[_event.m.Graverobber.getMoodState()]
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img]%townname% is not the pillar upon which you wish to sacrifice your good standing in the world - or at least, what good standing a mercenary can have. You tell %graverobber% that not only will you not be accompanying him, but that you refuse to let him go off and do this alone. He pouts like a young hunter whose bow has been taken away by an angry father.%SPEECH_ON%Well... alright then... I suppose it was only riches...%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Get back to work.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
				_event.m.Graverobber.worsenMood(1.0, "Was forbidden to rob a grave");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Graverobber.getMoodState()],
					text = _event.m.Graverobber.getName() + this.Const.MoodStateEvent[_event.m.Graverobber.getMoodState()]
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_33.png[/img]You and %graverobber% stalk low through the bushes, a gangly duo of absurdity, silhouettes murky and ruminating of obvious hijinks even in the darkest of nights. The two of you enter the graveyard as though you were to happen about it by accident, merrily pretending that what is to unfold next would surely not come from two stranges such as yourselves.\n\n About the graveyard are rows and rows of gray slabs and marbled statues with no faces and black iron gates that hee-hawed in the wind. Tall grass everywhere, fertilizer in abundance. Flowers homegrown and others laid down from elsewhere, and some a bit of both.\n\nPursing his lips, the graverobber turns about. He stabs his shovel into the ground and puts his fists to his hips.%SPEECH_ON%Goddammit.%SPEECH_OFF%Sensing something off, you ask what\'s wrong. He spits and answers.%SPEECH_ON%I can\'t \'member if it is that grave, that one, or that one.%SPEECH_OFF%He points to three different sites: one is a modest little stone, bleached and balded to commemorate a death; another is gated with gothic spires; another is but a door to a mausoleum. The graverobber turns to you.%SPEECH_ON%We probably don\'t have much time here, which grave you think it be?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We\'ll dig up the motley grave.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 66)
						{
							return "F";
						}
						else
						{
							return "I";
						}
					}

				},
				{
					Text = "We\'ll break past the gothic fence.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 66)
						{
							return "G";
						}
						else
						{
							return "I";
						}
					}

				},
				{
					Text = "We\'ll break into the mausoleum.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 66)
						{
							return "H";
						}
						else
						{
							return "I";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_33.png[/img]You and %graverobber% stalk low through the bushes, a gangly duo of absurdity, silhouettes murky and ruminating of obvious hijinks even in the darkest of nights. The two of you enter the graveyard as though you were to happen about it by accident, merrily pretending that what is to unfold next would surely not come from two stranges such as yourselves.\n\n About the graveyard are rows and rows of gray slabs and marbled statues with no faces and black iron gates that hee-hawed in the wind. Tall grass everywhere, fertilizer in abundance. Flowers homegrown and others laid down from elsewhere, and some a bit of both.\n\nPursing his lips, the graverobber turns about. He stabs his shovel into the ground and puts his fists to his hips.%SPEECH_ON%Goddammit.%SPEECH_OFF%Sensing something off, you ask what\'s wrong. He spits and answers.%SPEECH_ON%I can\'t \'member if it is that grave, that one, or that one.%SPEECH_OFF%He points to three different sites: one is a modest little stone, bleached and balded to commemorate a death; another is gated with gothic spires; another is but a door to a mausoleum. The graverobber turns to you.%SPEECH_ON%We probably don\'t have much time here, which grave you think it be?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "All for naught.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
				_event.m.Graverobber.worsenMood(0.5, "Had no success robbing a grave with you");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Graverobber.getMoodState()],
					text = _event.m.Graverobber.getName() + this.Const.MoodStateEvent[_event.m.Graverobber.getMoodState()]
				});
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_33.png[/img]With a swift crack of your spade, the gothic gate is broken open. The twang of metal on metal is sent grumbling between the gravestones and swaying tree branches seem to snicker at your rather loud trespass. When you swing the gate open, the hinges squall as if they themselves were awakened spirits. You enter the little square plot and lean against the spires of the fence. A short order gets %graverobber% to work while you keep a look out like a man unimpressed by the nature of his own crimes. Some minutes of scrupulous shoveling later and the robber of graves is finished. What ends up being found is a very large coffin that has no hopes of being dragged out of the ground, not with just two men anyway.\n\n Using the same manner with which you dealt the gate a blow, you break the latches off the casket and throw it open. A freshly-dead man stares back up at you, two stones painted with eyes rolling away from his sockets. The sight startles you, but you quickly start rifling through the dead man\'s baggage. As it turns out, %graverobber% was right: the man was buried with great satchels of gold and goblets and golden goblets. You take it all, close the casket, and sneak back out of the graveyard.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Treasures!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
				local money = this.Math.rand(200, 500);
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You gain [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Crowns"
					}
				];
				_event.m.Graverobber.improveMood(1.0, "Found treasure while robbing a grave");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Graverobber.getMoodState()],
					text = _event.m.Graverobber.getName() + this.Const.MoodStateEvent[_event.m.Graverobber.getMoodState()]
				});
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_33.png[/img]You enter the mausoleum like a man fearful that the door behind him might forever snap closed. The coffin rests on a slab of marble with candles burning about its four corners. While there was no wind outside, you can\'t help but hear a faint moan of it circling about the room. Shaking away your fears, you and %graverobber% push the casket\'s lid off, careful not to let it drop off the otherside and presumably wake half the town.\n\n Inside the sarcophagus, you find a man attired in a knight\'s clothing: a helmet, chest plate, and shield. His sword crosses his body from neck to groin, his hands clasped around the handle in a battle-ready embrace. You look to %graverobber% who shrugs.%SPEECH_ON%Suppose this fella was a knight.%SPEECH_OFF%You nod. The graverobber glances from dead man to living.%SPEECH_ON%Suppose... this knight don\'t need that stuff no more...%SPEECH_OFF%Seeing as how you don\'t plan to leave empty handed, you nod again. The dead knight puts up quite the fight as %graverobber% struggles to free him of that which he no longer needs. After a few minutes of battle, you lend a hand in removing the helmet. What falls out is a great bundle of blonde hair. %graverobber% steps back.%SPEECH_ON%That\'s a woman!%SPEECH_OFF%Suddenly, voices rise up from outside the graveyard. You grab all the things you can and tell the graverobber to start running.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Treasures!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
				local item;
				local r = this.Math.rand(1, 3);

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/arming_sword");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/helmets/decayed_full_helm");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/armor/decayed_coat_of_plates");
				}

				item.setCondition(item.getCondition() / 2);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				_event.m.Graverobber.improveMood(1.0, "Found treasure while robbing a grave");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Graverobber.getMoodState()],
					text = _event.m.Graverobber.getName() + this.Const.MoodStateEvent[_event.m.Graverobber.getMoodState()]
				});
			}

		});
		this.m.Screens.push({
			ID = "I",
			Text = "[img]gfx/ui/events/event_33.png[/img]Just as you take your shovel into hand, a man\'s voice calls out to you.%SPEECH_ON%Just what in the hell do you think y\'all are doing?%SPEECH_OFF%You wheel around to see a man lighting a lantern. He holds it up, the handle creaking as it swivels back and forth.%SPEECH_ON%Y\'all look like graverobbers to me.%SPEECH_OFF%%graverobber% unsheathes a knife from his belt. The watchman unsheathes a bell from his own belt, a large, rotund instrument that glistens gold on the side of the lantern\'s light and white on the side of the moon\'s.%SPEECH_ON%Come after me ye may, but not before I give this here bell a good ringing. Then the next bell you\'ll hear shall toll for thee.%SPEECH_OFF%You grab %graverobber% by the collar and tell him to leave. There\'s no sense in causing trouble. The watchman barks at you as you depart.%SPEECH_ON%I\'ll remember yer faces! Like a kicked dog knows the boot that done did it, I\'ll remember yer faces!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Embarrassing.",
					function getResult( _event )
					{
						this.World.FactionManager.getFaction(_event.m.Town.getFactions()[0]).addPlayerRelation(this.Const.World.Assets.RelationOffense, "You and your men attempted to rob a local grave");
						this.World.Assets.addMoralReputation(-1);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
				_event.m.Graverobber.worsenMood(0.5, "Was caught trying to rob a grave");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Graverobber.getMoodState()],
					text = _event.m.Graverobber.getName() + this.Const.MoodStateEvent[_event.m.Graverobber.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_graverobber = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.graverobber")
			{
				candidates_graverobber.push(bro);
			}
		}

		if (candidates_graverobber.len() == 0)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getSize() >= 2 && t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
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

		this.m.Town = town;
		this.m.Graverobber = candidates_graverobber[this.Math.rand(0, candidates_graverobber.len() - 1)];
		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"graverobber",
			this.m.Graverobber.getName()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Graverobber = null;
		this.m.Town = null;
	}

});


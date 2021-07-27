this.melon_thief_event <- this.inherit("scripts/events/event", {
	m = {
		Other = null,
		Dude = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.melon_thief";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_43.png[/img]You eye a large group of screaming villagers. They\'re drunkenly carrying a felled tree like a throng of ants would a beetle. There\'s a blindfolded and shackled man astride the wood. As the crowd draws near, the pungency of alcohol emanates from the mob like miasma from a particularly angry swamp.\n\n %otherbro% asks the riffraff where they\'re off to. A bearded stooge swerves forward, braking on a heel and toe tip at the same time like an unpracticed puppet.%SPEECH_ON%Oy! We off to tar and feather this, this, uh...%SPEECH_OFF%Someone yells out \'fruit philanderer!\' from the crowd. The stooge snaps his fingers.%SPEECH_ON%Right! This melon mugger is getting what\'s, er, coming... to him.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "A melon thief?",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Yeah, this is very much not our business.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_43.png[/img]The stooge sways on his feet. There\'s enough beer foam in his beard to get a wench drunk. He points forward.%SPEECH_ON%Thas... that\'s right! Mugged a melon right-oh, but not just any ord\'nary thief! Naw, he corked it something fierce! We found the raw sewage of his work all about him when we\'d caught up to his doings! And by raw sewage I mean his cock\'s ill-measured spillage!%SPEECH_OFF%Hardly catching any of that, you ask the man to explain - slowly this time. He throws his hands up as though you\'re an idiot.%SPEECH_ON%What\'s all this talk? You hump a melon and thass that! Such fornications are, well, thass... thass beyond ordinary appeals to justice! Now out of our way, stranger, we\'ve feathers to collect and then to redistribute by means of a bonafide tarrin\' and a featherin\' and mayhaps a little more tarrin\' if we got us some left!%SPEECH_OFF%The crowd cheers to this.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What say you, Melon Man?",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Fornicating fruit? %otherbro%, tar this fool!",
					function getResult( _event )
					{
						return "H";
					}

				},
				{
					Text = "Okay. Not our business.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_43.png[/img]You ask the man atop the tree what he has to say, if anything. He shrugs and speaks.%SPEECH_ON%Look, what happens between a man and a melon is their business and their business alone. No harm, no foul.%SPEECH_OFF%The stooge cracks the man with a stick.%SPEECH_ON%Naw, you tell this fella straight, tell \'im what ya did!%SPEECH_OFF%Sighing, the melon man nods.%SPEECH_ON%Well alright then, if that\'s the end of them negotiations, and things being what they is with me up here and the smell of tar in the air, I\'ll speak truthfully to the matter at hand. I fucked that melon and I enjoyed myself.%SPEECH_OFF%The crowd hisses and boos as your men laugh amongst themselves.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We can\'t let you tar this man.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "Fornicating fruit? %otherbro%, go help tar this fool!",
					function getResult( _event )
					{
						return "H";
					}

				},
				{
					Text = "Okay. Not our business.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_43.png[/img]You grab the stooge.%SPEECH_ON%Let this man go.%SPEECH_OFF%The man asks if you\'re really defending this fruit farker. You nod and tell him that adultery with a melon, while disgusting and confusing, is ultimately a harmless endeavor. A drunken peasant thumbs over his shoulder.%SPEECH_ON%Sss\'what? Juss last week we took ol\' Bentley behind the shed for breaking that poor duck\'s neck.%SPEECH_OFF%The man\'s face frowns and he drowns the rest of his drink. He mutters something about really missing that duck. Perhaps not making yourself clear, and tiring of these idiots\' hijinks, you draw your sword and cut the melon mugger free. You turn the sword toward the crowd and they quickly disperse in a drunken retreat, fanning out beside the road, randomly scattering to get from whence they came like a bunch of rocks skipped over a wavy lake.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Git you idiots, git!",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_43.png[/img]The \'melon mugger\' comes to you. He fixes up his drawers with a bit of rope and bindings.%SPEECH_ON%So, uh, seeing as how you spared me that awful fate, what say I try and pay you back? I\'m tired of this town anyhow.%SPEECH_OFF%You tell him that sellswording is not an enviable vocation to take up on the fly. He points a snarky finger.%SPEECH_ON%Look, if you\'re worried I\'ll pork yer produce then I promise on me mother\'s grave that I will keep my shire-borer in its pants.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Very well. Welcome to the %companyname%!",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				},
				{
					Text = "No, we\'d rather not be double-checking our food every time we take a bite.",
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
					"thief_background"
				]);
				_event.m.Dude.setTitle("the Melon Mugger");
				_event.m.Dude.getSprite("head").setBrush("bust_head_03");
				_event.m.Dude.getBackground().m.RawDescription = "%name% is just a regular melon thief - is what you tell people who ask.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.improveMood(1.0, "Satisfied his needs with a melon");
				_event.m.Dude.worsenMood(0.5, "Almost got tarred and feathered");

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_43.png[/img]%otherbro% nods.%SPEECH_ON%With pleasure! Out of the way peasantry, let a real man get some work done here.%SPEECH_OFF%The sellsword picks up the \'pitch bucket\' and hurls it completely over the fruit fornicator. The man screams as the hot liquids sizzle and a rather potent order wisps into a smoky air. You watch as %otherbro% grabs a few naked chickens - not their feathers, just the chickens themselves - and starts beating the melon mugger with them like an angry frock swinging chained censers. The tarred man hollers out, partly in pain, partly confused. The crowd, also confused, reluctantly cheers. When he\'s finished, %otherbro% drops the chickens, which are but a slop of drooping meat and tar at this point. He wipes his forehead.%SPEECH_ON%Hell yeah, sir.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I don\'t quite think he gets it, but that works.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				_event.m.Other.improveMood(0.5, "Has dealt out just punishment");

				if (_event.m.Other.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Other.getMoodState()],
						text = _event.m.Other.getName() + this.Const.MoodStateEvent[_event.m.Other.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (!t.isMilitary() && !t.isSouthern() && t.getSize() <= 1 && t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
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
		local candidates = [];

		foreach( b in brothers )
		{
			candidates.push(b);
		}

		this.m.Other = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"otherbro",
			this.m.Other != null ? this.m.Other.getName() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Other = null;
		this.m.Dude = null;
		this.m.Town = null;
	}

});


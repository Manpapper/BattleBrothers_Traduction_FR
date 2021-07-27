this.fell_down_well_event <- this.inherit("scripts/events/event", {
	m = {
		Strong = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.fell_down_well";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 150.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_91.png[/img]A woman jumps out of the treeline beside the path.%SPEECH_ON%Oh thank the gods, my prayers have been answered! Please, come quick! My grandpap has fallen down the well!%SPEECH_OFF%She turns and hurries away as though you\'ve already agreed to help her. %otherbrother% glances at you and shrugs.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "I guess we can help her.",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "Good";
						}
						else
						{
							return "Bad";
						}
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Strong != null)
				{
					this.Options.push({
						Text = "%strongbrother%, you\'re strong. Give her a hand.",
						function getResult( _event )
						{
							return "Strong";
						}

					});
				}

				this.Options.push({
					Text = "We have no time for this.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Good",
			Text = "[img]gfx/ui/events/event_91.png[/img]You decide it\'s worth your time and go and take a look. The old man was doing repairs on the wellhead, a wooden framework meant to cover its opening, when it broke apart and sent him plunging down. Staring into the well, you find the man staring back up. He gives a wave.%SPEECH_ON%Oy\' there, fellas. I\'m in a bit of a pickle. I\'m actually being pickled, now that I think about it...%SPEECH_OFF%Eh, right. %otherbrother% throws down a rope and the old man ties it around himself. You and the sellsword pull the woman\'s grandfather up and back onto dry land. He shakes your hand and thanks you cordially.%SPEECH_ON%Farkin\' hell, glad you came when you did, I was about to shit and piss like no other. Let me tell ya, this ain\'t my first time going down a well. Five years ago I\'d done it while repairing the wellhead, because the wellhead breaks often, you see. And it\'s not really a wellhead, we just call it that cause we\'re lazy. Back in my day we called it a... well, heh well, I actually done forgot. I guess a \'wellhead\' makes sense now, as I\'m not well in the head! Ho! Still got it. I was quite the charmer in my days, you see, and it\'s not often I get to put the practice in. M\'wife died ten years ago, and the one prior to her left me twenty winters ago! I say winters, because that\'s when she left me, in the winter. It was a brutal one and I had asked her to help chop the wood lest we all freeze. She said she wasn\'t doing that shit and taking care of the kids at the same time. I had kids with her as well as with the second wife. Five total. One died. Measles. Another disappeared, so he\'s probably dead. I try to be honest to myself about it, but you know, there\'s hope. If a random stranger can be found in the forest to save me in the nick of time, then maybe my son survived that battle with the greenskins. Ain\'t heard of him, though. I pray to the old gods and even that Davkul fella every now and again. Do you know of Davkul? I\'m not sure what to make of it. One time this man came by with a scar on his forehead, said he\'d show me the way of darkness. I said I see darkness everytime I nap. This scarred fella said one day I won\'t wake and I said good! Ha! So then this scarred bastard starts getting upset with me...%SPEECH_OFF%As he drones on, you look around for %otherbrother% only to find him stepping out of the woman\'s home, the lady herself carrying a bit of... obvious warmth on her face. You retrieve your sellsword and leave before the old man lops your head with the most longwinded and one-sided conversation ever.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nobody\'s ever there to save me.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(2);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				_event.m.Other.improveMood(2.0, "Got some loving");

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
		this.m.Screens.push({
			ID = "Bad",
			Text = "[img]gfx/ui/events/event_91.png[/img]The old man was doing repairs atop the wooden wellhead when it broke apart. Unfortunately, if you\'re standing atop a wellhead when it goes bust there\'s only one place to go: down. Very, very far down. As you look over the edge of the well, you can see the old man floating in a matter that is most unlively. %otherbrother% sidles up next to you and whispers, using a hand to keep his words from being heard.%SPEECH_ON%Uh, he\'s not moving.%SPEECH_OFF%An expertly observation, truly. You inform the lady of the man\'s passing. She purses her lips and asks that you remove the body anyway, explaning her reasoning rather succinctly.%SPEECH_ON%We can\'t be drinking his filth after all.%SPEECH_OFF%Fair enough. %otherbrother% manages to hook a rope-loop around the corpse and pull it up, its limbs dangling loosely like white washrags. He asks if she needs you to bury it, too. The woman wipes a tear and shakes her head.%SPEECH_ON%Nah. I\'ll bury that feller myself, weep over his grave tomorrow, and then get on with living.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Well, alright.",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(1);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Strong",
			Text = "[img]gfx/ui/events/event_91.png[/img]You decide it\'s worth your time and go and take a look. The wellhead, a wooden framework meant to cover its opening, has broken apart. Apparently, the old man was doing repairs atop it when this happened and so he plunged down into the well. He looks up at you.%SPEECH_ON%Oy\' there, fellas. I\'m in a bit of a pickle. I\'m actually being pickled now that I think about it...%SPEECH_OFF%Eh, right. %strongbrother% throws down a rope. The old man ties it around himself. You and the sellsword pull the woman\'s grandfather up and back onto dry land. He shakes your hand and thanks you cordially.%SPEECH_ON%Farkin\' hell, glad you came when you did, I was about to shit and piss like no other.%SPEECH_OFF%You talk with the old fella for a time, learning a lot about him. A while later, you realize %strongbrother% is nowhere in sight. Just as you think to start looking for him he steps out of the woman\'s home. She\'s glomming onto his muscles and being rather touchy feely.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Gonna be some strong lads roaming these part soon, no doubt...",
					function getResult( _event )
					{
						this.World.Assets.addMoralReputation(2);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Strong.getImagePath());
				_event.m.Strong.improveMood(2.0, "Got some loving");

				if (_event.m.Strong.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Strong.getMoodState()],
						text = _event.m.Strong.getName() + this.Const.MoodStateEvent[_event.m.Strong.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.SquareCoords.Y < this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_strong = [];
		local candidates_other = [];

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (b.getSkills().hasSkill("trait.strong"))
			{
				candidates_strong.push(b);
			}
			else
			{
				candidates_other.push(b);
			}
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];

		if (candidates_strong.len() != 0)
		{
			this.m.Strong = candidates_strong[this.Math.rand(0, candidates_strong.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"otherbrother",
			this.m.Other.getName()
		]);
		_vars.push([
			"strongbrother",
			this.m.Strong != null ? this.m.Strong.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Other = null;
		this.m.Strong = null;
	}

});


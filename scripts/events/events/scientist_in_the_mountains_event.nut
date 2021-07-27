this.scientist_in_the_mountains_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.scientist_in_the_mountains";
		this.m.Title = "In the mountains...";
		this.m.Cooldown = 150.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_42.png[/img]You come across an unexpected sight at the top of the mountain: a man sitting in a strange and wooden contraption, tilting it toward the edge of a deadly precipice. He\'s got a scarf over his eyes, pulling it down to talk.%SPEECH_ON%Ahoy, strangers. It appears you shall record history! For men governed the common horse to run faster than it knew how, I shall govern birds to... well, we can\'t ride birds, but I can, as you can see by this machine, simulate them. The shackles of space and time shall be lifted, much like these here wooden wings will lift me into the very skies!%SPEECH_OFF%This \'contraption\' comes with pedals, wooden spokes, and tarps of very thin and hastily stitched leather.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You need to stop this, you\'ll only kill yourself.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "That\'ll be interesting to watch.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "C" : "D";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_42.png[/img]You step forward and explain the reality of the situation.%SPEECH_ON%Good... sir. What bird takes flight from such great heights? Does not a bird simply propel itself upward with the thrust of its wings? You\'re going to throw yourself off this cliff in the hopes that your machine will work, knowing deep in your heart that it will not.%SPEECH_OFF%The haggard looking mountain scientist looks at his feet. He nods solemnly.%SPEECH_ON%It could use some tinkering, I suppose. You have an avian eye, good sir. And you also have my thanks. I shall tell people of your great wisdom!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "That\'s right, I am smart.",
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
			Text = "[img]gfx/ui/events/event_42.png[/img]{You step back and let the man take flight. He wraps his face in the scarf and sits into the seat of his machine. With a few long breaths, he pedals it forward. It promptly falls over the edge. The man is hurled through the leather wings like some sort of screaming bat. He spins through the device as it explodes down the rockwall in a torrent of wood and poor design. A moment later, you hear the faint din of his final landing spots. Spectacular! | The man pushes his machine off the edge, hopping into its seat at the last moment. They both tip over the precipice and there\'s a brief scream. But, against all odds, the man quickly reappears! His contraption flutters from side to side like some drunken butterfly, but he\'s in the air nonetheless.%SPEECH_ON%I did it, by the gods I did it! Look at me...%SPEECH_OFF%Suddenly, a shrieking falcon spears through one of his wings. The bird loops around for another strike, tearing apart the other wing. You wave your hands and try to scare the killer bird away.%SPEECH_ON%Hey, hey!%SPEECH_OFF%The machine totters and slowly starts to lose altitude. With the man pedaling harder to compensate, the spokes begin to break and a moment later the whole thing busts apart and you can only watch as the haggard scientist plummets to his doom. The falcon simply squats on the cliff face and watches its enemy die.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What a show!",
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
			Text = "[img]gfx/ui/events/event_42.png[/img]{Against better judgment, you let the man fly. He bundles his face in the scarf as though that\'ll save him of the soon to come hard landing. With a deep breath, he pushes his contraption off the edge and leaps in at the last moment as though he were joining his lover in a romantic suicide. The man and machine quickly disappear. You start to laugh when suddenly the man reappears. He\'s furiously pedaling his machine, the wings flapping hard. He sails around, looping this way and that, slowly getting higher and higher.%SPEECH_ON%I did it! By the gods, I did it! Look at how high I can go!%SPEECH_OFF%He shoots upward into the clouds, the rickety din of its wooden spokes whining away.%SPEECH_ON%Ohh, ohhhhh!%SPEECH_OFF%That\'s the last you see or hear of him. | The man pushes the machine off the edge and hops into the seat just as it totters over the edge. Screaming, the man climbs back up the contraption as it falls away. He leaps off the last tip of its poorly constructed wooden frame, propelling himself back to the precipice where he hangs on for dear life. You sprint over and drag him back up. His machine smashes into the ground far below, a soft din of predetermined destruction. Brushing himself off, the man nods at you.%SPEECH_ON%Thank you sir. I had a moment of clarity. What does a bird do? It doesn\'t take off from great heights, it takes off wherever it pleases! I shall rework the project! Thank you for saving my life, sir.%SPEECH_OFF%The way you see it, that went as well as it could have. The men are mightily entertained anyway.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Spectacular science.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 25)
					{
						bro.improveMood(1.0, "Felt entertained");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
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

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Mountains)
		{
			return;
		}

		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});


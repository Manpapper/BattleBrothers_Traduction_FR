this.minstrel_outsmarts_gambler_event <- this.inherit("scripts/events/event", {
	m = {
		Minstrel = null,
		Gambler = null
	},
	function create()
	{
		this.m.ID = "event.minstrel_outsmarts_gambler";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img] %gambler%, the man with a gambling problem, has apparently gone around camp asking men to play a game of horseshoes - with a few crowns on the line, of course. It appears that %minstrel%, the wily minstrel, has obliged him and taken the bet. He says he\'s pretty good at the game to which the gambler responds that he is the best. \n\n The two men heave horseshoes until their arms tire and the sun wanes. Nobody is the winner as the game can\'t move off of a tie. After another indecisive round, %minstrel% says he\'ll go for a double-or-nothing round if they go left-handed. %gambler% agrees. He goes first, throwing three horseshoes. The first two go haywire, but the third manages to spin around the ring. He grins as he wishes the minstrel good luck. %minstrel% nods and rolls up his sleeves. He sticks his tongue out and slims his eyes, lining up the shot. His feet do a little tap-dance and just before he throws he looks back and says,%SPEECH_ON%I should probably let you know that I *am* left-handed.%SPEECH_OFF%Without even looking forward, the minstrel lets loose his horseshoe. The throw is perfect, landing dead center about the stake, and the next two are tossed so quickly and so seamlessly that anybody watching erupts in hooting laughter. The gambler\'s mouth can only drop in disbelief.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cheeky little git.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Minstrel.getImagePath());
				this.Characters.push(_event.m.Gambler.getImagePath());
				_event.m.Minstrel.improveMood(1.0, "Has outsmarted " + _event.m.Gambler.getName());

				if (_event.m.Minstrel.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Minstrel.getMoodState()],
						text = _event.m.Minstrel.getName() + this.Const.MoodStateEvent[_event.m.Minstrel.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates_minstrel = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.minstrel")
			{
				candidates_minstrel.push(bro);
			}
		}

		if (candidates_minstrel.len() == 0)
		{
			return;
		}

		local candidates_gambler = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.gambler")
			{
				candidates_gambler.push(bro);
			}
		}

		if (candidates_gambler.len() == 0)
		{
			return;
		}

		this.m.Minstrel = candidates_minstrel[this.Math.rand(0, candidates_minstrel.len() - 1)];
		this.m.Gambler = candidates_gambler[this.Math.rand(0, candidates_gambler.len() - 1)];
		this.m.Score = (candidates_minstrel.len() + candidates_gambler.len()) * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"minstrel",
			this.m.Minstrel.getNameOnly()
		]);
		_vars.push([
			"gambler",
			this.m.Gambler.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Minstrel = null;
		this.m.Gambler = null;
	}

});


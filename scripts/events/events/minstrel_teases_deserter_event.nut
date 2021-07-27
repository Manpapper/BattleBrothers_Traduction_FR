this.minstrel_teases_deserter_event <- this.inherit("scripts/events/event", {
	m = {
		Minstrel = null,
		Deserter = null
	},
	function create()
	{
		this.m.ID = "event.minstrel_teases_deserter";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img] As the campfire crackles, %minstrel% the minstrel gets up and stands high on his stump. He beats his chest and then points to %deserter%.%SPEECH_ON%Yo, yee man of such fleeting feet, feet that flee before you\'ve been beat! The deserter! Oh, the deserter! A dessert for the deserter! His courage he did curdle, his honor he did hurdle, his manliness he did murder! The deserter!%SPEECH_OFF%In one swift motion the minstrel claps his hands and drops back down onto his seat. He\'s only there for a moment before %deserter%\'s hands are around his neck. The company is an uproar, stuck somewhere between separating the two and succumbing to fits of manic laughter.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "An epic for all the wrong reasons!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Minstrel.getImagePath());
				this.Characters.push(_event.m.Deserter.getImagePath());
				_event.m.Deserter.worsenMood(2.0, "Felt humiliated in front of the company");

				if (_event.m.Deserter.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Deserter.getMoodState()],
						text = _event.m.Deserter.getName() + this.Const.MoodStateEvent[_event.m.Deserter.getMoodState()]
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

		local candidates_deserter = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.deserter")
			{
				candidates_deserter.push(bro);
			}
		}

		if (candidates_deserter.len() == 0)
		{
			return;
		}

		this.m.Minstrel = candidates_minstrel[this.Math.rand(0, candidates_minstrel.len() - 1)];
		this.m.Deserter = candidates_deserter[this.Math.rand(0, candidates_deserter.len() - 1)];
		this.m.Score = (candidates_minstrel.len() + candidates_deserter.len()) * 5;
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
			"deserter",
			this.m.Deserter.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Minstrel = null;
		this.m.Deserter = null;
	}

});


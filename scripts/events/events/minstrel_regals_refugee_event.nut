this.minstrel_regals_refugee_event <- this.inherit("scripts/events/event", {
	m = {
		Minstrel = null,
		Refugee = null
	},
	function create()
	{
		this.m.ID = "event.minstrel_regals_refugee";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img] The company sits around a fire when %minstrel% the minstrel notices the refugee, %refugee%, sitting solemnly by himself. Within but a moment, the minstrel is on his feet, standing high on a stump, and waving his arms wide.%SPEECH_ON%Lo\', the town of %refugee% was small, its place quaint, and its food, well, a little on the \'eh\' side. But ho\'! Were its people big! For here sits amongst our company one of its kin, the world after his spirit, death on his heels, yet here he be, and we\'ve but only thanks - and crowns! - to offer him! Such is the price of his company, and such we are willing to give.%SPEECH_OFF%The minstrel sits back down and bows to the refugee. All of the %companyname% stands up and cheers, bringing a rare smile to %refugee%\'s face.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bravo!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Minstrel.getImagePath());
				this.Characters.push(_event.m.Refugee.getImagePath());
				_event.m.Refugee.improveMood(1.0, "Was regaled by " + _event.m.Minstrel.getName());

				if (_event.m.Refugee.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Refugee.getMoodState()],
						text = _event.m.Refugee.getName() + this.Const.MoodStateEvent[_event.m.Refugee.getMoodState()]
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

		local candidates_refugee = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.refugee")
			{
				candidates_refugee.push(bro);
			}
		}

		if (candidates_refugee.len() == 0)
		{
			return;
		}

		this.m.Minstrel = candidates_minstrel[this.Math.rand(0, candidates_minstrel.len() - 1)];
		this.m.Refugee = candidates_refugee[this.Math.rand(0, candidates_refugee.len() - 1)];
		this.m.Score = (candidates_minstrel.len() + candidates_refugee.len()) * 5;
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
			"refugee",
			this.m.Refugee.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Minstrel = null;
		this.m.Refugee = null;
	}

});


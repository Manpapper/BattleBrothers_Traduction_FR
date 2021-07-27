this.uber_courageous_event <- this.inherit("scripts/events/event", {
	m = {
		Juggernaut = null
	},
	function create()
	{
		this.m.ID = "event.uber_courageous";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_50.png[/img]%juggernaut% carries a brand of courage one part fearless, one part craziness. His urgency to throw himself against his enemies is inspirational, if no doubt foolish to a mind of reason and rationality. But this is the %companyname%, a band of men who are drawn to the simple life of sword and coin. %juggernaut%\'s indomitable nature in this struggle of kill or be killed has rubbed off on a few of the sellswords.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "This would be a mad world if all men were like him.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggernaut.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Juggernaut.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 75)
					{
						bro.improveMood(0.5, "Inspired by " + _event.m.Juggernaut.getName() + "\'s bravery");

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
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.fearless") && (bro.getSkills().hasSkill("trait.determined") || bro.getSkills().hasSkill("trait.deathwish")))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() < 1)
		{
			return;
		}

		this.m.Juggernaut = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"juggernaut",
			this.m.Juggernaut.getName()
		]);
	}

	function onClear()
	{
		this.m.Juggernaut = null;
	}

});


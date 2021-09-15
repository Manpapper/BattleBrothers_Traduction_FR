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
			Text = "[img]gfx/ui/events/event_50.png[/img]%juggernaut% porte une marque de courage à moitié intrépide et à moitié fou. Son empressement à se jeter sur ses ennemis est une source d\'inspiration, même s\'il est sans doute insensé pour un esprit de raison et de rationalité de faire cela. Mais c\'est %companyname%, un groupe d\'hommes attirés par la vie simple de l\'épée et de l\'argent La nature indomptable de %juggernaut% dans cette lutte pour tuer ou être tué a déteint sur quelques mercenaires.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ce serait un monde de fou si tous les hommes étaient comme lui.",
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
						bro.improveMood(0.5, "A été inspiré par la bravoure de " + _event.m.Juggernaut.getName());

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


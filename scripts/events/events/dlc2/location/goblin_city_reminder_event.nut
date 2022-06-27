this.goblin_city_reminder_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.goblin_city_reminder";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_119.png[/img]{Après avoir pris soins d\'autant de gobelins, il est probable que la nouvelle de leur mort et de leur extermination parvienne jusqu\'à la cité des peaux vertes. Si cet expert gobelin est aussi savant qu\'il le semble, les gobelins réagiront de manière excessive et enverront leurs armées, laissant les portes pratiquement sans défense. Il est peut-être temps de retourner à la cité des gobelins et de voir si les dires de l\'étranger sont vraies.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous devrions revenir.",
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
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.Flags.get("IsGoblinCityDestroyed"))
		{
			return;
		}

		if (this.World.Flags.get("IsGoblinCityOutposts") && this.World.Flags.get("GoblinCityCount") >= 5 || this.World.Flags.get("IsGoblinCityScouts") && this.World.Flags.get("GoblinCityCount") >= 10)
		{
			this.m.Score = 500;
		}
		else
		{
			return;
		}
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


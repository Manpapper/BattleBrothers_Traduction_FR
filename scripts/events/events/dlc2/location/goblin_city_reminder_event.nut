this.goblin_city_reminder_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.goblin_city_reminder";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_119.png[/img]{With so many goblins taken care of, it is likely that word of their deaths and annihilations will reach back to the greenskins\' city. If that goblin expert is as learned as he seems, the goblins will overreact and send their armies out, leaving the gates largely undefended. Perhaps it is time to return to the goblin city and see if the stranger\'s summations ring true.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We should return.",
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


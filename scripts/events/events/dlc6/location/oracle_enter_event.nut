this.oracle_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.oracle_enter";
		this.m.Title = "As you approach...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_152.png[/img]{Venturing into the vestibule of the ancient Oracle is like stepping into someone else\'s dream. Men and women listlessly shift around its pillars, the timid scratch of shoes across stone faintly filling the air, and day or night the architectural curvature brings a pale and somber shadow to its strange halls as though it were permitted eternity beneath the moon herself.\n\nPeople of all religions come to the Oracle with a shared sense of awe. Nobody knows which priestly being once dwelled there, nor what clerical colors they donned. Despite these mysteries, many believe that by sleeping inside the Oracle one can harness visions of their own future. An admirable faith to have, though you find it ironic these ethereal meanings must be sought by using the faithful\'s hands and feet to get there. For now, an impoverished and clustered tent city has glommed onto the Oracle\'s edges. It is a decrepit end for those who have so buoyed themselves to hope they\'ve made themselves refugees of reality.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Our fate will lead us here again in time.",
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


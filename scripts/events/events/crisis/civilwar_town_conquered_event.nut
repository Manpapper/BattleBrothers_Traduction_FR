this.civilwar_town_conquered_event <- this.inherit("scripts/events/event", {
	m = {
		News = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_town_conquered";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_45.png[/img]{News on the wind has it that %conqueror% has taken %city% from %defeated%! | Messengers on the road say that %conqueror% is the new ruler of %city%, having taken it from %defeated% after a gruesome battle. | Redraw the maps! Refugees, messengers, and traders on the road are reporting that %city% now belongs to %conqueror%!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "The board has changed.",
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
		if (!this.World.State.getPlayer().getTile().HasRoad)
		{
			return;
		}

		if (this.World.Statistics.hasNews("crisis_civilwar_town_conquered"))
		{
			this.m.Score = 2000;
		}
	}

	function onPrepare()
	{
		this.m.News = this.World.Statistics.popNews("crisis_civilwar_town_conquered");
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"conqueror",
			this.m.News.get("Conqueror")
		]);
		_vars.push([
			"defeated",
			this.m.News.get("Defeated")
		]);
		_vars.push([
			"city",
			this.m.News.get("City")
		]);
	}

	function onClear()
	{
		this.m.News = null;
	}

});


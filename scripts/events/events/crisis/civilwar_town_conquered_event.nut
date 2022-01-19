this.civilwar_town_conquered_event <- this.inherit("scripts/events/event", {
	m = {
		News = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_town_conquered";
		this.m.Title = "Sur le chemin...";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_45.png[/img]{Les nouvelles disent que %conqueror% a pris %city% à %defeated% ! | Les messagers sur la route disent que %conqueror% est le nouveau dirigeant de %city%, après l\'avoir pris à %defeated% après une horrible bataille. | Redessinez les cartes ! Des réfugiés, des messagers et des commerçants sur la route signalent que %city% appartient désormais à %conqueror% !}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Le tableau a changé.",
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


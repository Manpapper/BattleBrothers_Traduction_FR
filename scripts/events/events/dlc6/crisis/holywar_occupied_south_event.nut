this.holywar_occupied_south_event <- this.inherit("scripts/events/event", {
	m = {
		News = null
	},
	function create()
	{
		this.m.ID = "event.crisis.holywar_occupied_south";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_%image%.png[/img]{News is coming that the Gilded ones have conquered %holysite%. What they plan to do with it, who knows. Maybe put up a gold-plated fence to keep the northerners out? You\'re mostly concerned the fighting might be nearing an end, and with it all the sweet religious honey the %companyname% has been eating up. | The Gilder\'s gleam must be brighter than ever now: %holysite% has fallen under control of the southerners. Perhaps the Gilded folk will ask the %companyname% to help defend it, or maybe the old gods will need a bit of proper gumption in taking it back. Either way, the %companyname% is still on the catbird seat for fattening its purse.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "The fires of religious turmoil burn bright.",
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

		if (this.World.Statistics.hasNews("crisis_holywar_holysite_south"))
		{
			this.m.Score = 2000;
		}
	}

	function onPrepare()
	{
		this.m.News = this.World.Statistics.popNews("crisis_holywar_holysite_south");
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"holysite",
			this.m.News.get("Holysite")
		]);
		_vars.push([
			"image",
			this.m.News.get("Image")
		]);
	}

	function onClear()
	{
		this.m.News = null;
	}

});


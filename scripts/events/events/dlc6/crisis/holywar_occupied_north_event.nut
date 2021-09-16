this.holywar_occupied_north_event <- this.inherit("scripts/events/event", {
	m = {
		News = null
	},
	function create()
	{
		this.m.ID = "event.crisis.holywar_occupied_north";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_%image%.png[/img]{News travels fast with a bit of religious spurring: %holysite% has been taken by northern crusaders! | Crusaders from the north have taken %holysite%. You\'re not sure if this means the war is soon to be at an end. It would be a shame if that were the case as all this strife has made for such great opportunities. | %holysite% has fallen under the banner of northern crusaders! While the old gods no doubt rejoice, the followers of the Gilder will presumably seek to have it taken back. This may present opportunities for the %companyname%.}",
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

		if (this.World.Statistics.hasNews("crisis_holywar_holysite_north"))
		{
			this.m.Score = 2000;
		}
	}

	function onPrepare()
	{
		this.m.News = this.World.Statistics.popNews("crisis_holywar_holysite_north");
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


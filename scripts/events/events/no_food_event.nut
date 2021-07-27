this.no_food_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.no_food";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_52.png[/img]{Food stocks have run out! Despite the horrors of this world, the %companyname% can\'t be fielding a company of skeletons! You need to get the men food fast before they rightfully leave. | Even the most loyal of men is only as good as about five or six missed meals. After that, anyone is apt to leave and get themselves fed. Acquire food - and do it fast before the company falls apart! | You\'ve miscalculated the food reserves and placed the %companyname% into a unique danger - that of going hungry. Even the deadliest of companies would fall apart in days if it goes unfed and this company will be no different if you don\'t change things fast!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I need to get the men something to eat.",
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
		if (this.World.Assets.getFood() > 0)
		{
			return;
		}

		this.m.Score = 150;
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


this.lone_wolf_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.lone_wolf_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_137.png[/img]{You walk the stands of a jousting arena. Moldy fruits and vegetables litter the floor. Dried blood freckles the seats. And silence fills the air. When you sit, the wood of the place seems to groan in unison as though discomfited by the haunt of a rare visitor.\n\nIn your hands is a note. \'Looking fer hardy men, knowledge of the sword pref\'rred but all welcome.\' It is an old note, its purpose long since served. But what draws your eye is the price offered to the task: more crowns than you could muster in five tournaments.\n\n If this is the coin to be earned, then to hell with the jousts and the sparring. But you\'re not one to suit up for some other captain\'s orders. With all that you\'ve earned over the years you imagine you could start your own mercenary band just fine.}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "And that\'s what I\'ll do.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "The Lone Wolf";
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});


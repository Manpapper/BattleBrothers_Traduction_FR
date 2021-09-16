this.militia_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.militia_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_141.png[/img]{Hunt down bandits. Ward off raiders. Trap wolves attacking the farmsteads. All in a militiaman\'s work. And if more is asked then there is simply more to answer. All to keep your home of %home% safe.\n\n When a nobleman called on you, you and a group of ad hoc fighters took to the field in a battle between highborn. You didn\'t know their names or their quarry, only that one mustered you and your men to the field. And so there you went. Unfortunately, a lowborn man with spear and shield is little more than a peasant with misgivings of warriorship. Your militia was used to hold a contingent of enemy knights in place while your own side\'s archers rained hell from above, hitting knight and peasant alike.\n\n After the battle, you and your men fled the fields for good. You took up arms as sellswords and swore to one another by blood pact that you\'d never have a highborn in your company. A mercenary band of motley men and that is that.}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We are our own lords.",
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
		this.m.Title = "The Peasant Militia";
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"home",
			this.World.Flags.get("HomeVillage")
		]);
	}

	function onClear()
	{
	}

});


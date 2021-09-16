this.southern_quickstart_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.southern_quickstart_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_156.png[/img]{You could have stayed home. Never left town. Just lived out your days laboring for some Vizier. Instead, you took up the sword, scrounged what little money the Gilder had shone upon you, and started a band of mercenaries.\n\nLife as a Crownling has taken you places that most others never see. In a sense, you\'ve carved open doors and avenues through violence. But the years have slowly weighed down your neck with a nasty truth: you\'re barely a step above being a brigand. You get hired by locals to do simple things for simple pay and then sent on your way. You want the %companyname% to be bigger than that. You want your company shown to the Vizier\'s offices, you want it to gain the glory it deserves, and maybe you want it to even travel north to faraway lands. Hell, maybe in the north they treat a mercenary with respect!\n\nOf course, it won\'t be easy. You\'ve just a few men on hand. But those men are %bro1%, %bro2%, and %bro3%, the finest fighters you\'ve ever known. With them at your side, the whole world shall come to know the %companyname%!}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "The Gilder will reveal to us the way.",
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
		this.m.Title = "The " + this.World.Assets.getName();
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		_vars.push([
			"bro1",
			brothers[0].getName()
		]);
		_vars.push([
			"bro2",
			brothers[1].getName()
		]);
		_vars.push([
			"bro3",
			brothers[2].getName()
		]);
	}

	function onClear()
	{
	}

});


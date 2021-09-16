this.manhunters_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.manhunters_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_172.png[/img]{Constant conflict between nomads, city states, and vagabonds makes for good business: deserters, criminals, prisoners of war, and indebted alike flee across the land, and you with manacle in hand give chase.\n\nDespite the barren wastes upon which they rule, the Southern Realms are home to large and ever shifting populations which makes personhood itself a resource worth harvesting. The riverlike flow of persons is as natural an economy as any raw material.\n\nPrisoners of war make up the bulk of your outfit, beaten men who must submit to and fight for another force: your own. Criminals and general riff raff fill in here and there, easy pickings from smaller villages who don\'t have the means to handle their resident reprobates. And then there are the indebted... hellfire-doomed souls who must work their way back into the Gilder\'s gleam, and find salvation through blood, sweat, and tears. While most must work as laborers, you favor pressing them into your company. The indebted will not protest, for even the priests state it must be within the Gilder\'s sublime vision that they will find penitence in the %companyname%.}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Everyone can earn salvation by working off their debt to the Gilder.",
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
		this.m.Title = "The Manhunters";
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});


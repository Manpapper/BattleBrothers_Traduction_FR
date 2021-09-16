this.deserters_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.deserters_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_88.png[/img]{Long marches on old boots. Snow? Fight. Rain? Fight. Being charged by a line of heavy horse? Pick up that spear. Fight. Fight. Always fight. But even the simplicities gnawed. Ask for socks, get told to steal them from the peasants. Ask for a better meal, have your serving given to the ground.\n\n The ways of the soldier do not bother you. Killing does not bother you, nor does the threat of death. The disrespect of the nobles, the lack of responsibility by the lieutenants who \'bravely\' throw you to the meatgrinder, that is what saps the will. That and the boredom. The endless day after day after day tedium of nothingness.\n\n It is somewhat ironic that you and three other deserters abandoned the war camp on the day they did. A grand meal was given to the soldiers. A celebration of victory, they called it. Your plate was pushed to the rims with foodstuffs. Portions that belonged to the men who died that day. And you ate that food. You ate it right up. And then you picked up your bags, went on watch for the evening, and simply slipped away. For engineering the escape, three other deserters elected to follow your command.\n\n You\'d forge your own path as a sellsword where the pay would at least match the pain. But first, you\'ll have to make your way to other lands, for if you stay here for long, the noose will surely be where you meet your end.}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We\'ll take destiny in our own hands.",
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
		this.m.Title = "The Deserters";
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});


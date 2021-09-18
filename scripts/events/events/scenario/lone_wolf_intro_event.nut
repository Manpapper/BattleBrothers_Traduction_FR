this.lone_wolf_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.lone_wolf_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_137.png[/img]{Vous marchez sur les gradins d\'une arène de joute. Des fruits et légumes moisis jonchent le sol. Du sang séché tache les sièges. Et le silence emplit l\'air. Lorsque vous vous asseyez, le bois du lieu semble gémir à l\'unisson, comme s\'il était déconcerté par la présence d\'un rare visiteur.\n\nDans vos mains se trouve une note. \"Cherche hommes robustes, connaissance de l\'épée préférée mais tous bienvenus. C\'est une vieille note, dont le but est depuis longtemps atteint. Mais ce qui attire votre attention, c\'est le prix offert pour cette tâche : plus de couronnes que ce que vous pourriez rassembler en cinq tournois.\n\n Si c\'est l\'argent à gagner, alors au diable les joutes et les tournois. Mais vous n\'êtes pas du genre à suivre les ordres d\'un autre capitaine. Avec tout ce que vous avez gagné au fil des ans, vous imaginez que vous pourriez très bien monter votre propre groupe de mercenaires.}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Et c\'est ce que je vais faire.",
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


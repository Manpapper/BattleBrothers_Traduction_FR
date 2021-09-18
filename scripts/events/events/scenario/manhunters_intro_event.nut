this.manhunters_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.manhunters_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_172.png[/img]{Les conflits constants entre les nomades, les cités-États et les vagabonds sont source de bonnes affaires : les déserteurs, les criminels, les prisonniers de guerre et les endettés s\'enfuient à travers le pays, et c\'est vous, manille en main, qui les poursuivez. Malgré les terres arides sur lesquelles ils règnent, les royaumes du Sud abritent des populations importantes et en constante évolution, ce qui fait de la personne elle-même une ressource à exploiter. Le mouvement fluvial des personnes est une économie aussi naturelle que n\'importe quelle matière première.\n\nLes prisonniers de guerre constituent le gros de votre effectif, des hommes battus qui doivent se soumettre et se battre pour une autre force : la vôtre. Les criminels et la racaille en général sont présents ici et là, des proies faciles pour les petits villages qui n\'ont pas les moyens de gérer leurs réprouvés. Et puis il y a les endettés... des âmes condamnées par les flammes de l\'enfer qui doivent travailler pour retrouver le lustre de la Gildera, et trouver le salut dans le sang, la sueur et les larmes. Bien que la plupart doivent travailler comme ouvriers, vous préférez les intégrer dans votre compagnie. Les endettés ne protesteront pas, car même les prêtres affirment que c\'est dans le cadre de la vision sublime de Gilder qu\'ils trouveront pénitence dans %companyname%.}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tout le monde peut gagner le salut en travaillant pour rembourser sa dette au Gilder.",
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


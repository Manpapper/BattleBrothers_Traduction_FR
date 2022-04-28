this.holywar_occupied_south_event <- this.inherit("scripts/events/event", {
	m = {
		News = null
	},
	function create()
	{
		this.m.ID = "event.crisis.holywar_occupied_south";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_%image%.png[/img]{La nouvelle arrive que les dorés ont conquis la %holysite%. Ce qu\'ils prévoient d\'en faire, qui sait. Peut-être installer une barrière dorée pour empêcher les gens du nord d\'entrer ? Vous êtes surtout inquiets que les combats touchent à leur fin, et avec eux tout le doux miel religieux que %companyname% a mangé. | La lueur du Doreur doit être plus brillante que jamais maintenant : %holysite% est tombé sous le contrôle des sudistes. Peut-être que le peuple doré demandera au %companyname% d\'aider à le défendre, ou peut-être que les anciens dieux auront besoin d\'un peu de jugeote pour le reprendre. Quoi qu\'il en soit, %companyname% est toujours bien placé pour engraisser sa bourse.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Les feux de l\'agitation religieuse brûlent.",
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


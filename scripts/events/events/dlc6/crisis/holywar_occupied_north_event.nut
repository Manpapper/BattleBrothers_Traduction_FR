this.holywar_occupied_north_event <- this.inherit("scripts/events/event", {
	m = {
		News = null
	},
	function create()
	{
		this.m.ID = "event.crisis.holywar_occupied_north";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_%image%.png[/img]{Les nouvelles vont vite avec un peu d'élan religieux : %holysite% a été prise par les croisés du nord ! | Les croisés du nord ont pris %holysite%. Vous ne savez pas si cela signifie que la guerre est bientôt terminée. Il serait dommage que ce soit le cas, car toutes ces querelles ont créé de belles opportunités. | La %holysite% est tombée sous la bannière des croisés du Nord ! Alors que les anciens dieux se réjouissent sans doute, les adeptes du doreur chercheront sans doute à le récupérer. Cela peut présenter des opportunités pour le %companyname%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Les feux de l'agitation religieuse brûlent.",
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


this.holywar_flavor_north_outside_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.holywar_flavor_north_outside";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 20.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_95.png[/img]La ferme est une ruine fumante et ses occupants ont tous été décapités, sauf un. Un personnage malchanceux a été prostré sur le sol, les jambes écartées, et on lui a mis le feu à partir de ce qui semble être le ventre : sa poitrine est une ruine cendrée et cratérisée, et ses membres sont noircis et carbonisés, mais toujours squelettiques. Son visage est intact, peut-être à dessein, et d\'après son apparence, il n\'est pas mort d\'une manière que vous trouveriez convenable pour quiconque, pas même pour vos propres ennemis. | [img]gfx/ui/events/event_02.png[/img]Vous trouvez quelques soldats sudistes pendus à un arbre, les yeux depuis longtemps arrachés par les corbeaux et les pieds par les chasseurs de fortune. Ils se tortillent dans le vent et aucun des habitants ne semble pressé de les abattre. | [img]gfx/ui/events/event_60.png[/img]Un train de chariots est éparpillé des deux côtés d\'un chemin, le bois et les matériaux jonchent les champs à côté d\'eux. Tout ce qui a de la valeur a été pris, et le marchand a été tué jusqu\'au dernier. Les blessures indiquent des intentions méridionales, mais les gravures mortelles ne semblent pas aussi propres que ce que vous avez l\'habitude de voir. Cela pourrait très bien être le travail de voleurs utilisant la guerre sainte comme couverture. Quoi qu\'il en soit, il n\'y a plus rien de valeur et vous demandez aux hommes de continuer. | [img]gfx/ui/events/event_132.png[/img]Vous trouvez un champ de bataille, bien que votre arrivée soit bien trop tardive pour faire une apparition dramatique : les morts sont partout, au sud comme au nord, et les suturiers, les charognards et les vauriens ont déjà pillé la totalité des restes. A en juger par l\'apparence frêle d\'un gros tas de sudistes entassés en un seul endroit, et par la rapidité avec laquelle ils s\'en sont retirés, vous n\'avez guère de doute sur le fait que les Dorés ont jeté en avant leurs âmes endettées pour épargner le reste de la troupe.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "La guerre ne change jamais.",
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
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (!this.World.FactionManager.isHolyWar())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.SquareCoords.Y > this.World.getMapSize().Y * 0.7)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type == this.Const.World.TerrainType.Desert || currentTile.Type != this.Const.World.TerrainType.Oasis || currentTile.TacticalType == this.Const.World.TerrainTacticalType.DesertHills)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 5)
			{
				return;
			}
		}

		this.m.Score = 10;
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


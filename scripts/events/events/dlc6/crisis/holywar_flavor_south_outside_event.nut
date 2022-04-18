this.holywar_flavor_south_outside_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.holywar_flavor_south_outside";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 20.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_132.png[/img]Vous trouvez les restes désassemblés d'un champ de bataille : un amas d'objets inutilisables avec des cadavres si ratatinés qu'il est difficile de discerner à quel camp ils appartenaient. Les pilleurs ont sans doute pris tout ce qui pouvait servir. | [img]gfx/ui/events/event_132.png[/img]Un chariot fumant avec son propriétaire laissé à côté, sans tête, et le reste de son corps arraché jusqu'à l'os. Étant donné la guerre en cours, il est difficile de dire qui en est responsable. | [img]gfx/ui/events/event_132.png[/img]Vous trouvez les restes défigurés d'une ancienne bannière des dieux, plantée dans les sables avec un corps sans tête accroché au poteau. Sans doute un nordique, le corps est pratiquement en train de bouillonner sous les yeux des lézards des sables qui vont et viennent, essayant de s'emparer des dernières bonnes bouchées. D'autres corps sont éparpillés sur le sable, la plupart rampant avec des scarabées ou étant tirés par des serpents et autres créatures vultueuses. | [img]gfx/ui/events/event_167.png[/img]Vous trouvez un homme nordique mort étalé dans les sables, les bras et les jambes liés à une chaise en bois. Devant lui se trouve un grand poteau avec un cadre et des cordes qui pendent mollement de ses coins. Il semble qu'il ait autrefois tenu quelque chose de grand et de rond. La tête de l'homme est percée d'un trou, et la blessure est différente de tout ce que tu as pu voir : c'est presque comme s'ils l'avaient percée par la seule chaleur. Peut-être que les Dorés ont utilisé le reflet d'un grand médaillon pour intensifier le soleil ? C'est difficile à dire. | [img]gfx/ui/events/event_167.png[/img]Vous trouvez une rangée de cadavres dans le sable, et en y regardant de plus près, vous constatez qu'il s'agit de femmes du sud et de ce qui ressemble à un homme qui pourrait faire partie du conseil d'un Vizir. Toutes leurs têtes ont été enlevées et placées sur leur dos, les yeux tournés vers leurs fesses. Vous n'êtes pas sûr de la signification de tout cela, mais il ne fait aucun doute que c'est le résultat de querelles internes dans les propres rangs du Vizir. Il n'y a rien de valeur à prendre, alors vous demandez aux hommes de partir.}",
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

		if (currentTile.Type != this.Const.World.TerrainType.Desert && currentTile.Type != this.Const.World.TerrainType.Oasis && currentTile.TacticalType != this.Const.World.TerrainTacticalType.DesertHills && currentTile.Type != this.Const.World.TerrainType.Steppe)
		{
			return;
		}

		if (!currentTile.HasRoad)
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


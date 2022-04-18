this.holywar_flavor_south_settlement_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.holywar_flavor_south_settlement";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 20.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_97.png[/img]Des enfants passent la tête par-dessus une dune de sable, manquant de peu un autre groupe d\'enfants cachés à l\'ombre d\'une défilade. Quand la première troupe arrive par le haut, les enfants en embuscade sautent et les poignardent avec des bâtons et les tuent.%SPEECH_ON%Mort aux nordiques, que le regard du doreur nous éclaire!%SPEECH_OFF%Les enfants tués glissent le long de la dune, mous et sans vie, avant de se remettre sur leurs pieds et de dire que c\'est leur tour de jouer les gentils. Il semble que la guerre sainte ait déjà revigoré la prochaine génération pour qu\'elle soit prête quand son heure viendra. | [img]gfx/ui/events/event_166.png[/img]Des rangées et des rangées de fidèles se penchent sur le sable pour offrir leurs prières au Gilder. Toutes sortes d\'hommes, de femmes et d\'enfants, semblables ou non, puisqu\'il y a de riches marchands à côté de mendiants appauvris. Les seules exceptions sont le vizir et les conseillers, qui prient tous aux côtés des prêtres en tête de la procession. Si tant est que ces hommes prient : pour autant que l\'on puisse en juger, les membres du conseil chuchotent entre eux, certains ne prêtant pas la moindre attention à la cérémonie.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Une époque étrange.",
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

		if (this.World.FactionManager.isHolyWar())
		{
			local playerTile = this.World.State.getPlayer().getTile();
			local towns = this.World.EntityManager.getSettlements();
			local nearTown = false;

			foreach( t in towns )
			{
				if (t.isSouthern() && t.getTile().getDistanceTo(playerTile) <= 5 && t.isAlliedWithPlayer())
				{
					nearTown = true;
					break;
				}
			}

			if (!nearTown)
			{
				return;
			}

			this.m.Score = 10;
		}
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


this.holywar_flavor_south_settlement_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.holywar_flavor_south_settlement";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 20.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_97.png[/img]Children peep their heads over a sand dune, just missing another group of children hiding in the shade of a defilade. When the first troop come over the top, the ambushing kids jump out and stab them with sticks and slay them down.%SPEECH_ON%Death to the northerners, may the Gilder\'s gaze shine upon us!%SPEECH_OFF%The slain kids slide down the dune, limp and lifeless, before jolting back to their feet and arguing that it is their turn to play the \'good guys.\' It seems the holy war has already invigorated the next generation to be ready when their time comes. | [img]gfx/ui/events/event_166.png[/img]Rows and rows of the faithful bend to the sands to give their prayers to the Gilder. All manner of men and women and children alike, and dissimilar, being that there were wealthy merchants beside impoverished beggars. The only real standouts are the Vizier and the councilmen, who all pray beside the priests at the head of the procession. That is if these men are praying at all: as far as you can tell, the council is whispering amongst themselves, some not paying the slightest bit of attention to the ceremony.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A strange time.",
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


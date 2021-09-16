this.holywar_flavor_north_outside_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.holywar_flavor_north_outside";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 20.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_95.png[/img]The homestead is a smoldering ruin and its occupants have all been beheaded save one. An unlucky figure has instead been prostrated and spread-eagled on the ground and has been set afire from what looks like the belly out: his chest is a cratered, ashen ruin, and his limbs blackened and charred, yet still skeletal in their remains. His face is untouched, perhaps by design, and by the look of him he did not die in a manner you\'d find suitable to anyone, not even your own enemies. | [img]gfx/ui/events/event_02.png[/img]You find some southern soldiers hanging from a tree, their eyes long since plucked by crows and their feet by fortune hunters. They twist listlessly in the wind and none of the locals seem in a hurry to cut them down. | [img]gfx/ui/events/event_60.png[/img]A wagon train is splattered to both sides of a path, the wood and material littering the fields beside them. Everything of value has been taken, and the merchant slain to the last. The wounds indicate southern intents, yet the mortal carvings don\'t quite seem as clean as you\'re used to seeing. This could very well be the work of thieves using the holy war as cover. Either way, there\'s nothing of value left and you have the men continue on. | [img]gfx/ui/events/event_132.png[/img]You find a battlefield, though your arrival is far too late to make any dramatic appearance: the dead are all over the place, southern and northern, and the sutlers and scavengers and scapegraces have already looted the entirety of the aftermath. Judging the frail appearances of a big heap of southerners piled in one spot, and fast footed retreat from it, you\'ve little doubt the Gilded threw forward their indebted souls to spare the rest of the troop.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "War never changes.",
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


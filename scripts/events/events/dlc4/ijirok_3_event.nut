this.ijirok_3_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.ijirok_3";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_76.png[/img]{While camping in the northern wastes, a silhouette approaches, a flat black whose appearance was seemingly cut out of the thin air itself. As it nears, an orange glow blossoms from a horn of fire. The company draw their weapons for what shadowy figure could possibly be out here in all this nothing? What \'something\' crosses such a wretched land? But you find it is just elderly man with a bald pate and bulbous, red nose. If the snow could carve man from granite, this would be the look of its creation. The stranger passes through the camp with the company turning to him and yelling out, but not one sellsword goes near him. He finally leans down and puts the horn to the ground and the snow extinguishes its fire. Then he gets up and keeps going and soon disappears into the fog of night.\n\n  %randombrother% picks up the horn and tips it over. A rose falls out and its clear even in the dark that the petals are soft, but already curling to the brutal cold. You look around for the old man and see his tracks still fresh in the powder.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "All sorts of strange in these wastes.",
					function getResult( _event )
					{
						this.World.Flags.set("IjirokStage", 3);
						local locations = this.World.EntityManager.getLocations();

						foreach( v in locations )
						{
							if (v.getTypeID() == "location.icy_cave_location")
							{
								this.Const.World.Common.addFootprintsFromTo(this.World.State.getPlayer().getTile(), v.getTile(), this.Const.GenericFootprints, 0.5);
								break;
							}
						}

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
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (!this.World.Flags.has("IjirokStage") || this.World.Flags.get("IjirokStage") == 0 || this.World.Flags.get("IjirokStage") >= 4)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Snow || currentTile.Type != this.Const.World.TerrainType.SnowyForest)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 10)
			{
				return;
			}
		}

		local locations = this.World.EntityManager.getLocations();

		foreach( v in locations )
		{
			if (v.getTypeID() == "location.icy_cave_location")
			{
				if (v.getTile().getDistanceTo(currentTile) > 10)
				{
					return;
				}
			}
		}

		this.m.Score = 25;
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


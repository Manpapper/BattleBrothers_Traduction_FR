this.ijirok_1_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.ijirok_1";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_143.png[/img]%randombrother% hails you down and says that there\'s something you should come take a look at. Surely something that\'s out in all this ice and nothingness is worth seeing.\n\n The sellsword brings you to a cavernous hole in the ground. He lights a torch and steps into and you follow. There at the bottom you find a few more of your men. They\'re standing around what looks like a sarcophagus made of ice, except there\'s no lid. A frozen blackness cakes the edges of the container. In the corner of the room is an icy corpse stuck to the wall. His hands are at his sides and icicles of blood run from his wrists. Adjacent to it is a pair of clothes hanging from icehooks, but there is no body attached. A trail of blood leads from the clothes to the other man, then back out the cave.%SPEECH_ON%I don\'t know what to make of this sir.%SPEECH_OFF%One mercenary says. You ask the men if they\'ve seen anything in their scouting, and you mean damn near anything. But they all shake their heads no. If something was in that box then it is surely out now. You tell the men to get on out of the cave and back to camp.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "And keep your wits about you.",
					function getResult( _event )
					{
						this.World.Flags.set("IjirokStage", 1);
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

		if (!this.World.Flags.has("IjirokStage") || this.World.Flags.get("IjirokStage") >= 5)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Snow)
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


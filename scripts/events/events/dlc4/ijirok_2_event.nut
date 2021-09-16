this.ijirok_2_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.ijirok_2";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_143.png[/img]{A blotch in the snowy wastes catches your eye. With a couple of scouts you go out to see what it is, suspecting little more than perhaps an animal carcass or abandoned camp. Instead, you find a party of naked corpses with their bodies crouched as though they were sitting upon chairs. They\'re in a close-knit circle, all facing inward, some with their hands out as if warming them at a fire. You push one of the corpses. As it tips back, the body sitting opposite raises up. %randombrother% jumps away.%SPEECH_ON%By the old gods!%SPEECH_OFF%A rim of flesh runs just beneath the powdered snow, and the ring connects one corpse to the other, a shared desecration beyond your understanding. The skin runs inward, meeting at a fleshen fulcrum which rises out of the snow shaped like some macabre flower pot. Nothing is inside. One of the scouts demands a return to the safety of the company and you very much agree with him.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Keep this between us.",
					function getResult( _event )
					{
						this.World.Flags.set("IjirokStage", 2);
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

		if (!this.World.Flags.has("IjirokStage") || this.World.Flags.get("IjirokStage") == 0 || this.World.Flags.get("IjirokStage") >= 5)
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
			if (t.getTile().getDistanceTo(currentTile) <= 12)
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


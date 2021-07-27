this.enter_unfriendly_town_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null
	},
	function create()
	{
		this.m.ID = "event.enter_unfriendly_town";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_43.png[/img]{The {denizens | citizens | peasants | laymen | townfolk} of %townname% greet you with {a few rotten eggs thrown with such velocity and aim that you can\'t help but think these people do not take kindly to your presence. | a tarred and feather doll swinging from a nearby tree. The face of it is remarkably similar to your own, but you consider this nothing more than a coincidence. | a few rambunctious children, no doubt set loose by their parents to do evil that, in the adult world, would have garnered some measure of violent response. As the little runts go after you causing chaos, you order your men to put their boots to work. A few good stomps and kicks drive the bastards off, but for how long? | a burning effigy in your likeness. The peasants douse it in a pig trough. They stand around it, making sure you can\'t see what\'s left of the you-shapened wood.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I can\'t stand this town.",
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
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();
		local nearTown = false;
		local town;

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer() && t.getFactionOfType(this.Const.FactionType.Settlement).getPlayerRelation() <= 35)
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		this.m.Town = town;
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
	}

});


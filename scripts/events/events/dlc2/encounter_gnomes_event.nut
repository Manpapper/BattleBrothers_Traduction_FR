this.encounter_gnomes_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.encounter_gnomes";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 200.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img]You give the men a break and decide to scout the forest ahead yourself. Not more than five minutes out you hear the steady hum of chanting. Drawing your sword, you crest an embarkment of fallen trees and look over the side. There you see a dozen of what look like miniature men dancing in a circle. Half or whistling lowly while the rest keep repeating some word you\'ve never heard before. In the center of the nonsense is a mushroom and a very bored looking toad which, occasionally, one mini man will run up and touch before sprinting back to the circle grinning as though he got away with some roguish crime.\n\n This is too much. You crawl forward to get a better look only to have a branch snap under your weight. The little men stop instantly and look toward you like a herd of prey. One yells in gibberish and the lot of them skip and hop away, diving into tree holes or into bushes. When you go down to see them out, you find nothing. They\'ve vanished entirely. You go to the stump and find the toad impaled to the hilt by a dagger and the mushroom gone.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Strange.",
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
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 25)
			{
				return false;
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


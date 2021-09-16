this.holywar_flavor_south_outside_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.holywar_flavor_south_outside";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 20.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_132.png[/img]You find the disassembled remains of a battlefield: a litter of unusables with corpses so shriveled it\'s hard to discern to which side they belonged. The scraphunters no doubt took anything of use. | [img]gfx/ui/events/event_132.png[/img]A smoldering wagon with its owner left beside it, headless, and the rest of his body plucked to the bone. Given the war going on, it\'s hard to say who exactly is responsible for it. | [img]gfx/ui/events/event_132.png[/img]You find the defaced remains of an old gods banner, staked into the sands with a headless corpse strung up on the pole. No doubt a northerner, the body is practically bubbling in appearance as sand lizards snake to and fro, trying to get the last of the good morsels. There\'s a smattering of more bodies across the sands, most crawling with beetles or being tugged at by snakes and other vulturous creatures. | [img]gfx/ui/events/event_167.png[/img]You find a dead northern man propped up in the sands, his arms and legs bound to a wooden chair. In front of him is a large pole with a catch frame and ropes which hang limp from its corners. It seems it once held something large and rotund. The man\'s head has a hole bored through it, and the wound is unlike any you\'ve ever seen: it\'s almost as if they drilled through it with heat alone. Perhaps the Gilded used the reflection of a great medallion to intensify the sun? It\'s hard to say. | [img]gfx/ui/events/event_167.png[/img]You find a row of corpses in the sand, and upon closer inspection find they\'re all southern women and what looks like a man who could possibly be on a Vizier\'s council. All their heads have been removed and placed upon their backs, the eyes facing their buttocks. You\'re not sure what any of this means, but no doubt it is the result of internal quarrels within the Vizier\'s own ranks. There\'s nothing of value to take so you have the men move on.}",
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


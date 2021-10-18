this.undead_graveyard_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "A place where people have buried their dead, placing them down for their last rest. Or at least they hoped so.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.undead_graveyard";
		this.m.LocationType = this.Const.World.LocationType.Lair;
		this.m.CombatLocation.Template[0] = "tactical.graveyard";
		this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.Walls;
		this.m.CombatLocation.CutDownTrees = false;
		this.m.CombatLocation.ForceLineBattle = true;
		this.m.CombatLocation.AdditionalRadius = 5;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = false;
		local r = this.Math.rand(1, 4);

		if (r == 1)
		{
			this.setDefenderSpawnList(this.Const.World.Spawn.ZombiesOrZombiesAndGhosts);
		}
		else if (r == 2)
		{
			this.setDefenderSpawnList(this.Const.World.Spawn.ZombiesOrZombiesAndGhouls);
		}
		else if (r == 3)
		{
			this.setDefenderSpawnList(this.Const.World.Spawn.Ghouls);
		}
		else if (r == 4)
		{
			this.setDefenderSpawnList(this.Const.World.Spawn.Ghosts);
		}

		this.m.Resources = 130;
	}

	function onSpawned()
	{
		this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.World.LocationNames.Graveyard);
		this.location.onSpawned();
	}

	function onDropLootForPlayer( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);
		this.dropMoney(this.Math.rand(1, 200), _lootTable);
		this.dropTreasure(this.Math.rand(0, 1), [
			"loot/silver_bowl_item",
			"loot/signet_ring_item",
			"loot/signet_ring_item"
		], _lootTable);
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_graveyard_01");
	}

});


this.undead_buried_castle_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "Sunken into the ground, this castle has been long abandoned, only to give refuge to much darker creatures.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.undead_buried_castle";
		this.m.LocationType = this.Const.World.LocationType.Lair;
		this.m.CombatLocation.Template[0] = "tactical.ruins";
		this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.Walls;
		this.m.CombatLocation.CutDownTrees = false;
		this.m.CombatLocation.ForceLineBattle = true;
		this.m.CombatLocation.AdditionalRadius = 5;
		this.setDefenderSpawnList(this.Const.World.Spawn.UndeadArmy);
		this.m.NamedWeaponsList = this.Const.Items.NamedUndeadWeapons;
		this.m.NamedShieldsList = this.Const.Items.NamedUndeadShields;
		this.m.Resources = 350;
	}

	function onSpawned()
	{
		this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.World.LocationNames.BuriedCastle);
		this.location.onSpawned();
	}

	function onDropLootForPlayer( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);
		this.dropTreasure(this.Math.rand(3, 4), [
			"loot/silverware_item",
			"loot/silver_bowl_item",
			"loot/signet_ring_item",
			"loot/white_pearls_item",
			"loot/golden_chalice_item",
			"loot/gemstones_item",
			"loot/ancient_gold_coins_item",
			"loot/jeweled_crown_item",
			"loot/ancient_gold_coins_item",
			"loot/ornate_tome_item"
		], _lootTable);
	}

	function onInit()
	{
		this.location.onInit();
		local flipped = this.Math.rand(0, 1) == 1;
		local body = this.addSprite("body");
		body.setBrush("world_buried_castle");
		local isSouthern = this.getTile().Type == this.Const.World.TerrainType.Desert || this.getTile().Type == this.Const.World.TerrainType.Steppe || this.getTile().Type == this.Const.World.TerrainType.Oasis || this.getTile().TacticalType == this.Const.World.TerrainTacticalType.DesertHills;

		if (isSouthern && this.Const.DLC.Desert)
		{
			this.m.CombatLocation.Template[0] = "tactical.southern_ruins";
		}
	}

});


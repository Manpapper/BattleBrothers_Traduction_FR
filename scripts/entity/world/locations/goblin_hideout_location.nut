this.goblin_hideout_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "An abandoned homestead with a collapsed roof.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.goblin_hideout";
		this.m.LocationType = this.Const.World.LocationType.Lair | this.Const.World.LocationType.Passive;
		this.m.CombatLocation.Template[0] = "tactical.goblin_camp";
		this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.None;
		this.m.CombatLocation.CutDownTrees = true;
		this.m.IsDespawningDefenders = false;
		this.setDefenderSpawnList(this.Const.World.Spawn.GoblinDefenders);
		this.m.Resources = 70;
	}

	function onSpawned()
	{
		this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.World.LocationNames.Hideout);
		this.location.onSpawned();
	}

	function onDropLootForPlayer( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);
		this.dropMoney(this.Math.rand(0, 100), _lootTable);
		this.dropArmorParts(this.Math.rand(0, 5), _lootTable);
		this.dropAmmo(this.Math.rand(0, 20), _lootTable);
		this.dropFood(this.Math.rand(1, 2), [
			"strange_meat_item",
			"roots_and_berries_item",
			"pickled_mushrooms_item"
		], _lootTable);
		this.dropTreasure(1, [
			"loot/signet_ring_item",
			"trade/amber_shards_item",
			"trade/cloth_rolls_item",
			"trade/salt_item",
			"loot/goblin_carved_ivory_iconographs_item"
		], _lootTable);
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_homestead_01");
	}

});


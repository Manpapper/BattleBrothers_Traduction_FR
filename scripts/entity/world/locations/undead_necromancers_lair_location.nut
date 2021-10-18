this.undead_necromancers_lair_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "A necromancer has made this lair his refuge for practicing dark rituals undisturbed.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.undead_necromancers_lair";
		this.m.LocationType = this.Const.World.LocationType.Lair;
		this.m.CombatLocation.Template[0] = "tactical.graveyard";
		this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.None;
		this.m.CombatLocation.CutDownTrees = false;
		this.m.CombatLocation.ForceLineBattle = true;
		this.m.CombatLocation.AdditionalRadius = 5;
		this.setDefenderSpawnList(this.Const.World.Spawn.Necromancer);
		this.m.Resources = 150;
		this.m.RoamerSpawnList = this.Const.World.Spawn.Zombies;
		this.m.NamedShieldsList = this.Const.Items.NamedUndeadShields;
	}

	function onSpawned()
	{
		this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.World.LocationNames.NecromancerLair);
		this.location.onSpawned();
	}

	function onDropLootForPlayer( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);
		this.dropMoney(this.Math.rand(100, 400), _lootTable);
		this.dropFood(this.Math.rand(0, 1), [
			"wine_item",
			"bread_item"
		], _lootTable);
		this.dropTreasure(this.Math.rand(1, 2), [
			"loot/silverware_item",
			"loot/silver_bowl_item",
			"loot/signet_ring_item",
			"loot/signet_ring_item",
			"loot/ancient_gold_coins_item",
			"loot/ornate_tome_item"
		], _lootTable);

		if (this.Const.DLC.Unhold && this.Math.rand(1, 100) <= 10)
		{
			local treasure = [];
			treasure.push("misc/paint_black_item");
			this.dropTreasure(1, treasure, _lootTable);
		}
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_necromancers_lair_01");
	}

});


this.goblin_settlement_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "The gates to a great underground Goblin city, its maze-like tunnels teeming with vicious greenskins.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.goblin_settlement";
		this.m.LocationType = this.Const.World.LocationType.Lair;
		this.m.CombatLocation.Template[0] = "tactical.goblin_camp";
		this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.Walls;
		this.m.CombatLocation.CutDownTrees = true;
		this.m.IsDespawningDefenders = false;
		this.setDefenderSpawnList(this.Const.World.Spawn.GoblinBoss);
		this.m.Resources = 350;
	}

	function onSpawned()
	{
		this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.World.LocationNames.GoblinBase);
		this.location.onSpawned();
	}

	function onDropLootForPlayer( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);
		this.dropMoney(this.Math.rand(0, 100), _lootTable);
		this.dropArmorParts(this.Math.rand(10, 20), _lootTable);
		this.dropAmmo(this.Math.rand(25, 100), _lootTable);
		this.dropMedicine(this.Math.rand(0, 10), _lootTable);
		this.dropFood(this.Math.rand(4, 8), [
			"strange_meat_item",
			"roots_and_berries_item",
			"pickled_mushrooms_item"
		], _lootTable);
		this.dropTreasure(this.Math.rand(2, 3), [
			"trade/salt_item",
			"trade/dies_item",
			"trade/amber_shards_item",
			"loot/silverware_item",
			"loot/silver_bowl_item",
			"loot/ancient_gold_coins_item",
			"loot/silver_bowl_item",
			"loot/signet_ring_item",
			"loot/goblin_carved_ivory_iconographs_item",
			"loot/goblin_minted_coins_item",
			"loot/goblin_rank_insignia_item"
		], _lootTable);
	}

	function onInit()
	{
		this.location.onInit();
		this.setVisibleInFogOfWar(true);
		local body = this.addSprite("body");
		local inSteppe = this.getTile().Type == this.Const.World.TerrainType.Steppe;

		for( local i = 0; i != 6; i = ++i )
		{
			if (this.getTile().hasNextTile(i) && this.getTile().getNextTile(i).Type == this.Const.World.TerrainType.Steppe)
			{
				inSteppe = true;
				break;
			}
		}

		if (inSteppe)
		{
			body.setBrush("world_goblin_camp_steppe_02");
		}
		else
		{
			body.setBrush("world_goblin_camp_02");
		}
	}

});


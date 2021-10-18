this.unique_goblin_city_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "A great goblin city nested into the remains of an ancient fortress. Protected by dark and towering walls, it is host to a standing army of vicious greenskins.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.goblin_city";
		this.m.LocationType = this.Const.World.LocationType.Lair | this.Const.World.LocationType.Unique;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = true;
		this.m.IsDespawningDefenders = false;
		this.m.IsAttackable = false;
		this.m.VisibilityMult = 0.9;
		this.m.Resources = 500;
		this.m.OnEnter = "event.location.goblin_city_enter";
		this.m.OnDestroyed = "event.location.goblin_city_destroyed";
	}

	function onSpawned()
	{
		this.m.Name = "Rul\'gazhix";
		this.location.onSpawned();

		for( local i = 0; i < 14; i = ++i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.GoblinSkirmisher
			}, false);
		}

		for( local i = 0; i < 6; i = ++i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher
			}, false);
		}

		for( local i = 0; i < 2; i = ++i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.GoblinOverseer
			}, false);
		}

		for( local i = 0; i < 2; i = ++i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.GoblinShaman
			}, false);
		}

		for( local i = 0; i < 10; i = ++i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.GoblinWolfrider
			}, false);
		}

		for( local i = 0; i < 7; i = ++i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.GoblinAmbusher
			}, false);
		}

		for( local i = 0; i < 1; i = ++i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.GoblinOverseer
			}, false);
		}

		for( local i = 0; i < 1; i = ++i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.GoblinShaman
			}, false);
		}
	}

	function onDiscovered()
	{
		this.location.onDiscovered();
		this.World.Flags.increment("LegendaryLocationsDiscovered", 1);

		if (this.World.Flags.get("LegendaryLocationsDiscovered") >= 10)
		{
			this.updateAchievement("FamedExplorer", 1, 1);
		}
	}

	function onBeforeCombatStarted()
	{
		this.location.onBeforeCombatStarted();

		for( local added = 0; this.m.Troops.len() < 43;  )
		{
			local r = this.Math.rand(1, 3);

			if (r == 1)
			{
				this.Const.World.Common.addTroop(this, {
					Type = this.Const.World.Spawn.Troops.GoblinSkirmisher
				}, false);
			}
			else if (r == 2)
			{
				this.Const.World.Common.addTroop(this, {
					Type = this.Const.World.Spawn.Troops.GoblinAmbusher
				}, false);
			}
			else if (r == 3)
			{
				this.Const.World.Common.addTroop(this, {
					Type = this.Const.World.Spawn.Troops.GoblinWolfrider
				}, false);
			}

			added = ++added;

			if (added >= 6)
			{
				break;
			}
		}
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
			"trade/furs_item",
			"trade/salt_item",
			"trade/dies_item",
			"trade/amber_shards_item",
			"loot/silverware_item",
			"loot/silver_bowl_item",
			"loot/ancient_gold_coins_item",
			"loot/silver_bowl_item",
			"loot/signet_ring_item"
		], _lootTable);
		_lootTable.push(this.new("scripts/items/helmets/legendary/emperors_countenance"));
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_goblin_camp_04");
	}

	function onDeserialize( _in )
	{
		this.location.onDeserialize(_in);
		this.m.IsAttackable = true;
	}

});


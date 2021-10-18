this.black_monolith_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "A pitch black monolith towers over the surrounding lands, emitting a baleful aura. No living being dares drawing close to it.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.black_monolith";
		this.m.LocationType = this.Const.World.LocationType.Lair | this.Const.World.LocationType.Unique;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = false;
		this.m.IsAttackable = true;
		this.m.VisibilityMult = 1.0;
		this.m.Resources = 500;
		this.m.OnEnter = "event.location.monolith_enter";
		this.m.OnDestroyed = "event.location.monolith_destroyed";
	}

	function onSpawned()
	{
		this.m.Name = "Black Monolith";
		this.location.onSpawned();

		for( local i = 0; i < 8; i = ++i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.SkeletonMedium
			}, false);
		}

		for( local i = 0; i < 7; i = ++i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.SkeletonMediumPolearm
			}, false);
		}

		for( local i = 0; i < 4; i = ++i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.Vampire
			}, false);
		}

		for( local i = 0; i < 2; i = ++i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.VampireLOW
			}, false);
		}

		for( local i = 0; i < 9; i = ++i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.SkeletonHeavy
			}, false);
		}

		for( local i = 0; i < 8; i = ++i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.SkeletonHeavyPolearm
			}, false);
		}

		this.Const.World.Common.addTroop(this, {
			Type = this.Const.World.Spawn.Troops.SkeletonBoss
		}, false);

		for( local i = 0; i < 3; i = ++i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.SkeletonPriest
			}, false);
		}

		for( local i = 0; i < 5; i = ++i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.SkeletonHeavyBodyguard
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

		for( local added = 0; this.m.Troops.len() < 47;  )
		{
			local r = this.Math.rand(1, 7);

			if (r == 1)
			{
				this.Const.World.Common.addTroop(this, {
					Type = this.Const.World.Spawn.Troops.SkeletonMedium
				}, false);
			}
			else if (r == 2)
			{
				this.Const.World.Common.addTroop(this, {
					Type = this.Const.World.Spawn.Troops.SkeletonMediumPolearm
				}, false);
			}
			else if (r == 3)
			{
				this.Const.World.Common.addTroop(this, {
					Type = this.Const.World.Spawn.Troops.Vampire
				}, false);
			}
			else if (r == 4)
			{
				this.Const.World.Common.addTroop(this, {
					Type = this.Const.World.Spawn.Troops.VampireLOW
				}, false);
			}
			else if (r == 5)
			{
				this.Const.World.Common.addTroop(this, {
					Type = this.Const.World.Spawn.Troops.SkeletonHeavy
				}, false);
			}
			else if (r == 6)
			{
				this.Const.World.Common.addTroop(this, {
					Type = this.Const.World.Spawn.Troops.SkeletonHeavyPolearm
				}, false);
			}
			else if (r == 7)
			{
				this.Const.World.Common.addTroop(this, {
					Type = this.Const.World.Spawn.Troops.SkeletonPriest
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
		this.dropArmorParts(this.Math.rand(0, 60), _lootTable);
		this.dropTreasure(this.Math.rand(3, 4), [
			"loot/white_pearls_item",
			"loot/jeweled_crown_item",
			"loot/gemstones_item",
			"loot/golden_chalice_item",
			"loot/ancient_gold_coins_item"
		], _lootTable);
		_lootTable.push(this.new("scripts/items/armor/legendary/emperors_armor"));
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_monolith_01");
	}

	function onDeserialize( _in )
	{
		this.location.onDeserialize(_in);
		this.m.IsAttackable = true;
	}

});


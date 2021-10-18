this.undead_hideout_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "An abandoned homestead with a collapsed roof.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.undead_hideout";
		this.m.LocationType = this.Const.World.LocationType.Lair | this.Const.World.LocationType.Passive;
		this.m.CombatLocation.Template[0] = "tactical.ruins";
		this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.None;
		this.m.CombatLocation.CutDownTrees = false;
		this.m.CombatLocation.ForceLineBattle = true;
		this.m.IsDespawningDefenders = false;
		this.m.IsShowingBanner = false;
		local r = this.Math.rand(1, 2);

		if (r == 1)
		{
			this.setDefenderSpawnList(this.Const.World.Spawn.ZombiesOrZombiesAndGhouls);
		}
		else if (r == 2)
		{
			this.setDefenderSpawnList(this.Const.World.Spawn.ZombiesOrZombiesAndGhosts);
		}

		this.m.Resources = 80;
		this.m.RoamerSpawnList = this.Const.World.Spawn.Zombies;
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
		this.dropAmmo(this.Math.rand(0, 5), _lootTable);
		this.dropFood(this.Math.rand(1, 2), [
			"strange_meat_item",
			"strange_meat_item",
			"ground_grains_item",
			"dried_fruits_item"
		], _lootTable);
		this.dropTreasure(1, [
			"loot/signet_ring_item",
			"loot/signet_ring_item",
			"loot/silverware_item"
		], _lootTable);
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_homestead_01");
		local isSouthern = this.getTile().Type == this.Const.World.TerrainType.Desert || this.getTile().Type == this.Const.World.TerrainType.Steppe || this.getTile().Type == this.Const.World.TerrainType.Oasis || this.getTile().TacticalType == this.Const.World.TerrainTacticalType.DesertHills;

		if (isSouthern)
		{
			if (this.Const.DLC.Desert)
			{
				this.m.CombatLocation.Template[0] = "tactical.southern_ruins";
			}
		}
	}

});


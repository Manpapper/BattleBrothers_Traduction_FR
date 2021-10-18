this.nomad_tents_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "A small camp of nomad tents that can be packed up and moved quickly.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.nomad_tents";
		this.m.LocationType = this.Const.World.LocationType.Lair | this.Const.World.LocationType.Passive;
		this.m.CombatLocation.Template[0] = "tactical.desert_camp";
		this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.None;
		this.m.CombatLocation.CutDownTrees = false;
		this.m.IsShowingBanner = true;
		this.m.IsDespawningDefenders = false;
		this.setDefenderSpawnList(this.Const.World.Spawn.NomadDefenders);
		this.m.Resources = 70;
		this.m.VisibilityMult = 0.8;
		this.m.NamedShieldsList = this.Const.Items.NamedSouthernShields;
	}

	function onSpawned()
	{
		this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.World.LocationNames.NomadTents);
		this.location.onSpawned();
	}

	function onDropLootForPlayer( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);
		this.dropMoney(this.Math.rand(50, 150), _lootTable);
		this.dropArmorParts(this.Math.rand(0, 10), _lootTable);
		this.dropAmmo(this.Math.rand(0, 10), _lootTable);
		this.dropMedicine(this.Math.rand(0, 5), _lootTable);
		local treasure = [
			"loot/signet_ring_item",
			"trade/spices_item",
			"trade/cloth_rolls_item",
			"trade/salt_item"
		];
		this.dropFood(this.Math.rand(1, 2), [
			"bread_item",
			"dried_fruits_item",
			"ground_grains_item",
			"roots_and_berries_item",
			"goat_cheese_item"
		], _lootTable);
		this.dropTreasure(1, treasure, _lootTable);

		if (this.Const.DLC.Unhold && this.Math.rand(1, 100) <= 10)
		{
			local treasure = [];
			treasure.push("misc/paint_set_item");
			treasure.push("misc/paint_black_item");
			treasure.push("misc/paint_red_item");
			treasure.push("misc/paint_orange_red_item");
			treasure.push("misc/paint_white_blue_item");
			treasure.push("misc/paint_white_green_yellow_item");
			this.dropTreasure(1, treasure, _lootTable);
		}
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_nomad_camp_02");
	}

});


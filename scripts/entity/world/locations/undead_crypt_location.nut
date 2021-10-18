this.undead_crypt_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "A long forgotten crypt haunted by the ghosts of the past. The dead won\'t find sleep here.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.undead_crypt";
		this.m.LocationType = this.Const.World.LocationType.Lair;
		this.m.CombatLocation.Template[0] = "tactical.graveyard";
		this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.Walls;
		this.m.CombatLocation.CutDownTrees = false;
		this.m.CombatLocation.ForceLineBattle = true;
		this.m.CombatLocation.AdditionalRadius = 5;
		this.m.IsShowingDefenders = false;
		local r = this.Math.rand(1, 2);

		if (r == 1)
		{
			this.setDefenderSpawnList(this.Const.World.Spawn.ZombiesAndGhosts);
		}
		else if (r == 2)
		{
			this.setDefenderSpawnList(this.Const.World.Spawn.Necromancer);
		}

		this.m.Resources = 180;
	}

	function onSpawned()
	{
		this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.World.LocationNames.Crypt);
		this.location.onSpawned();
	}

	function onDropLootForPlayer( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);
		local treasure = [
			"loot/silver_bowl_item",
			"loot/signet_ring_item",
			"loot/signet_ring_item",
			"loot/ancient_gold_coins_item",
			"loot/ornate_tome_item"
		];

		if (this.Const.DLC.Unhold)
		{
			treasure.extend(treasure);
			treasure.extend(treasure);
			treasure.extend(treasure);
			treasure.extend(treasure);
			treasure.push("armor_upgrades/metal_plating_upgrade");
			treasure.push("armor_upgrades/metal_pauldrons_upgrade");
			treasure.push("armor_upgrades/mail_patch_upgrade");
			treasure.push("armor_upgrades/leather_shoulderguards_upgrade");
			treasure.push("armor_upgrades/leather_neckguard_upgrade");
			treasure.push("armor_upgrades/joint_cover_upgrade");
			treasure.push("armor_upgrades/heraldic_plates_upgrade");
			treasure.push("armor_upgrades/double_mail_upgrade");
		}

		this.dropMoney(this.Math.rand(100, 400), _lootTable);
		this.dropTreasure(this.Math.rand(1, 2), treasure, _lootTable);
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		local isSouthern = this.getTile().Type == this.Const.World.TerrainType.Desert || this.getTile().Type == this.Const.World.TerrainType.Steppe || this.getTile().Type == this.Const.World.TerrainType.Oasis || this.getTile().TacticalType == this.Const.World.TerrainTacticalType.DesertHills;

		if (isSouthern)
		{
			body.setBrush("world_crypt_02");
		}
		else
		{
			body.setBrush("world_crypt_01");
		}
	}

});


this.orc_settlement_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "A large and foul-smelling sea of tents, with a warlord\'s tent and throne-room in the middle, the largest of all. It\'s home to a whole tribe until they move on to hunt and raid elsewhere.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.orc_settlement";
		this.m.LocationType = this.Const.World.LocationType.Lair | this.Const.World.LocationType.Mobile;
		this.m.CombatLocation.Template[0] = "tactical.orc_camp";
		this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.None;
		this.m.CombatLocation.CutDownTrees = true;
		this.setDefenderSpawnList(this.Const.World.Spawn.OrcBoss);
		this.m.Resources = 350;
		this.m.NamedWeaponsList = this.Const.Items.NamedOrcWeapons;
		this.m.NamedShieldsList = this.Const.Items.NamedOrcShields;
	}

	function onSpawned()
	{
		this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.World.LocationNames.OrcCamp);
		this.location.onSpawned();
	}

	function onDropLootForPlayer( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);
		this.dropArmorParts(this.Math.rand(25, 50), _lootTable);
		this.dropMedicine(this.Math.rand(0, 6), _lootTable);
		local treasure = [
			"trade/furs_item",
			"trade/furs_item",
			"trade/furs_item",
			"trade/furs_item",
			"trade/uncut_gems_item",
			"trade/dies_item",
			"loot/white_pearls_item"
		];

		if (this.Const.DLC.Unhold)
		{
			treasure.extend(treasure);
			treasure.extend(treasure);
			treasure.extend(treasure);
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

		this.dropFood(this.Math.rand(4, 8), [
			"strange_meat_item"
		], _lootTable);
		this.dropTreasure(this.Math.rand(1, 3), treasure, _lootTable);

		if (this.Const.DLC.Unhold && this.Math.rand(1, 100) <= 10)
		{
			local treasure = [];
			treasure.push("misc/paint_black_item");
			treasure.push("misc/paint_red_item");
			this.dropTreasure(1, treasure, _lootTable);
		}
	}

	function onInit()
	{
		this.location.onInit();
		this.setVisibleInFogOfWar(true);
		local body = this.addSprite("body");
		body.setBrush("world_orc_camp_02");
	}

	function onSerialize( _out )
	{
		this.location.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.location.onDeserialize(_in);
	}

});


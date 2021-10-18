this.orc_cave_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "This cave has been occupied by greenskins and turned into a foul-smelling camp.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.orc_cave";
		this.m.LocationType = this.Const.World.LocationType.Lair | this.Const.World.LocationType.Passive;
		this.m.CombatLocation.Template[0] = "tactical.orc_camp";
		this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.None;
		this.m.CombatLocation.CutDownTrees = false;
		this.m.IsDespawningDefenders = false;
		this.setDefenderSpawnList(this.Const.World.Spawn.BerserkersOnly);
		this.m.Resources = 100;
		this.m.NamedWeaponsList = this.Const.Items.NamedOrcWeapons;
		this.m.NamedShieldsList = this.Const.Items.NamedOrcShields;
	}

	function onSpawned()
	{
		this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.World.LocationNames.OrcCave);
		this.location.onSpawned();
	}

	function onDropLootForPlayer( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);
		this.dropArmorParts(this.Math.rand(0, 5), _lootTable);
		this.dropMedicine(this.Math.rand(0, 2), _lootTable);
		this.dropFood(this.Math.rand(2, 4), [
			"strange_meat_item"
		], _lootTable);
		this.dropTreasure(1, [
			"trade/furs_item"
		], _lootTable);
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");

		if (this.getTile().Type == this.Const.World.TerrainType.Steppe)
		{
			body.setBrush("world_cave_steppe_01");
		}
		else
		{
			body.setBrush("world_cave_01");
		}
	}

});


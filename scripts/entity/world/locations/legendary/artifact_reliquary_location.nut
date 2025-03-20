this.artifact_reliquary_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "Une ruine effondrée datant d'une époque lointaine. La lueur occasionnelle d\'une torche trahit la présence d\'habitants actuels, tout comme les sons étranges qui émanent des profondeurs.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.artifact_reliquary";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = false;
		this.m.IsAttackable = true;
		this.m.VisibilityMult = 0.0;
		this.m.Resources = 500;
		this.m.OnEnter = "event.location.artifact_reliquary_enter";
	}

	function onSpawned()
	{
		this.m.Name = "Reliquaire d\'artefact";
		this.location.onSpawned();
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

	function onDropLootForPlayer( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);
		this.dropTreasure(2, [
			"loot/marble_bust_item"
		], _lootTable);
		_lootTable.push(this.new("scripts/items/helmets/golems/grand_diviner_headdress"));
		_lootTable.push(this.new("scripts/items/armor/golems/grand_diviner_robes"));
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_artifact_reliquary");
	}

});


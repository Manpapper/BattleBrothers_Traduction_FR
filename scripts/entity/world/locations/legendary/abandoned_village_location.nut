this.abandoned_village_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "Un village apparemment abandonné, avec une statue imposante qui domine la place.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.abandoned_village";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = false;
		this.m.IsAttackable = true;
		this.m.VisibilityMult = 1.0;
		this.m.Resources = 500;
		this.m.OnEnter = "event.location.abandoned_village_enter";
	}

	function onSpawned()
	{
		this.m.Name = "Village Abandonné";
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
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_abandoned_village");
	}

});


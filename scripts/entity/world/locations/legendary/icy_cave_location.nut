this.icy_cave_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "A cave amidst a sea of snow and rock. A thick gate of icicles keeps your entrance well stayed.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.icy_cave_location";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = false;
		this.m.VisibilityMult = 0.8;
		this.m.Resources = 0;
		this.m.OnEnter = "event.location.icy_cave_enter";
	}

	function onSpawned()
	{
		this.m.Name = "Icy Cave";
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

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_snow_cave");
	}

});


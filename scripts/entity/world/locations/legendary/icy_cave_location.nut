this.icy_cave_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "Une grotte au milieu d\'une mer de neige et de rochers. Une épaisse barrière de glaçons garde votre entrée bien gardée.";
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
		this.m.Name = "Grotte de Glace";
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


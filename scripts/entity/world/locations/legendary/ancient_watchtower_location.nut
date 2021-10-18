this.ancient_watchtower_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "A thin spire reaching high into the sky. The view from the top must be staggering.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.ancient_watchtower";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = false;
		this.m.VisibilityMult = 1.1;
		this.m.Resources = 0;
		this.m.OnEnter = "event.location.ancient_watchtower";
	}

	function onSpawned()
	{
		this.m.Name = "Ancient Spire";
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
		body.setBrush("world_ancient_watchtower");
	}

});


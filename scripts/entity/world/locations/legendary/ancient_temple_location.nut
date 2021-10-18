this.ancient_temple_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "The sunken and half buried entrance to some sort of temple or mausoleum that sticks out of the ground.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.ancient_temple";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = false;
		this.m.VisibilityMult = 0.9;
		this.m.Resources = 0;
		this.m.OnEnter = "event.location.ancient_temple_enter";
	}

	function onSpawned()
	{
		this.m.Name = "Ancient Temple";
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
		body.setBrush("world_ancient_temple");
	}

});


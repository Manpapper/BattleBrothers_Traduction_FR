this.fountain_of_youth_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "A small clearing in the forest centered around a curios, slender tree. Something seems to be off about this tree but it is difficult to make out from afar.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.fountain_of_youth";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = false;
		this.m.VisibilityMult = 0.9;
		this.m.Resources = 0;
		this.m.OnEnter = "event.location.fountain_of_youth";
	}

	function onSpawned()
	{
		this.m.Name = "Grotesque Tree";
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
		body.setBrush("world_fountain_of_youth");
	}

});


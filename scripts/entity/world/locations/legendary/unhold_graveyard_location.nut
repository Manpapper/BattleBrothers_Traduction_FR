this.unhold_graveyard_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "A wide field littered with gigantic bones and skulls. Some are bleached to white but some are fresh and still have flesh attached to them.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.unhold_graveyard";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = false;
		this.m.VisibilityMult = 0.9;
		this.m.Resources = 500;
		this.m.OnEnter = "event.location.unhold_graveyard";
	}

	function onSpawned()
	{
		this.m.Name = "Unhold Graveyard";
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
		body.setBrush("world_unhold_graveyard");
	}

});


this.ancient_statue_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "Une immense statue scintillant au soleil qui domine le paysage environnant.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.ancient_statue";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = false;
		this.m.VisibilityMult = 1.0;
		this.m.Resources = 500;
		this.m.OnEnter = "event.location.ancient_statue";
	}

	function onSpawned()
	{
		this.m.Name = "Statue Ancienne";
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
		body.setBrush("world_ancient_statue");
	}

});


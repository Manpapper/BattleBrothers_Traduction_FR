this.sunken_library_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "Shimmering in the sun, golden domes peer out of the sand and give away that something larger lies dormant here, sunken and buried under the sand for ages.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.sunken_library";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = false;
		this.m.IsAttackable = true;
		this.m.VisibilityMult = 0.8;
		this.m.Resources = 500;
		this.m.OnEnter = "event.location.sunken_library_enter";
	}

	function onSpawned()
	{
		this.m.Name = "Sunken Library";
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
		body.setBrush("world_legendary_library");
	}

	function onDeserialize( _in )
	{
		this.location.onDeserialize(_in);
		this.setVisited(false);
	}

});


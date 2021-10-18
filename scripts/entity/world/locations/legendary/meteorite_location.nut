this.meteorite_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "A great crater in the ground made by a rock that fell from the sky. A mausoleum was built around it a long ago, and to this day people from all corners of the world set out to pilgrimage here.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.holy_site.meteorite";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = true;
		this.m.IsAttackable = false;
		this.m.IsDestructible = false;
		this.m.VisibilityMult = 0.8;
		this.m.Resources = 0;
		this.m.OnEnter = "event.location.meteorite_enter";
	}

	function onSpawned()
	{
		this.m.Name = "The Fallen Star";
		this.location.onSpawned();
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_holy_site_01");
		local banner = this.addSprite("banner");
		banner.setOffset(this.createVec(-60, 50));
	}

});


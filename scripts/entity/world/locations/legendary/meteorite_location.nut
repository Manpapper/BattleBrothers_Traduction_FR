this.meteorite_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "Un grand cratère dans le sol fait par un rocher tombé du ciel. Un mausolée a été construit autour il y a longtemps, et jusqu\'à ce jour, des gens de tous les coins du monde s\'y rendent en pèlerinage.";
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
		this.m.Name = "Étoile Tombée";
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


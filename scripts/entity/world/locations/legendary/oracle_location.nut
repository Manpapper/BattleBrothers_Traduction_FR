this.oracle_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "Les vestiges d'un temple qui abritait un oracle à une époque révolue. Bien qu'il soit aujourd'hui en ruine, les gens continuent à s'y rendre et à avoir des visions de choses qui vont se réaliser.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.holy_site.oracle";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = true;
		this.m.IsAttackable = false;
		this.m.IsDestructible = false;
		this.m.VisibilityMult = 0.8;
		this.m.Resources = 0;
		this.m.OnEnter = "event.location.oracle_enter";
	}

	function onSpawned()
	{
		this.m.Name = "L'Oracle";
		this.location.onSpawned();
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_holy_site_02");
		local banner = this.addSprite("banner");
		banner.setOffset(this.createVec(90, 80));
	}

});


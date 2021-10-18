this.witch_hut_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "A skewed and withered hut that looks like it could collapse at any moment. Smoke is rising from an awry chimney.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.witch_hut";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsShowingDefenders = true;
		this.m.IsShowingBanner = false;
		this.m.IsAttackable = true;
		this.m.VisibilityMult = 0.9;
		this.m.Resources = 500;
		this.m.OnEnter = "event.location.witchhut_enter";
		this.m.OnDestroyed = "event.location.witchhut_destroyed";
	}

	function onSpawned()
	{
		this.m.Name = "Witch Hut";
		this.location.onSpawned();

		for( local i = 0; i < 4; i = ++i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.Hexe
			}, false);
		}

		for( local i = 0; i < 2; i = ++i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.DirewolfBodyguard
			}, false);
		}

		for( local i = 0; i < 3; i = ++i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.SpiderBodyguard
			}, false);
		}

		for( local i = 0; i < 5; i = ++i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.DirewolfHIGH
			}, false);
		}

		for( local i = 0; i < 1; i = ++i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.UnholdBog
			}, false);
		}

		for( local i = 0; i < 1; i = ++i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.Unhold
			}, false);
		}

		for( local i = 0; i < 2; i = ++i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.Ghoul
			}, false);
		}

		for( local i = 0; i < 1; i = ++i )
		{
			this.Const.World.Common.addTroop(this, {
				Type = this.Const.World.Spawn.Troops.GhoulHIGH
			}, false);
		}
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
		body.setBrush("world_witch_hut");
	}

	function onDeserialize( _in )
	{
		this.location.onDeserialize(_in);
		this.m.IsAttackable = true;
	}

});


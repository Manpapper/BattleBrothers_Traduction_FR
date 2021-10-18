this.noble_camp_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "A sea of tents, host to the army of a noble house.";
	}

	function create()
	{
		this.location.create();
		this.m.Name = "Army Camp";
		this.m.TypeID = "location.noble_camp";
		this.m.LocationType = this.Const.World.LocationType.Passive;
		this.m.CombatLocation.Template[0] = "tactical.human_camp";
		this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.Palisade;
		this.m.CombatLocation.CutDownTrees = true;
		this.m.IsDespawningDefenders = false;
		this.setDefenderSpawnList(this.Const.World.Spawn.Noble);
		this.m.Resources = 300;
	}

	function onInit()
	{
		this.location.onInit();
		local banner = this.addSprite("banner");
		this.setSpriteOffset("banner", this.createVec(-8, 55));
		local body = this.addSprite("body");
		body.setBrush("noble_camp_01");
		local lighting = this.addSprite("lighting");
		lighting.setBrush("noble_camp_01_light");
		this.registerThinker();
	}

	function onFinish()
	{
		this.location.onFinish();
		this.unregisterThinker();
	}

	function onUpdate()
	{
		local lighting = this.getSprite("lighting");

		if (lighting.IsFadingDone)
		{
			if (lighting.Alpha == 0 && this.World.getTime().TimeOfDay >= 4 && this.World.getTime().TimeOfDay <= 7)
			{
				lighting.Color = this.createColor("ffffff00");

				if (this.World.getCamera().isInsideScreen(this.getPos(), 0))
				{
					lighting.fadeIn(5000);
				}
				else
				{
					lighting.Alpha = 255;
				}
			}
			else if (lighting.Alpha != 0 && this.World.getTime().TimeOfDay >= 0 && this.World.getTime().TimeOfDay <= 3)
			{
				if (this.World.getCamera().isInsideScreen(this.getPos(), 0))
				{
					lighting.fadeOut(4000);
				}
				else
				{
					lighting.Alpha = 0;
				}
			}
		}
	}

	function onSerialize( _out )
	{
		this.location.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.location.onDeserialize(_in);
	}

});


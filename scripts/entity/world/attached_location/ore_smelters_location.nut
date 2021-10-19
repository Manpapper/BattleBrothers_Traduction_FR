this.ore_smelters_location <- this.inherit("scripts/entity/world/attached_location", {
	m = {
		LastFireTime = 0
	},
	function create()
	{
		this.attached_location.create();
		this.m.Name = "Fonderies de Minerais";
		this.m.ID = "attached_location.ore_smelters";
		this.m.Description = "Les fonderies de minerai brûlant produisent des lingots de métal de haute qualité utilisés par les forgerons d\'armes compétents pour créer les armes les plus sophistiquées.";
		this.m.Sprite = "world_ore_smelters_01";
		this.m.SpriteDestroyed = "world_ore_smelters_01_ruins";
	}

	function getSounds( _all = true )
	{
		local r = [];

		if (this.World.getTime().IsDaytime)
		{
			r = [
				{
					File = "ambience/buildings/blacksmith_hot_water_00.wav",
					Volume = 1.0,
					Pitch = 1.0
				},
				{
					File = "ambience/buildings/blacksmith_hammering_00.wav",
					Volume = 1.0,
					Pitch = 1.0
				},
				{
					File = "ambience/buildings/blacksmith_hammering_01.wav",
					Volume = 1.0,
					Pitch = 1.0
				},
				{
					File = "ambience/buildings/blacksmith_hammering_02.wav",
					Volume = 1.0,
					Pitch = 1.0
				}
			];

			foreach( s in r )
			{
				s.Volume *= this.Const.Sound.Volume.Ambience / this.Const.Sound.Volume.AmbienceOutsideSettlement;
			}
		}

		return r;
	}

	function onUpdateDraftList( _list )
	{
		if (!this.isActive())
		{
			return;
		}

		_list.push("apprentice_background");
		_list.push("deserter_background");
	}

	function onUpdateShopList( _id, _list )
	{
		if (_id == "building.marketplace")
		{
			_list.push({
				R = 35,
				P = 1.0,
				S = "weapons/dagger"
			});
			_list.push({
				R = 25,
				P = 1.0,
				S = "supplies/armor_parts_item"
			});
		}
		else if (_id == "building.specialized_trader")
		{
		}
		else if (_id == "building.weaponsmith")
		{
			_list.push({
				R = 35,
				P = 1.0,
				S = "weapons/fighting_axe"
			});
			_list.push({
				R = 45,
				P = 1.0,
				S = "weapons/noble_sword"
			});
			_list.push({
				R = 45,
				P = 1.0,
				S = "weapons/warhammer"
			});
			_list.push({
				R = 35,
				P = 1.0,
				S = "weapons/flail"
			});
			_list.push({
				R = 45,
				P = 1.0,
				S = "weapons/greatsword"
			});
			_list.push({
				R = 35,
				P = 1.0,
				S = "weapons/warbrand"
			});
			_list.push({
				R = 40,
				P = 1.0,
				S = "weapons/greataxe"
			});
			_list.push({
				R = 50,
				P = 1.0,
				S = "weapons/longaxe"
			});
			_list.push({
				R = 50,
				P = 1.0,
				S = "weapons/two_handed_hammer"
			});
		}
		else if (_id == "building.armorsmith")
		{
		}
	}

	function onInit()
	{
		this.attached_location.onInit();
		this.registerThinker();
	}

	function onFinish()
	{
		this.attached_location.onFinish();
		this.unregisterThinker();
	}

	function onUpdate()
	{
		if (!this.m.IsActive)
		{
			return;
		}

		if (this.m.Settlement != null && this.m.Settlement.isDiscovered() && this.World.getTime().IsDaytime && this.Time.getRealTimeF() - this.m.LastFireTime >= 10.0)
		{
			this.m.LastFireTime = this.Time.getRealTimeF();
			local smoke = this.Const.World.SmelterSmokeParticles;

			for( local i = 0; i < smoke.len(); i = ++i )
			{
				this.World.spawnParticleEffect(smoke[i].Brushes, smoke[i].Delay, smoke[i].Quantity, smoke[i].LifeTime, smoke[i].SpawnRate, smoke[i].Stages, this.createVec(this.getPos().X - 30, this.getPos().Y - 25), -200 + this.Const.World.ZLevel.Particles);
			}
		}
	}

});


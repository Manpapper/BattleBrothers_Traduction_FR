this.militia_trainingcamp_location <- this.inherit("scripts/entity/world/attached_location", {
	m = {
		LastFireTime = 0
	},
	function create()
	{
		this.attached_location.create();
		this.m.Name = "Casernes de la Milice";
		this.m.ID = "attached_location.militia_trainingcamp";
		this.m.Description = "Un grand complexe de casernes de la milice. Ce camp transformera de simples paysans en soldats un peu plus compétents, capables de défendre leur maison et leurs proches.";
		this.m.Sprite = "world_militia_trainingcamp_01";
		this.m.SpriteDestroyed = "world_militia_trainingcamp_01_ruins";
		this.m.IsMilitary = true;
		this.m.IsScalingDefenders = false;
	}

	function getSounds( _all = true )
	{
		local r = [];

		if (this.World.getTime().IsDaytime)
		{
			r = [
				{
					File = "ambience/settlement/settlement_dog_00.wav",
					Volume = 1.0,
					Pitch = 1.0
				},
				{
					File = "ambience/settlement/settlement_dog_01.wav",
					Volume = 1.0,
					Pitch = 1.0
				},
				{
					File = "ambience/settlement/settlement_dog_02.wav",
					Volume = 1.0,
					Pitch = 1.0
				},
				{
					File = "ambience/settlement/fortification_yelling_00.wav",
					Volume = 1.0,
					Pitch = 1.0
				},
				{
					File = "ambience/settlement/fortification_yelling_01.wav",
					Volume = 1.0,
					Pitch = 1.0
				},
				{
					File = "ambience/settlement/fortification_yelling_02.wav",
					Volume = 1.0,
					Pitch = 1.0
				},
				{
					File = "ambience/settlement/fortification_yelling_03.wav",
					Volume = 1.0,
					Pitch = 1.0
				}
			];
			return r;
		}

		return r;
	}

	function onInit()
	{
		this.attached_location.onInit();
		this.getSprite("body").Scale = 0.9;
		this.getSprite("lighting").setBrush("world_militia_trainingcamp_01_light");
		this.getSprite("lighting").Scale = 0.9;
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

		this.updateLighting();

		if (this.World.getTime().TimeOfDay >= 4 && this.World.getTime().TimeOfDay <= 7 && this.Time.getRealTimeF() - this.m.LastFireTime >= 10.0)
		{
			this.spawnFire();
			this.m.LastFireTime = this.Time.getRealTimeF();
		}
	}

	function spawnFire()
	{
		local smoke = this.Const.World.CampSmokeParticles;

		for( local i = 0; i < smoke.len(); i = ++i )
		{
			this.World.spawnParticleEffect(smoke[i].Brushes, smoke[i].Delay, smoke[i].Quantity, smoke[i].LifeTime, smoke[i].SpawnRate, smoke[i].Stages, this.createVec(this.getPos().X + 5, this.getPos().Y - 25), -200 + this.Const.World.ZLevel.Particles, true);
		}

		local fire = this.Const.World.CampFireParticles;

		for( local i = 0; i < fire.len(); i = ++i )
		{
			this.World.spawnParticleEffect(fire[i].Brushes, fire[i].Delay, fire[i].Quantity, fire[i].LifeTime, fire[i].SpawnRate, fire[i].Stages, this.createVec(this.getPos().X + 5, this.getPos().Y - 25), -200 + this.Const.World.ZLevel.Particles - 3, true);
		}
	}

	function onUpdateDraftList( _list )
	{
		if (!this.isActive())
		{
			return;
		}

		_list.push("militia_background");
		_list.push("militia_background");
		_list.push("retired_soldier_background");
	}

	function onUpdateShopList( _id, _list )
	{
		if (_id == "building.marketplace")
		{
			_list.push({
				R = 30,
				P = 1.0,
				S = "armor/leather_tunic"
			});
			_list.push({
				R = 40,
				P = 1.0,
				S = "armor/padded_surcoat"
			});
			_list.push({
				R = 40,
				P = 1.0,
				S = "armor/padded_leather"
			});
			_list.push({
				R = 50,
				P = 1.0,
				S = "armor/gambeson"
			});
			_list.push({
				R = 10,
				P = 1.0,
				S = "helmets/aketon_cap"
			});
			_list.push({
				R = 15,
				P = 1.0,
				S = "helmets/full_aketon_cap"
			});
			_list.push({
				R = 60,
				P = 1.0,
				S = "helmets/nasal_helmet"
			});
			_list.push({
				R = 65,
				P = 1.0,
				S = "helmets/kettle_hat"
			});
			_list.push({
				R = 30,
				P = 1.0,
				S = "shields/wooden_shield"
			});
			_list.push({
				R = 50,
				P = 1.0,
				S = "weapons/hooked_blade"
			});
			_list.push({
				R = 60,
				P = 1.0,
				S = "weapons/scramasax"
			});
			_list.push({
				R = 70,
				P = 1.0,
				S = "weapons/boar_spear"
			});
			_list.push({
				R = 70,
				P = 1.0,
				S = "weapons/dagger"
			});

			if (this.Const.DLC.Unhold)
			{
				_list.extend([
					{
						R = 70,
						P = 1.0,
						S = "weapons/two_handed_wooden_hammer"
					},
					{
						R = 40,
						P = 1.0,
						S = "weapons/goedendag"
					},
					{
						R = 20,
						P = 1.0,
						S = "weapons/throwing_spear"
					}
				]);
			}
		}
		else if (_id == "building.specialized_trader")
		{
		}
		else if (_id == "building.weaponsmith")
		{
		}
		else if (_id == "building.armorsmith")
		{
		}
	}

});


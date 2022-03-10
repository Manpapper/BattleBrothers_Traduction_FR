this.fortified_outpost_location <- this.inherit("scripts/entity/world/attached_location", {
	m = {
		LastFireTime = 0
	},
	function create()
	{
		this.attached_location.create();
		this.m.Name = "Caserne";
		this.m.ID = "attached_location.fortified_outpost";
		this.m.Description = "De grandes casernes abritant une foule de soldats professionnels.";
		this.m.Sprite = "world_fortified_outpost_01";
		this.m.SpriteDestroyed = "world_fortified_outpost_01_ruins";
		this.m.IsMilitary = true;
		this.m.IsScalingDefenders = true;
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
		}

		return r;
	}

	function onInit()
	{
		this.attached_location.onInit();
		this.getSprite("body").Scale = 0.9;
		this.getSprite("lighting").setBrush("world_fortified_outpost_01_light");
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
			this.World.spawnParticleEffect(smoke[i].Brushes, smoke[i].Delay, smoke[i].Quantity, smoke[i].LifeTime, smoke[i].SpawnRate, smoke[i].Stages, this.createVec(this.getPos().X + 32, this.getPos().Y - 41), -200 + this.Const.World.ZLevel.Particles, true);
		}

		local fire = this.Const.World.CampFireParticles;

		for( local i = 0; i < fire.len(); i = ++i )
		{
			this.World.spawnParticleEffect(fire[i].Brushes, fire[i].Delay, fire[i].Quantity, fire[i].LifeTime, fire[i].SpawnRate, fire[i].Stages, this.createVec(this.getPos().X + 32, this.getPos().Y - 41), -200 + this.Const.World.ZLevel.Particles - 3, true);
		}
	}

	function onUpdateDraftList( _list )
	{
		if (!this.isActive())
		{
			return;
		}

		_list.push("retired_soldier_background");
		_list.push("deserter_background");
		_list.push("sellsword_background");
		_list.push("hedge_knight_background");
		_list.push("paladin_background");
	}

	function onUpdateShopList( _id, _list )
	{
		if (_id == "building.marketplace")
		{
			_list.push({
				R = 60,
				P = 1.0,
				S = "accessory/wardog_item"
			});
			_list.push({
				R = 60,
				P = 1.0,
				S = "accessory/armored_wardog_item"
			});
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
				R = 60,
				P = 1.0,
				S = "armor/basic_mail_shirt"
			});
			_list.push({
				R = 70,
				P = 1.0,
				S = "armor/mail_shirt"
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
				R = 65,
				P = 1.0,
				S = "helmets/flat_top_helmet"
			});
			_list.push({
				R = 30,
				P = 1.0,
				S = "shields/wooden_shield"
			});
			_list.push({
				R = 70,
				P = 1.0,
				S = "weapons/dagger"
			});
			_list.push({
				R = 70,
				P = 1.0,
				S = "weapons/billhook"
			});
			_list.push({
				R = 70,
				P = 1.0,
				S = "weapons/pike"
			});
			_list.push({
				R = 60,
				P = 1.0,
				S = "weapons/military_cleaver"
			});
			_list.push({
				R = 70,
				P = 1.0,
				S = "weapons/boar_spear"
			});
			_list.push({
				R = 70,
				P = 1.0,
				S = "weapons/military_pick"
			});
			_list.push({
				R = 50,
				P = 1.0,
				S = "helmets/padded_nasal_helmet"
			});
			_list.push({
				R = 55,
				P = 1.0,
				S = "helmets/padded_kettle_hat"
			});
			_list.push({
				R = 60,
				P = 1.0,
				S = "helmets/padded_flat_top_helmet"
			});
			_list.push({
				R = 50,
				P = 1.0,
				S = "armor/leather_lamellar"
			});
			_list.push({
				R = 65,
				P = 1.0,
				S = "armor/mail_hauberk"
			});
			_list.push({
				R = 50,
				P = 1.0,
				S = "weapons/crossbow"
			});
			_list.push({
				R = 50,
				P = 1.0,
				S = "weapons/light_crossbow"
			});
			_list.push({
				R = 10,
				P = 1.0,
				S = "ammo/quiver_of_bolts"
			});

			if (this.Const.DLC.Unhold)
			{
				_list.extend([
					{
						R = 75,
						P = 1.0,
						S = "weapons/longsword"
					},
					{
						R = 75,
						P = 1.0,
						S = "weapons/two_handed_wooden_flail"
					},
					{
						R = 55,
						P = 1.0,
						S = "weapons/polehammer"
					},
					{
						R = 55,
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
			_list.push({
				R = 20,
				P = 1.0,
				S = "weapons/military_pick"
			});
		}
		else if (_id == "building.armorsmith")
		{
		}
	}

});


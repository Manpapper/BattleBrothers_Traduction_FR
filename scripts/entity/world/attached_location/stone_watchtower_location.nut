this.stone_watchtower_location <- this.inherit("scripts/entity/world/attached_location", {
	m = {},
	function create()
	{
		this.attached_location.create();
		this.m.Name = "Tour de Guet en Pierre";
		this.m.ID = "attached_location.stone_watchtower";
		this.m.Description = "Une tour de guet en pierre occupée par des soldats bien entraînés qui montent la garde.";
		this.m.Sprite = "world_stone_watchtower_01";
		this.m.SpriteDestroyed = "world_stone_watchtower_01_ruins";
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
			return r;
		}

		return r;
	}

	function onUpdateDraftList( _list )
	{
		if (!this.isActive())
		{
			return;
		}

		_list.push("retired_soldier_background");
		_list.push("deserter_background");
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
				S = "weapons/billhook"
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
				R = 50,
				P = 1.0,
				S = "weapons/crossbow"
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
						R = 80,
						P = 1.0,
						S = "weapons/two_handed_wooden_flail"
					},
					{
						R = 80,
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

	function onInit()
	{
		this.attached_location.onInit();
		this.getSprite("lighting").setBrush("world_stone_watchtower_01_light");
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
	}

});


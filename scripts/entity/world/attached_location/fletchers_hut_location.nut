this.fletchers_hut_location <- this.inherit("scripts/entity/world/attached_location", {
	m = {},
	function create()
	{
		this.attached_location.create();
		this.m.Name = "Cabanon du fabricant de flèches";
		this.m.ID = "attached_location.fletchers_hut";
		this.m.Description = "Les fabricants de flèches dans ces cabanes produisent toutes sortes de munitions à distance qu\'ils vendent ensuite à la colonie la plus proche.";
		this.m.Sprite = "world_fletchers_hut_01";
		this.m.SpriteDestroyed = "world_fletchers_hut_01_ruins";
	}

	function getSounds( _all = true )
	{
		local r = [];

		if (this.World.getTime().IsDaytime)
		{
			r = [
				{
					File = "ambience/settlement/settlement_saw_00.wav",
					Volume = 1.0,
					Pitch = 1.0
				},
				{
					File = "ambience/settlement/settlement_saw_01.wav",
					Volume = 1.0,
					Pitch = 1.0
				},
				{
					File = "ambience/settlement/settlement_building_00.wav",
					Volume = 1.0,
					Pitch = 1.0
				},
				{
					File = "ambience/settlement/settlement_building_01.wav",
					Volume = 1.0,
					Pitch = 1.0
				},
				{
					File = "ambience/settlement/settlement_building_02.wav",
					Volume = 1.0,
					Pitch = 1.0
				},
				{
					File = "ambience/settlement/settlement_building_03.wav",
					Volume = 1.0,
					Pitch = 1.0
				},
				{
					File = "ambience/settlement/settlement_building_03.wav",
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

	function onUpdateProduce( _list )
	{
		_list.push("supplies/ammo_item");
	}

	function onUpdateDraftList( _list )
	{
		if (!this.isActive())
		{
			return;
		}

		_list.push("hunter_background");
		_list.push("bowyer_background");
		_list.push("bowyer_background");
		_list.push("poacher_background");
		_list.push("witchhunter_background");
	}

	function onUpdateShopList( _id, _list )
	{
		if (_id == "building.marketplace")
		{
			_list.push({
				R = 10,
				P = 1.0,
				S = "weapons/short_bow"
			});
			_list.push({
				R = 0,
				P = 0.8,
				S = "ammo/quiver_of_arrows"
			});
			_list.push({
				R = 0,
				P = 0.8,
				S = "ammo/quiver_of_bolts"
			});
			_list.push({
				R = 0,
				P = 0.8,
				S = "supplies/ammo_item"
			});
		}
		else if (_id == "building.specialized_trader")
		{
		}
		else if (_id == "building.fletcher")
		{
			_list.push({
				R = 20,
				P = 1.0,
				S = "weapons/hunting_bow"
			});
			_list.push({
				R = 20,
				P = 1.0,
				S = "weapons/light_crossbow"
			});
		}
		else if (_id == "building.armorsmith")
		{
		}
	}

});


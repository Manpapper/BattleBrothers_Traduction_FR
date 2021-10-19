this.pig_farm_location <- this.inherit("scripts/entity/world/attached_location", {
	m = {},
	function create()
	{
		this.attached_location.create();
		this.m.Name = "Porcherie";
		this.m.ID = "attached_location.pig_farm";
		this.m.Description = "L\'odeur de cette porcherie est tout aussi distincte que les bruits de couinement provenant des fosses boueuses. Les côtelettes de porc produites ici sont généralement vendues dans la colonie voisine.";
		this.m.Sprite = "world_pig_farm_01";
		this.m.SpriteDestroyed = "world_pig_farm_01_ruins";
	}

	function getSounds( _all = true )
	{
		local r = [];

		if (this.World.getTime().IsDaytime)
		{
			r = [
				{
					File = "ambience/buildings/market_pig_00.wav",
					Volume = 1.0,
					Pitch = 1.0
				},
				{
					File = "ambience/buildings/market_pig_01.wav",
					Volume = 1.0,
					Pitch = 1.0
				},
				{
					File = "ambience/buildings/market_pig_02.wav",
					Volume = 1.0,
					Pitch = 1.0
				},
				{
					File = "ambience/buildings/market_pig_03.wav",
					Volume = 1.0,
					Pitch = 1.0
				},
				{
					File = "ambience/buildings/market_pig_04.wav",
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
		_list.push("supplies/smoked_ham_item");
	}

	function onUpdateDraftList( _list )
	{
		if (!this.isActive())
		{
			return;
		}

		_list.push("butcher_background");
		_list.push("daytaler_background");
		_list.push("daytaler_background");
		_list.push("farmhand_background");
		_list.push("farmhand_background");
		_list.push("farmhand_background");
	}

	function onUpdateShopList( _id, _list )
	{
		if (_id == "building.marketplace")
		{
			_list.push({
				R = 0,
				P = 1.0,
				S = "supplies/smoked_ham_item"
			});
			_list.push({
				R = 10,
				P = 1.0,
				S = "weapons/butchers_cleaver"
			});
			_list.push({
				R = 20,
				P = 1.0,
				S = "armor/butcher_apron"
			});
		}
	}

	function onInit()
	{
		this.attached_location.onInit();
		this.getSprite("body").Scale = 0.9;
	}

});


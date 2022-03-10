this.herbalists_grove_location <- this.inherit("scripts/entity/world/attached_location", {
	m = {},
	function create()
	{
		this.attached_location.create();
		this.m.Name = "Bosquet de l\'Herboriste";
		this.m.ID = "attached_location.herbalists_grove";
		this.m.Description = "Dans ce bosquet isolé, l\'herboriste averti recueille toutes sortes de plantes et de racines médicinales.";
		this.m.Sprite = "world_herbalists_grove_01";
		this.m.SpriteDestroyed = "world_herbalists_grove_01_ruins";
		this.m.IsConnected = false;
	}

	function onUpdateProduce( _list )
	{
		_list.push("supplies/medicine_item");
	}

	function onUpdateDraftList( _list )
	{
		if (!this.isActive())
		{
			return;
		}

		_list.push("monk_background");
		_list.push("flagellant_background");
		_list.push("anatomist_background");
	}

	function onUpdateShopList( _id, _list )
	{
		if (_id == "building.marketplace")
		{
			_list.push({
				R = 0,
				P = 1.0,
				S = "supplies/medicine_item"
			});
			_list.push({
				R = 0,
				P = 1.0,
				S = "accessory/bandage_item"
			});
			_list.push({
				R = 50,
				P = 1.0,
				S = "accessory/antidote_item"
			});
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


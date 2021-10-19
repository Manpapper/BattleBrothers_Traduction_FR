this.mushroom_grove_location <- this.inherit("scripts/entity/world/attached_location", {
	m = {},
	function create()
	{
		this.attached_location.create();
		this.m.Name = "Bosquet à champignons";
		this.m.ID = "attached_location.mushroom_grove";
		this.m.Description = "Cachés dans la boue et les roseaux, les cueilleurs experts peuvent trouver des bosquets et des grottes remplis de champignons précieux comme ceux-ci.";
		this.m.Sprite = "world_mushroom_grove_01";
		this.m.SpriteDestroyed = "world_mushroom_grove_01_ruins";
	}

	function onUpdateProduce( _list )
	{
		_list.push("supplies/pickled_mushrooms_item");
	}

	function onUpdateDraftList( _list )
	{
		if (!this.isActive())
		{
			return;
		}

		_list.push("cultist_background");
		_list.push("cultist_background");
		_list.push("flagellant_background");
		_list.push("wildman_background");
	}

	function onUpdateShopList( _id, _list )
	{
		if (_id == "building.marketplace")
		{
			_list.push({
				R = 0,
				P = 1.0,
				S = "supplies/pickled_mushrooms_item"
			});
			_list.push({
				R = 20,
				P = 1.0,
				S = "armor/apron"
			});
			_list.push({
				R = 20,
				P = 1.0,
				S = "supplies/medicine_item"
			});
			_list.push({
				R = 50,
				P = 1.0,
				S = "accessory/berserker_mushrooms_item"
			});
		}
	}

});


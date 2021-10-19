this.fishing_huts_oriental_location <- this.inherit("scripts/entity/world/attached_location/fishing_huts_location", {
	m = {},
	function create()
	{
		this.fishing_huts_location.create();
		this.m.Sprite = "world_southern_fishing_huts";
		this.m.SpriteDestroyed = "world_southern_fishing_huts_ruins";
	}

	function onUpdateProduce( _list )
	{
		_list.push("supplies/dried_fish_item");
	}

	function onUpdateDraftList( _list )
	{
		if (!this.isActive())
		{
			return;
		}

		_list.push("fisherman_southern_background");
		_list.push("fisherman_southern_background");
		_list.push("fisherman_southern_background");
		_list.push("fisherman_southern_background");
	}

	function onUpdateShopList( _id, _list )
	{
		if (_id == "building.marketplace")
		{
			_list.push({
				R = 0,
				P = 1.0,
				S = "supplies/dried_fish_item"
			});
			_list.push({
				R = 20,
				P = 1.0,
				S = "weapons/militia_spear"
			});
			_list.push({
				R = 10,
				P = 1.0,
				S = "tools/throwing_net"
			});
			_list.push({
				R = 20,
				P = 1.0,
				S = "tools/throwing_net"
			});
		}
	}

});


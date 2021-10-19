this.incense_dryer_location <- this.inherit("scripts/entity/world/attached_location", {
	m = {},
	function create()
	{
		this.attached_location.create();
		this.m.Name = "Séchoir à Encens";
		this.m.ID = "attached_location.incense_dryer";
		this.m.Description = "La sève des arbres environnants est recueillie et séchée au soleil pour créer le précieux encens.";
		this.m.Sprite = "world_incense_01";
		this.m.SpriteDestroyed = "world_incense_01_ruins";
	}

	function onBuild()
	{
		local myTile = this.getTile();
		myTile.setBrush("world_desert_0" + this.Math.rand(6, 9));
		return true;
	}

	function onUpdateProduce( _list )
	{
		_list.push("trade/incense_item");
	}

	function onUpdateDraftList( _list )
	{
		if (!this.isActive())
		{
			return;
		}

		_list.push("daytaler_southern_background");
		_list.push("daytaler_southern_background");
	}

	function onUpdateShopList( _id, _list )
	{
		if (_id == "building.marketplace")
		{
			_list.push({
				R = 0,
				P = 1.0,
				S = "trade/incense_item"
			});
		}
	}

});


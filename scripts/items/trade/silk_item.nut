this.silk_item <- this.inherit("scripts/items/trade/trading_good_item", {
	m = {},
	function create()
	{
		this.trading_good_item.create();
		this.m.ID = "misc.silk";
		this.m.Name = "Silk";
		this.m.Description = "These smooth silk cloth pieces are very hard to come by. Only the most wealthy and noble can afford to get their garments tailored from it, and they fetch good prices especially in the north.";
		this.m.Icon = "trade/inventory_trade_11.png";
		this.m.Culture = this.Const.World.Culture.Southern;
		this.m.ProducingBuildings = [
			"attached_location.silk_farm"
		];
		this.m.Value = 460;
	}

});


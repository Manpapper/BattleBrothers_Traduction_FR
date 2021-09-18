this.peat_bricks_item <- this.inherit("scripts/items/trade/trading_good_item", {
	m = {},
	function create()
	{
		this.trading_good_item.create();
		this.m.ID = "misc.peat_bricks";
		this.m.Name = "Peat Bricks";
		this.m.Description = "Bricks made from dried peat, usually used as fuel. Traders will pay good coin for this.";
		this.m.Icon = "trade/inventory_trade_08.png";
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.ProducingBuildings = [
			"attached_location.peat_pit"
		];
		this.m.Value = 100;
	}

});


this.salt_item <- this.inherit("scripts/items/trade/trading_good_item", {
	m = {},
	function create()
	{
		this.trading_good_item.create();
		this.m.ID = "misc.salt";
		this.m.Name = "Salt";
		this.m.Description = "Rock salt used for cooking and curing food. Traders will pay good coin for this.";
		this.m.Icon = "trade/inventory_trade_03.png";
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.ProducingBuildings = [
			"attached_location.salt_mine"
		];
		this.m.Value = 340;
	}

});


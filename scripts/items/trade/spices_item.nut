this.spices_item <- this.inherit("scripts/items/trade/trading_good_item", {
	m = {},
	function create()
	{
		this.trading_good_item.create();
		this.m.ID = "misc.spices";
		this.m.Name = "Spices";
		this.m.Description = "Various flavorful and rare spices heeding from the southern realms. These ingredients are highly sought after in the north.";
		this.m.Icon = "trade/inventory_trade_10.png";
		this.m.Culture = this.Const.World.Culture.Southern;
		this.m.ProducingBuildings = [
			"attached_location.plantation"
		];
		this.m.Value = 320;
	}

});


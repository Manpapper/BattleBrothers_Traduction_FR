this.copper_ingots_item <- this.inherit("scripts/items/trade/trading_good_item", {
	m = {},
	function create()
	{
		this.trading_good_item.create();
		this.m.ID = "misc.copper_ingots";
		this.m.Name = "Copper Ingots";
		this.m.Description = "Copper smolten and cast into ingots for easy transportation. Traders will pay good coin for this.";
		this.m.Icon = "trade/inventory_trade_07.png";
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.ProducingBuildings = [
			"attached_location.surface_copper_vein"
		];
		this.m.Value = 220;
	}

});


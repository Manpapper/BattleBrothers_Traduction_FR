this.amber_shards_item <- this.inherit("scripts/items/trade/trading_good_item", {
	m = {},
	function create()
	{
		this.trading_good_item.create();
		this.m.ID = "misc.amber_shards";
		this.m.Name = "Éclats d\'ambre";
		this.m.Description = "Des éclats d\'ambre qui sont principalement utilisés pour les colliers et les bagues. Les commerçants paieront une belle somme pour cela.";
		this.m.Icon = "trade/inventory_trade_04.png";
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.ProducingBuildings = [
			"attached_location.amber_collector"
		];
		this.m.Value = 260;
	}

});


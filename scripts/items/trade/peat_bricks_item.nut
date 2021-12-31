this.peat_bricks_item <- this.inherit("scripts/items/trade/trading_good_item", {
	m = {},
	function create()
	{
		this.trading_good_item.create();
		this.m.ID = "misc.peat_bricks";
		this.m.Name = "Briques de tourbe";
		this.m.Description = "Briques fabriquées à partir de tourbe séchée, généralement utilisée comme combustible. Les commerçants paieront une modique somme pour cela.";
		this.m.Icon = "trade/inventory_trade_08.png";
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.ProducingBuildings = [
			"attached_location.peat_pit"
		];
		this.m.Value = 100;
	}

});


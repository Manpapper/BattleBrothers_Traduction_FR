this.spices_item <- this.inherit("scripts/items/trade/trading_good_item", {
	m = {},
	function create()
	{
		this.trading_good_item.create();
		this.m.ID = "misc.spices";
		this.m.Name = "Épices";
		this.m.Description = "Diverses épices savoureuses et rares venant des royaumes du sud. Ces ingrédients sont très recherchés dans le nord.";
		this.m.Icon = "trade/inventory_trade_10.png";
		this.m.Culture = this.Const.World.Culture.Southern;
		this.m.ProducingBuildings = [
			"attached_location.plantation"
		];
		this.m.Value = 320;
	}

});


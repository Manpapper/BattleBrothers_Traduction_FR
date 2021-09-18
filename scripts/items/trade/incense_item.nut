this.incense_item <- this.inherit("scripts/items/trade/trading_good_item", {
	m = {},
	function create()
	{
		this.trading_good_item.create();
		this.m.ID = "misc.incense";
		this.m.Name = "Incense";
		this.m.Description = "These dried tree sap pieces create a thick smoke filled with mysterious and exotic scents. Will fetch good prices especially in the north.";
		this.m.Icon = "trade/inventory_trade_12.png";
		this.m.Culture = this.Const.World.Culture.Southern;
		this.m.ProducingBuildings = [
			"attached_location.incense_dryer"
		];
		this.m.Value = 380;
	}

	function getSellPriceMult()
	{
		return this.World.State.getCurrentTown().getModifiers().IncensePriceMult;
	}

	function getBuyPriceMult()
	{
		return this.World.State.getCurrentTown().getModifiers().IncensePriceMult;
	}

});


this.salt_item <- this.inherit("scripts/items/trade/trading_good_item", {
	m = {},
	function create()
	{
		this.trading_good_item.create();
		this.m.ID = "misc.salt";
		this.m.Name = "Sel";
		this.m.Description = "Sel en cristaux utilisé pour la cuisson et le durcissement des aliments. Les commerçants paieront une belle somme pour cela.";
		this.m.Icon = "trade/inventory_trade_03.png";
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.ProducingBuildings = [
			"attached_location.salt_mine"
		];
		this.m.Value = 340;
	}

});


this.silk_item <- this.inherit("scripts/items/trade/trading_good_item", {
	m = {},
	function create()
	{
		this.trading_good_item.create();
		this.m.ID = "misc.silk";
		this.m.Name = "Soie";
		this.m.Description = "Ces pièces en tissu de soie lisse sont très difficiles à trouver. Seuls les plus riches et les plus nobles peuvent se permettre d\'en faire confectionner leurs vêtements, vous en obtiendrez un bon prix, surtout dans le nord..";
		this.m.Icon = "trade/inventory_trade_11.png";
		this.m.Culture = this.Const.World.Culture.Southern;
		this.m.ProducingBuildings = [
			"attached_location.silk_farm"
		];
		this.m.Value = 460;
	}

});


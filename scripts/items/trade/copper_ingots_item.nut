this.copper_ingots_item <- this.inherit("scripts/items/trade/trading_good_item", {
	m = {},
	function create()
	{
		this.trading_good_item.create();
		this.m.ID = "misc.copper_ingots";
		this.m.Name = "Lingots de cuivre";
		this.m.Description = "Cuivre fondu et coulé en lingots pour un transport facile. Les commerçants paieront une belle somme pour cela.";
		this.m.Icon = "trade/inventory_trade_07.png";
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.ProducingBuildings = [
			"attached_location.surface_copper_vein"
		];
		this.m.Value = 220;
	}

});


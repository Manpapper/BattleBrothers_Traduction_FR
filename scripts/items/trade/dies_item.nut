this.dies_item <- this.inherit("scripts/items/trade/trading_good_item", {
	m = {},
	function create()
	{
		this.trading_good_item.create();
		this.m.ID = "misc.dies";
		this.m.Name = "Teintures";
		this.m.Description = "Colorants précieux fabriqués à partir de diverses plantes ou minéraux. Les commerçants paieront une bBois de haute qualité sans noeuds ni autres défauts. Les commerçants paieront une belle somme pour cela.";
		this.m.Icon = "trade/inventory_trade_02.png";
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.ProducingBuildings = [
			"attached_location.dye_maker"
		];
		this.m.Value = 400;
	}

});


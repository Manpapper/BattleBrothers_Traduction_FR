this.uncut_gems_item <- this.inherit("scripts/items/trade/trading_good_item", {
	m = {},
	function create()
	{
		this.trading_good_item.create();
		this.m.ID = "misc.uncut_gems";
		this.m.Name = "Gemmes non taillées";
		this.m.Description = "Pierres précieuses brutes attendant d\'être taillées et polies. Les commerçants paieront une belle somme pour cela.";
		this.m.Icon = "trade/inventory_trade_06.png";
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.ProducingBuildings = [
			"attached_location.gem_mine"
		];
		this.m.Value = 520;
	}

});


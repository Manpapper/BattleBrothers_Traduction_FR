this.trade_jug_02_item <- this.inherit("scripts/items/special/trade_jug_01_item", {
	m = {},
	function create()
	{
		this.trade_jug_01_item.create();
		this.m.Icon = "consumables/jug_02.png";
	}

});


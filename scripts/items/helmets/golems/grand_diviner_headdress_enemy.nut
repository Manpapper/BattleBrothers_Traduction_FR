this.grand_diviner_headdress_enemy <- this.inherit("scripts/items/helmets/golems/grand_diviner_headdress", {
	m = {},
	function create()
	{
		this.grand_diviner_headdress.create();
		this.m.IsDroppedAsLoot = false;
	}

});


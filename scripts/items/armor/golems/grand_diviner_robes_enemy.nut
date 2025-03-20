this.grand_diviner_robes_enemy <- this.inherit("scripts/items/armor/golems/grand_diviner_robes", {
	m = {},
	function create()
	{
		this.grand_diviner_robes.create();
		this.m.IsDroppedAsLoot = false;
	}

});


this.ghoul_teeth_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.ghoul_teeth";
		this.m.Name = "Jagged Fangs";
		this.m.Description = "A handful of jagged fangs taken from a Nachzehrer. Infected with rot but hard enough to chew through any bone. Might fetch some coin from alchemists on the market place.";
		this.m.Icon = "misc/inventory_ghoul_teeth_01.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 200;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

});


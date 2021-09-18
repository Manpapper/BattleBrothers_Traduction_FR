this.ghoul_horn_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.ghoul_horn";
		this.m.Name = "Nachzehrer Horn";
		this.m.Description = "Nachzehrers can grow impressive horns, and these in turn make for impressive trophies.";
		this.m.Icon = "misc/inventory_ghoul_horn.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 375;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

});


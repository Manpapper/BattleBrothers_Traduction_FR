this.unhold_heart_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.unhold_heart";
		this.m.Name = "Unhold\'s Heart";
		this.m.Description = "The large and heavy heart of an Unhold. Rumored to have magical properties, alchemists are prepared to pay a tidy sum to get it into their hands.";
		this.m.Icon = "misc/inventory_unhold_01.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 1125;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/enemies/unhold_regenerate_01.wav", this.Const.Sound.Volume.Inventory);
	}

});


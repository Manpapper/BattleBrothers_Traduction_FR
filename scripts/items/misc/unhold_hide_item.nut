this.unhold_hide_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.unhold_hide";
		this.m.Name = "Unhold Hide";
		this.m.Description = "Hide is the basis of most armors, and this thick hide taken from an Unhold is especially sturdy.";
		this.m.Icon = "misc/inventory_unhold_hide.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 1000;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

});


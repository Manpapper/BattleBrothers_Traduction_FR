this.werewolf_pelt_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.werewolf_pelt";
		this.m.Name = "Unusually Large Wolf Pelt";
		this.m.Description = "A thick and unusually large wolf pelt that should fetch a decent price at the market.";
		this.m.Icon = "misc/inventory_wolfpelt_01.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 500;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

});


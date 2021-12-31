this.legendary_sword_grip_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.legendary_sword_grip";
		this.m.Name = "Pommeau d\'épée";
		this.m.Description = "Une poignée d\'épée magistralement conçue recouverte de mystérieuses pierres bleues. Les pierres semblent avoir une lumière scintillante émergeant du plus profond de l\'intérieur. Peut-être que l\'épée pourrait être reforgée si vous aviez les deux parties.";
		this.m.Icon = "misc/inventory_sword_hilt_01.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 2500;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

});


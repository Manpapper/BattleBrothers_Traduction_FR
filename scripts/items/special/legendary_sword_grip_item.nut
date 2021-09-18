this.legendary_sword_grip_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.legendary_sword_grip";
		this.m.Name = "Sword Grip";
		this.m.Description = "A masterfully crafted sword grip covered in mysterious blue stones. The stones seem to have a glimmering light emerging from deep within. Perhaps the sword could be reforged if you had both parts.";
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


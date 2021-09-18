this.mysterious_herbs_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.mysterious_herbs";
		this.m.Name = "Mysterious Herbs";
		this.m.Description = "These herbs do not look or smell like any known to you. Their scent is intriguing and appalling at the same time.";
		this.m.Icon = "misc/inventory_hexe_herbs.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 1650;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

});


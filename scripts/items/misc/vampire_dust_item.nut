this.vampire_dust_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.vampire_dust";
		this.m.Name = "Shimmering Ashes";
		this.m.Description = "A small heap of ashes shimmering in many facets of blue. Allegedly it\'s the remains of a powerful undead creature, but few people would believe a claim like this.";
		this.m.Icon = "misc/inventory_vampire_dust_01.png";
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


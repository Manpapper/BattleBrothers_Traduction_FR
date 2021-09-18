this.legendary_sword_blade_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.legendary_sword_blade";
		this.m.Name = "Sword Blade";
		this.m.Description = "The glimmering blade of a broken sword you retrieved from the Kraken. In all your years of fighting you never encountered such a masterfully crafted blade. Perhaps the sword could be reforged if you had both parts.";
		this.m.Icon = "misc/inventory_sword_blade_01.png";
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


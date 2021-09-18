this.frost_unhold_fur_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.frost_unhold_fur";
		this.m.Name = "Thick White Fur";
		this.m.Description = "Thick white fur formerly belonging to an Unhold of the frozen north.";
		this.m.Icon = "misc/inventory_unhold_frost_fur_01.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 1500;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

});


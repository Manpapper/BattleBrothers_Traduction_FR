this.unhold_bones_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.unhold_bones";
		this.m.Name = "Giant Skull and Bones";
		this.m.Description = "These large bones taken from an Unhold are a valued trophy among beast hunters.";
		this.m.Icon = "misc/inventory_unhold_bones.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 1125;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

});


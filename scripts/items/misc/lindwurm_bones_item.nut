this.lindwurm_bones_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.lindwurm_bones";
		this.m.Name = "Lindwurm Bones";
		this.m.Description = "The bones of the Lindwurm are mostly hollow from the inside, making them an easy to carry trophy despite their size.";
		this.m.Icon = "misc/inventory_lindwurm_bones.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 2200;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

});


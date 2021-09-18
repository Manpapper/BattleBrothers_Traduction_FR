this.lindwurm_scales_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.lindwurm_scales";
		this.m.Name = "Lindwurm Scales";
		this.m.Description = "The shimmering green scales of a Lindwurm are among the most reputable trophies a beast hunter can bring home from his adventures.";
		this.m.Icon = "misc/inventory_lindwurm_scales.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 3000;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

});


this.lindwurm_blood_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.lindwurm_blood";
		this.m.Name = "Lindwurm Blood";
		this.m.Description = "The corroding blood of a Lindwurm that eats away at metal in no time. Luckily it can be safely transported in glass vials.";
		this.m.Icon = "misc/inventory_lindwurm_blood.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 2000;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

});


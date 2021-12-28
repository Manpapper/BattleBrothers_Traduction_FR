this.lindwurm_blood_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.lindwurm_blood";
		this.m.Name = "Sang de Lindwurm";
		this.m.Description = "Le sang corrosif d\'un Lindwurm qui ronge le métal en un rien de temps. Heureusement, il peut être transporté en toute sécurité dans des flacons en verre.";
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


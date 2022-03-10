this.heart_of_the_forest_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.heart_of_the_forest";
		this.m.Name = "Cœur de la forêt";
		this.m.Description = "Une partie de plante épineuse, ressemblant à un coeur humain.";
		this.m.Icon = "misc/inventory_schrat_heart.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 3250;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

});


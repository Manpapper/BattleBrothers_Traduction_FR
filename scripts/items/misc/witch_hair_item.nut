this.witch_hair_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.witch_hair";
		this.m.Name = "Cheveux de sorcière";
		this.m.Description = "Des mèches longues et cassantes de cheveux grisâtres provenant d\'une Hexen. On dit que leurs cheveux ont de puissantes propriétés pour créer des potions et des élixirs. Mais là encore, il est également dit que les Hexen gardent les organes génitaux de leurs victimes comme animaux de compagnie, donc les informations obtenues de la paysannerie pourraient ne pas être particulièrement fiables.";
		this.m.Icon = "misc/inventory_hexe_hair.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 2000;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/cloth_01.wav", this.Const.Sound.Volume.Inventory);
	}

});


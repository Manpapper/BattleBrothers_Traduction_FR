this.witch_hair_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.witch_hair";
		this.m.Name = "Witch Hair";
		this.m.Description = "Long and brittle strands of greyish hair taken from a Hexe. Their hair is said to have powerful properties in creating potions and elixirs. But then again, it\'s also said that Hexen keep the genitals of their victims as pets, so information attained from the peasantry might not be especially reliable.";
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


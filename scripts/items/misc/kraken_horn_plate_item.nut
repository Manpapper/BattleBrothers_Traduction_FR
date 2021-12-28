this.kraken_horn_plate_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.kraken_horn_plate";
		this.m.Name = "Plaque de corne";
		this.m.Description = "Tirée de la tête du légendaire kraken, cette grande et dure plaque en corne est un trophée que peu de gens dans ce monde peuvent revendiquer.";
		this.m.Icon = "misc/inventory_kraken_plate.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 4000;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

});


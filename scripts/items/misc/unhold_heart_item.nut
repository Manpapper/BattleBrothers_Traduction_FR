this.unhold_heart_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.unhold_heart";
		this.m.Name = "Coeur d\'Unhold";
		this.m.Description = "Le coeur gros et lourd d\'un Unhold. La rumeur dit qu\'ils ont des propriétés magiques, les alchimistes sont prêts à payer une somme rondelette pour l\'avoir entre leurs mains.";
		this.m.Icon = "misc/inventory_unhold_01.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 1125;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/enemies/unhold_regenerate_01.wav", this.Const.Sound.Volume.Inventory);
	}

});


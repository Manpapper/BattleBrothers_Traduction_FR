this.legendary_sword_blade_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.item.create();
		this.m.ID = "misc.legendary_sword_blade";
		this.m.Name = "Lame d\'épée";
		this.m.Description = "La lame scintillante d\'une épée brisée que vous avez récupérée du Kraken. Au cours de toutes vos années de combat, vous n\'avez jamais rencontré une lame si magistralement conçue. Peut-être que l\'épée pourrait être reforgée si vous aviez les deux parties.";
		this.m.Icon = "misc/inventory_sword_blade_01.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Quest;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 2500;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

});


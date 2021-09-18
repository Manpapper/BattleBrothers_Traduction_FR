this.broken_ritual_armor_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.broken_ritual_armor";
		this.m.Name = "Broken Ritual Armor";
		this.m.Description = "The broken remains of a heavy barbarian armor, covered in ritual runes. It\'s unusable like this, and yet you feel that there\'s something special about it. Perhaps there is some way to mend it?";
		this.m.Icon = "misc/inventory_champion_armor_quest.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 1000;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_halfplate_impact_01.wav", this.Const.Sound.Volume.Inventory);
	}

});


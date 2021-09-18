this.ghoul_brain_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.ghoul_brain";
		this.m.Name = "Nachzehrer Brain";
		this.m.Description = "The greasy brain of a slain Nachzehrer. What could you possibly want with this?";
		this.m.Icon = "misc/inventory_ghoul_brain.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 200;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/enemies/unhold_regenerate_01.wav", this.Const.Sound.Volume.Inventory);
	}

});


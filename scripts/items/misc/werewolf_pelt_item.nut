this.werewolf_pelt_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.werewolf_pelt";
		this.m.Name = "Peau de loup inhabituellement grande";
		this.m.Description = "Une peau de loup épaisse et inhabituellement grande qui devrait se vendre à un prix décent sur le marché.";
		this.m.Icon = "misc/inventory_wolfpelt_01.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 500;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

});


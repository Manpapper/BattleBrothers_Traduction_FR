this.spider_silk_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.spider_silk";
		this.m.Name = "Gossamer";
		this.m.Description = "Gossamer gathered from the remains of a Webknecht. Light and strong, it is superior to most common materials. If only it weren\'t so sticky...";
		this.m.Icon = "misc/inventory_webknecht_silk.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 350;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

});


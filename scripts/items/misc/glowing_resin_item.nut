this.glowing_resin_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.glowing_resin";
		this.m.Name = "Glowing Resin";
		this.m.Description = "These amber resin shards have a light orange hue to them. If melted, the material makes for a strong adhesive.";
		this.m.Icon = "misc/inventory_schrat_resin.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 2500;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
	}

});


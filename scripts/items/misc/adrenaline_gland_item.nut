this.adrenaline_gland_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.adrenaline_gland";
		this.m.Name = "Adrenaline Gland";
		this.m.Description = "A Direwolf\'s frenzy and bloodlust can be attributed to substances produced by this gland. Someone, somewhere will probably have a use for it.";
		this.m.Icon = "misc/inventory_wolf_adrenaline.png";
		this.m.SlotType = this.Const.ItemSlot.None;
		this.m.ItemType = this.Const.Items.ItemType.Misc | this.Const.Items.ItemType.Crafting;
		this.m.IsDroppedAsLoot = true;
		this.m.Value = 400;
	}

	function playInventorySound( _eventType )
	{
		this.Sound.play("sounds/combat/cleave_hit_hitpoints_01.wav", this.Const.Sound.Volume.Inventory);
	}

});


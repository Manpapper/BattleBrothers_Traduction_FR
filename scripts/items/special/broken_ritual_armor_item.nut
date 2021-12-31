this.broken_ritual_armor_item <- this.inherit("scripts/items/item", {
	m = {},
	function create()
	{
		this.m.ID = "misc.broken_ritual_armor";
		this.m.Name = "Armure rituelle brisée";
		this.m.Description = "Les restes brisés d\'une lourde armure barbare, recouverts de runes rituelles. C\'est inutilisable comme ça, et pourtant on sent qu\'elle a quelque chose de spécial. Peut-être y a-t-il un moyen de la réparer?";
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


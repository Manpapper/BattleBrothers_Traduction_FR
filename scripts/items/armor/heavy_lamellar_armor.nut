this.heavy_lamellar_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.heavy_lamellar_armor";
		this.m.Name = "Heavy Lamellar Armor";
		this.m.Description = "A heavy lamellar armor that covers most parts of the body with thick, overlapping metal plates for maximum protection.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 89;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 5000;
		this.m.Condition = 285;
		this.m.ConditionMax = 285;
		this.m.StaminaModifier = -40;
	}

});


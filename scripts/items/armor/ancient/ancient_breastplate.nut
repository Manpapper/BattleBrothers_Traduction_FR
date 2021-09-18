this.ancient_breastplate <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.ancient_breastplate";
		this.m.Name = "Ancient Breastplate";
		this.m.Description = "A tarnished thick breastplate of ancient origin.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 62;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 900;
		this.m.Condition = 135;
		this.m.ConditionMax = 135;
		this.m.StaminaModifier = -22;
	}

});


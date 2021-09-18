this.gunner_hat <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.gunner_hat";
		this.m.Name = "Gunner\'s Hat";
		this.m.Description = "A finely wrapped cloth turban worn by those that practise the use of elaborate gunpowder weapons in armies of the city states.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.ReplaceSprite = true;
		this.m.VariantString = "helmet_southern";
		this.m.Variant = 9;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 50;
		this.m.Condition = 30;
		this.m.ConditionMax = 30;
		this.m.StaminaModifier = 0;
	}

});


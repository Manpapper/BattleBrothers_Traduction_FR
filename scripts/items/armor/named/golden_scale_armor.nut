this.golden_scale_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.golden_scale";
		this.m.Description = "Une armure en écailles composée de petites écailles métalliques imbriquées. Le style et l\'artisanat font allusion à l\'armure provenant d\'une région lointaine.";
		this.m.NameList = [
			"Scale Shirt",
			"Scale Armor",
			"Dragonskin",
			"Snakeskin",
			"Scales",
			"Wyrmskin",
			"Goldskin",
			"Scale Tunic",
			"Golden Armor",
			"Golden Reminder"
		];
		this.m.Variant = 44;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 8000;
		this.m.Condition = 240;
		this.m.ConditionMax = 240;
		this.m.StaminaModifier = -28;
		this.randomizeValues();
	}

});


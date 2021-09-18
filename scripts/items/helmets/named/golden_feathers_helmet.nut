this.golden_feathers_helmet <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.golden_feathers";
		this.m.Description = "A sturdy alloy helmet of foreign design, combined with a full mail coif for excellent protection.";
		this.m.NameList = [
			"Headpiece",
			"Golden Skullcap",
			"Feathered Helm",
			"Shimmering Helmet",
			"Helm with Coif"
		];
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.Variant = 50;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 6000;
		this.m.Condition = 240;
		this.m.ConditionMax = 240;
		this.m.StaminaModifier = -16;
		this.m.Vision = -3;
		this.randomizeValues();
	}

});


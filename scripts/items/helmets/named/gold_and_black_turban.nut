this.gold_and_black_turban <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.gold_and_black_turban";
		this.m.Description = "Ce casque de style méridional est non seulement richement décoré, mais aussi bien équilibré et fabriqué à partir de matériaux de la plus haute qualité.";
		this.m.NameList = [
			"Crown of the South",
			"Desert Crest",
			"Turban of the Sun",
			"Golden Crest",
			"Vizier\'s Pride",
			"Helm of the Sand King",
			"Scorpion\'s Helm",
			"Sun Veil",
			"Gilder\'s Pride",
			"Gilder\'s Visage"
		];
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.VariantString = "helmet_southern_named";
		this.m.Variant = 2;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 6000;
		this.m.Condition = 290;
		this.m.ConditionMax = 290;
		this.m.StaminaModifier = -20;
		this.m.Vision = -3;
		this.randomizeValues();
	}

});


this.named_metal_bull_helmet <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.named_metal_bull_helmet";
		this.m.Description = "Un casque renforcé fabriqué à partir d\'un alliage extrêmement robuste. Il est richement décoré et lourd mais offre une protection extraordinaire.";
		this.m.NameList = [
			"Horned Helmet",
			"Alloy Headpiece",
			"Ancient Sallet",
			"Protector",
			"Horned Crest"
		];
		this.m.PrefixList = this.Const.Strings.BarbarianPrefix;
		this.m.UseRandomName = false;
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.Variant = 233;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 8000;
		this.m.Condition = 300;
		this.m.ConditionMax = 300;
		this.m.StaminaModifier = -22;
		this.m.Vision = -3;
		this.randomizeValues();
	}

});


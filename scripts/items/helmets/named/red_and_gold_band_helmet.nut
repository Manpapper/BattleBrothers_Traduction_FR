this.red_and_gold_band_helmet <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.red_and_gold_band_helmet";
		this.m.Description = "This southern style helmet is not only richly decorated, but also well balanced and made from extremely high quality metals.";
		this.m.NameList = [
			"Splinted Helmet",
			"Segmented Helmet",
			"Crown of the Sand King",
			"Blazing Dome",
			"Nomad\'s Crown",
			"Splinted Feathered Helmet"
		];
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.VariantString = "helmet_southern_named";
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 6000;
		this.m.Condition = 255;
		this.m.ConditionMax = 255;
		this.m.StaminaModifier = -17;
		this.m.Vision = -2;
		this.randomizeValues();
	}

});


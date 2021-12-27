this.named_golden_lamellar_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.named_golden_lamellar_armor";
		this.m.Description = "Une pièce d\'armure lamellaire extraordinairement bien conçue. Il est recouvert d\'or battu, ce qui le fait vraiment ressortir.";
		this.m.NameList = [
			"Harness",
			"Ward",
			"Defense",
			"Splendor",
			"Golden Lamellar"
		];
		this.m.Variant = 100;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 11000;
		this.m.Condition = 285;
		this.m.ConditionMax = 285;
		this.m.StaminaModifier = -40;
		this.randomizeValues();
	}

});


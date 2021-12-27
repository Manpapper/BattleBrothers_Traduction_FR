this.named_skull_and_chain_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.named_skull_and_chain_armor";
		this.m.Description = "Une armure barbare de fabrication grossière qui a été ajustée pour protéger sans être trop encombrante. Elle porte les marques typiques des tribus barbares du nord.";
		this.m.NameList = [
			"Tribal Hide",
			"Barbarian Coat",
			"Scavenged Armor",
			"Barbarian Pelt",
			"Primitive Harness"
		];
		this.m.PrefixList = this.Const.Strings.BarbarianPrefix;
		this.m.UseRandomName = false;
		this.m.Variant = 102;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 5500;
		this.m.Condition = 190;
		this.m.ConditionMax = 190;
		this.m.StaminaModifier = -24;
		this.randomizeValues();
	}

});


this.black_and_gold_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.black_and_gold";
		this.m.Description = "Ancient knowledge has been used when smithing this unique set of armor. Its light mail overlapped with golden splints offers high protection with manageable encumberment.";
		this.m.NameList = [
			"Gilder\'s Shining Ward",
			"Gilder\'s Skin",
			"Suncloak",
			"Blazing Mail",
			"Suntouched Harness",
			"Shining Hauberk",
			"Armor of the Scorpion King"
		];
		this.m.VariantString = "body_southern_named";
		this.m.Variant = 2;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 9000;
		this.m.Condition = 210;
		this.m.ConditionMax = 210;
		this.m.StaminaModifier = -25;
		this.randomizeValues();
	}

});


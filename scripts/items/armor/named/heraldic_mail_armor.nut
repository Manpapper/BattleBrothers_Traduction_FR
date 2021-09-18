this.heraldic_mail_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.heraldic_mail";
		this.m.Description = "Truly fit for a knight, this mail hauberk is made from the highest quality materials and boasts precious decorations and ornaments.";
		this.m.NameList = [
			"Heraldic Mail",
			"Splendor",
			"Grandiosity",
			"Pageantry",
			"Swank",
			"Full Mail",
			"Mail Hauberk",
			"Chainmail",
			"Duty",
			"Honor",
			"Noble Mail"
		];
		this.m.Variant = 36;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 7000;
		this.m.Condition = 210;
		this.m.ConditionMax = 210;
		this.m.StaminaModifier = -26;
		this.randomizeValues();
	}

});


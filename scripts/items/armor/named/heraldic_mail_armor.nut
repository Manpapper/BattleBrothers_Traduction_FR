this.heraldic_mail_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.heraldic_mail";
		this.m.Description = "Vraiment digne d\'un chevalier, ce haubert de courrier est fabriqué à partir de matériaux de la plus haute qualité et arbore des décorations et des ornements précieux.";
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


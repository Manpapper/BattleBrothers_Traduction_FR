this.named_noble_mail_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.named_noble_mail_armor";
		this.m.Description = "Cette pièce de cotte de mailles légère était autrefois l\'objet personnel d\'un maître d\'armes bien connu. Il est aussi léger qu\'une tunique, mais protège toutes les parties vitales du corps.";
		this.m.NameList = [
			"Reinforced Mail",
			"Nightcloak",
			"Noble Mail",
			"Fencing Mail"
		];
		this.m.Variant = 99;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 5500;
		this.m.Condition = 160;
		this.m.ConditionMax = 160;
		this.m.StaminaModifier = -15;
		this.randomizeValues();
	}

});


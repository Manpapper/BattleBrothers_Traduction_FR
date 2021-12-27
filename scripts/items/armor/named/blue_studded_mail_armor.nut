this.blue_studded_mail_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.blue_studded_mail";
		this.m.Description = "Cette chemise de mailles particulière est combinée avec un gambison et recouverte d\'une veste en cuir robuste et rivetée pour une armure légère mais protectrice.";
		this.m.NameList = [
			"Padded Mail",
			"Toadskin",
			"Ogreskin",
			"Layered Armor",
			"Reinforced Mail"
		];
		this.m.Variant = 46;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 4000;
		this.m.Condition = 150;
		this.m.ConditionMax = 150;
		this.m.StaminaModifier = -18;
		this.randomizeValues();
	}

});


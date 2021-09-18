this.norse_helmet <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.norse";
		this.m.Description = "A richly ornated nordic helmet that must have belonged to a high ranking noble or exalted warrior.";
		this.m.NameList = [
			"Clan Helmet",
			"Highland Helm",
			"Norse Nasal Helmet",
			"Faceguard",
			"Padded Norse Helmet",
			"Owl Helmet"
		];
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.Variant = 203;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 2000;
		this.m.Condition = 125;
		this.m.ConditionMax = 125;
		this.m.StaminaModifier = -6;
		this.m.Vision = -1;
		this.randomizeValues();
	}

});


this.wolf_helmet <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.wolf";
		this.m.Description = "Un casque en métal robuste avec une cotte de mailles attachée, recouvert d\'une impressionnante tête de loup.";
		this.m.NameList = [
			"Beast Cap",
			"Helmet of the Wolf",
			"Berserker Coif",
			"Beast Coif",
			"Wolf Crown",
			"Predator Crown"
		];
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.Variant = 48;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 2000;
		this.m.Condition = 140;
		this.m.ConditionMax = 140;
		this.m.StaminaModifier = -8;
		this.randomizeValues();
	}

});


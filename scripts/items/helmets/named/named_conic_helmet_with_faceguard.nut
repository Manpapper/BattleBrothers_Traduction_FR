this.named_conic_helmet_with_faceguard <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.named_conic_helmet_with_faceguard";
		this.m.Description = "This conic helmet has a faceguard attached and finely fitted scales to protect the neck. The faceguard resembles a fearsome warrior that is about to strike his enemy.";
		this.m.NameList = [
			"Conic Feathered Helmet",
			"Iron Mask",
			"Warlord\'s Helm",
			"Iron Visage",
			"Steel Countenance"
		];
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.Variant = 205;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 8000;
		this.m.Condition = 280;
		this.m.ConditionMax = 280;
		this.m.StaminaModifier = -19;
		this.m.Vision = -3;
		this.randomizeValues();
	}

});


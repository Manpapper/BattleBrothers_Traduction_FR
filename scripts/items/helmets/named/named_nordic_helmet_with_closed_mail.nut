this.named_nordic_helmet_with_closed_mail <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.named_nordic_helmet_with_closed_mail";
		this.m.Description = "This nordic helmet with faceguard is extraordinarly crafted, and as protective as it is impressive looking.";
		this.m.NameList = [
			"Sea Raider Helmet",
			"Owl Helmet",
			"Decorated Nordic Helmet",
			"Chieftain Helmet",
			"Engraved Nordic Helmet",
			"Nordic Noble Helmet"
		];
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.Variant = 206;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 7500;
		this.m.Condition = 265;
		this.m.ConditionMax = 265;
		this.m.StaminaModifier = -18;
		this.m.Vision = -2;
		this.randomizeValues();
	}

});


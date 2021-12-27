this.black_leather_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.black_leather";
		this.m.Description = "Une armure en cuir bien conçue et durcie soutenue par un gambison rembourré et une cotte de mailles. Léger à porter mais très solide.";
		this.m.NameList = [
			"Leather Cuirass",
			"Mail Shirt",
			"Leather Armor",
			"Skin",
			"Peel",
			"Guard",
			"Coat",
			"Nightcloak",
			"Black",
			"Dark Omen"
		];
		this.m.Variant = 42;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 2000;
		this.m.Condition = 110;
		this.m.ConditionMax = 110;
		this.m.StaminaModifier = -11;
		this.randomizeValues();
	}

});


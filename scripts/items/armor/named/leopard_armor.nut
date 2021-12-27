this.leopard_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.leopard_armor";
		this.m.Description = "Un harnais à plaques lamellaires lourdes associé à une maille fine et à un rembourrage confortable. Une pièce vraiment bien faite qui est presque trop précieuse pour être déchirée au combat.";
		this.m.NameList = [
			"Gilder\'s Embrace",
			"Gilder\'s Guard",
			"Glistening Lamellar",
			"Vizier\'s Harness",
			"Carapace of the Desert",
			"Master Hunter\'s Armor"
		];
		this.m.VariantString = "body_southern_named";
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 15000;
		this.m.Condition = 290;
		this.m.ConditionMax = 290;
		this.m.StaminaModifier = -35;
		this.randomizeValues();
	}

});


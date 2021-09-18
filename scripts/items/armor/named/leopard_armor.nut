this.leopard_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.leopard_armor";
		this.m.Description = "A heavy lamellar plate harness combined with fine mail and comfortable padding. A truly well made piece that is almost too precious to be torn in battle.";
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


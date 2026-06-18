this.heraldic_mail <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.heraldic_mail";
		this.m.Name = "Cotte de mailles héraldique";
		this.m.Description = "Un haubert de mailles lourd et extraordinairement bien conçu avec des mitaines de mailles ajoutées et une doublure rembourré. Seul un vrai maître pouvait fabriquer une armure comme celle-ci.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		local variants = [
			36,
			36,
			36,
			119,
			120,
			121
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 2500;
		this.m.Condition = 185;
		this.m.ConditionMax = 185;
		this.m.StaminaModifier = -18;
	}

});


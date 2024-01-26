this.adorned_full_helm <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.adorned_full_helm";
		this.m.Name = "Heaume Intégral Ornée";
		this.m.Description = "Un heaume métallique fermé avec des trous de respiration. Ornée de reliques et entretenue avec amour malgré son utilisation extensive, il s'agit du casque d'un véritable chevalier en quête d'aventures.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.Variant = 239;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 3700;
		this.m.Condition = 300;
		this.m.ConditionMax = 300;
		this.m.StaminaModifier = -18;
		this.m.Vision = -3;
	}

});


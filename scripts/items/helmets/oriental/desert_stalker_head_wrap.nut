this.desert_stalker_head_wrap <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.desert_stalker_head_wrap";
		this.m.Name = "Desert Stalker\'s Head Wrap";
		this.m.Description = "A thick head wrap with small hidden leather strings for added protection, adorned with a bronze scorpion.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.ReplaceSprite = true;
		this.m.VariantString = "helmet_southern";
		this.m.Variant = 22;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 120;
		this.m.Condition = 45;
		this.m.ConditionMax = 45;
		this.m.StaminaModifier = 0;
	}

});


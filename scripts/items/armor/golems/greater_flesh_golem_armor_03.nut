this.greater_flesh_golem_armor_03 <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.greater_flesh_golem_armor_03";
		this.m.Name = "Gilded Toga";
		this.m.Description = "";
		this.m.IsDroppedAsLoot = false;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 3;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 0;
		this.m.Condition = 80;
		this.m.ConditionMax = 80;
		this.m.StaminaModifier = 0;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_greater_flesh_golem_armor_" + variant;
		this.m.SpriteDamaged = "bust_greater_flesh_golem_armor_" + variant;
		this.m.SpriteCorpse = "bust_greater_flesh_golem_armor_" + variant + "_dead";
	}

});


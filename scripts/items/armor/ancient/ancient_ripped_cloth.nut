this.ancient_ripped_cloth <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.ancient_ripped_cloth";
		this.m.Name = "Ripped Cloth";
		this.m.Description = "";
		this.m.IsDroppedAsLoot = false;
		this.m.ShowOnCharacter = true;
		local variants = [
			74,
			75,
			76,
			77,
			78,
			79
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 0;
		this.m.Condition = 25;
		this.m.ConditionMax = 25;
		this.m.StaminaModifier = 0;
	}

});


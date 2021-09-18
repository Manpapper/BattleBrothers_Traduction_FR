this.ancient_lich_attire <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.ancient_lich_attire";
		this.m.Name = "Ancient Attire";
		this.m.Description = "";
		this.m.IsDroppedAsLoot = false;
		this.m.ShowOnCharacter = true;
		this.m.VariantString = "body_skeleton";
		local variants = [
			80
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 0;
		this.m.Condition = 60;
		this.m.ConditionMax = 60;
		this.m.StaminaModifier = 0;
	}

});


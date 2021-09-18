this.ancient_priest_attire <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.ancient_priest_attire";
		this.m.Name = "Ancient Priest Attire";
		this.m.Description = "";
		this.m.IsDroppedAsLoot = false;
		this.m.ShowOnCharacter = true;
		local variants = [
			70,
			71,
			72,
			73
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 0;
		this.m.Condition = 40;
		this.m.ConditionMax = 40;
		this.m.StaminaModifier = 0;
	}

});


this.decayed_coat_of_scales <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.decayed_coat_of_scales";
		this.m.Name = "Manteau d\'écailles pourri";
		this.m.Description = "Ce manteau d\'écailles est usé et des pièces se sont perdues ou sont manquantes. Il offre toujours une très bonne protection si l\'odeur ne vous dérange pas.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		local variants = [
			49,
			52,
			55,
			58
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 3000;
		this.m.Condition = 240;
		this.m.ConditionMax = 240;
		this.m.StaminaModifier = -36;
	}

});


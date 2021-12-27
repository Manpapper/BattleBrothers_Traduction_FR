this.ancient_plated_scale_hauberk <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.ancient_plated_scale_hauberk";
		this.m.Name = "Haubert en écailles plaquées antiques";
		this.m.Description = "Une épaisse couche d\'écailles, en partie renforcée d\'une couche de métal plaqué sur le dessus. C\'est une armure massive d\'origine ancienne qui n\'a pas bien vieilli.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 69;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 3200;
		this.m.Condition = 210;
		this.m.ConditionMax = 210;
		this.m.StaminaModifier = -30;
	}

});


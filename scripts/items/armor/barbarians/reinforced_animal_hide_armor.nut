this.reinforced_animal_hide_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.reinforced_animal_hide_armor";
		this.m.Name = "Armure en peau d\'animal renforcée";
		this.m.Description = "Une armure renforcée en peau d\'animal fabriquée à partir de pièces de cuir épais avec de la maille et des écailles métalliques supplémentaires.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 97;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 120;
		this.m.Condition = 65;
		this.m.ConditionMax = 65;
		this.m.StaminaModifier = -7;
	}

});


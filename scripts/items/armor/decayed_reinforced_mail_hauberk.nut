this.decayed_reinforced_mail_hauberk <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.decayed_reinforced_mail_hauberk";
		this.m.Name = "Decayed Reinforced Mail Hauberk";
		this.m.Description = "A long mail shirt in bad condition. Some rings are missing and it is covered in dirt and has an odd smell about it.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		local variants = [
			50,
			53,
			56,
			59
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 1000;
		this.m.Condition = 170;
		this.m.ConditionMax = 170;
		this.m.StaminaModifier = -26;
	}

});


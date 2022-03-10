this.adorned_heavy_mail_hauberk <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.adorned_heavy_mail_hauberk";
		this.m.Name = "Adorned Heavy Mail Hauberk";
		this.m.Description = "A heavy chainmail hauberk worn under a thick riveted jacket and reinforced with vambraces. Adorned with trophies and lovingly maintained despite its extensive use, this is the armor of a true questing knight.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 109;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 6800;
		this.m.Condition = 300;
		this.m.ConditionMax = 300;
		this.m.StaminaModifier = -34;
	}

});


this.patched_mail_shirt <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.patched_mail_shirt";
		this.m.Name = "Patched Mail Shirt";
		this.m.Description = "This light mail shirt has seen better times but still grants decent protection.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 22;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 250;
		this.m.Condition = 90;
		this.m.ConditionMax = 90;
		this.m.StaminaModifier = -10;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_body_22";
		this.m.SpriteDamaged = "bust_body_22_damaged";
		this.m.SpriteCorpse = "bust_body_22_dead";
		this.m.IconLarge = "armor/inventory_body_armor_22.png";
		this.m.Icon = "armor/icon_body_armor_22.png";
	}

});


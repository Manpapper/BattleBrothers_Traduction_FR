this.rusty_mail_coif <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.rusty_mail_coif";
		this.m.Name = "Rusty Mail Coif";
		this.m.Description = "A rusty mail coif that still offers good protection - it leaves horrible stains though.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.ReplaceSprite = true;
		this.m.Variant = 0;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 150;
		this.m.Condition = 70;
		this.m.ConditionMax = 70;
		this.m.StaminaModifier = -4;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_helmet_29";
		this.m.SpriteDamaged = "bust_helmet_29_damaged";
		this.m.SpriteCorpse = "bust_helmet_29_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/inventory_helmet_29.png";
	}

});


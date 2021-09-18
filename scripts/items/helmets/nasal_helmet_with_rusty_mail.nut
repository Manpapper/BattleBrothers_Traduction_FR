this.nasal_helmet_with_rusty_mail <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.nasal_helmet_with_rusty_mail";
		this.m.Name = "Nasal Helmet With Rusty Mail";
		this.m.Description = "A worn and used helmet with a rusty mail coif.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.ReplaceSprite = true;
		this.m.Variant = 0;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 600;
		this.m.Condition = 140;
		this.m.ConditionMax = 140;
		this.m.StaminaModifier = -9;
		this.m.Vision = -2;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_helmet_31";
		this.m.SpriteDamaged = "bust_helmet_31_damaged";
		this.m.SpriteCorpse = "bust_helmet_31_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/inventory_helmet_31.png";
	}

});


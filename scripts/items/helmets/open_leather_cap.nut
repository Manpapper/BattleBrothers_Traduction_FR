this.open_leather_cap <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.open_leather_cap";
		this.m.Name = "Open Leather Cap";
		this.m.Description = "A sturdy leather cap that is not covering the ears and neck.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.ReplaceSprite = true;
		this.m.Variant = 0;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 60;
		this.m.Condition = 40;
		this.m.ConditionMax = 40;
		this.m.StaminaModifier = -2;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_helmet_25";
		this.m.SpriteDamaged = "bust_helmet_25_damaged";
		this.m.SpriteCorpse = "bust_helmet_25_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/inventory_helmet_25.png";
	}

});


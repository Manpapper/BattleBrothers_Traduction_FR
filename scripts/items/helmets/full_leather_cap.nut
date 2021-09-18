this.full_leather_cap <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.full_leather_cap";
		this.m.Name = "Full Leather Cap";
		this.m.Description = "A closed leather cap that protects the head and neck. Padded for extra protection.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.ReplaceSprite = true;
		this.m.Variant = 0;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 80;
		this.m.Condition = 45;
		this.m.ConditionMax = 45;
		this.m.StaminaModifier = -3;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_helmet_27";
		this.m.SpriteDamaged = "bust_helmet_27_damaged";
		this.m.SpriteCorpse = "bust_helmet_27_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/inventory_helmet_27.png";
	}

});


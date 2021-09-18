this.wardog_heavy_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.updateVariant();
		this.m.ID = "armor.body.wardog_heavy_armor";
		this.m.Name = "Heavy Wardog Armor";
		this.m.Description = "";
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.Condition = 85;
		this.m.ConditionMax = 85;
		this.m.StaminaModifier = -15;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_dog_01_armor_02";
		this.m.SpriteDamaged = "bust_dog_01_armor_02_damaged";
		this.m.SpriteCorpse = "bust_dog_01_armor_02_dead";
	}

});


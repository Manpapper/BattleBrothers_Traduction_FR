this.orc_warrior_light_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.updateVariant();
		this.m.ID = "armor.body.orc_warrior_light_armor";
		this.m.Name = "Looted Scale Armor";
		this.m.Description = "";
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Condition = 280;
		this.m.ConditionMax = 280;
		this.m.StaminaModifier = -22;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_orc_03_armor_01";
		this.m.SpriteDamaged = "bust_orc_03_armor_01_damaged";
		this.m.SpriteCorpse = "bust_orc_03_armor_01_dead";
	}

});


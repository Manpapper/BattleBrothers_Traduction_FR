this.orc_young_very_light_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.updateVariant();
		this.m.ID = "armor.body.orc_young_very_light_armor";
		this.m.Name = "Hide Armor";
		this.m.Description = "";
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.Condition = 35;
		this.m.ConditionMax = 35;
		this.m.StaminaModifier = 0;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_orc_01_armor_01";
		this.m.SpriteDamaged = "bust_orc_01_armor_01_damaged";
		this.m.SpriteCorpse = "bust_orc_01_armor_01_dead";
	}

});


this.orc_young_heavy_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.updateVariant();
		this.m.ID = "armor.body.orc_young_heavy_armor";
		this.m.Name = "Metal Plated Hide Armor";
		this.m.Description = "";
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.Condition = 120;
		this.m.ConditionMax = 120;
		this.m.StaminaModifier = -20;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_orc_01_armor_04";
		this.m.SpriteDamaged = "bust_orc_01_armor_04_damaged";
		this.m.SpriteCorpse = "bust_orc_01_armor_04_dead";
	}

});


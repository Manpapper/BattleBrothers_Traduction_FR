this.orc_warrior_medium_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.updateVariant();
		this.m.ID = "armor.body.orc_warrior_medium_armor";
		this.m.Name = "Looted Reinforced Mail";
		this.m.Description = "";
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Condition = 340;
		this.m.ConditionMax = 340;
		this.m.StaminaModifier = -26;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_orc_03_armor_02";
		this.m.SpriteDamaged = "bust_orc_03_armor_02_damaged";
		this.m.SpriteCorpse = "bust_orc_03_armor_02_dead";
	}

});


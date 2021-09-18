this.goblin_medium_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.updateVariant();
		this.m.ID = "armor.body.goblin_medium_armor";
		this.m.Name = "Medium Armor";
		this.m.Description = "";
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.Condition = 55;
		this.m.ConditionMax = 55;
		this.m.StaminaModifier = -4;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_goblin_01_armor_03";
		this.m.SpriteDamaged = "bust_goblin_01_armor_03_damaged";
		this.m.SpriteCorpse = "bust_goblin_01_armor_03_dead";
	}

});


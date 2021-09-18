this.goblin_shaman_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.updateVariant();
		this.m.ID = "armor.body.goblin_shaman_armor";
		this.m.Name = "Ritual Armor";
		this.m.Description = "";
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.Condition = 45;
		this.m.ConditionMax = 45;
		this.m.StaminaModifier = -5;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_goblin_02_armor_01";
		this.m.SpriteDamaged = "bust_goblin_02_armor_01_damaged";
		this.m.SpriteCorpse = "bust_goblin_02_armor_01_dead";
	}

});


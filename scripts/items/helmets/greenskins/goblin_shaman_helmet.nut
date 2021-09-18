this.goblin_shaman_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.updateVariant();
		this.m.ID = "armor.head.goblin_shaman_helmet";
		this.m.Name = "Ritual Headpiece";
		this.m.Description = "";
		this.m.ShowOnCharacter = true;
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.Condition = 35;
		this.m.ConditionMax = 35;
		this.m.StaminaModifier = -2;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_goblin_02_helmet_01";
		this.m.SpriteDamaged = "bust_goblin_02_helmet_01_damaged";
		this.m.SpriteCorpse = "bust_goblin_02_helmet_01_dead";
	}

});


this.goblin_heavy_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.updateVariant();
		this.m.ID = "armor.head.goblin_heavy_helmet";
		this.m.Name = "Helmet";
		this.m.Description = "";
		this.m.ShowOnCharacter = true;
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Condition = 90;
		this.m.ConditionMax = 90;
		this.m.StaminaModifier = -4;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_goblin_01_helmet_02";
		this.m.SpriteDamaged = "bust_goblin_01_helmet_02_damaged";
		this.m.SpriteCorpse = "bust_goblin_01_helmet_02_dead";
	}

});


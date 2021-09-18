this.goblin_leader_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.updateVariant();
		this.m.ID = "armor.head.goblin_leader_helmet";
		this.m.Name = "Helmet";
		this.m.Description = "";
		this.m.ShowOnCharacter = true;
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Condition = 120;
		this.m.ConditionMax = 120;
		this.m.StaminaModifier = -10;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_goblin_03_helmet_01";
		this.m.SpriteDamaged = "bust_goblin_03_helmet_01_damaged";
		this.m.SpriteCorpse = "bust_goblin_03_helmet_01_dead";
	}

});


this.goblin_skirmisher_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.Variant = this.Math.rand(1, 3);
		this.updateVariant();
		this.m.ID = "armor.head.goblin_skirmisher_helmet";
		this.m.Name = "Helmet";
		this.m.Description = "";
		this.m.ShowOnCharacter = true;
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.Condition = 25;
		this.m.ConditionMax = 25;
		this.m.StaminaModifier = 0;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_goblin_04_helmet_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_goblin_04_helmet_0" + this.m.Variant + "_damaged";
		this.m.SpriteCorpse = "bust_goblin_04_helmet_0" + this.m.Variant + "_dead";
	}

});


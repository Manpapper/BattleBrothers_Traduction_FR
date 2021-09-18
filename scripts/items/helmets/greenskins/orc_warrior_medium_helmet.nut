this.orc_warrior_medium_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		local variants = [
			2,
			5
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ID = "armor.head.orc_warrior_medium_helmet";
		this.m.Name = "Looted Kettle Hat";
		this.m.Description = "";
		this.m.ShowOnCharacter = true;
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Condition = 300;
		this.m.ConditionMax = 300;
		this.m.StaminaModifier = -18;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_orc_03_helmet_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_orc_03_helmet_0" + this.m.Variant + "_damaged";
		this.m.SpriteCorpse = "bust_orc_03_helmet_0" + this.m.Variant + "_dead";
	}

});


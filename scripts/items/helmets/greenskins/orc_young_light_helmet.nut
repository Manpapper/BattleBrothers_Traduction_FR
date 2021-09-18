this.orc_young_light_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		local variants = [
			1
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ID = "armor.head.orc_young_light_helmet";
		this.m.Name = "Helmet";
		this.m.Description = "";
		this.m.ShowOnCharacter = true;
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.Condition = 35;
		this.m.ConditionMax = 35;
		this.m.StaminaModifier = 0;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_orc_01_helmet_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_orc_01_helmet_0" + this.m.Variant + "_damaged";
		this.m.SpriteCorpse = "bust_orc_01_helmet_0" + this.m.Variant + "_dead";
	}

});


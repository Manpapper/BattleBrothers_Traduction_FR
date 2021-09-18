this.named_bandit_kite_shield <- this.inherit("scripts/items/shields/named/named_shield", {
	m = {},
	function create()
	{
		this.named_shield.create();
		this.m.Variant = this.Math.rand(1, 1);
		this.updateVariant();
		this.m.ID = "shield.named_bandit_kite_shield";
		this.m.NameList = this.Const.Strings.ShieldNames;
		this.m.Description = "A long, wooden shield covering the whole body for good protection against ranged attacks. This particular shield shows some unique craftsmanship and is a rare find.";
		this.m.AddGenericSkill = true;
		this.m.ShowOnCharacter = true;
		this.m.Value = 700;
		this.m.MeleeDefense = 15;
		this.m.RangedDefense = 25;
		this.m.StaminaModifier = -16;
		this.m.Condition = 48;
		this.m.ConditionMax = 48;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.Sprite = "shield_bandit_02_named_0" + this.m.Variant;
		this.m.SpriteDamaged = "shield_bandit_02_named_0" + this.m.Variant + "_damaged";
		this.m.ShieldDecal = "shield_bandit_02_named_0" + this.m.Variant + "_destroyed";
		this.m.IconLarge = "shields/inventory_bandits_shield_02_named_0" + this.m.Variant + ".png";
		this.m.Icon = "shields/icon_bandits_shield_02_named_0" + this.m.Variant + ".png";
	}

	function onEquip()
	{
		this.named_shield.onEquip();
		this.addSkill(this.new("scripts/skills/actives/shieldwall"));
		this.addSkill(this.new("scripts/skills/actives/knock_back"));
	}

});


this.named_sipar_shield <- this.inherit("scripts/items/shields/named/named_shield", {
	m = {},
	function create()
	{
		this.named_shield.create();
		this.m.ID = "shield.named_sipar_shield";
		this.m.NameList = this.Const.Strings.ShieldNames;
		this.m.PrefixList = this.Const.Strings.SouthernPrefix;
		this.m.SuffixList = this.Const.Strings.SouthernSuffix;
		this.m.Description = "A full metal round shield of southern design with elaborate ornaments. Quite heavy, but also durable.";
		this.m.AddGenericSkill = true;
		this.m.ShowOnCharacter = true;
		this.m.SoundOnHit = this.Const.Sound.ShieldHitMetal;
		this.m.Variant = this.Math.rand(1, 2);
		this.updateVariant();
		this.m.Value = 1500;
		this.m.MeleeDefense = 18;
		this.m.RangedDefense = 18;
		this.m.StaminaModifier = -18;
		this.m.Condition = 60;
		this.m.ConditionMax = 60;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.Sprite = "shield_metal_round_03_named_0" + this.m.Variant;
		this.m.SpriteDamaged = "shield_metal_round_03_named_0" + this.m.Variant + "_damaged";
		this.m.ShieldDecal = "shield_metal_round_03_named_0" + this.m.Variant + "_destroyed";
		this.m.IconLarge = "shields/inventory_metal_round_shield_03_named_0" + this.m.Variant + ".png";
		this.m.Icon = "shields/icon_metal_round_shield_03_named_0" + this.m.Variant + ".png";
	}

	function onEquip()
	{
		this.named_shield.onEquip();
		this.addSkill(this.new("scripts/skills/actives/shieldwall"));
		this.addSkill(this.new("scripts/skills/actives/knock_back"));
	}

});


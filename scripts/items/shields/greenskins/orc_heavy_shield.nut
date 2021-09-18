this.orc_heavy_shield <- this.inherit("scripts/items/shields/shield", {
	m = {},
	function create()
	{
		this.shield.create();
		this.m.ID = "shield.orc_heavy_shield";
		this.m.Name = "Heavy Metal Shield";
		this.m.Description = "A massive metal shield that is almost impossible to destroy but very heavy and fatiguing to wear for any human.";
		this.m.AddGenericSkill = true;
		this.m.ShowOnCharacter = true;
		this.m.SoundOnHit = this.Const.Sound.ShieldHitMetal;
		this.updateVariant();
		this.m.Value = 250;
		this.m.MeleeDefense = 15;
		this.m.RangedDefense = 15;
		this.m.StaminaModifier = -22;
		this.m.Condition = 72;
		this.m.ConditionMax = 72;
		this.m.FatigueOnSkillUse = 5;
	}

	function updateVariant()
	{
		this.m.Sprite = "shield_orc_02";
		this.m.SpriteDamaged = "shield_orc_02_damaged";
		this.m.ShieldDecal = "shield_orc_02_destroyed";
		this.m.IconLarge = "shields/orc_iron_shield_140x70.png";
		this.m.Icon = "shields/orc_iron_shield_70x70.png";
	}

	function onEquip()
	{
		this.shield.onEquip();
		this.addSkill(this.new("scripts/skills/actives/shieldwall"));
		this.addSkill(this.new("scripts/skills/actives/knock_back"));
	}

});


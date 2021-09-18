this.named_battle_whip <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.named_battle_whip";
		this.m.NameList = this.Const.Strings.WhipNames;
		this.m.Description = "A whip is quite the peculiar weapon, but this piece has been crafted by a true master. It is more durable and balanced than any other you\'ve seen.";
		this.m.Categories = "Cleaver, One-Handed";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.RangeMin = 1;
		this.m.RangeMax = 3;
		this.m.RangeIdeal = 3;
		this.m.Value = 2200;
		this.m.Condition = 40;
		this.m.ConditionMax = 40;
		this.m.StaminaModifier = -6;
		this.m.RegularDamage = 15;
		this.m.RegularDamageMax = 30;
		this.m.ArmorDamageMult = 0.25;
		this.m.DirectDamageMult = 0.1;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/whip_01_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/whip_01_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_whip_01_named_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		local skill = this.new("scripts/skills/actives/whip_skill");
		skill.m.Icon = "skills/active_171.png";
		skill.m.IconDisabled = "skills/active_171_sw.png";
		skill.m.Overlay = "active_171";
		this.addSkill(skill);
		local skill = this.new("scripts/skills/actives/disarm_skill");
		this.addSkill(skill);
	}

});


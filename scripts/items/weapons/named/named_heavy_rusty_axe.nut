this.named_heavy_rusty_axe <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.named_heavy_rusty_axe";
		this.m.NameList = this.Const.Strings.AxeNames;
		this.m.PrefixList = this.Const.Strings.BarbarianPrefix;
		this.m.SuffixList = this.Const.Strings.BarbarianSuffix;
		this.m.UseRandomName = false;
		this.m.Description = "This heavy and ornated axe belonged to a valued member of a barbarian tribe. Its decorations and relatively high craftsmanship are a rare find among the wild warriors of the north.";
		this.m.Categories = "Axe, Two-Handed";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 3400;
		this.m.ShieldDamage = 36;
		this.m.Condition = 96.0;
		this.m.ConditionMax = 96.0;
		this.m.StaminaModifier = -16;
		this.m.RegularDamage = 75;
		this.m.RegularDamageMax = 90;
		this.m.ArmorDamageMult = 1.5;
		this.m.DirectDamageMult = 0.4;
		this.m.DirectDamageAdd = 0.1;
		this.m.ChanceToHitHead = 0;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/wildmen_09_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/wildmen_09_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_wildmen_09_named_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		local skill = this.new("scripts/skills/actives/split_man");
		skill.m.Icon = "skills/active_187.png";
		skill.m.IconDisabled = "skills/active_187_sw.png";
		skill.m.Overlay = "active_187";
		this.addSkill(skill);
		local skill = this.new("scripts/skills/actives/round_swing");
		skill.m.Icon = "skills/active_188.png";
		skill.m.IconDisabled = "skills/active_188_sw.png";
		skill.m.Overlay = "active_188";
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/split_shield");
		skill.setApplyAxeMastery(true);
		skill.setFatigueCost(skill.getFatigueCostRaw() + 5);
		this.addSkill(skill);
	}

});


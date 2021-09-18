this.named_two_handed_spiked_mace <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.named_two_handed_spiked_mace";
		this.m.NameList = this.Const.Strings.TwoHandedMaceNames;
		this.m.PrefixList = this.Const.Strings.BarbarianPrefix;
		this.m.SuffixList = this.Const.Strings.BarbarianSuffix;
		this.m.UseRandomName = false;
		this.m.Description = "A heavy spiked mace crafted to resemble a human skull. Despite its crude appearance, this is a well balanced and deadly weapon.";
		this.m.Categories = "Mace, Two-Handed";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 3000;
		this.m.ShieldDamage = 20;
		this.m.Condition = 72.0;
		this.m.ConditionMax = 72.0;
		this.m.StaminaModifier = -14;
		this.m.RegularDamage = 50;
		this.m.RegularDamageMax = 70;
		this.m.ArmorDamageMult = 1.15;
		this.m.DirectDamageMult = 0.5;
		this.m.DirectDamageAdd = 0.1;
		this.m.ChanceToHitHead = 0;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/wildmen_06_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/wildmen_06_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_wildmen_06_named_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		local skill;
		skill = this.new("scripts/skills/actives/cudgel_skill");
		skill.m.Icon = "skills/active_178.png";
		skill.m.IconDisabled = "skills/active_178_sw.png";
		skill.m.Overlay = "active_178";
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/strike_down_skill");
		skill.m.Icon = "skills/active_179.png";
		skill.m.IconDisabled = "skills/active_179_sw.png";
		skill.m.Overlay = "active_179";
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/split_shield");
		skill.setFatigueCost(skill.getFatigueCostRaw() + 5);
		this.addSkill(skill);
	}

});


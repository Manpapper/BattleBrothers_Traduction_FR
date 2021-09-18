this.two_handed_flanged_mace <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.two_handed_flanged_mace";
		this.m.Name = "Two-Handed Flanged Mace";
		this.m.Description = "A large and heavy winged mace held with both hands. Receiving a blow from this weapon will leave anyone dazed and gasping for air, no matter their armor.";
		this.m.Categories = "Mace, Two-Handed";
		this.m.IconLarge = "weapons/melee/mace_two_handed_02.png";
		this.m.Icon = "weapons/melee/mace_two_handed_02_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = false;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_mace_two_handed_02";
		this.m.Value = 1600;
		this.m.ShieldDamage = 26;
		this.m.Condition = 120.0;
		this.m.ConditionMax = 120.0;
		this.m.StaminaModifier = -16;
		this.m.RegularDamage = 75;
		this.m.RegularDamageMax = 95;
		this.m.ArmorDamageMult = 1.25;
		this.m.DirectDamageMult = 0.5;
		this.m.ChanceToHitHead = 0;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill;
		skill = this.new("scripts/skills/actives/cudgel_skill");
		skill.m.Icon = "skills/active_133.png";
		skill.m.IconDisabled = "skills/active_133_sw.png";
		skill.m.Overlay = "active_133";
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/strike_down_skill");
		skill.m.Icon = "skills/active_134.png";
		skill.m.IconDisabled = "skills/active_134_sw.png";
		skill.m.Overlay = "active_134";
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/split_shield");
		skill.setFatigueCost(skill.getFatigueCostRaw() + 5);
		this.addSkill(skill);
	}

});


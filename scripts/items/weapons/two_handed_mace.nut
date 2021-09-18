this.two_handed_mace <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.two_handed_mace";
		this.m.Name = "Two-Handed Mace";
		this.m.Description = "A massive wooden club with a spiked head. Receiving a blow from this weapon will leave anyone dazed and gasping for air, no matter their armor.";
		this.m.Categories = "Mace, Two-Handed";
		this.m.IconLarge = "weapons/melee/mace_two_handed_01.png";
		this.m.Icon = "weapons/melee/mace_two_handed_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = false;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_mace_two_handed_01";
		this.m.Value = 1000;
		this.m.ShieldDamage = 20;
		this.m.Condition = 80.0;
		this.m.ConditionMax = 80.0;
		this.m.StaminaModifier = -14;
		this.m.RegularDamage = 50;
		this.m.RegularDamageMax = 75;
		this.m.ArmorDamageMult = 1.15;
		this.m.DirectDamageMult = 0.5;
		this.m.ChanceToHitHead = 0;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill;
		skill = this.new("scripts/skills/actives/cudgel_skill");
		skill.m.Icon = "skills/active_131.png";
		skill.m.IconDisabled = "skills/active_131_sw.png";
		skill.m.Overlay = "active_131";
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/strike_down_skill");
		skill.m.Icon = "skills/active_132.png";
		skill.m.IconDisabled = "skills/active_132_sw.png";
		skill.m.Overlay = "active_132";
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/split_shield");
		skill.setFatigueCost(skill.getFatigueCostRaw() + 5);
		this.addSkill(skill);
	}

});


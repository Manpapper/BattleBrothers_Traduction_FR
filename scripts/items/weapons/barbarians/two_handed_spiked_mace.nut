this.two_handed_spiked_mace <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.two_handed_spiked_mace";
		this.m.Name = "Two-Handed Spiked Mace";
		this.m.Description = "A huge club fitted with a skull for good measure. Receiving a blow from this weapon will leave anyone dazed and gasping for air, no matter their armor.";
		this.m.Categories = "Mace, Two-Handed";
		this.m.IconLarge = "weapons/melee/wildmen_06.png";
		this.m.Icon = "weapons/melee/wildmen_06_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = false;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_wildmen_06";
		this.m.Value = 900;
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
	}

	function onEquip()
	{
		this.weapon.onEquip();
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


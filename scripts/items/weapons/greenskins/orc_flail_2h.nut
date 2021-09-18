this.orc_flail_2h <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.orc_flail_2h";
		this.m.Name = "Berserk Chain";
		this.m.Description = "A massive iron chain with a spiked full metal head at the end. Too heavy to be used effectively by the average human.";
		this.m.Categories = "Flail, Two-Handed";
		this.m.IconLarge = "weapons/melee/orc_flail_two_handed.png";
		this.m.Icon = "weapons/melee/orc_flail_two_handed_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAoE = true;
		this.m.EquipSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_orc_weapon_05";
		this.m.Value = 1300;
		this.m.ShieldDamage = 0;
		this.m.Condition = 64.0;
		this.m.ConditionMax = 64.0;
		this.m.StaminaModifier = -30;
		this.m.RegularDamage = 40;
		this.m.RegularDamageMax = 100;
		this.m.ArmorDamageMult = 1.25;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 15;
		this.m.FatigueOnSkillUse = 5;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill;
		skill = this.new("scripts/skills/actives/pound");
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/thresh");
		this.addSkill(skill);
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});


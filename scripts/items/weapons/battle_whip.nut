this.battle_whip <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.battle_whip";
		this.m.Name = "Battle Whip";
		this.m.Description = "A long whip with a barbed tip that can tear terrible bleeding wounds over significant range, but is very inefficient against armor.";
		this.m.Categories = "Cleaver, One-Handed";
		this.m.IconLarge = "weapons/melee/whip_01.png";
		this.m.Icon = "weapons/melee/whip_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_whip_01";
		this.m.RangeMin = 1;
		this.m.RangeMax = 3;
		this.m.RangeIdeal = 3;
		this.m.Value = 450;
		this.m.Condition = 40;
		this.m.ConditionMax = 40;
		this.m.StaminaModifier = -6;
		this.m.RegularDamage = 15;
		this.m.RegularDamageMax = 30;
		this.m.ArmorDamageMult = 0.25;
		this.m.DirectDamageMult = 0.1;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill = this.new("scripts/skills/actives/whip_skill");
		skill.m.Icon = "skills/active_171.png";
		skill.m.IconDisabled = "skills/active_171_sw.png";
		skill.m.Overlay = "active_171";
		this.addSkill(skill);
		local skill = this.new("scripts/skills/actives/disarm_skill");
		this.addSkill(skill);
	}

});


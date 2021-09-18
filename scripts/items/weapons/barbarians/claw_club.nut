this.claw_club <- this.inherit("scripts/items/weapons/weapon", {
	m = {
		StunChance = 30
	},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.claw_club";
		this.m.Name = "Claw Club";
		this.m.Description = "The massive claws of some wild animal are fixed to this large club";
		this.m.Categories = "Mace, One-Handed";
		this.m.IconLarge = "weapons/melee/wildmen_02.png";
		this.m.Icon = "weapons/melee/wildmen_02_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_wildmen_02";
		this.m.Value = 100;
		this.m.Condition = 76.0;
		this.m.ConditionMax = 76.0;
		this.m.StaminaModifier = -10;
		this.m.RegularDamage = 20;
		this.m.RegularDamageMax = 30;
		this.m.ArmorDamageMult = 0.75;
		this.m.DirectDamageMult = 0.4;
		this.m.DirectDamageAdd = 0.1;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill = this.new("scripts/skills/actives/bash");
		skill.m.Icon = "skills/active_183.png";
		skill.m.IconDisabled = "skills/active_183_sw.png";
		skill.m.Overlay = "active_183";
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/knock_out");
		skill.m.Icon = "skills/active_186.png";
		skill.m.IconDisabled = "skills/active_186_sw.png";
		skill.m.Overlay = "active_186";
		this.addSkill(skill);
	}

});


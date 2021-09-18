this.saif <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.saif";
		this.m.Name = "Saif";
		this.m.Description = "A curved sword typically found only in the southern reaches. Excellent for slashing, but not for thrusting or penetrating armor.";
		this.m.Categories = "Sword, One-Handed";
		this.m.IconLarge = "weapons/melee/southern_short_sword_01.png";
		this.m.Icon = "weapons/melee/southern_short_sword_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_southern_short_sword_01";
		this.m.Value = 350;
		this.m.Condition = 48.0;
		this.m.ConditionMax = 48.0;
		this.m.StaminaModifier = -4;
		this.m.RegularDamage = 35;
		this.m.RegularDamageMax = 40;
		this.m.ArmorDamageMult = 0.65;
		this.m.DirectDamageMult = 0.2;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill = this.new("scripts/skills/actives/slash");
		skill.m.Icon = "skills/active_172.png";
		skill.m.IconDisabled = "skills/active_172_sw.png";
		skill.m.Overlay = "active_172";
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/gash_skill");
		this.addSkill(skill);
	}

});


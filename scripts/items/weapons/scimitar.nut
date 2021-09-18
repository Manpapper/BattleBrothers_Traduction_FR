this.scimitar <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.scimitar";
		this.m.Name = "Scimitar";
		this.m.Description = "An exotic curved sword from the south that is excellent for slashing, but not for thrusting or penetrating armor.";
		this.m.Categories = "Sword, One-Handed";
		this.m.IconLarge = "weapons/melee/scimitar_02.png";
		this.m.Icon = "weapons/melee/scimitar_02_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_scimitar_02";
		this.m.Value = 1000;
		this.m.Condition = 48.0;
		this.m.ConditionMax = 48.0;
		this.m.StaminaModifier = -6;
		this.m.RegularDamage = 40;
		this.m.RegularDamageMax = 45;
		this.m.ArmorDamageMult = 0.7;
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


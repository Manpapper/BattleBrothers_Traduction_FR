this.goblin_falchion <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.goblin_falchion";
		this.m.Name = "Cruel Falchion";
		this.m.Description = "A lightweight goblin falchion made for cutting.";
		this.m.Categories = "Sword, One-Handed";
		this.m.IconLarge = "weapons/melee/goblin_weapon_02.png";
		this.m.Icon = "weapons/melee/goblin_weapon_02_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_goblin_weapon_02";
		this.m.Value = 900;
		this.m.Condition = 52.0;
		this.m.ConditionMax = 52.0;
		this.m.StaminaModifier = -4;
		this.m.RegularDamage = 35;
		this.m.RegularDamageMax = 45;
		this.m.ArmorDamageMult = 0.7;
		this.m.DirectDamageMult = 0.2;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local slash = this.new("scripts/skills/actives/slash");
		slash.m.Icon = "skills/active_78.png";
		slash.m.IconDisabled = "skills/active_78_sw.png";
		slash.m.Overlay = "active_78";
		this.addSkill(slash);
		this.addSkill(this.new("scripts/skills/actives/riposte"));
	}

});


this.axehammer <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.axehammer";
		this.m.Name = "Axehammer";
		this.m.Description = "A massive, rusty hybrid of hammer and axe. Due to its blunt edge more of the former than the latter.";
		this.m.Categories = "Hammer/Axe, One-Handed";
		this.m.IconLarge = "weapons/melee/wildmen_03.png";
		this.m.Icon = "weapons/melee/wildmen_03_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_wildmen_03";
		this.m.Value = 800;
		this.m.ShieldDamage = 14;
		this.m.Condition = 96.0;
		this.m.ConditionMax = 96.0;
		this.m.StaminaModifier = -10;
		this.m.RegularDamage = 20;
		this.m.RegularDamageMax = 30;
		this.m.ArmorDamageMult = 2.0;
		this.m.DirectDamageMult = 0.5;
		this.m.DirectDamageAdd = 0.1;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skillToAdd = this.new("scripts/skills/actives/hammer");
		skillToAdd.m.Icon = "skills/active_184.png";
		skillToAdd.m.IconDisabled = "skills/active_184_sw.png";
		skillToAdd.m.Overlay = "active_184";
		this.addSkill(skillToAdd);
		skillToAdd = this.new("scripts/skills/actives/split_shield");
		skillToAdd.setApplyAxeMastery(true);
		this.addSkill(skillToAdd);
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});


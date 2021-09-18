this.crude_axe <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.crude_axe";
		this.m.Name = "Crude Axe";
		this.m.Description = "This axe is crudely made, but heavy and jagged.";
		this.m.Categories = "Axe, One-Handed";
		this.m.IconLarge = "weapons/melee/wildmen_05.png";
		this.m.Icon = "weapons/melee/wildmen_05_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.IsAgainstShields = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_wildmen_05";
		this.m.Value = 800;
		this.m.ShieldDamage = 12;
		this.m.Condition = 82.0;
		this.m.ConditionMax = 82.0;
		this.m.StaminaModifier = -12;
		this.m.RegularDamage = 30;
		this.m.RegularDamageMax = 40;
		this.m.ArmorDamageMult = 1.2;
		this.m.DirectDamageMult = 0.3;
		this.m.DirectDamageAdd = 0.1;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill = this.new("scripts/skills/actives/chop");
		skill.m.Icon = "skills/active_185.png";
		skill.m.IconDisabled = "skills/active_185_sw.png";
		skill.m.Overlay = "active_185";
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/split_shield");
		skill.setApplyAxeMastery(true);
		this.addSkill(skill);
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});


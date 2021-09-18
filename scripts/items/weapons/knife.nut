this.knife <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.knife";
		this.m.Name = "Knife";
		this.m.Description = "A short knife, not made for combat.";
		this.m.Categories = "Dagger, One-Handed";
		this.m.IconLarge = "weapons/melee/knife_01.png";
		this.m.Icon = "weapons/melee/knife_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_knife_01";
		this.m.Value = 30;
		this.m.Condition = 32.0;
		this.m.ConditionMax = 32.0;
		this.m.RegularDamage = 15;
		this.m.RegularDamageMax = 25;
		this.m.ArmorDamageMult = 0.5;
		this.m.DirectDamageMult = 0.2;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/stab"));
		this.addSkill(this.new("scripts/skills/actives/puncture"));
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});


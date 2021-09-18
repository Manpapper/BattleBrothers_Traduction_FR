this.warhammer <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.warhammer";
		this.m.Name = "Warhammer";
		this.m.Description = "A short iron warhammer that easily batters through armor plates.";
		this.m.Categories = "Hammer, One-Handed";
		this.m.IconLarge = "weapons/melee/warhammer_01.png";
		this.m.Icon = "weapons/melee/warhammer_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_warhammer_01";
		this.m.Value = 2500;
		this.m.ShieldDamage = 0;
		this.m.Condition = 100.0;
		this.m.ConditionMax = 100.0;
		this.m.StaminaModifier = -8;
		this.m.RegularDamage = 30;
		this.m.RegularDamageMax = 40;
		this.m.ArmorDamageMult = 2.25;
		this.m.DirectDamageMult = 0.5;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/hammer"));
		this.addSkill(this.new("scripts/skills/actives/crush_armor"));
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});


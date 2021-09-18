this.military_pick <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.military_pick";
		this.m.Name = "Military Pick";
		this.m.Description = "A wooden shaft with a long and pointy metal head designed to puncture the sturdiest of armors.";
		this.m.Categories = "Hammer, One-Handed";
		this.m.IconLarge = "weapons/melee/military_pick_01.png";
		this.m.Icon = "weapons/melee/military_pick_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_pick_01";
		this.m.Value = 900;
		this.m.ShieldDamage = 0;
		this.m.Condition = 80.0;
		this.m.ConditionMax = 80.0;
		this.m.StaminaModifier = -8;
		this.m.RegularDamage = 20;
		this.m.RegularDamageMax = 35;
		this.m.ArmorDamageMult = 2.0;
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


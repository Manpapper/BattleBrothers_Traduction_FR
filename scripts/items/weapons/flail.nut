this.flail <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.flail";
		this.m.Name = "Flail";
		this.m.Description = "A separate striking head attached to a handle by a chain. A rather unpredictable weapon, but useful to strike over or around shield cover.";
		this.m.Categories = "Flail, One-Handed";
		this.m.IconLarge = "weapons/melee/flail_01.png";
		this.m.Icon = "weapons/melee/flail_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.ItemProperty = this.Const.Items.Property.IgnoresShieldwall;
		this.m.IsDoubleGrippable = true;
		this.m.IsAgainstShields = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_flail_01";
		this.m.Value = 1400;
		this.m.ShieldDamage = 0;
		this.m.Condition = 72.0;
		this.m.ConditionMax = 72.0;
		this.m.StaminaModifier = -8;
		this.m.RegularDamage = 25;
		this.m.RegularDamageMax = 55;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 10;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/flail_skill"));
		this.addSkill(this.new("scripts/skills/actives/lash_skill"));
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});


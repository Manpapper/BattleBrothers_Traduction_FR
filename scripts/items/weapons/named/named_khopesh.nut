this.named_khopesh <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.named_khopesh";
		this.m.NameList = this.Const.Strings.CleaverNames;
		this.m.PrefixList = this.Const.Strings.OldWeaponPrefix;
		this.m.UseRandomName = false;
		this.m.Description = "An elegant curved blade that is fitted on a richly ornated grip. Pieces like this have been lost for centuries and are said to date back to the height of the empire.";
		this.m.Categories = "Cleaver, One-Handed";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 3200;
		this.m.ShieldDamage = 0;
		this.m.Condition = 42.0;
		this.m.ConditionMax = 42.0;
		this.m.StaminaModifier = -10;
		this.m.RegularDamage = 35;
		this.m.RegularDamageMax = 55;
		this.m.ArmorDamageMult = 1.2;
		this.m.DirectDamageMult = 0.25;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/kopesh_01_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/kopesh_01_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_khopesh_named_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/cleave"));
		this.addSkill(this.new("scripts/skills/actives/decapitate"));
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});


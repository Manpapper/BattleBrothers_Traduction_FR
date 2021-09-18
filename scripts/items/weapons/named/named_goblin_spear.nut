this.named_goblin_spear <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.named_goblin_spear";
		this.m.NameList = this.Const.Strings.SpearNames;
		this.m.PrefixList = this.Const.Strings.GoblinWeaponPrefix;
		this.m.UseRandomName = false;
		this.m.Description = "A masterfully crafted goblin spear. Accurate, fast and deadly in the hands of any skilled fighter.";
		this.m.Categories = "Spear, One-Handed";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded | this.Const.Items.ItemType.Defensive;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 2000;
		this.m.Condition = 36.0;
		this.m.ConditionMax = 36.0;
		this.m.StaminaModifier = -2;
		this.m.RegularDamage = 25;
		this.m.RegularDamageMax = 35;
		this.m.ArmorDamageMult = 0.7;
		this.m.DirectDamageMult = 0.25;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/goblin_weapon_03_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/goblin_weapon_03_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_goblin_weapon_03_named_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/thrust"));
		this.addSkill(this.new("scripts/skills/actives/spearwall"));
	}

});


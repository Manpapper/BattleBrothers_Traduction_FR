this.named_goblin_falchion <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.named_goblin_falchion";
		this.m.NameList = this.Const.Strings.SwordNames;
		this.m.PrefixList = this.Const.Strings.GoblinWeaponPrefix;
		this.m.UseRandomName = false;
		this.m.Description = "Fashioned from sharpened black rock, this cruel blade can tear wounds faster than the eye can see. A truly remarkable piece.";
		this.m.Categories = "Sword, One-Handed";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 2600;
		this.m.Condition = 52.0;
		this.m.ConditionMax = 52.0;
		this.m.StaminaModifier = -2;
		this.m.RegularDamage = 35;
		this.m.RegularDamageMax = 45;
		this.m.ArmorDamageMult = 0.7;
		this.m.DirectDamageMult = 0.2;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/goblin_weapon_02_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/goblin_weapon_02_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_goblin_weapon_02_named_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		local slash = this.new("scripts/skills/actives/slash");
		slash.m.Icon = "skills/active_78.png";
		slash.m.IconDisabled = "skills/active_78_sw.png";
		slash.m.Overlay = "active_78";
		this.addSkill(slash);
		this.addSkill(this.new("scripts/skills/actives/riposte"));
	}

});


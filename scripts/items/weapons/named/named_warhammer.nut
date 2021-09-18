this.named_warhammer <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = this.Math.rand(1, 3);
		this.updateVariant();
		this.m.ID = "weapon.named_warhammer";
		this.m.NameList = this.Const.Strings.HammerNames;
		this.m.Description = "A well-crafted warhammer that easily batters through armor plates.";
		this.m.Categories = "Hammer, One-Handed";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 4200;
		this.m.ShieldDamage = 0;
		this.m.Condition = 100.0;
		this.m.ConditionMax = 100.0;
		this.m.StaminaModifier = -8;
		this.m.RegularDamage = 30;
		this.m.RegularDamageMax = 40;
		this.m.ArmorDamageMult = 2.25;
		this.m.DirectDamageMult = 0.5;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/warhammer_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/warhammer_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_named_warhammer_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/hammer"));
		this.addSkill(this.new("scripts/skills/actives/crush_armor"));
	}

});


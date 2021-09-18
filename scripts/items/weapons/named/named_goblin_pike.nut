this.named_goblin_pike <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.named_goblin_pike";
		this.m.NameList = this.Const.Strings.PikeNames;
		this.m.PrefixList = this.Const.Strings.GoblinWeaponPrefix;
		this.m.UseRandomName = false;
		this.m.Description = "A goblin pike with its jagged tips can tear terrible, bleeding wounds. This piece is particularly well-crafted.";
		this.m.Categories = "Polearm, Two-Handed";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded | this.Const.Items.ItemType.Defensive;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 2400;
		this.m.ShieldDamage = 0;
		this.m.Condition = 40.0;
		this.m.ConditionMax = 40.0;
		this.m.StaminaModifier = -6;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 50;
		this.m.RegularDamageMax = 70;
		this.m.ArmorDamageMult = 0.9;
		this.m.DirectDamageMult = 0.25;
		this.m.ChanceToHitHead = 5;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/goblin_weapon_04_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/goblin_weapon_04_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_goblin_weapon_04_named_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		local impale = this.new("scripts/skills/actives/rupture");
		impale.m.Icon = "skills/active_80.png";
		impale.m.IconDisabled = "skills/active_80_sw.png";
		impale.m.Overlay = "active_80";
		this.addSkill(impale);
		this.addSkill(this.new("scripts/skills/actives/repel"));
	}

});


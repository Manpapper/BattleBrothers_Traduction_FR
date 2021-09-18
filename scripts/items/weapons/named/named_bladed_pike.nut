this.named_bladed_pike <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.named_warscythe";
		this.m.NameList = this.Const.Strings.PikeNames;
		this.m.PrefixList = this.Const.Strings.OldWeaponPrefix;
		this.m.UseRandomName = false;
		this.m.Description = "This pike with a swerved blade hails from the legions of the ancient empire. Very few weapons have been preserved as well as this piece.";
		this.m.Categories = "Polearm, Two-Handed";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 2200;
		this.m.ShieldDamage = 0;
		this.m.Condition = 30.0;
		this.m.ConditionMax = 30.0;
		this.m.StaminaModifier = -14;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 55;
		this.m.RegularDamageMax = 80;
		this.m.ArmorDamageMult = 1.25;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 5;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/bladed_pike_01_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/bladed_pike_01_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_bladed_pike_named_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		local impale = this.new("scripts/skills/actives/impale");
		impale.m.Icon = "skills/active_54.png";
		impale.m.IconDisabled = "skills/active_54_sw.png";
		impale.m.Overlay = "active_54";
		this.addSkill(impale);
		this.addSkill(this.new("scripts/skills/actives/repel"));
	}

});


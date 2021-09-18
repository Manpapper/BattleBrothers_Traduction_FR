this.named_warbow <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = this.Math.rand(1, 3);
		this.updateVariant();
		this.m.ID = "weapon.named_warbow";
		this.m.NameList = this.Const.Strings.BowNames;
		this.m.Description = "Made from very strong yet flexible wood, this warbow has massive pulling power and is a rare piece of skilled craftsmanship.";
		this.m.Categories = "Bow, Two-Handed";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.Defensive;
		this.m.EquipSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = true;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 4600;
		this.m.RangeMin = 2;
		this.m.RangeMax = 7;
		this.m.RangeIdeal = 7;
		this.m.StaminaModifier = -6;
		this.m.Condition = 100.0;
		this.m.ConditionMax = 100.0;
		this.m.RegularDamage = 50;
		this.m.RegularDamageMax = 70;
		this.m.ArmorDamageMult = 0.6;
		this.m.DirectDamageMult = 0.35;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/ranged/bow_01_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/ranged/bow_01_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_named_bow_0" + this.m.Variant;
	}

	function getAmmoID()
	{
		return "ammo.arrows";
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/quick_shot"));
		this.addSkill(this.new("scripts/skills/actives/aimed_shot"));
	}

});


this.named_polehammer <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = this.Math.rand(1, 2);
		this.updateVariant();
		this.m.ID = "weapon.named_polehammer";
		this.m.NameList = this.Const.Strings.PolehammerNames;
		this.m.Description = "A crude weapon like a polehammer can also be crafted with passion, skill and attention to detail, as this exemplar showcases impressively.";
		this.m.Categories = "Hammer, Two-Handed";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 3200;
		this.m.ShieldDamage = 0;
		this.m.Condition = 100.0;
		this.m.ConditionMax = 100.0;
		this.m.StaminaModifier = -14;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 50;
		this.m.RegularDamageMax = 75;
		this.m.ArmorDamageMult = 1.85;
		this.m.DirectDamageMult = 0.5;
		this.m.ChanceToHitHead = 5;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/polehammer_01_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/polehammer_01_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_polehammer_01_named_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		local skill;
		local skill = this.new("scripts/skills/actives/batter_skill");
		this.addSkill(skill);
		local skill = this.new("scripts/skills/actives/demolish_armor_skill");
		this.addSkill(skill);
	}

});


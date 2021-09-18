this.named_longaxe <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = this.Math.rand(1, 3);
		this.updateVariant();
		this.m.ID = "weapon.named_longaxe";
		this.m.NameList = this.Const.Strings.LongaxeNames;
		this.m.Description = "A relatively thin blade on a very long shaft used for devastating cutting attacks over some distance, and to render shields unusable from behind the frontline. This longaxe must be the work of an extraordinary craftsman.";
		this.m.Categories = "Axe, Two-Handed";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 3000;
		this.m.ShieldDamage = 24;
		this.m.Condition = 72.0;
		this.m.ConditionMax = 72.0;
		this.m.StaminaModifier = -14;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 70;
		this.m.RegularDamageMax = 95;
		this.m.ArmorDamageMult = 1.1;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 5;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/longaxe_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/longaxe_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_named_longaxe_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		local strike_skill = this.new("scripts/skills/actives/strike_skill");
		strike_skill.setApplyAxeMastery(true);
		this.addSkill(strike_skill);
		local split_shield = this.new("scripts/skills/actives/split_shield");
		split_shield.setApplyAxeMastery(true);
		split_shield.m.MaxRange = 2;
		split_shield.m.FatigueCost += 10;
		split_shield.m.Icon = "skills/active_67.png";
		split_shield.m.IconDisabled = "skills/active_67_sw.png";
		split_shield.m.Overlay = "active_67";
		this.addSkill(split_shield);
	}

});


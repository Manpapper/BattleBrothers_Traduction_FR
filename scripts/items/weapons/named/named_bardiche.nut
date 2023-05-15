this.named_bardiche <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = this.Math.rand(1, 2);
		this.updateVariant();
		this.m.ID = "weapon.named_bardiche";
		this.m.NameList = this.Const.Strings.AxeNames;
		this.m.Description = "Cette lourde bardiche fabriquée à partir d\'un alliage rare est largement supérieure aux armes similaires.";
		this.m.Categories = "Hache, Deux-Mains";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 4600;
		this.m.ShieldDamage = 24;
		this.m.Condition = 64.0;
		this.m.ConditionMax = 64.0;
		this.m.StaminaModifier = -16;
		this.m.RegularDamage = 75;
		this.m.RegularDamageMax = 95;
		this.m.ArmorDamageMult = 1.3;
		this.m.DirectDamageMult = 0.4;
		this.m.ChanceToHitHead = 0;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/bardiche_01_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/bardiche_01_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_bardiche_01_named_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		local skillToAdd = this.new("scripts/skills/actives/split_man");
		skillToAdd.m.Icon = "skills/active_168.png";
		skillToAdd.m.IconDisabled = "skills/active_168_sw.png";
		skillToAdd.m.Overlay = "active_168";
		this.addSkill(skillToAdd);
		skillToAdd = this.new("scripts/skills/actives/split_axe");
		this.addSkill(skillToAdd);
		skillToAdd = this.new("scripts/skills/actives/split_shield");
		skillToAdd.setApplyAxeMastery(true);
		skillToAdd.setFatigueCost(skillToAdd.getFatigueCostRaw() + 5);
		this.addSkill(skillToAdd);
	}

});


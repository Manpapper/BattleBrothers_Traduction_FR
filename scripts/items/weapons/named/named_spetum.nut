this.named_spetum <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = this.Math.rand(1, 2);
		this.updateVariant();
		this.m.ID = "weapon.named_spetum";
		this.m.NameList = this.Const.Strings.SpetumNames;
		this.m.Description = "This Spetum is especially well-crafted, and its three tips have been honed into perfectly pointy spikes.";
		this.m.Categories = "Spear, Two-Handed";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 2800;
		this.m.ShieldDamage = 0;
		this.m.Condition = 60.0;
		this.m.ConditionMax = 60.0;
		this.m.StaminaModifier = -14;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 55;
		this.m.RegularDamageMax = 75;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.25;
		this.m.ChanceToHitHead = 5;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/spetum_01_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/spetum_01_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_spetum_01_named_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		local prong = this.new("scripts/skills/actives/prong_skill");
		this.addSkill(prong);
		local spearwall = this.new("scripts/skills/actives/spearwall");
		spearwall.m.Icon = "skills/active_124.png";
		spearwall.m.IconDisabled = "skills/active_124_sw.png";
		spearwall.m.Overlay = "active_124";
		spearwall.m.BaseAttackName = prong.getName();
		spearwall.setFatigueCost(spearwall.getFatigueCostRaw() + 5);
		spearwall.m.ActionPointCost = 6;
		this.addSkill(spearwall);
	}

});


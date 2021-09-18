this.spetum <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.spetum";
		this.m.Name = "Spetum";
		this.m.Description = "A cross between a spear and a pike, making for a good defensive weapon. Used for thrusting over some distance and keeping the enemy at bay.";
		this.m.Categories = "Spear, Two-Handed";
		this.m.IconLarge = "weapons/melee/spetum_01.png";
		this.m.Icon = "weapons/melee/spetum_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded | this.Const.Items.ItemType.Defensive;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_spetum_01";
		this.m.Value = 750;
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
	}

	function onEquip()
	{
		this.weapon.onEquip();
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


this.warscythe <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.warscythe";
		this.m.Name = "Warscythe";
		this.m.Description = "A long pole attached to a sharp curved blade, used to deliver deep sweeping strikes over some distance.";
		this.m.Categories = "Polearm, Two-Handed";
		this.m.IconLarge = "weapons/melee/warscythe_01.png";
		this.m.Icon = "weapons/melee/warscythe_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_warscythe_01";
		this.m.Value = 700;
		this.m.ShieldDamage = 0;
		this.m.Condition = 36.0;
		this.m.ConditionMax = 36.0;
		this.m.StaminaModifier = -16;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 55;
		this.m.RegularDamageMax = 80;
		this.m.ArmorDamageMult = 1.05;
		this.m.DirectDamageMult = 0.3;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local strike = this.new("scripts/skills/actives/strike_skill");
		strike.m.Icon = "skills/active_93.png";
		strike.m.IconDisabled = "skills/active_93_sw.png";
		strike.m.Overlay = "active_93";
		this.addSkill(strike);
		this.addSkill(this.new("scripts/skills/actives/reap_skill"));
	}

});


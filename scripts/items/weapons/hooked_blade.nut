this.hooked_blade <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.hooked_blade";
		this.m.Name = "Hooked Blade";
		this.m.Description = "An agricultural tool adapted for use in battle, this polearm has a hooked blade for striking over some distance and pulling in targets.";
		this.m.Categories = "Polearm, Two-Handed";
		this.m.IconLarge = "weapons/melee/hooked_blade_01.png";
		this.m.Icon = "weapons/melee/hooked_blade_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_bill_02";
		this.m.Value = 700;
		this.m.ShieldDamage = 0;
		this.m.Condition = 55.0;
		this.m.ConditionMax = 55.0;
		this.m.StaminaModifier = -12;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 40;
		this.m.RegularDamageMax = 70;
		this.m.ArmorDamageMult = 1.1;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 5;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local strike = this.new("scripts/skills/actives/strike_skill");
		strike.m.Icon = "skills/active_93.png";
		strike.m.IconDisabled = "skills/active_93_sw.png";
		strike.m.Overlay = "active_93";
		this.addSkill(strike);
		this.addSkill(this.new("scripts/skills/actives/hook"));
	}

});


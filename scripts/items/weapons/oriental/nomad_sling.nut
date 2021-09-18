this.nomad_sling <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.nomad_sling";
		this.m.Name = "Nomad Sling";
		this.m.Description = "A leather sling on a metal-reinforced staff, used to hurl stones at the enemy. With stones abundant everywhere, it will never run out of ammunition.";
		this.m.Categories = "Throwing Weapon, Two-Handed";
		this.m.IconLarge = "weapons/ranged/warriors_sling_01.png";
		this.m.Icon = "weapons/ranged/warriors_sling_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.Defensive;
		this.m.EquipSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_sling_02";
		this.m.Value = 300;
		this.m.StaminaModifier = -6;
		this.m.RangeMin = 2;
		this.m.RangeMax = 6;
		this.m.RangeIdeal = 6;
		this.m.Condition = 56.0;
		this.m.ConditionMax = 56.0;
		this.m.RegularDamage = 35;
		this.m.RegularDamageMax = 50;
		this.m.ArmorDamageMult = 0.6;
		this.m.DirectDamageMult = 0.35;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/sling_stone_skill"));
	}

});


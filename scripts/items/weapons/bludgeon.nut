this.bludgeon <- this.inherit("scripts/items/weapons/weapon", {
	m = {
		StunChance = 30
	},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.bludgeon";
		this.m.Name = "Bludgeon";
		this.m.Description = "A spiked metal head on a wooden shaft, crude but effective in bashing in heads.";
		this.m.Categories = "Mace, One-Handed";
		this.m.IconLarge = "weapons/melee/mace_02.png";
		this.m.Icon = "weapons/melee/mace_02_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_mace_02";
		this.m.Value = 90;
		this.m.Condition = 64.0;
		this.m.ConditionMax = 64.0;
		this.m.StaminaModifier = -8;
		this.m.RegularDamage = 20;
		this.m.RegularDamageMax = 35;
		this.m.ArmorDamageMult = 0.75;
		this.m.DirectDamageMult = 0.4;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/bash"));
		this.addSkill(this.new("scripts/skills/actives/knock_out"));
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});


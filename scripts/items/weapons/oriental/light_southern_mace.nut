this.light_southern_mace <- this.inherit("scripts/items/weapons/weapon", {
	m = {
		StunChance = 30
	},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.light_southern_mace";
		this.m.Name = "Light Southern Mace";
		this.m.Description = "A metal mace with extended wings for added effectiveness against armor.";
		this.m.Categories = "Mace, One-Handed";
		this.m.IconLarge = "weapons/melee/light_southern_mace_01.png";
		this.m.Icon = "weapons/melee/light_southern_mace_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_light_southern_mace_01";
		this.m.Value = 400;
		this.m.ShieldDamage = 0;
		this.m.Condition = 72.0;
		this.m.ConditionMax = 72.0;
		this.m.StaminaModifier = -10;
		this.m.RegularDamage = 30;
		this.m.RegularDamageMax = 40;
		this.m.ArmorDamageMult = 1.1;
		this.m.DirectDamageMult = 0.4;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local bash = this.new("scripts/skills/actives/bash");
		this.addSkill(bash);
		local knockout = this.new("scripts/skills/actives/knock_out");
		this.addSkill(knockout);
	}

});


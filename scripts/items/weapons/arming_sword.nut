this.arming_sword <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.arming_sword";
		this.m.Name = "Arming Sword";
		this.m.Description = "A lightweight, straight sword suitable for slashing, thrusting and swinging.";
		this.m.Categories = "Sword, One-Handed";
		this.m.IconLarge = "weapons/melee/sword_02.png";
		this.m.Icon = "weapons/melee/sword_02_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_sword_02";
		this.m.Condition = 56.0;
		this.m.ConditionMax = 56.0;
		this.m.StaminaModifier = -6;
		this.m.Value = 1250;
		this.m.RegularDamage = 40;
		this.m.RegularDamageMax = 45;
		this.m.ArmorDamageMult = 0.8;
		this.m.DirectDamageMult = 0.2;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/slash"));
		this.addSkill(this.new("scripts/skills/actives/riposte"));
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});


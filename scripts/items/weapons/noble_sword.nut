this.noble_sword <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.noble_sword";
		this.m.Name = "Noble Sword";
		this.m.Description = "A well-balanced long sword with a double-edged blade.";
		this.m.Categories = "Sword, One-Handed";
		this.m.IconLarge = "weapons/melee/sword_03.png";
		this.m.Icon = "weapons/melee/sword_03_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_sword_03";
		this.m.Condition = 72.0;
		this.m.ConditionMax = 72.0;
		this.m.StaminaModifier = -8;
		this.m.Value = 3200;
		this.m.RegularDamage = 45;
		this.m.RegularDamageMax = 50;
		this.m.ArmorDamageMult = 0.85;
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


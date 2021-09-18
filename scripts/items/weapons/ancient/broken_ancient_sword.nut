this.broken_ancient_sword <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.broken_ancient_sword";
		this.m.Name = "Broken Ancient Sword";
		this.m.Description = "An ancient sword with a broken blade, severely limiting its reach.";
		this.m.Categories = "Sword, One-Handed";
		this.m.IconLarge = "weapons/melee/ancient_broken_sword_01.png";
		this.m.Icon = "weapons/melee/ancient_broken_sword_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_ancient_sword_02";
		this.m.Value = 200;
		this.m.Condition = 24.0;
		this.m.ConditionMax = 24.0;
		this.m.StaminaModifier = -3;
		this.m.RegularDamage = 30;
		this.m.RegularDamageMax = 35;
		this.m.ArmorDamageMult = 0.75;
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


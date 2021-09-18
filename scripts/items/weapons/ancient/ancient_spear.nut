this.ancient_spear <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.ancient_spear";
		this.m.Name = "Ancient Spear";
		this.m.Description = "An ancient wooden spear of simple design. Time has taken its toll on this weapon.";
		this.m.Categories = "Spear, One-Handed";
		this.m.IconLarge = "weapons/melee/ancient_spear_01.png";
		this.m.Icon = "weapons/melee/ancient_spear_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded | this.Const.Items.ItemType.Defensive;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_ancient_spear_01";
		this.m.Value = 150;
		this.m.Condition = 36.0;
		this.m.ConditionMax = 36.0;
		this.m.StaminaModifier = -6;
		this.m.RegularDamage = 20;
		this.m.RegularDamageMax = 35;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.25;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/thrust"));
		this.addSkill(this.new("scripts/skills/actives/spearwall"));
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});


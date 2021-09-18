this.scramasax <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.scramasax";
		this.m.Name = "Scramasax";
		this.m.Description = "A long and heavy knife with a one sided blade used more for hacking than slashing.";
		this.m.Categories = "Cleaver, One-Handed";
		this.m.IconLarge = "weapons/melee/sax_01.png";
		this.m.Icon = "weapons/melee/sax_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_sax_01";
		this.m.Value = 700;
		this.m.Condition = 56.0;
		this.m.ConditionMax = 56.0;
		this.m.StaminaModifier = -8;
		this.m.RegularDamage = 30;
		this.m.RegularDamageMax = 45;
		this.m.ArmorDamageMult = 0.8;
		this.m.DirectDamageMult = 0.25;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/cleave"));
		this.addSkill(this.new("scripts/skills/actives/decapitate"));
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});


this.antler_cleaver <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.antler_cleaver";
		this.m.Name = "Antler Cleaver";
		this.m.Description = "A very crude cleaver crafted from a sharpened antler. Heavy and blunt, but still dangerous.";
		this.m.Categories = "Cleaver, One-Handed";
		this.m.IconLarge = "weapons/melee/wildmen_01.png";
		this.m.Icon = "weapons/melee/wildmen_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_wildmen_01";
		this.m.ShieldDamage = 0;
		this.m.Condition = 48.0;
		this.m.ConditionMax = 48.0;
		this.m.StaminaModifier = -8;
		this.m.Value = 120;
		this.m.RegularDamage = 20;
		this.m.RegularDamageMax = 30;
		this.m.ArmorDamageMult = 0.75;
		this.m.DirectDamageMult = 0.25;
		this.m.DirectDamageAdd = 0.1;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local cleave = this.new("scripts/skills/actives/cleave");
		cleave.m.Icon = "skills/active_177.png";
		cleave.m.IconDisabled = "skills/active_177_sw.png";
		cleave.m.Overlay = "active_177";
		this.addSkill(cleave);
		local decapitate = this.new("scripts/skills/actives/decapitate");
		this.addSkill(decapitate);
	}

});


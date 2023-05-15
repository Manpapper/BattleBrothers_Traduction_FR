this.two_handed_flail <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.two_handed_flail";
		this.m.Name = "Fléau à deux mains";
		this.m.Description = "Un grand fléau en métal lourd qui nécessitait deux mains pour l\'utiliser. Utile pour frapper sur ou autour d\'un bouclier.";
		this.m.Categories = "Fléau, Deux-Mains";
		this.m.IconLarge = "weapons/melee/flail_two_handed_02.png";
		this.m.Icon = "weapons/melee/flail_two_handed_02_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAoE = true;
		this.m.EquipSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_flail_two_handed_02";
		this.m.Value = 1400;
		this.m.ShieldDamage = 0;
		this.m.Condition = 80.0;
		this.m.ConditionMax = 80.0;
		this.m.StaminaModifier = -16;
		this.m.RegularDamage = 45;
		this.m.RegularDamageMax = 90;
		this.m.ArmorDamageMult = 1.15;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 15;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill;
		skill = this.new("scripts/skills/actives/pound");
		skill.m.Icon = "skills/active_129.png";
		skill.m.IconDisabled = "skills/active_129_sw.png";
		skill.m.Overlay = "active_129";
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/thresh");
		skill.m.Icon = "skills/active_130.png";
		skill.m.IconDisabled = "skills/active_130_sw.png";
		skill.m.Overlay = "active_130";
		this.addSkill(skill);
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});


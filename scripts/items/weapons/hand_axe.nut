this.hand_axe <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.hand_axe";
		this.m.Name = "Handaxe";
		this.m.Description = "A one-handed axe with a medium long shaft and a refined head.";
		this.m.Categories = "Axe, One-Handed";
		this.m.IconLarge = "weapons/melee/axe_02.png";
		this.m.Icon = "weapons/melee/axe_02_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.IsAgainstShields = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_axe_02";
		this.m.Value = 900;
		this.m.ShieldDamage = 12;
		this.m.Condition = 68.0;
		this.m.ConditionMax = 68.0;
		this.m.StaminaModifier = -10;
		this.m.RegularDamage = 30;
		this.m.RegularDamageMax = 45;
		this.m.ArmorDamageMult = 1.2;
		this.m.DirectDamageMult = 0.3;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/chop"));
		local skillToAdd = this.new("scripts/skills/actives/split_shield");
		skillToAdd.setApplyAxeMastery(true);
		this.addSkill(skillToAdd);
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});


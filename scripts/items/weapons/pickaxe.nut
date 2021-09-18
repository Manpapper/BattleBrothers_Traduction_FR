this.pickaxe <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.pickaxe";
		this.m.Name = "Pickaxe";
		this.m.Description = "A hard head made from metal attached to a wooden handle, the Pickaxe is a miner\'s tool used to break up rocks. As an improvised weapon it\'s unwieldy but can deliver fatal injuries even through armor.";
		this.m.Categories = "Hammer, One-Handed";
		this.m.IconLarge = "weapons/melee/miners_pick_01.png";
		this.m.Icon = "weapons/melee/miners_pick_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_pickaxe_01";
		this.m.Value = 120;
		this.m.ShieldDamage = 0;
		this.m.Condition = 56.0;
		this.m.ConditionMax = 56.0;
		this.m.StaminaModifier = -10;
		this.m.RegularDamage = 15;
		this.m.RegularDamageMax = 30;
		this.m.ArmorDamageMult = 1.5;
		this.m.DirectDamageMult = 0.5;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local hammer = this.new("scripts/skills/actives/hammer");
		hammer.m.Icon = "skills/active_60.png";
		hammer.m.IconDisabled = "skills/active_60_sw.png";
		hammer.m.Overlay = "active_60";
		this.addSkill(hammer);
		local crush = this.new("scripts/skills/actives/crush_armor");
		crush.m.Icon = "skills/active_59.png";
		crush.m.IconDisabled = "skills/active_59_sw.png";
		crush.m.Overlay = "active_59";
		this.addSkill(crush);
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});


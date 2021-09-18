this.qatal_dagger <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.qatal_dagger";
		this.m.Name = "Qatal Dagger";
		this.m.Description = "A curved blade notoriously used by assassins of the southern deserts. Particularly effective against targets already debilitated.";
		this.m.Categories = "Dagger, One-Handed";
		this.m.IconLarge = "weapons/melee/qatal_dagger_01.png";
		this.m.Icon = "weapons/melee/qatal_dagger_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_qatal_dagger";
		this.m.Condition = 60.0;
		this.m.ConditionMax = 60.0;
		this.m.Value = 1000;
		this.m.RegularDamage = 30;
		this.m.RegularDamageMax = 45;
		this.m.ArmorDamageMult = 0.7;
		this.m.DirectDamageMult = 0.2;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local s = this.new("scripts/skills/actives/stab");
		s.m.Icon = "skills/active_198.png";
		s.m.IconDisabled = "skills/active_198_sw.png";
		s.m.Overlay = "active_198";
		this.addSkill(s);
		this.addSkill(this.new("scripts/skills/actives/deathblow_skill"));
	}

});


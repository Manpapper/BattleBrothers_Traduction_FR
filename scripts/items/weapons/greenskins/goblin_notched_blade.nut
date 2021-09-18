this.goblin_notched_blade <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.goblin_notched_blade";
		this.m.Name = "Notched Blade";
		this.m.Description = "A long curved knife with a one sided blade used for slashing, hacking and stabbing at weak spots.";
		this.m.Categories = "Sword/Dagger, One-Handed";
		this.m.IconLarge = "weapons/melee/goblin_weapon_01.png";
		this.m.Icon = "weapons/melee/goblin_weapon_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_goblin_weapon_01";
		this.m.Value = 350;
		this.m.Condition = 44.0;
		this.m.ConditionMax = 44.0;
		this.m.StaminaModifier = -3;
		this.m.RegularDamage = 20;
		this.m.RegularDamageMax = 30;
		this.m.ArmorDamageMult = 0.6;
		this.m.DirectDamageMult = 0.2;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local slash = this.new("scripts/skills/actives/slash");
		slash.m.Icon = "skills/active_77.png";
		slash.m.IconDisabled = "skills/active_77_sw.png";
		slash.m.Overlay = "active_77";
		this.addSkill(slash);
		this.addSkill(this.new("scripts/skills/actives/puncture"));
	}

});


this.morning_star <- this.inherit("scripts/items/weapons/weapon", {
	m = {
		StunChance = 30
	},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.morning_star";
		this.m.Name = "Morning Star";
		this.m.Description = "Un manche en bois avec une tête en métal à pointes utilisé pour délivrer une combinaison de coups contondants et perforants.";
		this.m.Categories = "Mace, One-Handed";
		this.m.IconLarge = "weapons/melee/morning_star_01.png";
		this.m.Icon = "weapons/melee/morning_star_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_morning_star_01";
		this.m.Value = 600;
		this.m.ShieldDamage = 0;
		this.m.Condition = 72.0;
		this.m.ConditionMax = 72.0;
		this.m.StaminaModifier = -10;
		this.m.RegularDamage = 30;
		this.m.RegularDamageMax = 45;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.4;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local bash = this.new("scripts/skills/actives/bash");
		bash.m.Icon = "skills/active_76.png";
		bash.m.IconDisabled = "skills/active_76_sw.png";
		bash.m.Overlay = "active_76";
		this.addSkill(bash);
		this.addSkill(this.new("scripts/skills/actives/knock_out"));
	}

});


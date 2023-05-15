this.polemace <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.polemace";
		this.m.Name = "Polemace";
		this.m.Description = "Une longue masse qui peut être utilisée pour délivrer des coups époustouflants à distance.";
		this.m.Categories = "Masse, Deux-Mains";
		this.m.IconLarge = "weapons/melee/polemace_01.png";
		this.m.Icon = "weapons/melee/polemace_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_polemace_01";
		this.m.Value = 1400;
		this.m.ShieldDamage = 0;
		this.m.Condition = 64.0;
		this.m.ConditionMax = 64.0;
		this.m.StaminaModifier = -14;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 60;
		this.m.RegularDamageMax = 75;
		this.m.ArmorDamageMult = 1.2;
		this.m.DirectDamageMult = 0.4;
		this.m.ChanceToHitHead = 5;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill = this.new("scripts/skills/actives/crumble_skill");
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/knock_over_skill");
		this.addSkill(skill);
	}

});


this.polehammer <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.polehammer";
		this.m.Name = "Polehammer";
		this.m.Description = "A warhammer mounted on a long pole, used against armored targets over some distance and from behind the frontline.";
		this.m.Categories = "Hammer, Two-Handed";
		this.m.IconLarge = "weapons/melee/polehammer_01.png";
		this.m.Icon = "weapons/melee/polehammer_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_polehammer_01";
		this.m.Value = 1500;
		this.m.ShieldDamage = 0;
		this.m.Condition = 100.0;
		this.m.ConditionMax = 100.0;
		this.m.StaminaModifier = -14;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 50;
		this.m.RegularDamageMax = 75;
		this.m.ArmorDamageMult = 1.85;
		this.m.DirectDamageMult = 0.5;
		this.m.ChanceToHitHead = 5;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill;
		local skill = this.new("scripts/skills/actives/batter_skill");
		this.addSkill(skill);
		local skill = this.new("scripts/skills/actives/demolish_armor_skill");
		this.addSkill(skill);
	}

});


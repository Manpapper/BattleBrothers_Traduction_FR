this.thorned_whip <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.thorned_whip";
		this.m.Name = "Thorned Whip";
		this.m.Description = "A sturdy thorned whip. Used by barbarians both in battle and to herd wild beasts, even the largest of which will flinch from its crack.";
		this.m.Categories = "Cleaver, One-Handed";
		this.m.IconLarge = "weapons/melee/wildmen_11.png";
		this.m.Icon = "weapons/melee/wildmen_11_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_wildmen_11";
		this.m.RangeMin = 1;
		this.m.RangeMax = 3;
		this.m.RangeIdeal = 3;
		this.m.Value = 400;
		this.m.Condition = 40;
		this.m.ConditionMax = 40;
		this.m.StaminaModifier = -6;
		this.m.RegularDamage = 15;
		this.m.RegularDamageMax = 25;
		this.m.ArmorDamageMult = 0.3;
		this.m.DirectDamageMult = 0.1;
		this.m.DirectDamageAdd = 0.1;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill = this.new("scripts/skills/actives/whip_skill");
		skill.m.Icon = "skills/active_161.png";
		skill.m.IconDisabled = "skills/active_161_sw.png";
		skill.m.Overlay = "active_161";
		this.addSkill(skill);
		local skill = this.new("scripts/skills/actives/disarm_skill");
		this.addSkill(skill);
	}

});


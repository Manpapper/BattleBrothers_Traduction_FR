this.drum_item <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.barbarian_drum";
		this.m.Name = "Drum";
		this.m.Description = "";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.TwoHanded | this.Const.Items.ItemType.Misc;
		this.m.IsDoubleGrippable = true;
		this.m.IsDroppedAsLoot = false;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_wildmen_10";
		this.m.RangeMin = 1;
		this.m.RangeMax = 6;
		this.m.RangeIdeal = 6;
		this.m.Value = 0;
		this.m.Condition = 0;
		this.m.ConditionMax = 0;
		this.m.StaminaModifier = 0;
		this.m.RegularDamage = 5;
		this.m.RegularDamageMax = 5;
		this.m.ArmorDamageMult = 0.0;
		this.m.DirectDamageMult = 0.0;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/drums_of_war_skill"));
	}

});


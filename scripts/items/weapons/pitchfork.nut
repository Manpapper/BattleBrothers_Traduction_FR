this.pitchfork <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.pitchfork";
		this.m.Name = "Pitchfork";
		this.m.Description = "An agricultural tool with a long handle and thick pointed tines used to lift and pitch straw. As an improvised weapon it can be used to keep an opponent at bay, but it won\'t inflict the deadliest of injuries and will perform poorly against armor.";
		this.m.Categories = "Polearm, Two-Handed";
		this.m.IconLarge = "weapons/melee/pitchfork_01.png";
		this.m.Icon = "weapons/melee/pitchfork_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_pitchfork_01";
		this.m.Value = 150;
		this.m.ShieldDamage = 0;
		this.m.Condition = 40.0;
		this.m.ConditionMax = 40.0;
		this.m.StaminaModifier = -14;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 30;
		this.m.RegularDamageMax = 50;
		this.m.ArmorDamageMult = 0.75;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 5;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local impale = this.new("scripts/skills/actives/impale");
		impale.m.Icon = "skills/active_57.png";
		impale.m.IconDisabled = "skills/active_57_sw.png";
		impale.m.Overlay = "active_57";
		this.addSkill(impale);
		local repel = this.new("scripts/skills/actives/repel");
		repel.m.Icon = "skills/active_58.png";
		repel.m.IconDisabled = "skills/active_58_sw.png";
		repel.m.Overlay = "active_58";
		this.addSkill(repel);
	}

});


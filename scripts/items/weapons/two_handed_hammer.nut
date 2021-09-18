this.two_handed_hammer <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.two_handed_hammer";
		this.m.Name = "Two-Handed Hammer";
		this.m.Description = "A large and heavy hammer held with both hands. What it lacks in grace, it makes up for in raw force as it is used to shatter even heavily-armored enemy lines by knocking people away or to the ground.";
		this.m.Categories = "Hammer, Two-Handed";
		this.m.IconLarge = "weapons/melee/hammer_two_handed_01.png";
		this.m.Icon = "weapons/melee/hammer_two_handed_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_hammer_01";
		this.m.Value = 2000;
		this.m.ShieldDamage = 26;
		this.m.Condition = 120.0;
		this.m.ConditionMax = 120.0;
		this.m.StaminaModifier = -18;
		this.m.RegularDamage = 60;
		this.m.RegularDamageMax = 90;
		this.m.ArmorDamageMult = 2.0;
		this.m.DirectDamageMult = 0.5;
		this.m.ChanceToHitHead = 0;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/smite_skill"));
		this.addSkill(this.new("scripts/skills/actives/shatter_skill"));
		local skillToAdd = this.new("scripts/skills/actives/split_shield");
		skillToAdd.setFatigueCost(skillToAdd.getFatigueCostRaw() + 5);
		this.addSkill(skillToAdd);
	}

});


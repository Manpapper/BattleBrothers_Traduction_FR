this.two_handed_wooden_hammer <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.two_handed_wooden_hammer";
		this.m.Name = "Two-Handed Mallet";
		this.m.Description = "A large wooden mallet that is held with both hands. Can deal devastating blows that may knock even armored enemies away or to the ground.";
		this.m.Categories = "Hammer, Two-Handed";
		this.m.IconLarge = "weapons/melee/hammer_two_handed_02.png";
		this.m.Icon = "weapons/melee/hammer_two_handed_02_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_hammer_02";
		this.m.Value = 500;
		this.m.ShieldDamage = 20;
		this.m.Condition = 50.0;
		this.m.ConditionMax = 50.0;
		this.m.StaminaModifier = -14;
		this.m.RegularDamage = 40;
		this.m.RegularDamageMax = 70;
		this.m.ArmorDamageMult = 1.5;
		this.m.DirectDamageMult = 0.5;
		this.m.ChanceToHitHead = 0;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill;
		skill = this.new("scripts/skills/actives/smite_skill");
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/shatter_skill");
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/split_shield");
		skill.setFatigueCost(skill.getFatigueCostRaw() + 5);
		this.addSkill(skill);
	}

});


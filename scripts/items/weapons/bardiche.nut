this.bardiche <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.bardiche";
		this.m.Name = "Bardiche";
		this.m.Description = "A large axe with a long head that can be brought down on the enemy with devastating effect.";
		this.m.Categories = "Axe, Two-Handed";
		this.m.IconLarge = "weapons/melee/bardiche_01.png";
		this.m.Icon = "weapons/melee/bardiche_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = false;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_bardiche_01";
		this.m.Value = 2200;
		this.m.ShieldDamage = 24;
		this.m.Condition = 64.0;
		this.m.ConditionMax = 64.0;
		this.m.StaminaModifier = -16;
		this.m.RegularDamage = 75;
		this.m.RegularDamageMax = 95;
		this.m.ArmorDamageMult = 1.3;
		this.m.DirectDamageMult = 0.4;
		this.m.ChanceToHitHead = 0;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skillToAdd = this.new("scripts/skills/actives/split_man");
		skillToAdd.m.Icon = "skills/active_168.png";
		skillToAdd.m.IconDisabled = "skills/active_168_sw.png";
		skillToAdd.m.Overlay = "active_168";
		this.addSkill(skillToAdd);
		skillToAdd = this.new("scripts/skills/actives/split_axe");
		this.addSkill(skillToAdd);
		skillToAdd = this.new("scripts/skills/actives/split_shield");
		skillToAdd.setApplyAxeMastery(true);
		skillToAdd.setFatigueCost(skillToAdd.getFatigueCostRaw() + 5);
		this.addSkill(skillToAdd);
	}

});


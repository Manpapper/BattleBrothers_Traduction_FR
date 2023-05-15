this.woodcutters_axe <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.woodcutters_axe";
		this.m.Name = "Hache de bûcheron";
		this.m.Description = "Une longue hache à deux mains qui pèse lourdement à chaque coup. Tenu à deux mains, il sert à abattre les grands arbres, mais il peut tout aussi bien abattre les hommes.";
		this.m.Categories = "Hache, Deux-Mains";
		this.m.IconLarge = "weapons/melee/axe_two_handed_02.png";
		this.m.Icon = "weapons/melee/axe_two_handed_02_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_axe_two_handed_02";
		this.m.Value = 400;
		this.m.ShieldDamage = 30;
		this.m.Condition = 48.0;
		this.m.ConditionMax = 48.0;
		this.m.StaminaModifier = -14;
		this.m.RegularDamage = 35;
		this.m.RegularDamageMax = 70;
		this.m.ArmorDamageMult = 1.25;
		this.m.DirectDamageMult = 0.4;
		this.m.ChanceToHitHead = 0;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/split_man"));
		this.addSkill(this.new("scripts/skills/actives/round_swing"));
		local skillToAdd = this.new("scripts/skills/actives/split_shield");
		skillToAdd.setApplyAxeMastery(true);
		skillToAdd.setFatigueCost(skillToAdd.getFatigueCostRaw() + 5);
		this.addSkill(skillToAdd);
	}

});


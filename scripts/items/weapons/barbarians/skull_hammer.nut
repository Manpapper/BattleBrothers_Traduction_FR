this.skull_hammer <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.skull_hammer";
		this.m.Name = "Marteau crâne à deux mains";
		this.m.Description = "Un marteau en métal brut utilisé à deux mains pour écraser à la fois l\'armure et son porteur.";
		this.m.Categories = "Hammer, Deux-Mains";
		this.m.IconLarge = "weapons/melee/wildmen_07.png";
		this.m.Icon = "weapons/melee/wildmen_07_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_wildmen_07";
		this.m.Value = 1300;
		this.m.ShieldDamage = 26;
		this.m.Condition = 120.0;
		this.m.ConditionMax = 120.0;
		this.m.StaminaModifier = -16;
		this.m.RegularDamage = 45;
		this.m.RegularDamageMax = 65;
		this.m.ArmorDamageMult = 1.8;
		this.m.DirectDamageMult = 0.5;
		this.m.DirectDamageAdd = 0.1;
		this.m.ChanceToHitHead = 0;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill = this.new("scripts/skills/actives/smite_skill");
		skill.m.Icon = "skills/active_180.png";
		skill.m.IconDisabled = "skills/active_180_sw.png";
		skill.m.Overlay = "active_180";
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/shatter_skill");
		skill.m.Icon = "skills/active_181.png";
		skill.m.IconDisabled = "skills/active_181_sw.png";
		skill.m.Overlay = "active_181";
		this.addSkill(skill);
		local skill = this.new("scripts/skills/actives/split_shield");
		skill.setFatigueCost(skill.getFatigueCostRaw() + 5);
		this.addSkill(skill);
	}

});


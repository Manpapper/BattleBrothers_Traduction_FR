this.rusty_warblade <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.rusty_warblade";
		this.m.Name = "Rusty Warblade";
		this.m.Description = "A heavy blade with a curved end combining sword and axe into a devastating two-handed cleaver.";
		this.m.Categories = "Cleaver, Two-Handed";
		this.m.IconLarge = "weapons/melee/wildmen_08.png";
		this.m.Icon = "weapons/melee/wildmen_08_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_wildmen_08";
		this.m.Value = 1600;
		this.m.ShieldDamage = 16;
		this.m.Condition = 52.0;
		this.m.ConditionMax = 52.0;
		this.m.StaminaModifier = -18;
		this.m.RegularDamage = 60;
		this.m.RegularDamageMax = 80;
		this.m.ArmorDamageMult = 1.1;
		this.m.DirectDamageAdd = 0.1;
		this.m.DirectDamageMult = 0.25;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local cleave = this.new("scripts/skills/actives/cleave");
		cleave.m.Icon = "skills/active_182.png";
		cleave.m.IconDisabled = "skills/active_182_sw.png";
		cleave.m.Overlay = "active_182";
		cleave.m.FatigueCost = 15;
		this.addSkill(cleave);
		this.addSkill(this.new("scripts/skills/actives/decapitate"));
		local skillToAdd = this.new("scripts/skills/actives/split_shield");
		skillToAdd.setFatigueCost(skillToAdd.getFatigueCostRaw() + 5);
		this.addSkill(skillToAdd);
	}

});


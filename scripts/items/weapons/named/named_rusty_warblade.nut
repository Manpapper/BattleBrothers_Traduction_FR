this.named_rusty_warblade <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.named_rusty_warblade";
		this.m.NameList = this.Const.Strings.CleaverNames;
		this.m.PrefixList = this.Const.Strings.BarbarianPrefix;
		this.m.SuffixList = this.Const.Strings.BarbarianSuffix;
		this.m.UseRandomName = false;
		this.m.Description = "This massive and exceptionally well-crafted warblade is covered with runes and decorations that are typical for the barbarian tribes of the north.";
		this.m.Categories = "Cleaver, Two-Handed";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 3200;
		this.m.ShieldDamage = 16;
		this.m.Condition = 52.0;
		this.m.ConditionMax = 52.0;
		this.m.StaminaModifier = -18;
		this.m.RegularDamage = 60;
		this.m.RegularDamageMax = 80;
		this.m.ArmorDamageMult = 1.1;
		this.m.DirectDamageAdd = 0.1;
		this.m.DirectDamageMult = 0.25;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/wildmen_08_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/wildmen_08_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_wildmen_08_named_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
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


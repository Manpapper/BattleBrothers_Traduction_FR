this.named_crypt_cleaver <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.named_crypt_cleaver";
		this.m.NameList = this.Const.Strings.CleaverNames;
		this.m.PrefixList = this.Const.Strings.OldWeaponPrefix;
		this.m.UseRandomName = false;
		this.m.Description = "A massive cleaver that can cut through flesh and armor alike. This piece is in good condition despite its old age.";
		this.m.Categories = "Cleaver, Two-Handed";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 3200;
		this.m.ShieldDamage = 16;
		this.m.Condition = 48.0;
		this.m.ConditionMax = 48.0;
		this.m.StaminaModifier = -16;
		this.m.RegularDamage = 60;
		this.m.RegularDamageMax = 80;
		this.m.ArmorDamageMult = 1.2;
		this.m.DirectDamageMult = 0.25;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/cryptcleaver_01_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/cryptcleaver_01_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_cryptcleaver_named_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		local cleave = this.new("scripts/skills/actives/cleave");
		cleave.m.FatigueCost = 15;
		this.addSkill(cleave);
		this.addSkill(this.new("scripts/skills/actives/decapitate"));
		local skillToAdd = this.new("scripts/skills/actives/split_shield");
		skillToAdd.setFatigueCost(skillToAdd.getFatigueCostRaw() + 5);
		this.addSkill(skillToAdd);
	}

});


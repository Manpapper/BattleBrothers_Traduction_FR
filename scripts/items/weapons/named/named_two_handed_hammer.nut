this.named_two_handed_hammer <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = this.Math.rand(1, 3);
		this.updateVariant();
		this.m.ID = "weapon.named_two_handed_hammer";
		this.m.NameList = this.Const.Strings.HammerNames;
		this.m.Description = "A massive hammer that is surprisingly well-balanced, despite its huge weight. What it lacks in grace, it makes up for in raw force as it is used to shatter even heavily-armored enemy lines by knocking people away or to the ground.";
		this.m.Categories = "Hammer, Two-Handed";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 4000;
		this.m.ShieldDamage = 26;
		this.m.Condition = 120.0;
		this.m.ConditionMax = 120.0;
		this.m.StaminaModifier = -18;
		this.m.RegularDamage = 60;
		this.m.RegularDamageMax = 90;
		this.m.ArmorDamageMult = 2.0;
		this.m.DirectDamageMult = 0.5;
		this.m.ChanceToHitHead = 0;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/hammer_two_handed_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/hammer_two_handed_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_named_hammer_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/smite_skill"));
		this.addSkill(this.new("scripts/skills/actives/shatter_skill"));
		local skillToAdd = this.new("scripts/skills/actives/split_shield");
		skillToAdd.setFatigueCost(skillToAdd.getFatigueCostRaw() + 5);
		this.addSkill(skillToAdd);
	}

});


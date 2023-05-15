this.named_warbrand <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = this.Math.rand(1, 3);
		this.updateVariant();
		this.m.ID = "weapon.named_warbrand";
		this.m.NameList = this.Const.Strings.WarbrandNames;
		this.m.Description = "Une variante magistralement conçue et quelque peu rare de l\'épée avec une lame longue et fine, affûtée d\'un seul côté et sans garde-corps. Peut être utilisé à la fois pour des entailles rapides et des frappes rapides.";
		this.m.Categories = "Epée, Deux-Mains";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = false;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 4000;
		this.m.ShieldDamage = 0;
		this.m.Condition = 64.0;
		this.m.ConditionMax = 64.0;
		this.m.StaminaModifier = -10;
		this.m.RegularDamage = 50;
		this.m.RegularDamageMax = 75;
		this.m.ArmorDamageMult = 0.75;
		this.m.DirectDamageMult = 0.2;
		this.m.ChanceToHitHead = 5;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/military_scythe_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/military_scythe_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_named_warbrand_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		local slash = this.new("scripts/skills/actives/slash");
		slash.m.FatigueCost = 13;
		this.addSkill(slash);
		this.addSkill(this.new("scripts/skills/actives/split"));
		this.addSkill(this.new("scripts/skills/actives/swing"));
	}

});


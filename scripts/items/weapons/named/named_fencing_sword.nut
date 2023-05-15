this.named_fencing_sword <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = this.Math.rand(1, 2);
		this.updateVariant();
		this.m.ID = "weapon.named_fencing_sword";
		this.m.NameList = this.Const.Strings.FencingSwordNames;
		this.m.Description = "Fabriquer une épée d\'escrime appropriée, à la fois délicate et flexible, n\'est pas moins difficile que de la manier. Le forgeron qui a créé cette arme particulière doit avoir été parmi les meilleurs dans son métier.";
		this.m.Categories = "Epée, Une Main";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Condition = 48.0;
		this.m.ConditionMax = 48.0;
		this.m.StaminaModifier = -4;
		this.m.Value = 4000;
		this.m.RegularDamage = 35;
		this.m.RegularDamageMax = 50;
		this.m.ArmorDamageMult = 0.75;
		this.m.DirectDamageMult = 0.2;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/sword_fencing_01_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/sword_fencing_01_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_fencing_sword_01_named_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/slash"));
		this.addSkill(this.new("scripts/skills/actives/lunge_skill"));
	}

});


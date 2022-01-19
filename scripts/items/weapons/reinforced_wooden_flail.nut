this.reinforced_wooden_flail <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.reinforced_wooden_flail";
		this.m.Name = "Fléau en bois renforcé";
		this.m.Description = "Deux gros bâtons attachés par une chaîne courte et renforcés de métal, le fléau en bois renforcé est un outil agricole transformé en arme. Plutôt imprévisible, mais suffisamment mortel pour abattre la plupart des hommes avec un bon coup à la tête, et utile pour frapper par-dessus ou autour d\'un bouclier.";
		this.m.Categories = "Flail, One-Handed";
		this.m.IconLarge = "weapons/melee/flail_03.png";
		this.m.Icon = "weapons/melee/flail_03_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.ItemProperty = this.Const.Items.Property.IgnoresShieldwall;
		this.m.IsDoubleGrippable = true;
		this.m.IsAgainstShields = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_flail_03";
		this.m.Value = 300;
		this.m.ShieldDamage = 0;
		this.m.Condition = 40.0;
		this.m.ConditionMax = 40.0;
		this.m.StaminaModifier = -7;
		this.m.RegularDamage = 20;
		this.m.RegularDamageMax = 45;
		this.m.ArmorDamageMult = 0.8;
		this.m.ChanceToHitHead = 10;
		this.m.DirectDamageMult = 0.3;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local flail = this.new("scripts/skills/actives/flail_skill");
		flail.m.Icon = "skills/active_65.png";
		flail.m.IconDisabled = "skills/active_65_sw.png";
		flail.m.Overlay = "active_65";
		this.addSkill(flail);
		local lash = this.new("scripts/skills/actives/lash_skill");
		lash.m.Icon = "skills/active_92.png";
		lash.m.IconDisabled = "skills/active_92_sw.png";
		lash.m.Overlay = "active_92";
		this.addSkill(lash);
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});


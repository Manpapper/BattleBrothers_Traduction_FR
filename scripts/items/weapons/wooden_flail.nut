this.wooden_flail <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.wooden_flail";
		this.m.Name = "Fléau en bois";
		this.m.Description = "Deux gros bâtons attachés avec une chaîne courte, le fléau en bois est un outil agricole utilisé pour frapper des tas de céréales pour détacher les cosses. En tant qu\'arme improvisée, il est plutôt imprévisible mais utile de frapper sur ou autour de la couverture du bouclier.";
		this.m.Categories = "Fléau, Une Main";
		this.m.IconLarge = "weapons/melee/flail_02.png";
		this.m.Icon = "weapons/melee/flail_02_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.ItemProperty = this.Const.Items.Property.IgnoresShieldwall;
		this.m.IsDoubleGrippable = true;
		this.m.IsAgainstShields = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_flail_02";
		this.m.Value = 40;
		this.m.ShieldDamage = 0;
		this.m.Condition = 32.0;
		this.m.ConditionMax = 32.0;
		this.m.StaminaModifier = -6;
		this.m.RegularDamage = 10;
		this.m.RegularDamageMax = 25;
		this.m.ArmorDamageMult = 0.5;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 10;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local flail = this.new("scripts/skills/actives/flail_skill");
		flail.m.Icon = "skills/active_62.png";
		flail.m.IconDisabled = "skills/active_62_sw.png";
		flail.m.Overlay = "active_62";
		this.addSkill(flail);
		local lash = this.new("scripts/skills/actives/lash_skill");
		lash.m.Icon = "skills/active_94.png";
		lash.m.IconDisabled = "skills/active_94_sw.png";
		lash.m.Overlay = "active_94";
		this.addSkill(lash);
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});


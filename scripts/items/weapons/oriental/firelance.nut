this.firelance <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.firelance";
		this.m.Name = "Lance de feu";
		this.m.Description = "Une lance de conception méridionale avec une charge explosive qui crachera du feu sur deux tuiles lorsqu\'elle est allumée. La charge n\'est utilisable qu\'une seule fois par bataille, mais automatiquement rechargée après la bataille.";
		this.m.Categories = "Spear/Firearm, Une Main";
		this.m.IconLarge = "weapons/ranged/firelance_01.png";
		this.m.Icon = "weapons/ranged/firelance_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.Ammo;
		this.m.IsDroppedAsLoot = true;
		this.m.AddGenericSkill = true;
		this.m.ShowArmamentIcon = true;
		this.m.IsDoubleGrippable = true;
		this.m.ArmamentIcon = "icon_firelance_01";
		this.m.Value = 750;
		this.m.Ammo = 1;
		this.m.AmmoMax = 1;
		this.m.AmmoCost = 3;
		this.m.RangeMin = 1;
		this.m.RangeMax = 1;
		this.m.RangeIdeal = 1;
		this.m.RangeMaxBonus = 0;
		this.m.Condition = 48.0;
		this.m.ConditionMax = 48.0;
		this.m.StaminaModifier = -12;
		this.m.RegularDamage = 30;
		this.m.RegularDamageMax = 35;
		this.m.ArmorDamageMult = 1.1;
		this.m.DirectDamageMult = 0.25;
		this.m.ShieldDamage = 0;
		this.m.ChanceToHitHead = 0;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/thrust"));
		this.addSkill(this.new("scripts/skills/actives/ignite_firelance_skill"));
	}

	function setAmmo( _a )
	{
		this.weapon.setAmmo(_a);

		if (this.m.Ammo > 0)
		{
			this.m.Name = "Lance de feu";
			this.m.IconLarge = "weapons/ranged/firelance_01.png";
			this.m.Icon = "weapons/ranged/firelance_01_70x70.png";
			this.m.ArmamentIcon = "icon_firelance_01";
		}
		else
		{
			this.m.Name = "Lance de feu (Utilisé)";
			this.m.IconLarge = "weapons/ranged/firelance_02.png";
			this.m.Icon = "weapons/ranged/firelance_02_70x70.png";
			this.m.ArmamentIcon = "icon_firelance_01_empty";
		}

		this.updateAppearance();
	}

});


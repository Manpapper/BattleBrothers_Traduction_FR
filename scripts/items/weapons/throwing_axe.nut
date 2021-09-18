this.throwing_axe <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function isAmountShown()
	{
		return true;
	}

	function getAmountString()
	{
		return this.m.Ammo + "/" + this.m.AmmoMax;
	}

	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.throwing_axe";
		this.m.Name = "Bundle of Throwing Axes";
		this.m.Description = "Small axes to be thrown in an overhand motion towards a target. Heavy enough to inflict serious damage to armor and shields from range.";
		this.m.Categories = "Throwing Weapon, One-Handed";
		this.m.IconLarge = "weapons/ranged/throwing_axes_01.png";
		this.m.Icon = "weapons/ranged/throwing_axes_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.Ammo | this.Const.Items.ItemType.Defensive;
		this.m.AddGenericSkill = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_throwing_axes_01";
		this.m.Value = 200;
		this.m.Ammo = 5;
		this.m.AmmoMax = 5;
		this.m.RangeMin = 2;
		this.m.RangeMax = 4;
		this.m.RangeIdeal = 4;
		this.m.StaminaModifier = -4;
		this.m.RegularDamage = 25;
		this.m.RegularDamageMax = 40;
		this.m.ArmorDamageMult = 1.1;
		this.m.DirectDamageMult = 0.25;
		this.m.ShieldDamage = 0;
		this.m.ChanceToHitHead = 5;
		this.m.IsDroppedAsLoot = true;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/throw_axe"));
	}

	function setAmmo( _a )
	{
		this.weapon.setAmmo(_a);

		if (this.m.Ammo > 0)
		{
			this.m.Name = "Bundle of Throwing Axes";
			this.m.IconLarge = "weapons/ranged/throwing_axes_01.png";
			this.m.Icon = "weapons/ranged/throwing_axes_01_70x70.png";
			this.m.ShowArmamentIcon = true;
		}
		else
		{
			this.m.Name = "Bundle of Throwing Axes (Empty)";
			this.m.IconLarge = "weapons/ranged/throwing_axes_01_bag.png";
			this.m.Icon = "weapons/ranged/throwing_axes_01_bag_70x70.png";
			this.m.ShowArmamentIcon = false;
		}

		this.updateAppearance();
	}

});


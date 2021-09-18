this.heavy_throwing_axe <- this.inherit("scripts/items/weapons/weapon", {
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
		this.m.ID = "weapon.heavy_throwing_axe";
		this.m.Name = "Bundle of Heavy Throwing Axes";
		this.m.Description = "Heavy and unwieldy throwing axes used by northern barbarians. Difficult to throw and hit with, but deadly.";
		this.m.Categories = "Throwing Weapon, One-Handed";
		this.m.IconLarge = "weapons/ranged/throwing_axes_heavy_01.png";
		this.m.Icon = "weapons/ranged/throwing_axes_heavy_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.Ammo | this.Const.Items.ItemType.Defensive;
		this.m.AddGenericSkill = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_throwing_axes_heavy_01";
		this.m.Value = 300;
		this.m.Ammo = 5;
		this.m.AmmoMax = 5;
		this.m.RangeMin = 2;
		this.m.RangeMax = 4;
		this.m.RangeIdeal = 4;
		this.m.StaminaModifier = -6;
		this.m.RegularDamage = 30;
		this.m.RegularDamageMax = 50;
		this.m.ArmorDamageMult = 1.15;
		this.m.DirectDamageMult = 0.25;
		this.m.ShieldDamage = 0;
		this.m.ChanceToHitHead = 5;
		this.m.IsDroppedAsLoot = true;
		this.m.AdditionalAccuracy = -5;
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
			this.m.Name = "Bundle of Heavy Throwing Axes";
			this.m.IconLarge = "weapons/ranged/throwing_axes_heavy_01.png";
			this.m.Icon = "weapons/ranged/throwing_axes_heavy_01_70x70.png";
			this.m.ShowArmamentIcon = true;
		}
		else
		{
			this.m.Name = "Bundle of Heavy Throwing Axes (Empty)";
			this.m.IconLarge = "weapons/ranged/throwing_axes_01_bag.png";
			this.m.Icon = "weapons/ranged/throwing_axes_01_bag_70x70.png";
			this.m.ShowArmamentIcon = false;
		}

		this.updateAppearance();
	}

});


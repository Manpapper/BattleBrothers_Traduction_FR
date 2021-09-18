this.heavy_javelin <- this.inherit("scripts/items/weapons/weapon", {
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
		this.m.ID = "weapon.heavy_javelin";
		this.m.Name = "Bundle of Heavy Javelins";
		this.m.Description = "A set of heavy, rugged-looking javelins. Harder to throw and hit with, but more impactful.";
		this.m.Categories = "Throwing Weapon, One-Handed";
		this.m.IconLarge = "weapons/ranged/javelins_heavy_01.png";
		this.m.Icon = "weapons/ranged/javelins_heavy_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.Ammo | this.Const.Items.ItemType.Defensive;
		this.m.AddGenericSkill = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_javelins_heavy_01";
		this.m.Value = 300;
		this.m.Ammo = 5;
		this.m.AmmoMax = 5;
		this.m.RangeMin = 1;
		this.m.RangeMax = 4;
		this.m.RangeIdeal = 4;
		this.m.StaminaModifier = -8;
		this.m.RegularDamage = 35;
		this.m.RegularDamageMax = 50;
		this.m.ArmorDamageMult = 0.8;
		this.m.DirectDamageMult = 0.45;
		this.m.ShieldDamage = 0;
		this.m.IsDroppedAsLoot = true;
		this.m.AdditionalAccuracy = -5;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/throw_javelin"));
	}

	function setAmmo( _a )
	{
		this.weapon.setAmmo(_a);

		if (this.m.Ammo > 0)
		{
			this.m.Name = "Bundle of Heavy Javelins";
			this.m.IconLarge = "weapons/ranged/javelins_heavy_01.png";
			this.m.Icon = "weapons/ranged/javelins_heavy_01_70x70.png";
			this.m.ShowArmamentIcon = true;
		}
		else
		{
			this.m.Name = "Bundle of Heavy Javelins (Empty)";
			this.m.IconLarge = "weapons/ranged/javelins_01_bag.png";
			this.m.Icon = "weapons/ranged/javelins_01_bag_70x70.png";
			this.m.ShowArmamentIcon = false;
		}

		this.updateAppearance();
	}

});


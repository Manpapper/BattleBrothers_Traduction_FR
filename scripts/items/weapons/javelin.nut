this.javelin <- this.inherit("scripts/items/weapons/weapon", {
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
		this.m.ID = "weapon.javelin";
		this.m.Name = "Lot de javelots";
		this.m.Description = "Quelques javelots généralement portées par les tirailleurs. Ils ont une portée limitée et sont épuisants à lancer, mais peuvent infliger des blessures dévastatrices.";
		this.m.Categories = "Arme de jet, Une Main";
		this.m.IconLarge = "weapons/ranged/javelins_01.png";
		this.m.Icon = "weapons/ranged/javelins_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.Ammo | this.Const.Items.ItemType.Defensive;
		this.m.AddGenericSkill = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_javelin_02";
		this.m.Value = 200;
		this.m.Ammo = 5;
		this.m.AmmoMax = 5;
		this.m.RangeMin = 1;
		this.m.RangeMax = 4;
		this.m.RangeIdeal = 4;
		this.m.StaminaModifier = -6;
		this.m.RegularDamage = 30;
		this.m.RegularDamageMax = 45;
		this.m.ArmorDamageMult = 0.75;
		this.m.DirectDamageMult = 0.45;
		this.m.ShieldDamage = 0;
		this.m.IsDroppedAsLoot = true;
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
			this.m.Name = "Bundle of Javelins";
			this.m.IconLarge = "weapons/ranged/javelins_01.png";
			this.m.Icon = "weapons/ranged/javelins_01_70x70.png";
			this.m.ShowArmamentIcon = true;
		}
		else
		{
			this.m.Name = "Bundle of Javelins (Empty)";
			this.m.IconLarge = "weapons/ranged/javelins_01_bag.png";
			this.m.Icon = "weapons/ranged/javelins_01_bag_70x70.png";
			this.m.ShowArmamentIcon = false;
		}

		this.updateAppearance();
	}

});


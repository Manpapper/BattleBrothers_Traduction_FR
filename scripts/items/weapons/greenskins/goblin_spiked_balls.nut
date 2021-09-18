this.goblin_spiked_balls <- this.inherit("scripts/items/weapons/weapon", {
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
		this.m.ID = "weapon.goblin_spiked_balls";
		this.m.Name = "Bundle of Spiked Bolas";
		this.m.Description = "Small and heavy iron balls with metal spikes to be hurled at a target.";
		this.m.Categories = "Throwing Weapon, One-Handed";
		this.m.IconLarge = "weapons/ranged/goblin_weapon_07.png";
		this.m.Icon = "weapons/ranged/goblin_weapon_07_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.Ammo | this.Const.Items.ItemType.Defensive;
		this.m.AddGenericSkill = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_goblin_weapon_07";
		this.m.Value = 200;
		this.m.Ammo = 6;
		this.m.AmmoMax = 6;
		this.m.RangeMin = 2;
		this.m.RangeMax = 4;
		this.m.RangeIdeal = 4;
		this.m.StaminaModifier = -3;
		this.m.RegularDamage = 20;
		this.m.RegularDamageMax = 35;
		this.m.ArmorDamageMult = 0.7;
		this.m.DirectDamageMult = 0.4;
		this.m.IsDroppedAsLoot = true;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/throw_balls"));
	}

	function setAmmo( _a )
	{
		this.weapon.setAmmo(_a);

		if (this.m.Ammo > 0)
		{
			this.m.ShowArmamentIcon = true;
		}
		else
		{
			this.m.ShowArmamentIcon = false;
		}

		this.updateAppearance();
	}

});


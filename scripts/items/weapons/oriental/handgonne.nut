this.handgonne <- this.inherit("scripts/items/weapons/weapon", {
	m = {
		IsLoaded = true
	},
	function isLoaded()
	{
		return this.m.IsLoaded;
	}

	function setLoaded( _l )
	{
		this.m.IsLoaded = _l;

		if (_l)
		{
			this.m.ArmamentIcon = "icon_handgonne_01_loaded";
		}
		else
		{
			this.m.ArmamentIcon = "icon_handgonne_01_empty";
		}

		this.updateAppearance();
	}

	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.handgonne";
		this.m.Name = "Handgonne";
		this.m.Description = "An iron barrel with a long wooden handle. It fires shrapnel in a cone and can hit multiple targets with one shot. Can not be used while engaged in melee.";
		this.m.Categories = "Firearm, Two-Handed";
		this.m.IconLarge = "weapons/ranged/handgonne_01.png";
		this.m.Icon = "weapons/ranged/handgonne_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.Defensive;
		this.m.EquipSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_handgonne_01_loaded";
		this.m.Value = 3000;
		this.m.RangeMin = 2;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RangeMaxBonus = 1;
		this.m.StaminaModifier = -14;
		this.m.Condition = 60.0;
		this.m.ConditionMax = 60.0;
		this.m.RegularDamage = 35;
		this.m.RegularDamageMax = 75;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.25;
		this.m.IsEnforcingRangeLimit = true;
	}

	function getAmmoID()
	{
		return "ammo.powder";
	}

	function getRangeEffective()
	{
		return this.m.RangeMax + 2;
	}

	function getTooltip()
	{
		local result = this.weapon.getTooltip();

		if (!this.m.IsLoaded)
		{
			result.push({
				id = 10,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Must be reloaded before firing again[/color]"
			});
		}

		return result;
	}

	function onCombatFinished()
	{
		this.setLoaded(true);
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/fire_handgonne_skill"));

		if (!this.m.IsLoaded)
		{
			this.addSkill(this.new("scripts/skills/actives/reload_handgonne_skill"));
		}
	}

	function onCombatFinished()
	{
		this.weapon.onCombatFinished();
		this.m.IsLoaded = true;
	}

});


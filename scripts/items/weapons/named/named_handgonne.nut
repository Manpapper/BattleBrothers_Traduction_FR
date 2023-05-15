this.named_handgonne <- this.inherit("scripts/items/weapons/named/named_weapon", {
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
			this.m.ArmamentIcon = "icon_handgonne_01_named_0" + this.m.Variant + "_loaded";
		}
		else
		{
			this.m.ArmamentIcon = "icon_handgonne_01_named_0" + this.m.Variant + "_empty";
		}

		this.updateAppearance();
	}

	function create()
	{
		this.named_weapon.create();
		this.m.Variant = this.Math.rand(1, 2);
		this.updateVariant();
		this.m.ID = "weapon.named_handgonne";
		this.m.NameList = this.Const.Strings.HandgonneNames;
		this.m.PrefixList = this.Const.Strings.SouthernPrefix;
		this.m.SuffixList = this.Const.Strings.SouthernSuffix;
		this.m.Description = "Un canon en fonte savamment moulé avec un long manche en bois. Il tire des éclats d\'obus dans un cône et peut toucher plusieurs cibles d\'un seul coup. Ne peut pas être utilisé en mêlée.";
		this.m.Categories = "Firearm, Deux-Mains";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.Defensive;
		this.m.EquipSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = true;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 5000;
		this.m.RangeMin = 2;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RangeMaxBonus = 1;
		this.m.StaminaModifier = -14;
		this.m.Condition = 60.0;
		this.m.ConditionMax = 60.0;
		this.m.RegularDamage = 35;
		this.m.RegularDamageMax = 75;
		this.m.ArmorDamageMult = 0.9;
		this.m.DirectDamageMult = 0.25;
		this.m.IsEnforcingRangeLimit = true;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/ranged/handgonne_01_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/ranged/handgonne_01_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_handgonne_01_named_0" + this.m.Variant + "_empty";
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
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Doit être rechargé avant de tirer à nouveau[/color]"
			});
		}

		return result;
	}

	function createRandomName()
	{
		if (!this.m.UseRandomName || this.Math.rand(1, 100) <= 60)
		{
			if (this.m.SuffixList.len() == 0 || this.Math.rand(1, 100) <= 70)
			{
				return this.m.PrefixList[this.Math.rand(0, this.m.PrefixList.len() - 1)] + " " + this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)];
			}
			else
			{
				return this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)] + " " + this.m.SuffixList[this.Math.rand(0, this.m.SuffixList.len() - 1)];
			}
		}
		else if (this.Math.rand(1, 2) == 1)
		{
			return this.getRandomCharacterName(this.Const.Strings.SouthernNamesLast) + "\'s " + this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)];
		}
		else
		{
			return this.getRandomCharacterName(this.Const.Strings.NomadChampionStandalone) + "\'s " + this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)];
		}
	}

	function onCombatFinished()
	{
		this.setLoaded(true);
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
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


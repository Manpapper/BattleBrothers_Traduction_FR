this.named_warscythe <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.named_warscythe";
		this.m.NameList = this.Const.Strings.WarscytheNames;
		this.m.PrefixList = this.Const.Strings.OldWeaponPrefix;
		this.m.UseRandomName = false;
		this.m.Description = "Une longue perche attachée à une lame incurvée tranchante, utilisée pour effectuer des frappes profondes sur une certaine distance. Cet exemplaire est particulièrement bien conçu.";
		this.m.Categories = "Arme D\'Hast, Deux-Mains";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 2800;
		this.m.ShieldDamage = 0;
		this.m.Condition = 36.0;
		this.m.ConditionMax = 36.0;
		this.m.StaminaModifier = -16;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 55;
		this.m.RegularDamageMax = 80;
		this.m.ArmorDamageMult = 1.05;
		this.m.DirectDamageMult = 0.3;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/warscythe_01_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/warscythe_01_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_warscythe_named_0" + this.m.Variant;
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

	function onEquip()
	{
		this.named_weapon.onEquip();
		local strike = this.new("scripts/skills/actives/strike_skill");
		strike.m.Icon = "skills/active_93.png";
		strike.m.IconDisabled = "skills/active_93_sw.png";
		strike.m.Overlay = "active_93";
		this.addSkill(strike);
		this.addSkill(this.new("scripts/skills/actives/reap_skill"));
	}

});


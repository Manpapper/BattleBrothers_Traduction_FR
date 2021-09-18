this.named_shamshir <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = this.Math.rand(1, 2);
		this.updateVariant();
		this.m.ID = "weapon.named_shamshir";
		this.m.NameList = this.Const.Strings.SabreNames;
		this.m.PrefixList = this.Const.Strings.SouthernPrefix;
		this.m.SuffixList = this.Const.Strings.SouthernSuffix;
		this.m.Description = "A Shamshir already is an exquisite and exotic weapon in these parts, but this piece is of extraordinary quality. It will cut through flesh and bone just as easily as through a ripe melon.";
		this.m.Categories = "Sword, One-Handed";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 4000;
		this.m.Condition = 72.0;
		this.m.ConditionMax = 72.0;
		this.m.StaminaModifier = -8;
		this.m.RegularDamage = 45;
		this.m.RegularDamageMax = 50;
		this.m.ArmorDamageMult = 0.75;
		this.m.DirectDamageMult = 0.2;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/scimitar_01_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/scimitar_01_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_scimitar_01_named_0" + this.m.Variant;
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
		local skill = this.new("scripts/skills/actives/slash");
		skill.m.Icon = "skills/active_172.png";
		skill.m.IconDisabled = "skills/active_172_sw.png";
		skill.m.Overlay = "active_172";
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/gash_skill");
		this.addSkill(skill);
	}

});


this.named_armor <- this.inherit("scripts/items/armor/armor", {
	m = {
		PrefixList = this.Const.Strings.RandomArmorPrefix,
		SuffixList = [],
		NameList = [],
		UseRandomName = true
	},
	function create()
	{
		this.armor.create();
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Named;
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
	}

	function getRandomCharacterName( _list )
	{
		local vars = [
			[
				"randomname",
				this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]
			],
			[
				"randomsouthernname",
				this.Const.Strings.SouthernNames[this.Math.rand(0, this.Const.Strings.SouthernNames.len() - 1)]
			],
			[
				"randomtown",
				this.Const.World.LocationNames.VillageWestern[this.Math.rand(0, this.Const.World.LocationNames.VillageWestern.len() - 1)]
			]
		];
		return this.buildTextFromTemplate(_list[this.Math.rand(0, _list.len() - 1)], vars);
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
			return this.getRandomCharacterName(this.Const.Strings.KnightNames) + "\'s " + this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)];
		}
		else
		{
			return this.getRandomCharacterName(this.Const.Strings.BanditLeaderNames) + "\'s " + this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)];
		}
	}

	function onEquip()
	{
		this.armor.onEquip();

		if (this.m.Name.len() == 0)
		{
			if (this.Math.rand(1, 100) <= 25)
			{
				this.setName(this.getContainer().getActor().getName() + "\'s " + this.m.NameList[this.Math.rand(0, this.m.NameList.len() - 1)]);
			}
			else
			{
				this.setName(this.createRandomName());
			}
		}
	}

	function onAddedToStash( _stashID )
	{
		if (this.m.Name.len() == 0)
		{
			this.setName(this.createRandomName());
		}
	}

	function setName( _name )
	{
		this.m.Name = _name;
	}

	function randomizeValues()
	{
		this.m.StaminaModifier = this.Math.min(-8, this.m.StaminaModifier + this.Math.rand(3, 9));
		this.m.Condition = this.Math.floor(this.m.Condition * this.Math.rand(110, 125) * 0.01) * 1.0;
		this.m.ConditionMax = this.m.Condition;
	}

	function onSerialize( _out )
	{
		_out.writeString(this.m.Name);
		_out.writeF32(this.m.ConditionMax);
		_out.writeI8(this.m.StaminaModifier);
		this.armor.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.m.Name = _in.readString();
		this.m.ConditionMax = _in.readF32();
		this.m.StaminaModifier = _in.readI8();
		this.armor.onDeserialize(_in);
		this.updateVariant();
	}

});


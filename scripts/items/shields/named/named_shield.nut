this.named_shield <- this.inherit("scripts/items/shields/shield", {
	m = {
		PrefixList = this.Const.Strings.RandomShieldPrefix,
		SuffixList = [],
		NameList = [],
		UseRandomName = true
	},
	function create()
	{
		this.shield.create();
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Named;
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
		this.shield.onEquip();

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

	function setName( _name )
	{
		this.m.Name = _name;
	}

	function randomizeValues()
	{
		local available = [];
		available.push(function ( _i )
		{
			_i.m.MeleeDefense = this.Math.round(_i.m.MeleeDefense * this.Math.rand(120, 140) * 0.01);
		});
		available.push(function ( _i )
		{
			_i.m.RangedDefense = this.Math.round(_i.m.RangedDefense * this.Math.rand(120, 140) * 0.01);
		});
		available.push(function ( _i )
		{
			_i.m.FatigueOnSkillUse = _i.m.FatigueOnSkillUse - this.Math.rand(1, 3);
		});
		available.push(function ( _i )
		{
			_i.m.Condition = this.Math.round(_i.m.Condition * this.Math.rand(120, 160) * 0.01) * 1.0;
			_i.m.ConditionMax = _i.m.Condition;
		});
		available.push(function ( _i )
		{
			_i.m.StaminaModifier = this.Math.round(_i.m.StaminaModifier * this.Math.rand(70, 90) * 0.01);
		});

		for( local n = 2; n != 0 && available.len() != 0; n = --n )
		{
			local r = this.Math.rand(0, available.len() - 1);
			available[r](this);
			available.remove(r);
		}
	}

	function onEquip()
	{
		this.shield.onEquip();

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

	function onSerialize( _out )
	{
		_out.writeF32(this.m.ConditionMax);
		this.shield.onSerialize(_out);
		_out.writeString(this.m.Name);
		_out.writeI8(this.m.StaminaModifier);
		_out.writeU16(this.m.MeleeDefense);
		_out.writeU16(this.m.RangedDefense);
		_out.writeI16(this.m.FatigueOnSkillUse);
	}

	function onDeserialize( _in )
	{
		this.m.ConditionMax = _in.readF32();
		this.shield.onDeserialize(_in);
		this.m.Name = _in.readString();
		this.m.StaminaModifier = _in.readI8();
		this.m.MeleeDefense = _in.readU16();
		this.m.RangedDefense = _in.readU16();

		if (_in.getMetaData().getVersion() >= 47)
		{
			this.m.FatigueOnSkillUse = _in.readI16();
		}
		else
		{
			this.m.FatigueOnSkillUse = 0;
		}
	}

});


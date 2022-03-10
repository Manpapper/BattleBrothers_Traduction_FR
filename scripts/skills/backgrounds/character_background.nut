this.character_background <- this.inherit("scripts/skills/skill", {
	m = {
		HiringCost = 0,
		DailyCost = 0,
		DailyCostMult = 1.0,
		Excluded = [],
		ExcludedTalents = [],
		Faces = null,
		Hairs = null,
		HairColors = null,
		Beards = null,
		Bodies = this.Const.Bodies.AllMale,
		Ethnicity = 0,
		Level = 1,
		BeardChance = 60,
		Names = this.Const.Strings.CharacterNames,
		LastNames = [],
		Titles = [],
		RawDescription = "",
		BackgroundDescription = "",
		GoodEnding = null,
		BadEnding = null,
		IsScenarioOnly = false,
		IsNew = true,
		IsUntalented = false,
		IsOffendedByViolence = false,
		IsCombatBackground = false,
		IsNoble = false,
		IsLowborn = false
	},
	function isExcluded( _id )
	{
		return this.m.Excluded.find(_id) != null;
	}

	function isUntalented()
	{
		return this.m.IsUntalented;
	}

	function setScenarioOnly( _f )
	{
		this.m.IsScenarioOnly = _f;
	}

	function isOffendedByViolence()
	{
		return this.m.IsOffendedByViolence;
	}

	function isCombatBackground()
	{
		return this.m.IsCombatBackground;
	}

	function isNoble()
	{
		return this.m.IsNoble;
	}

	function isLowborn()
	{
		return this.m.IsLowborn;
	}

	function getEthnicity()
	{
		return this.m.Ethnicity;
	}

	function getExcludedTalents()
	{
		return this.m.ExcludedTalents;
	}

	function getGoodEnding()
	{
		return this.m.GoodEnding;
	}

	function getBadEnding()
	{
		return this.m.BadEnding;
	}

	function create()
	{
		this.m.Type = this.Const.SkillType.Background | this.Const.SkillType.Trait;
		this.m.Order = this.Const.SkillOrder.Background;
		this.m.DailyCostMult = this.Math.rand(90, 110) * 0.01;
	}

	function isHidden()
	{
		return this.skill.isHidden() || this.m.IsScenarioOnly;
	}

	function getName()
	{
		return "Background: " + this.m.Name;
	}

	function getNameOnly()
	{
		return this.m.Name;
	}

	function getBackgroundDescription()
	{
		return this.m.BackgroundDescription;
	}

	function getGenericTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getBackgroundDescription()
			}
		];
	}

	function buildDescription( _isFinal = false )
	{
		if (this.m.IsScenarioOnly)
		{
			return;
		}

		local villages = this.World.EntityManager.getSettlements();
		local citystates = [];
		local northern = [];

		for( local i = 0; i < villages.len(); i = ++i )
		{
			if (this.isKindOf(villages[i], "city_state"))
			{
				citystates.push(villages[i]);
			}
			else
			{
				northern.push(villages[i]);
			}
		}

		local brother = this.World.getPlayerRoster().getAll();
		brother = brother.len() != 0 ? brother[this.Math.rand(0, brother.len() - 1)].getName() : "";
		local vars = [
			[
				"townname",
				this.World.State.getCurrentTown() != null ? this.World.State.getCurrentTown().getNameOnly() : villages[this.Math.rand(0, villages.len() - 1)].getNameOnly()
			],
			[
				"randomtown",
				northern[this.Math.rand(0, northern.len() - 1)].getNameOnly()
			],
			[
				"randomcity",
				northern[0].getNameOnly()
			],
			[
				"randomcitystate",
				citystates.len() != 0 ? citystates[this.Math.rand(0, citystates.len() - 1)].getNameOnly() : ""
			],
			[
				"randomname",
				this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]
			],
			[
				"randomnoble",
				this.Const.Strings.KnightNames[this.Math.rand(0, this.Const.Strings.KnightNames.len() - 1)]
			],
			[
				"companyname",
				this.World.Assets.getName()
			],
			[
				"randombrother",
				brother
			]
		];
		this.onPrepareVariables(vars);

		if (!_isFinal)
		{
			this.m.RawDescription = this.buildTextFromTemplate(this.onBuildDescription(), vars);
		}

		vars.push([
			"name",
			this.getContainer().getActor().getNameOnly()
		]);
		vars.push([
			"fullname",
			this.getContainer().getActor().getName()
		]);
		vars.push([
			"title",
			this.getContainer().getActor().getTitle()
		]);
		this.m.Description = this.buildTextFromTemplate(this.m.RawDescription, vars);
	}

	function onPrepareVariables( _vars )
	{
	}

	function buildAttributes()
	{
		local a = {
			Hitpoints = [
				50,
				60
			],
			Bravery = [
				30,
				40
			],
			Stamina = [
				90,
				100
			],
			MeleeSkill = [
				47,
				57
			],
			RangedSkill = [
				32,
				42
			],
			MeleeDefense = [
				0,
				5
			],
			RangedDefense = [
				0,
				5
			],
			Initiative = [
				100,
				110
			]
		};
		local c = this.onChangeAttributes();
		a.Hitpoints[0] += c.Hitpoints[0];
		a.Hitpoints[1] += c.Hitpoints[1];
		a.Bravery[0] += c.Bravery[0];
		a.Bravery[1] += c.Bravery[1];
		a.Stamina[0] += c.Stamina[0];
		a.Stamina[1] += c.Stamina[1];
		a.MeleeSkill[0] += c.MeleeSkill[0];
		a.MeleeSkill[1] += c.MeleeSkill[1];
		a.MeleeDefense[0] += c.MeleeDefense[0];
		a.MeleeDefense[1] += c.MeleeDefense[1];
		a.RangedSkill[0] += c.RangedSkill[0];
		a.RangedSkill[1] += c.RangedSkill[1];
		a.RangedDefense[0] += c.RangedDefense[0];
		a.RangedDefense[1] += c.RangedDefense[1];
		a.Initiative[0] += c.Initiative[0];
		a.Initiative[1] += c.Initiative[1];
		local b = this.getContainer().getActor().getBaseProperties();
		b.ActionPoints = 9;
		b.Hitpoints = this.Math.rand(a.Hitpoints[0], a.Hitpoints[1]);
		b.Bravery = this.Math.rand(a.Bravery[0], a.Bravery[1]);
		b.Stamina = this.Math.rand(a.Stamina[0], a.Stamina[1]);
		b.MeleeSkill = this.Math.rand(a.MeleeSkill[0], a.MeleeSkill[1]);
		b.RangedSkill = this.Math.rand(a.RangedSkill[0], a.RangedSkill[1]);
		b.MeleeDefense = this.Math.rand(a.MeleeDefense[0], a.MeleeDefense[1]);
		b.RangedDefense = this.Math.rand(a.RangedDefense[0], a.RangedDefense[1]);
		b.Initiative = this.Math.rand(a.Initiative[0], a.Initiative[1]);
		this.getContainer().getActor().m.CurrentProperties = clone b;
		this.getContainer().getActor().setHitpoints(b.Hitpoints);
	}

	function updateAppearance()
	{
	}

	function addEquipment()
	{
		this.onAddEquipment();
		this.adjustHiringCostBasedOnEquipment();
	}

	function onUpdate( _properties )
	{
		if (this.m.DailyCost == 0 || this.getContainer().hasSkill("trait.player"))
		{
			_properties.DailyWage = 0;
		}
		else
		{
			local level = this.getContainer().getActor().getLevel();
			local wage = this.Math.round(this.m.DailyCost * this.m.DailyCostMult);
			_properties.DailyWage += wage * this.Math.pow(1.1, this.Math.min(10, level - 1));

			if (level > 11)
			{
				local previous = wage * this.Math.pow(1.1, 10);
				_properties.DailyWage += previous * this.Math.pow(1.03, level - 1 - 10) - previous;
			}
		}

		if (("State" in this.World) && this.World.State != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.manhunters" && this.getID() != "background.slave")
		{
			_properties.XPGainMult *= 0.9;
		}
	}

	function adjustHiringCostBasedOnEquipment()
	{
		local actor = this.getContainer().getActor();
		actor.m.HiringCost = this.Math.floor(this.m.HiringCost + 500 * this.Math.pow(this.m.Level - 1, 1.5));
		local items = actor.getItems().getAllItems();
		local cost = 0;

		foreach( i in items )
		{
			cost = cost + i.getValue();
		}

		cost = cost * 1.25;
		actor.m.HiringCost = actor.m.HiringCost + cost;
		actor.m.HiringCost *= 0.1;
		actor.m.HiringCost = this.Math.ceil(actor.m.HiringCost);
		actor.m.HiringCost *= 10;
	}

	function setAppearance()
	{
		if (this.m.HairColors == null)
		{
			return;
		}

		local actor = this.getContainer().getActor();
		local hairColor = this.m.HairColors[this.Math.rand(0, this.m.HairColors.len() - 1)];

		if (this.m.Faces != null)
		{
			local sprite = actor.getSprite("head");
			sprite.setBrush(this.m.Faces[this.Math.rand(0, this.m.Faces.len() - 1)]);
			sprite.Color = this.createColor("#fbffff");
			sprite.varyColor(0.05, 0.05, 0.05);
			sprite.varySaturation(0.1);
			local body = actor.getSprite("body");
			body.Color = sprite.Color;
			body.Saturation = sprite.Saturation;
		}

		if (this.m.Hairs != null && this.Math.rand(0, this.m.Hairs.len()) != this.m.Hairs.len())
		{
			local sprite = actor.getSprite("hair");
			sprite.setBrush("hair_" + hairColor + "_" + this.m.Hairs[this.Math.rand(0, this.m.Hairs.len() - 1)]);

			if (hairColor != "grey")
			{
				sprite.varyColor(0.1, 0.1, 0.1);
			}
			else
			{
				sprite.varyBrightness(0.1);
			}
		}

		if (this.m.Beards != null && this.Math.rand(1, 100) <= this.m.BeardChance)
		{
			local beard = actor.getSprite("beard");
			beard.setBrush("beard_" + hairColor + "_" + this.m.Beards[this.Math.rand(0, this.m.Beards.len() - 1)]);
			beard.Color = actor.getSprite("hair").Color;

			if (this.doesBrushExist(beard.getBrush().Name + "_top"))
			{
				local sprite = actor.getSprite("beard_top");
				sprite.setBrush(beard.getBrush().Name + "_top");
				sprite.Color = actor.getSprite("hair").Color;
			}
		}

		if (this.m.Ethnicity == 1 && hairColor != "grey")
		{
			local hair = actor.getSprite("hair");
			hair.Saturation = 0.8;
			hair.setBrightness(0.4);
			local beard = actor.getSprite("beard");
			beard.Color = hair.Color;
			beard.Saturation = hair.Saturation;
			local beard_top = actor.getSprite("beard_top");
			beard_top.Color = hair.Color;
			beard_top.Saturation = hair.Saturation;
		}

		if (this.m.Bodies != null)
		{
			local body = this.m.Bodies[this.Math.rand(0, this.m.Bodies.len() - 1)];
			actor.getSprite("body").setBrush(body);
			actor.getSprite("injury_body").setBrush(body + "_injured");
		}

		this.onSetAppearance();
	}

	function onAddEquipment()
	{
	}

	function onSetAppearance()
	{
	}

	function onAdded()
	{
		if (this.m.DailyCost > 0)
		{
			this.m.DailyCost += 1;
		}

		local actor = this.getContainer().getActor();
		actor.m.Background = this;

		if (this.m.IsNew && !(("State" in this.Tactical) && this.Tactical.State != null && this.Tactical.State.isScenarioMode()))
		{
			this.m.IsNew = false;

			if (actor.getTitle() == "" && this.m.LastNames.len() != 0 && this.Math.rand(0, 1) == 1)
			{
				actor.setTitle(this.m.LastNames[this.Math.rand(0, this.m.LastNames.len() - 1)]);
			}

			if (actor.getTitle() == "" && this.m.Titles.len() != 0 && this.Math.rand(0, 3) == 3)
			{
				actor.setTitle(this.m.Titles[this.Math.rand(0, this.m.Titles.len() - 1)]);
			}

			if (this.m.Level != 1)
			{
				actor.m.PerkPoints = this.m.Level - 1;
				actor.m.LevelUps = this.m.Level - 1;
				actor.m.Level = this.m.Level;
				actor.m.XP = this.Const.LevelXP[this.m.Level - 1];
			}
		}
	}

	function onBuildDescription()
	{
		return "";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				0,
				0
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				0,
				0
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				0,
				0
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				0,
				0
			]
		};
		return c;
	}

	function onSerialize( _out )
	{
		this.skill.onSerialize(_out);
		_out.writeString(this.m.Description);
		_out.writeString(this.m.RawDescription);
		_out.writeU8(this.m.Level);
		_out.writeBool(this.m.IsNew);
		_out.writeF32(this.m.DailyCostMult);
	}

	function onDeserialize( _in )
	{
		this.skill.onDeserialize(_in);
		this.m.Description = _in.readString();
		this.m.RawDescription = _in.readString();
		this.m.Level = _in.readU8();
		this.m.IsNew = _in.readBool();

		if (_in.getMetaData().getVersion() >= 39)
		{
			this.m.DailyCostMult = _in.readF32();
		}
		else
		{
			this.m.DailyCostMult = 1.0;
		}
	}

});


this.injury <- this.inherit("scripts/skills/skill", {
	m = {
		HealingTimeMin = 1,
		HealingTimeMax = 1,
		TreatmentPriceMult = 1.0,
		TimeApplied = 0.0,
		DropIcon = "",
		InfectionChance = 0.0,
		IsFresh = true,
		IsTreated = false,
		IsTreatable = true,
		IsAlwaysInEffect = false,
		IsHealingMentioned = true,
		IsShownOnArm = false,
		IsShownOnBody = false,
		IsShownOnHead = false,
		IsShownOutOfCombat = false,
		IsContentWithReserve = true
	},
	function isFresh()
	{
		return this.m.IsFresh;
	}

	function isTreated()
	{
		return this.m.IsTreated;
	}

	function isTreatable()
	{
		return this.m.IsTreatable;
	}

	function getInfectionChance()
	{
		return this.m.InfectionChance;
	}

	function setTreated( _f )
	{
		this.m.IsTreated = _f;
	}

	function setOutOfCombat( _f )
	{
		this.m.IsShownOutOfCombat = _f;
	}

	function getNameOnly()
	{
		return this.m.Name;
	}

	function getName()
	{
		return this.m.IsTreated ? this.m.Name + " (Treated)" : this.m.Name;
	}

	function getPrice()
	{
		local mult = this.World.State.getCurrentTown().getBuyPriceMult() * this.Const.Difficulty.BuyPriceMult[this.World.Assets.getEconomicDifficulty()] * this.m.TreatmentPriceMult;
		local time = this.getTime();
		local maxt = this.Math.max(1, this.m.HealingTimeMax - this.Math.floor((time - this.m.TimeApplied) / this.World.getTime().SecondsPerDay));
		mult = mult * (1.0 + (this.getContainer().getActor().getLevel() - 1) * 0.2);
		local p = maxt * mult * this.Const.World.Assets.BaseWoundTreatmentPrice;
		p = this.Math.round(p * 0.1) * 10;
		return p;
	}

	function getHealingTime()
	{
		local time = this.getTime();
		local mint = this.Math.max(1, (this.m.IsTreated ? this.m.HealingTimeMin * 0.5 : this.m.HealingTimeMin) - this.Math.ceil((time - this.m.TimeApplied) / this.World.getTime().SecondsPerDay));
		local maxt = this.Math.max(1, (this.m.IsTreated ? this.m.HealingTimeMax * 0.5 : this.m.HealingTimeMax) - this.Math.floor((time - this.m.TimeApplied) / this.World.getTime().SecondsPerDay));

		if (("State" in this.World) && this.World.State != null && this.World.Retinue.hasFollower("follower.surgeon"))
		{
			mint = this.Math.max(1, mint - 1);
			maxt = this.Math.max(1, maxt - 1);
		}
		
		if (this.getContainer().getActor().getSkills().hasSkill("effects.nachzehrer_potion"))
		{
			mint = this.Math.max(1, mint - 1);
			maxt = this.Math.max(1, maxt - 1);
		}

		return {
			Min = mint,
			Max = maxt
		};
	}

	function addHealingTime( _days )
	{
		this.m.HealingTimeMin = this.Math.max(1, this.m.HealingTimeMin + _days);
		this.m.HealingTimeMax = this.Math.max(this.m.HealingTimeMin + 1, this.m.HealingTimeMax + _days);
	}

	function create()
	{
		this.m.IsStacking = false;
		this.m.Type = this.Const.SkillType.StatusEffect | this.Const.SkillType.Injury;
		this.m.Order = this.Const.SkillOrder.TemporaryInjury;
	}

	function addTooltipHint( _tooltip )
	{
		if (this.m.IsContentWithReserve)
		{
			_tooltip.push({
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Is content for now with being in reserve"
			});
		}

		if (this.m.IsFresh && !this.m.IsAlwaysInEffect && !this.getContainer().getActor().getCurrentProperties().IsAffectedByFreshInjuries && this.m.IsHealingMentioned)
		{
			_tooltip.push({
				id = 7,
				type = "text",
				icon = "ui/icons/warning.png",
				text = "Ne prendra effet qu\'à la fin du combat dû à l\'effet de Volonté de Fer"
			});
		}

		if (!this.m.IsAlwaysInEffect && !this.getContainer().getActor().getCurrentProperties().IsAffectedByInjuries && this.m.IsHealingMentioned)
		{
			if (("State" in this.Tactical) && this.Tactical.State != null)
			{
				_tooltip.push({
					id = 7,
					type = "text",
					icon = "ui/icons/warning.png",
					text = "Prendra effet seulement après la fin du combat à cause de l\'effet Volonté de Fer"
				});
			}
			else
			{
				_tooltip.push({
					id = 7,
					type = "text",
					icon = "ui/icons/warning.png",
					text = "Prendra effet seulement après la fin du combat à cause de l\'effet Volonté de Fer"
				});
			}
		}

		if (("State" in this.World) && this.World.State != null && this.World.Assets.getMedicine() <= 0 && this.m.IsHealingMentioned)
		{
			_tooltip.push({
				id = 7,
				type = "hint",
				icon = "ui/icons/warning.png",
				text = "Ne se soigenra pas car vous n\'avez plus de ressources médicales"
			});
		}
		else if (this.getContainer().getActor().getSkills().hasSkill("trait.oath_of_sacrifice") && this.m.IsHealingMentioned)
		{
			_tooltip.push({
				id = 7,
				type = "hint",
				icon = "ui/icons/warning.png",
				text = "Ne guérira pas parce que ce personnage a prêté un serment de sacrifice."
			});
		}
		else
		{
			local ht = this.getHealingTime();
			local d;

			if (this.m.IsHealingMentioned)
			{
				if (ht.Max > 1 && ht.Min == ht.Max)
				{
					d = "Sera guéri dans " + ht.Min + " jours";
				}
				else if (ht.Max > 1)
				{
					d = "Sera guéri dans " + ht.Min + " à " + ht.Max + " jours";
				}
				else
				{
					d = "Sera guéri d\'ici demain";
				}

				_tooltip.push({
					id = 6,
					type = "hint",
					icon = "ui/icons/days_wounded.png",
					text = d
				});
			}
			else
			{
				if (ht.Max > 1 && ht.Min == ht.Max)
				{
					d = "Sera guéri dans " + ht.Min + " jours";
				}
				else if (ht.Max > 1)
				{
					d = "Sera guéri dans " + ht.Min + " à " + ht.Max + " jours";
				}
				else
				{
					d = "Sera guéri d\'ici demain";
				}

				_tooltip.push({
					id = 6,
					type = "hint",
					icon = "ui/icons/action_points.png",
					text = d
				});
			}
		}
	}

	function isValid( _actor )
	{
		return true;
	}

	function onAdded()
	{
		if (this.getContainer().getActor().isPlacedOnMap())
		{
			this.spawnIcon(this.m.DropIcon, this.getContainer().getActor().getTile());
		}

		if (this.m.TimeApplied == 0)
		{
			this.m.TimeApplied = this.getTime();
		}
	}

	function onUpdate( _properties )
	{
		if (this.m.IsContentWithReserve)
		{
			_properties.IsContentWithBeingInReserve = true;
		}
	}

	function onCombatStarted()
	{
		this.m.IsFresh = false;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();

		if (this.m.IsShownOutOfCombat)
		{
			this.m.IsFresh = false;
		}

		this.m.IsShownOutOfCombat = true;
	}

	function onNewDay()
	{
		if (!(this.getContainer().getActor().getSkills().hasSkill("trait.oath_of_sacrifice") && this.m.IsTreatable) && (this.World.Assets.getMedicine() >= this.Const.World.Assets.MedicinePerInjuryDay || !this.m.IsHealingMentioned))
		{
			if (this.m.IsHealingMentioned)
			{
				this.World.Assets.addMedicine(-this.Const.World.Assets.MedicinePerInjuryDay);
			}

			local time = this.getTime();
			local daysPassed = this.Math.ceil((time - this.m.TimeApplied) / this.World.getTime().SecondsPerDay);
			local minTime = this.m.HealingTimeMin * (this.m.IsTreated ? 0.5 : 1.0);
			local maxTime = this.m.HealingTimeMax * (this.m.IsTreated ? 0.5 : 1.0);

			if (this.World.Retinue.hasFollower("follower.surgeon"))
			{
				minTime = this.Math.max(1, minTime - 1);
				maxTime = this.Math.max(1, maxTime - 1);
			}
			
			if (this.getContainer().getActor().getSkills().hasSkill("effects.nachzehrer_potion"))
			{
				minTime = this.Math.max(1, minTime - 1);
				maxTime = this.Math.max(1, maxTime - 1);
			}

			if (daysPassed < minTime)
			{
				return;
			}

			local chance = daysPassed / (maxTime * 1.0) * 100.0;

			if (this.Math.rand(1, 100) <= chance)
			{
				this.removeSelf();
				return;
			}
		}
		else
		{
			this.m.TimeApplied = this.Math.minf(this.Time.getVirtualTimeF(), this.m.TimeApplied + this.World.getTime().SecondsPerDay);
		}
	}

	function showInjury()
	{
		if (!this.m.IsShownOutOfCombat)
		{
			return;
		}

		local actor = this.getContainer().getActor();

		if (this.m.IsShownOnHead)
		{
			local sprite = actor.getSprite("bandage_1");

			if (this.m.IsTreated)
			{
				sprite.setBrush("bandage_clean_01");
			}

			sprite.Visible = true;
		}

		if (this.m.IsShownOnBody)
		{
			local sprite = actor.getSprite("bandage_2");

			if (this.m.IsTreated)
			{
				sprite.setBrush("bandage_clean_02");
			}

			sprite.Visible = true;
		}

		if (this.m.IsShownOnArm)
		{
			local sprite = actor.getSprite("bandage_3");

			if (this.m.IsTreated)
			{
				sprite.setBrush("bandage_clean_03");
			}

			sprite.Visible = true;
		}
	}

	function getTime()
	{
		if (("State" in this.World) && this.World.State != null && this.World.State.getCombatStartTime() != 0)
		{
			return this.World.State.getCombatStartTime();
		}
		else
		{
			return this.Time.getVirtualTimeF();
		}
	}

	function onSerialize( _out )
	{
		_out.writeF32(this.m.TimeApplied);
		_out.writeBool(this.m.IsTreated);
		_out.writeU32(this.m.HealingTimeMin);
		_out.writeU32(this.m.HealingTimeMax);
		_out.writeBool(false);
	}

	function onDeserialize( _in )
	{
		this.m.IsFresh = false;
		this.m.IsShownOutOfCombat = true;
		this.m.TimeApplied = _in.readF32();
		this.m.IsTreated = _in.readBool();
		
		if (_in.getMetaData().getVersion() >= 64)
		{
			this.m.HealingTimeMin = _in.readU32();
			this.m.HealingTimeMax = _in.readU32();
		}

		_in.readBool();
	}

});


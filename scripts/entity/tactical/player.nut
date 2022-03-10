this.player <- this.inherit("scripts/entity/tactical/human", {
	m = {
		Level = 1,
		PerkPoints = 0,
		PerkPointsSpent = 0,
		LevelUps = 0,
		Mood = 3.0,
		MoodChanges = [],
		LastDrinkTime = 0,
		PlaceInFormation = 255,
		Background = null,
		HiringCost = 0,
		HireTime = 0.0,
		IsTryoutDone = false,
		IsGuest = false,
		Attributes = [],
		Talents = [],
		CombatStats = {
			DamageDealtHitpoints = 0,
			DamageDealtArmor = 0,
			DamageReceivedHitpoints = 0,
			DamageReceivedArmor = 0,
			Kills = 0,
			XPGained = 0
		},
		LifetimeStats = {
			Kills = 0,
			Battles = 0,
			BattlesWithoutMe = 0,
			MostPowerfulVanquished = "",
			MostPowerfulVanquishedXP = 0,
			MostPowerfulVanquishedType = 0,
			FavoriteWeapon = "",
			FavoriteWeaponUses = 0,
			CurrentWeaponUses = 0
		}
	},
	function setName( _value )
	{
		this.m.Name = _value;

		if (this.m.Background != null)
		{
			this.m.Background.buildDescription(true);
		}
	}

	function getTitle()
	{
		return this.m.Title;
	}

	function setTitle( _value )
	{
		this.m.Title = _value;

		if (this.m.Background != null)
		{
			this.m.Background.buildDescription(true);
		}
	}

	function getXP()
	{
		return this.m.XP;
	}

	function getXPValue()
	{
		return 100 + (this.m.Level - 1) * 30;
	}

	function getLevel()
	{
		return this.m.Level;
	}
	
	function setPerkPoints( _value )
	{
		this.m.PerkPoints = _value;
	}

	function getPerkPoints()
	{
		return this.m.PerkPoints;
	}

	function getPerkPointsSpent()
	{
		return this.m.PerkPointsSpent;
	}

	function getLevelUps()
	{
		return this.m.LevelUps;
	}

	function getTalents()
	{
		return this.m.Talents;
	}

	function getCombatStats()
	{
		return this.m.CombatStats;
	}

	function getLifetimeStats()
	{
		return this.m.LifetimeStats;
	}

	function getPlaceInFormation()
	{
		return this.m.PlaceInFormation;
	}

	function setPlaceInFormation( _p )
	{
		this.m.PlaceInFormation = _p;
	}

	function getHiringCost()
	{
		return this.m.HiringCost;
	}

	function getTryoutCost()
	{
		return this.Math.ceil(this.Math.max(10, this.Math.min(this.m.HiringCost - 25, 25 + this.m.HiringCost * 0.1) * this.World.Assets.m.TryoutPriceMult));
	}

	function getDailyCost()
	{
		return this.Math.max(0, this.m.CurrentProperties.DailyWage * this.m.CurrentProperties.DailyWageMult * (("State" in this.World) && this.World.State != null ? this.World.Assets.m.DailyWageMult : 1.0));
	}

	function getDailyFood()
	{
		return this.Math.maxf(0.0, this.m.CurrentProperties.DailyFood);
	}

	function getBackground()
	{
		return this.m.Background;
	}

	function getHireTime()
	{
		return this.m.HireTime;
	}

	function getLastDrinkTime()
	{
		return this.m.LastDrinkTime;
	}

	function setLastDrinkTime( _t )
	{
		this.m.LastDrinkTime = _t;
	}

	function setGuest( _f )
	{
		this.m.IsGuest = _f;
	}

	function isLeveled()
	{
		return (this.m.PerkPoints != 0 || this.m.LevelUps != 0) && !this.m.IsGuest;
	}

	function isGuest()
	{
		return this.m.IsGuest;
	}

	function isTryoutDone()
	{
		return this.m.IsTryoutDone;
	}

	function setTryoutDone( _t )
	{
		this.m.IsTryoutDone = _t;
	}

	function getMood()
	{
		return this.m.Mood;
	}

	function getMoodState()
	{
		return this.Math.floor(this.m.Mood);
	}

	function getMoodChanges()
	{
		return this.m.MoodChanges;
	}

	function improveMood( _a = 1.0, _reason = "" )
	{
		this.m.Mood = this.Math.minf(this.m.Mood + _a, this.Const.MoodState.len() - 0.05);

		if (_reason != "")
		{
			local time = 0.0;

			if (("State" in this.World) && this.World.State != null && this.World.State.getCombatStartTime() != 0)
			{
				time = this.World.State.getCombatStartTime();
			}
			else
			{
				time = this.Time.getVirtualTimeF();
			}

			if (this.m.MoodChanges.len() >= 1 && this.m.MoodChanges[0].Text == _reason)
			{
				this.m.MoodChanges[0].Time = time;
			}
			else
			{
				if (this.m.MoodChanges.len() >= 5)
				{
					this.m.MoodChanges.remove(this.m.MoodChanges.len() - 1);
				}

				this.m.MoodChanges.insert(0, {
					Positive = true,
					Text = _reason,
					Time = time
				});
			}
		}

		this.getSkills().update();
	}

	function worsenMood( _a = 1.0, _reason = "" )
	{
		this.m.Mood = this.Math.maxf(this.m.Mood - _a, 0.0);

		if (_reason != "")
		{
			local time = 0.0;

			if (("State" in this.World) && this.World.State != null && this.World.State.getCombatStartTime() != 0)
			{
				time = this.World.State.getCombatStartTime();
			}
			else
			{
				time = this.Time.getVirtualTimeF();
			}

			if (this.m.MoodChanges.len() >= 1 && this.m.MoodChanges[0].Text == _reason)
			{
				this.m.MoodChanges[0].Time = time;
			}
			else
			{
				if (this.m.MoodChanges.len() >= 5)
				{
					this.m.MoodChanges.remove(this.m.MoodChanges.len() - 1);
				}

				this.m.MoodChanges.insert(0, {
					Positive = false,
					Text = _reason,
					Time = time
				});
			}
		}

		this.getSkills().update();
	}

	function recoverMood()
	{
		if (this.m.MoodChanges.len() != 0 && this.m.MoodChanges[this.m.MoodChanges.len() - 1].Time + this.Const.MoodChange.Timeout < this.Time.getVirtualTimeF())
		{
			this.m.MoodChanges.remove(this.m.MoodChanges.len() - 1);
		}

		if (this.m.Mood < 3.1500001)
		{
			local mult = this.getSkills().hasSkill("trait.optimist") ? this.Const.MoodChange.OptimistMult : 1.0;
			local diff = this.Math.maxf(this.Const.MoodChange.RecoveryPerHour, (3.1500001 - this.m.Mood) * this.Const.MoodChange.RelativeRecoveryPerHour);
			this.m.Mood = this.Math.minf(3.1500001, this.m.Mood + diff * mult * this.Const.MoodChange.CheckIntervalHours);
			this.getSkills().update();
		}
		else if (this.m.Mood > 3.1500001)
		{
			local mult = this.getSkills().hasSkill("trait.pessimist") ? this.Const.MoodChange.PessimistMult : 1.0;
			local diff = this.Math.maxf(this.Const.MoodChange.RecoveryPerHour, (this.m.Mood - 3.1500001) * this.Const.MoodChange.RelativeRecoveryPerHour);
			this.m.Mood = this.Math.maxf(3.1500001, this.m.Mood - diff * mult * this.Const.MoodChange.CheckIntervalHours);
			this.getSkills().update();
		}
	}

	function getHiringTraits()
	{
		local ret = [];

		if (!this.m.IsTryoutDone)
		{
			return ret;
		}

		foreach( s in this.m.Skills.m.Skills )
		{
			if (s.getType() == this.Const.SkillType.Trait)
			{
				ret.push({
					id = s.getID(),
					icon = s.getIconColored()
				});
			}
		}

		return ret;
	}

	function getDaysWithCompany()
	{
		local time;

		if (("State" in this.World) && this.World.State != null && this.World.State.getCombatStartTime() != 0)
		{
			time = this.Math.round((this.World.State.getCombatStartTime() - this.m.HireTime) / this.World.getTime().SecondsPerDay);
		}
		else
		{
			time = this.Math.round((this.Time.getVirtualTimeF() - this.m.HireTime) / this.World.getTime().SecondsPerDay);
		}

		return time;
	}

	function getTooltip( _targetedWithSkill = null )
	{
		if (!this.isPlacedOnMap() || !this.isAlive() || this.isDying())
		{
			return [];
		}

		local turnsToGo = this.Tactical.TurnSequenceBar.getTurnsUntilActive(this.getID());
		local tooltip = [
			{
				id = 1,
				type = "title",
				text = this.getName(),
				icon = "ui/tooltips/height_" + this.getTile().Level + ".png"
			}
		];

		if (!this.isPlayerControlled() && _targetedWithSkill != null && this.isKindOf(_targetedWithSkill, "skill"))
		{
			local tile = this.getTile();

			if (tile.IsVisibleForEntity && _targetedWithSkill.isUsableOn(this.getTile()))
			{
				tooltip.push({
					id = 3,
					type = "headerText",
					icon = "ui/icons/hitchance.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]" + _targetedWithSkill.getHitchance(this) + "%[/color] chance de toucher",
					children = _targetedWithSkill.getHitFactors(tile)
				});
			}
		}

		tooltip.extend([
			{
				id = 2,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = this.Tactical.TurnSequenceBar.getActiveEntity() == this ? "Agit maintenant" : this.m.IsTurnDone || turnsToGo == null ? "Tour terminé" : "Agit dans " + turnsToGo + (turnsToGo > 1 ? " tours" : " tour")
			},
			{
				id = 3,
				type = "progressbar",
				icon = "ui/icons/armor_head.png",
				value = this.getArmor(this.Const.BodyPart.Head),
				valueMax = this.getArmorMax(this.Const.BodyPart.Head),
				text = "" + this.getArmor(this.Const.BodyPart.Head) + " / " + this.getArmorMax(this.Const.BodyPart.Head) + "",
				style = "armor-head-slim"
			},
			{
				id = 4,
				type = "progressbar",
				icon = "ui/icons/armor_body.png",
				value = this.getArmor(this.Const.BodyPart.Body),
				valueMax = this.getArmorMax(this.Const.BodyPart.Body),
				text = "" + this.getArmor(this.Const.BodyPart.Body) + " / " + this.getArmorMax(this.Const.BodyPart.Body) + "",
				style = "armor-body-slim"
			},
			{
				id = 5,
				type = "progressbar",
				icon = "ui/icons/health.png",
				value = this.getHitpoints(),
				valueMax = this.getHitpointsMax(),
				text = "" + this.getHitpoints() + " / " + this.getHitpointsMax() + "",
				style = "hitpoints-slim"
			},
			{
				id = 6,
				type = "progressbar",
				icon = "ui/icons/morale.png",
				value = this.getMoraleState(),
				valueMax = this.Const.MoraleState.COUNT - 1,
				text = this.Const.MoraleStateName[this.getMoraleState()],
				style = "morale-slim"
			},
			{
				id = 7,
				type = "progressbar",
				icon = "ui/icons/fatigue.png",
				value = this.getFatigue(),
				valueMax = this.getFatigueMax(),
				text = "" + this.getFatigue() + " / " + this.getFatigueMax() + "",
				style = "fatigue-slim"
			}
		]);
		local result = [];
		local statusEffects = this.getSkills().query(this.Const.SkillType.StatusEffect | this.Const.SkillType.TemporaryInjury, false, true);

		foreach( i, statusEffect in statusEffects )
		{
			tooltip.push({
				id = 100 + i,
				type = "text",
				icon = statusEffect.getIcon(),
				text = statusEffect.getName()
			});
		}

		return tooltip;
	}

	function getRosterTooltip()
	{
		local tooltip = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			}
		];
		local time = this.getDaysWithCompany();
		local text;

		if (!this.isGuest())
		{
			if (this.m.Background != null && this.m.Background.getID() == "background.companion")
			{
				text = "Avec la compagnie depuis le tout début.";
			}
			else if (time > 1)
			{
				text = "Avec la compagnie depuis " + time + " jours.";
			}
			else
			{
				text = "Vient de rejoindre la compagnie.";
			}

			if (this.m.LifetimeStats.Battles != 0)
			{
				if (this.m.LifetimeStats.Battles == 1)
				{
					text = text + (" A pris part à " + this.m.LifetimeStats.Battles + " bataille");
				}
				else
				{
					text = text + (" A pris part à " + this.m.LifetimeStats.Battles + " batailles");
				}

				if (this.m.LifetimeStats.Kills == 1)
				{
					text = text + (" et a tué " + this.m.LifetimeStats.Kills + " ennemi.");
				}
				else if (this.m.LifetimeStats.Kills > 1)
				{
					text = text + (" et a tué " + this.m.LifetimeStats.Kills + " ennemis.");
				}
				else
				{
					text = text + ".";
				}

				if (this.m.LifetimeStats.MostPowerfulVanquished != "")
				{
					text = text + (" L\'adversaire le plus puissant qu\'il a vaincu était " + this.m.LifetimeStats.MostPowerfulVanquished + ".");
				}
			}

			tooltip.push({
				id = 2,
				type = "description",
				text = text
			});
			tooltip.push({
				id = 5,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "Niveau " + this.m.Level
			});

			if (this.getDailyCost() != 0)
			{
				tooltip.push({
					id = 3,
					type = "text",
					icon = "ui/icons/asset_daily_money.png",
					text = "Payé [img]gfx/ui/tooltips/money.png[/img]" + this.getDailyCost() + " par jour"
				});
			}

			tooltip.push({
				id = 4,
				type = "text",
				icon = this.Const.MoodStateIcon[this.getMoodState()],
				text = this.Const.MoodStateName[this.getMoodState()]
			});

			if (this.m.PlaceInFormation <= 17)
			{
				tooltip.push({
					id = 6,
					type = "hint",
					icon = "ui/icons/stat_screen_dmg_dealt.png",
					text = "En ligne de front"
				});
			}
			else
			{
				tooltip.push({
					id = 6,
					type = "hint",
					icon = "ui/icons/camp.png",
					text = "En reserve"
				});
			}
		}

		local injuries = this.getSkills().query(this.Const.SkillType.Injury | this.Const.SkillType.SemiInjury);

		foreach( injury in injuries )
		{
			if (injury.isType(this.Const.SkillType.TemporaryInjury))
			{
				local ht = injury.getHealingTime();

				if (ht.Min != ht.Max)
				{
					tooltip.push({
						id = 90,
						type = "text",
						icon = injury.getIcon(),
						text = injury.getName() + " (" + ht.Min + "-" + ht.Max + " jours)"
					});
				}
				else if (ht.Min > 1)
				{
					tooltip.push({
						id = 90,
						type = "text",
						icon = injury.getIcon(),
						text = injury.getName() + " (" + ht.Min + " jours)"
					});
				}
				else
				{
					tooltip.push({
						id = 90,
						type = "text",
						icon = injury.getIcon(),
						text = injury.getName() + " (" + ht.Min + " jour)"
					});
				}
			}
			else
			{
				tooltip.push({
					id = 90,
					type = "text",
					icon = injury.getIcon(),
					text = injury.getName()
				});
			}
		}

		if (this.getHitpoints() < this.getHitpointsMax())
		{
			local ht = this.Math.ceil((this.getHitpointsMax() - this.getHitpoints()) / (this.Const.World.Assets.HitpointsPerHour * (("State" in this.World) && this.World.State != null ? this.World.Assets.m.HitpointsPerHourMult : 1.0)) / 24.0);

			if (ht > 1)
			{
				tooltip.push({
					id = 133,
					type = "text",
					icon = "ui/icons/days_wounded.png",
					text = "Blessures légères (" + ht + " jours)"
				});
			}
			else
			{
				tooltip.push({
					id = 133,
					type = "text",
					icon = "ui/icons/days_wounded.png",
					text = "Blessures légères (" + ht + " jour)"
				});
			}
		}

		return tooltip;
	}

	function getOverlayImage()
	{
		if (("State" in this.World) && this.World.State != null)
		{
			return this.World.Assets.getBanner();
		}
		else
		{
			return "banner_06";
		}
	}

	function getImagePath( _ignoreLayers = [] )
	{
		local result = "tacticalentity(" + this.m.ContentID + "," + this.getID() + ",socket,miniboss,arrow";

		for( local i = 0; i < _ignoreLayers.len(); i = ++i )
		{
			result = result + ("," + _ignoreLayers[i]);
		}

		result = result + ")";
		return result;
	}

	function getDaysWounded()
	{
		if (this.getHitpoints() < this.getHitpointsMax())
		{
			return this.Math.ceil((this.getHitpointsMax() - this.getHitpoints()) / (this.Const.World.Assets.HitpointsPerHour * (("State" in this.World) && this.World.State != null ? this.World.Assets.m.HitpointsPerHourMult : 1.0)) / 24.0);
		}
		else
		{
			return 0;
		}
	}

	function onUpdateInjuryLayer()
	{
		if (!this.hasSprite("injury"))
		{
			return;
		}

		local injury = this.getSprite("injury");
		local injury_body = this.getSprite("injury_body");
		local p = this.m.Hitpoints / this.getHitpointsMax();

		if (p > 0.67)
		{
			this.setDirty(this.m.IsDirty || injury.Visible || injury_body.Visible);
			injury.Visible = false;
			injury_body.Visible = false;
		}
		else
		{
			this.setDirty(this.m.IsDirty || !injury.Visible || !injury_body.Visible);
			injury.Visible = true;
			injury_body.Visible = true;

			if (p > 0.33)
			{
				injury.setBrush("bust_head_injured_01");
			}
			else
			{
				injury.setBrush("bust_head_injured_02");
			}

			if (p > 0.4)
			{
				injury_body.Visible = false;
			}
			else
			{
				injury_body.Visible = true;
				injury_body.setBrush(this.getSprite("body").getBrush().Name + "_injured");
			}
		}
	}

	function create()
	{
		this.m.IsControlledByPlayer = true;
		this.m.IsGeneratingKillName = false;
		this.m.Type = this.Const.EntityType.Player;
		this.m.BloodType = this.Const.BloodType.Red;
		this.human.create();
		this.getFlags().add("human");
		this.getFlags().set("PotionLastUsed", 0.0);
		this.getFlags().set("PotionsUsed", 0);
		this.m.AIAgent = this.new("scripts/ai/tactical/player_agent");
		this.m.AIAgent.setActor(this);
	}

	function onHired()
	{
		this.m.HireTime = this.Time.getVirtualTimeF();

		if (this.getBackground().getID() != "background.slave")
		{
			this.improveMood(1.5, "A rejoint une compagnie de mercenaire");
		}

		if (("State" in this.World) && this.World.State != null && this.World.Assets.getOrigin() != null)
		{
			this.World.Assets.getOrigin().onHired(this);
		}

		if (this.World.getPlayerRoster().getSize() >= 12)
		{
			this.updateAchievement("AFullCompany", 1, 1);
		}

		if (this.World.getPlayerRoster().getSize() >= 20)
		{
			this.updateAchievement("PowerInNumbers", 1, 1);
		}

		if (this.World.getPlayerRoster().getSize() == 25 && this.World.Assets.getOrigin().getID() == "scenario.militia")
		{
			this.updateAchievement("HumanWave", 1, 1);
		}
	}

	function onCombatStart()
	{
		this.m.MaxEnemiesThisTurn = 1;
		this.m.CombatStats.DamageReceivedHitpoints = 0;
		this.m.CombatStats.DamageReceivedArmor = 0;
		this.m.CombatStats.DamageDealtHitpoints = 0;
		this.m.CombatStats.DamageDealtArmor = 0;
		this.m.CombatStats.Kills = 0;
		this.m.CombatStats.XPGained = 0;
		this.m.Skills.onCombatStarted();
		this.m.Items.onCombatStarted();
		this.m.Skills.update();
		this.getAIAgent().getProperties().BehaviorMult[this.Const.AI.Behavior.ID.Retreat] = 0.0;
	}

	function onBeforeCombatResult()
	{
		this.onCombatFinished();
		this.m.LifetimeStats.Battles += 1;
		this.getAIAgent().getProperties().BehaviorMult[this.Const.AI.Behavior.ID.Retreat] = 0.0;
		this.getAIAgent().setUseHeat(false);
	}

	function onCombatFinished()
	{
		this.actor.resetRenderEffects();
		this.m.IsAlive = true;
		this.m.IsDying = false;
		this.m.IsAbleToDie = true;
		this.m.Hitpoints = this.Math.max(1, this.m.Hitpoints);
		this.m.MaxEnemiesThisTurn = 1;

		if (this.m.MoraleState != this.Const.MoraleState.Ignore)
		{
			this.setMoraleState(this.Const.MoraleState.Steady);
		}

		this.resetBloodied(false);
		this.getSprite("dirt").Visible = false;
		this.getFlags().set("Devoured", false);
		this.getFlags().set("Charmed", false);
		this.getFlags().set("Sleeping", false);
		this.getFlags().set("Nightmare", false);
		this.m.Fatigue = 0;
		this.m.ActionPoints = 0;
		this.m.Items.onCombatFinished();
		this.m.Skills.onCombatFinished();

		if (this.m.IsAlive)
		{
			this.updateLevel();
			this.updateInjuryVisuals(false);
			this.setDirty(true);
		}
	}

	function isReallyKilled( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.None)
		{
			return true;
		}

		if (this.Tactical.State.isScenarioMode())
		{
			return true;
		}

		if (this.Tactical.State.isAutoRetreat())
		{
			return true;
		}

		if (this.isGuest())
		{
			return true;
		}

		if (this.Math.rand(1, 100) <= this.Const.Combat.SurviveWithInjuryChance * this.m.CurrentProperties.SurviveWithInjuryChanceMult || this.World.Assets.m.IsSurvivalGuaranteed && !this.m.Skills.hasSkillOfType(this.Const.SkillType.PermanentInjury) && (this.World.Assets.getOrigin().getID() != "scenario.manhunters" || this.getBackground().getID() != "background.slave"))
		{
			local potential = [];
			local injuries = this.Const.Injury.Permanent;
			local numPermInjuries = 0;

			foreach( inj in injuries )
			{
				if (!this.m.Skills.hasSkill(inj.ID))
				{
					potential.push(inj);
				}
				else
				{
					numPermInjuries = ++numPermInjuries;
				}
			}

			if (potential.len() != 0)
			{
				local skill = this.new("scripts/skills/" + potential[this.Math.rand(0, potential.len() - 1)].Script);
				this.m.Skills.add(skill);
				this.Tactical.getSurvivorRoster().add(this);
				this.m.IsDying = false;
				this.worsenMood(this.Const.MoodChange.PermanentInjury, "A subi une blessure permanente");
				this.updateAchievement("ScarsForLife", 1, 1);

				if (numPermInjuries + 1 >= 3)
				{
					this.updateAchievement("HardToKill", 1, 1);
				}

				return false;
			}
		}

		return true;
	}

	function onOtherActorDeath( _killer, _victim, _skill )
	{
		if (!this.m.IsAlive || this.m.IsDying)
		{
			return;
		}

		if (!this.isGuest() && _victim.getFaction() == this.getFaction() && ("getBackground" in _victim) && _victim.getBackground().getID() == "background.slave" && this.getBackground().getID() != "background.slave")
		{
			return;
		}

		this.actor.onOtherActorDeath(_killer, _victim, _skill);
	}

	function kill( _killer = null, _skill = null, _fatalityType = this.Const.FatalityType.None, _silent = false )
	{
		if (!this.Tactical.State.isScenarioMode() && this.World.Assets.m.IsSurvivalGuaranteed && _fatalityType != this.Const.FatalityType.Kraken && _fatalityType != this.Const.FatalityType.Devoured && !this.m.Skills.hasSkillOfType(this.Const.SkillType.PermanentInjury) && (this.World.Assets.getOrigin().getID() != "scenario.manhunters" || this.getBackground() != null && this.getBackground().getID() != "background.slave"))
		{
			_fatalityType = this.Const.FatalityType.None;
		}

		this.actor.kill(_killer, _skill, _fatalityType, _silent);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (!this.Tactical.State.isScenarioMode() && _fatalityType != this.Const.FatalityType.Unconscious)
		{
			if (this.getLevel() >= 11 && this.World.Assets.isIronman())
			{
				this.updateAchievement("ToughFarewell", 1, 1);
			}
			else
			{
				this.updateAchievement("BloodyToll", 1, 1);
			}

			if (_killer != null && this.isKindOf(_killer, "player") && _killer.getSkills().hasSkill("effects.charmed"))
			{
				this.updateAchievement("NothingPersonal", 1, 1);
			}
		}

		local flip = this.Math.rand(0, 100) < 50;
		this.m.IsCorpseFlipped = flip;
		local isResurrectable = _fatalityType == this.Const.FatalityType.None || _fatalityType == this.Const.FatalityType.Disemboweled;
		local appearance = this.getItems().getAppearance();
		local sprite_body = this.getSprite("body");
		local sprite_head = this.getSprite("head");
		local sprite_hair = this.getSprite("hair");
		local sprite_beard = this.getSprite("beard");
		local sprite_beard_top = this.getSprite("beard_top");
		local tattoo_body = this.getSprite("tattoo_body");
		local tattoo_head = this.getSprite("tattoo_head");
		local sprite_surcoat = this.getSprite("surcoat");
		local sprite_accessory = this.getSprite("accessory");

		if (!this.isGuest())
		{
			local stub = this.Tactical.getCasualtyRoster().create("scripts/entity/tactical/player_corpse_stub");
			stub.setOriginalID(this.getID());
			stub.setName(this.getNameOnly());
			stub.setTitle(this.getTitle());
			stub.setCombatStats(this.m.CombatStats);
			stub.setLifetimeStats(this.m.LifetimeStats);
			stub.m.DaysWithCompany = this.getDaysWithCompany();
			stub.m.Level = this.getLevel();
			stub.m.DailyCost = this.getDailyCost();
			stub.addSprite("blood_1").setBrush(this.Const.BloodPoolDecals[this.Const.BloodType.Red][this.Math.rand(0, this.Const.BloodPoolDecals[this.Const.BloodType.Red].len() - 1)]);
			stub.addSprite("blood_2").setBrush(this.Const.BloodDecals[this.Const.BloodType.Red][this.Math.rand(0, this.Const.BloodDecals[this.Const.BloodType.Red].len() - 1)]);
			stub.setSpriteOffset("blood_1", this.createVec(0, -15));
			stub.setSpriteOffset("blood_2", this.createVec(0, -30));

			if (_fatalityType == this.Const.FatalityType.Devoured)
			{
				for( local i = 0; i != this.Const.CorpsePart.len(); i = ++i )
				{
					stub.addSprite("stuff_" + i).setBrush(this.Const.CorpsePart[i]);
				}
			}
			else
			{
				local decal = stub.addSprite("body");
				decal.setBrush(sprite_body.getBrush().Name + "_dead");
				decal.Color = sprite_head.Color;
				decal.Saturation = sprite_head.Saturation;

				if (tattoo_body.HasBrush)
				{
					decal = stub.addSprite("tattoo_body");
					decal.setBrush(tattoo_body.getBrush().Name + "_dead");
					decal.Color = tattoo_body.Color;
					decal.Saturation = tattoo_body.Saturation;
				}

				if (appearance.CorpseArmor != "")
				{
					decal = stub.addSprite("armor");
					decal.setBrush(appearance.CorpseArmor);
				}

				if (sprite_surcoat.HasBrush)
				{
					decal = stub.addSprite("surcoat");
					decal.setBrush("surcoat_" + (this.m.Surcoat < 10 ? "0" + this.m.Surcoat : this.m.Surcoat) + "_dead");
				}

				if (appearance.CorpseArmorUpgradeBack != "")
				{
					decal = stub.addSprite("upgrade_back");
					decal.setBrush(appearance.CorpseArmorUpgradeBack);
				}

				if (sprite_accessory.HasBrush)
				{
					decal = stub.addSprite("accessory");
					decal.setBrush(sprite_accessory.getBrush().Name + "_dead");
				}

				if (_fatalityType == this.Const.FatalityType.Disemboweled)
				{
					stub.addSprite("guts").setBrush("bust_body_guts_01");
				}
				else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Arrow)
				{
					if (appearance.CorpseArmor != "")
					{
						stub.addSprite("arrows").setBrush(appearance.CorpseArmor + "_arrows");
					}
					else
					{
						stub.addSprite("arrows").setBrush(appearance.Corpse + "_arrows");
					}
				}
				else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Javelin)
				{
					if (appearance.CorpseArmor != "")
					{
						stub.addSprite("arrows").setBrush(appearance.CorpseArmor + "_javelin");
					}
					else
					{
						stub.addSprite("arrows").setBrush(appearance.Corpse + "_javelin");
					}
				}

				if (_fatalityType != this.Const.FatalityType.Decapitated)
				{
					if (!appearance.HideCorpseHead)
					{
						decal = stub.addSprite("head");
						decal.setBrush(sprite_head.getBrush().Name + "_dead");
						decal.Color = sprite_head.Color;
						decal.Saturation = sprite_head.Saturation;

						if (tattoo_head.HasBrush)
						{
							decal = stub.addSprite("tattoo_head");
							decal.setBrush(this.getSprite("tattoo_head").getBrush().Name + "_dead");
							decal.Color = tattoo_head.Color;
							decal.Saturation = tattoo_head.Saturation;
						}
					}

					if (!appearance.HideBeard && !appearance.HideCorpseHead && sprite_beard.HasBrush)
					{
						decal = stub.addSprite("beard");
						decal.setBrush(sprite_beard.getBrush().Name + "_dead");
						decal.Color = sprite_beard.Color;
						decal.Saturation = sprite_beard.Saturation;
					}

					if (!appearance.HideHair && !appearance.HideCorpseHead && sprite_hair.HasBrush)
					{
						decal = stub.addSprite("hair");
						decal.setBrush(sprite_hair.getBrush().Name + "_dead");
						decal.Color = sprite_hair.Color;
						decal.Saturation = sprite_hair.Saturation;
					}

					if (_fatalityType == this.Const.FatalityType.Smashed)
					{
						stub.addSprite("smashed").setBrush("bust_head_smashed_01");
					}
					else if (appearance.HelmetCorpse != "")
					{
						decal = stub.addSprite("helmet");
						decal.setBrush(this.getItems().getAppearance().HelmetCorpse);
					}

					if (!appearance.HideBeard && !appearance.HideCorpseHead && sprite_beard_top.HasBrush)
					{
						decal = stub.addSprite("beard_top");
						decal.setBrush(sprite_beard_top.getBrush().Name + "_dead");
						decal.Color = sprite_beard.Color;
						decal.Saturation = sprite_beard.Saturation;
					}
				}

				if (appearance.CorpseArmorUpgradeFront != "")
				{
					decal = stub.addSprite("upgrade_front");
					decal.setBrush(appearance.CorpseArmorUpgradeFront);
				}
			}
		}

		if (_tile != null)
		{
			this.human.onDeath(_killer, _skill, _tile, _fatalityType);
			local corpse = _tile.Properties.get("Corpse");
			corpse.IsPlayer = true;
			corpse.Value = 10.0;
		}

		if (!this.m.IsGuest && !this.Tactical.State.isScenarioMode())
		{
			this.World.Assets.addScore(-5 * this.getLevel());
		}

		if (!this.m.IsGuest && !this.Tactical.State.isScenarioMode() && _fatalityType != this.Const.FatalityType.Unconscious && (_skill != null && _killer != null || _fatalityType == this.Const.FatalityType.Devoured || _fatalityType == this.Const.FatalityType.Kraken))
		{
			local killedBy;

			if (_fatalityType == this.Const.FatalityType.Devoured)
			{
				killedBy = "Dévoré par un Nachzehrer";
			}
			else if (_fatalityType == this.Const.FatalityType.Kraken)
			{
				killedBy = "Dévoré par un Kraken";
			}
			else if (_fatalityType == this.Const.FatalityType.Suicide)
			{
				killedBy = "S\'est suicidé";
			}
			else if (_skill.isType(this.Const.SkillType.StatusEffect))
			{
				killedBy = _skill.getKilledString();
			}
			else if (_killer.getID() == this.getID())
			{
				killedBy = "Mort au combat";
			}
			else
			{
				if (_fatalityType == this.Const.FatalityType.Decapitated)
				{
					killedBy = "Décapité";
				}
				else if (_fatalityType == this.Const.FatalityType.Disemboweled)
				{
					if (this.Math.rand(1, 2) == 1)
					{
						killedBy = "Éventré";
					}
					else
					{
						killedBy = "Éviscéré";
					}
				}
				else
				{
					killedBy = _skill.getKilledString();
				}

				killedBy = killedBy + (" par " + _killer.getKilledName());
			}

			local fallen = {
				Name = this.getName(),
				Time = this.World.getTime().Days,
				TimeWithCompany = this.Math.max(1, this.getDaysWithCompany()),
				Kills = this.m.LifetimeStats.Kills,
				Battles = this.m.LifetimeStats.Battles + 1,
				KilledBy = killedBy,
				Expendable = this.getBackground().getID() == "background.slave"
			};
			this.World.Statistics.addFallen(fallen);
		}
	}

	function onInit()
	{
		this.human.onInit();
		this.m.Skills.add(this.new("scripts/skills/special/stats_collector"));
		this.m.Skills.add(this.new("scripts/skills/special/mood_check"));
		this.m.Skills.add(this.new("scripts/skills/special/weapon_breaking_warning"));
		this.m.Skills.add(this.new("scripts/skills/special/no_ammo_warning"));
		this.m.Skills.add(this.new("scripts/skills/effects/battle_standard_effect"));
		this.m.Skills.add(this.new("scripts/skills/actives/break_ally_free_skill"));

		if (this.Const.DLC.Unhold)
		{
			this.m.Skills.add(this.new("scripts/skills/actives/wake_ally_skill"));
		}

		this.setFaction(this.Const.Faction.Player);
		this.m.Items.setUnlockedBagSlots(2);
		this.m.Skills.add(this.new("scripts/skills/special/bag_fatigue"));
		this.setDiscovered(true);
	}

	function onActorKilled( _actor, _tile, _skill )
	{
		this.actor.onActorKilled(_actor, _tile, _skill);
		local XPkiller = this.Math.floor(_actor.getXPValue() * this.Const.XP.XPForKillerPct);
		local XPgroup = _actor.getXPValue() * (1.0 - this.Const.XP.XPForKillerPct);
		this.addXP(XPkiller);
		local brothers = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);

		if (brothers.len() == 1)
		{
			if (this.getSkills().hasSkill("trait.oath_of_distinction"))
			{
				return;
			}
			
			this.addXP(XPgroup);
		}
		else
		{
			foreach( bro in brothers )
			{
				if (bro.getSkills().hasSkill("trait.oath_of_distinction"))
				{
					return;
				}
				
				bro.addXP(this.Math.max(1, this.Math.floor(XPgroup / brothers.len())));
			}
		}
	}

	function setMoraleState( _m )
	{
		if (_m == this.Const.MoraleState.Confident && this.m.Skills.hasSkill("trait.insecure"))
		{
			return;
		}
		
		if (_m == this.Const.MoraleState.Confident && ("State" in this.World) && this.World.State != null && this.World.Assets.getOrigin().getID() == "scenario.anatomists")
		{
			return;
		}

		if (_m == this.Const.MoraleState.Fleeing && this.m.Skills.hasSkill("effects.ancient_priest_potion"))
		{
			return;
		}

		if (_m == this.Const.MoraleState.Fleeing && this.m.Skills.hasSkill("trait.oath_of_valor"))
		{
			return;
		}

		if (_m == this.Const.MoraleState.Confident && this.getMoraleState() != this.Const.MoraleState.Confident && this.isPlacedOnMap() && this.Time.getRound() >= 1 && ("State" in this.World) && this.World.State != null && this.World.Ambitions.hasActiveAmbition() && this.World.Ambitions.getActiveAmbition().getID() == "ambition.oath_of_camaraderie")
		{
			this.World.Statistics.getFlags().increment("OathtakersBrosConfident");
		}

		this.actor.setMoraleState(_m);
	}

	function checkMorale( _change, _difficulty, _type = this.Const.MoraleCheckType.Default, _showIconBeforeMoraleIcon = "", _noNewLine = false )
	{
		if (_change > 0 && this.m.MoraleState == this.Const.MoraleState.Steady && this.m.Skills.hasSkill("trait.insecure"))
		{
			return false;
		}
		
		if (_change > 0 && this.m.MoraleState == this.Const.MoraleState.Steady && ("State" in this.World) && this.World.State != null && this.World.Assets.getOrigin().getID() == "scenario.anatomists")
		{
			return false;
		}

		if (_change < 0 && this.m.MoraleState == this.Const.MoraleState.Breaking && this.m.Skills.hasSkill("effects.ancient_priest_potion"))
		{
			return false;
		}

		if (_change < 0 && this.m.MoraleState == this.Const.MoraleState.Breaking && this.m.Skills.hasSkill("trait.oath_of_valor"))
		{
			return false;
		}

		if (_change > 0 && this.m.Skills.hasSkill("trait.optimist"))
		{
			_difficulty = _difficulty + 5;
		}
		else if (_change < 0 && this.m.Skills.hasSkill("trait.pessimist"))
		{
			_difficulty = _difficulty - 5;
		}
		else if (this.m.Skills.hasSkill("trait.irrational"))
		{
			_difficulty = _difficulty + (this.Math.rand(0, 1) == 0 ? 10 : -10);
		}
		else if (this.m.Skills.hasSkill("trait.mad"))
		{
			_difficulty = _difficulty + (this.Math.rand(0, 1) == 0 ? 15 : -15);
		}

		if (_change < 0 && _type == this.Const.MoraleCheckType.MentalAttack && this.m.Skills.hasSkill("trait.superstitious"))
		{
			_difficulty = _difficulty - 10;
		}

		return this.actor.checkMorale(_change, _difficulty, _type, _showIconBeforeMoraleIcon, _noNewLine);
	}

	function getXPForNextLevel()
	{
		if (this.m.Level >= 7 && ("State" in this.World) && this.World.State != null && this.World.Assets.getOrigin().getID() == "scenario.manhunters" && this.getBackground().getID() == "background.slave")
		{
			return this.Const.LevelXP[6];
		}
		else
		{
			return this.m.Level < this.Const.LevelXP.len() ? this.Const.LevelXP[this.m.Level] : this.Const.LevelXP[this.Const.LevelXP.len() - 1];
		}
	}

	function addXP( _xp, _scale = true )
	{
		local isScenarioMode = !(("State" in this.World) && this.World.State != null);

		if (this.m.Level >= this.Const.LevelXP.len() || this.isGuest() || !isScenarioMode && this.World.Assets.getOrigin().getID() == "scenario.manhunters" && this.m.Level >= 7 && this.getBackground().getID() == "background.slave")
		{
			return;
		}

		if (_scale)
		{
			_xp = _xp * this.Const.Combat.GlobalXPMult;
		}

		if (_scale && !isScenarioMode)
		{
			_xp = _xp * this.Const.Difficulty.XPMult[this.World.Assets.getDifficulty()];
		}

		if (this.m.Level >= 11)
		{
			_xp = _xp * this.Const.Combat.GlobalXPVeteranLevelMult;
		}

		if (!isScenarioMode)
		{
			if (_scale)
			{
				_xp = _xp * this.World.Assets.m.XPMult;

				if (this.World.Retinue.hasFollower("follower.drill_sergeant"))
				{
					_xp = _xp * this.Math.maxf(1.0, 1.2 - 0.02 * (this.m.Level - 1));
				}
			}

			if (this.World.getPlayerRoster().getSize() < 3)
			{
				_xp = _xp * (1.0 - (3 - this.World.getPlayerRoster().getSize()) * 0.15);
			}
		}

		if (this.m.XP + _xp * this.m.CurrentProperties.XPGainMult >= this.Const.LevelXP[this.Const.LevelXP.len() - 1])
		{
			this.m.CombatStats.XPGained += this.Const.LevelXP[this.Const.LevelXP.len() - 1] - this.m.XP;
			this.m.XP = this.Const.LevelXP[this.Const.LevelXP.len() - 1];
			return;
		}
		else if (!isScenarioMode && this.World.Assets.getOrigin().getID() == "scenario.manhunters" && this.m.XP + _xp * this.m.CurrentProperties.XPGainMult >= this.Const.LevelXP[6] && this.getBackground().getID() == "background.slave")
		{
			this.m.CombatStats.XPGained += this.Const.LevelXP[6] - this.m.XP;
			this.m.XP = this.Const.LevelXP[6];
			return;
		}

		this.m.XP += this.Math.floor(_xp * this.m.CurrentProperties.XPGainMult);
		this.m.CombatStats.XPGained += this.Math.floor(_xp * this.m.CurrentProperties.XPGainMult);
	}

	function unlockPerk( _id )
	{
		if (this.hasPerk(_id))
		{
			return true;
		}

		local perk = this.Const.Perks.findById(_id);

		if (perk == null)
		{
			return false;
		}

		if (this.m.PerkPoints > 0)
		{
			--this.m.PerkPoints;
		}

		++this.m.PerkPointsSpent;
		this.m.Skills.add(this.new(perk.Script));
		this.m.Skills.update();

		if (this.m.Level >= 11 && _id == "perk.student")
		{
			++this.m.PerkPoints;
		}
		
		if (("State" in this.World) && this.World.State != null && this.World.Assets.getOrigin() != null)
		{
			this.World.Assets.getOrigin().onUnlockPerk(this, _id);
		}

		return true;
	}

	function isPerkUnlockable( _id )
	{
		if (this.m.PerkPoints == 0 || this.hasPerk(_id))
		{
			return false;
		}

		local perk = this.Const.Perks.findById(_id);

		if (this.m.PerkPointsSpent >= perk.Unlocks)
		{
			return true;
		}

		return false;
	}

	function hasPerk( _id )
	{
		return this.m.Skills.hasSkill(_id);
	}

	function isPerkTierUnlocked( _category, _tier )
	{
		local numPerks = 0;

		for( local j = 0; j < this.m.PerksUnlocked[_category].len(); j = ++j )
		{
			numPerks = numPerks + this.m.PerksUnlocked[_category][j];
		}

		if (numPerks < this.Const.Perks.UnlockRequirementsPerTier[_tier])
		{
			return false;
		}

		return true;
	}

	function getPerksUnlocked( _category, _tier )
	{
		return this.m.PerksUnlocked[_category][_tier];
	}

	function updateLevel()
	{
		while (this.m.Level < this.Const.LevelXP.len() && this.m.XP >= this.Const.LevelXP[this.m.Level])
		{
			++this.m.Level;
			++this.m.LevelUps;

			if (this.m.Level <= this.Const.XP.MaxLevelWithPerkpoints)
			{
				++this.m.PerkPoints;
			}

			if (this.m.Level == 11 && this.m.Skills.hasSkill("perk.student"))
			{
				++this.m.PerkPoints;
			}
			
			if (("State" in this.World) && this.World.State != null && this.World.Assets.getOrigin() != null)
			{
				this.World.Assets.getOrigin().onUpdateLevel(this);
			}

			if (this.m.Level == 11)
			{
				this.updateAchievement("OldAndWise", 1, 1);
			}

			if (this.m.Level == 11 && this.m.Skills.hasSkill("trait.player"))
			{
				this.updateAchievement("TooStubbornToDie", 1, 1);
			}
		}
	}

	function assignRandomEquipment()
	{
		if (this.Math.rand(0, 2) != 0)
		{
			this.assignRandomMeleeEquipment();
		}
		else
		{
			this.assignRandomRangedEquipment();
		}
	}

	function assignRandomMeleeEquipment()
	{
		local r = this.Math.rand(1, 24);

		if (r == 1)
		{
			this.m.Items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}
		else if (r == 2)
		{
			this.m.Items.equip(this.new("scripts/items/armor/mail_shirt"));
		}
		else if (r == 3)
		{
			this.m.Items.equip(this.new("scripts/items/armor/coat_of_plates"));
		}
		else if (r == 4)
		{
			this.m.Items.equip(this.new("scripts/items/armor/gambeson"));
		}
		else if (r == 5)
		{
			this.m.Items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 6)
		{
			this.m.Items.equip(this.new("scripts/items/armor/padded_leather"));
		}
		else if (r == 7)
		{
			this.m.Items.equip(this.new("scripts/items/armor/lamellar_harness"));
		}
		else if (r == 8)
		{
			this.m.Items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else if (r == 9)
		{
			this.m.Items.equip(this.new("scripts/items/armor/heavy_lamellar_armor"));
		}
		else if (r == 10)
		{
			this.m.Items.equip(this.new("scripts/items/armor/basic_mail_shirt"));
		}
		else if (r == 11)
		{
			this.m.Items.equip(this.new("scripts/items/armor/scale_armor"));
		}
		else if (r == 12)
		{
			this.m.Items.equip(this.new("scripts/items/armor/coat_of_scales"));
		}
		else if (r == 13)
		{
			this.m.Items.equip(this.new("scripts/items/armor/linen_tunic"));
		}
		else if (r == 14)
		{
			this.m.Items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}
		else if (r == 15)
		{
			this.m.Items.equip(this.new("scripts/items/armor/heraldic_mail"));
		}
		else if (r == 16)
		{
			this.m.Items.equip(this.new("scripts/items/armor/named/black_leather_armor"));
		}
		else if (r == 17)
		{
			this.m.Items.equip(this.new("scripts/items/armor/named/golden_scale_armor"));
		}
		else if (r == 18)
		{
			this.m.Items.equip(this.new("scripts/items/armor/named/blue_studded_mail_armor"));
		}
		else if (r == 19)
		{
			this.m.Items.equip(this.new("scripts/items/armor/named/brown_coat_of_plates_armor"));
		}
		else if (r == 20)
		{
			this.m.Items.equip(this.new("scripts/items/armor/named/green_coat_of_plates_armor"));
		}
		else if (r == 21)
		{
			this.m.Items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}
		else if (r == 22)
		{
			this.m.Items.equip(this.new("scripts/items/armor/reinforced_mail_hauberk"));
		}
		else if (r == 23)
		{
			this.m.Items.equip(this.new("scripts/items/armor/mail_hauberk"));
		}
		else if (r == 24)
		{
			this.m.Items.equip(this.new("scripts/items/armor/leather_lamellar"));
		}

		r = this.Math.rand(1, 30);

		if (r == 1)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/hood"));
		}
		else if (r == 2)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/mail_coif"));
		}
		else if (r == 3)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/closed_mail_coif"));
		}
		else if (r == 4)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/reinforced_mail_coif"));
		}
		else if (r == 5)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/kettle_hat"));
		}
		else if (r == 6)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/nasal_helmet"));
		}
		else if (r == 7)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/padded_nasal_helmet"));
		}
		else if (r == 8)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/nasal_helmet_with_mail"));
		}
		else if (r == 9)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/full_helm"));
		}
		else if (r == 10)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/flat_top_helmet"));
		}
		else if (r == 11)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/padded_flat_top_helmet"));
		}
		else if (r == 12)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/flat_top_with_mail"));
		}
		else if (r == 13)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/kettle_hat_with_mail"));
		}
		else if (r == 14)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/kettle_hat_with_closed_mail"));
		}
		else if (r == 15)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/closed_flat_top_with_neckguard"));
		}
		else if (r == 16)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/closed_flat_top_helmet"));
		}
		else if (r == 17)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/closed_flat_top_with_mail"));
		}
		else if (r == 18)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/witchhunter_hat"));
		}
		else if (r == 19)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/named/golden_feathers_helmet"));
		}
		else if (r == 20)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/named/heraldic_mail_helmet"));
		}
		else if (r == 21)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/named/nasal_feather_helmet"));
		}
		else if (r == 22)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/named/norse_helmet"));
		}
		else if (r == 23)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/named/sallet_green_helmet"));
		}
		else if (r == 24)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/named/wolf_helmet"));
		}

		r = this.Math.rand(1, 17);

		if (r == 1)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/noble_sword"));
			this.m.Items.equip(this.new("scripts/items/shields/heater_shield"));
		}
		else if (r == 2)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/shortsword"));
		}
		else if (r == 3)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/greatsword"));
		}
		else if (r == 4)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/bludgeon"));
		}
		else if (r == 5)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/winged_mace"));
			this.m.Items.equip(this.new("scripts/items/shields/kite_shield"));
		}
		else if (r == 6)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/winged_mace"));
		}
		else if (r == 7)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/boar_spear"));
			this.m.Items.equip(this.new("scripts/items/shields/wooden_shield"));
		}
		else if (r == 8)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/hand_axe"));
			this.m.Items.equip(this.new("scripts/items/shields/wooden_shield"));
		}
		else if (r == 9)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/fighting_axe"));
		}
		else if (r == 10)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/dagger"));
		}
		else if (r == 11)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/billhook"));
		}
		else if (r == 12)
		{
			this.m.Items.equip(this.new("scripts/items/shields/heater_shield"));
			this.m.Items.equip(this.new("scripts/items/weapons/warhammer"));
		}
		else if (r == 13)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/military_cleaver"));
		}
		else if (r == 14)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/flail"));
		}
		else if (r == 15)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/pike"));
		}
		else if (r == 16)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/two_handed_hammer"));
		}
		else if (r == 17)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/warbrand"));
		}
	}

	function assignRandomRangedEquipment()
	{
		local r = this.Math.rand(1, 10);

		if (r == 1)
		{
			this.m.Items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}
		else if (r == 2)
		{
			this.m.Items.equip(this.new("scripts/items/armor/mail_shirt"));
		}
		else if (r == 3)
		{
			this.m.Items.equip(this.new("scripts/items/armor/padded_leather"));
		}
		else if (r == 4)
		{
			this.m.Items.equip(this.new("scripts/items/armor/gambeson"));
		}
		else if (r == 5)
		{
			this.m.Items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 6)
		{
			this.m.Items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else if (r == 7)
		{
			this.m.Items.equip(this.new("scripts/items/armor/linen_tunic"));
		}
		else if (r == 8)
		{
			this.m.Items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}
		else if (r == 9)
		{
			this.m.Items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}
		else if (r == 10)
		{
			this.m.Items.equip(this.new("scripts/items/armor/thick_tunic"));
		}

		r = this.Math.rand(1, 7);

		if (r == 1)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/hood"));
		}
		else if (r == 2)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/aketon_cap"));
		}
		else if (r == 3)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/full_aketon_cap"));
		}
		else if (r == 4)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/open_leather_cap"));
		}
		else if (r == 5)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/full_leather_cap"));
		}

		r = this.Math.rand(1, 4);

		if (r == 1)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/hunting_bow"));
			this.m.Items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
		}
		else if (r == 2)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/short_bow"));
			this.m.Items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
		}
		else if (r == 3)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/crossbow"));
			this.m.Items.equip(this.new("scripts/items/ammo/quiver_of_bolts"));
		}
		else if (r == 4)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/light_crossbow"));
			this.m.Items.equip(this.new("scripts/items/ammo/quiver_of_bolts"));
		}
	}

	function assignRandomThrowingEquipment()
	{
		local r = this.Math.rand(1, 8);

		if (r == 1)
		{
			this.m.Items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}
		else if (r == 2)
		{
			this.m.Items.equip(this.new("scripts/items/armor/mail_shirt"));
		}
		else if (r == 3)
		{
			this.m.Items.equip(this.new("scripts/items/armor/padded_leather"));
		}
		else if (r == 4)
		{
			this.m.Items.equip(this.new("scripts/items/armor/gambeson"));
		}
		else if (r == 5)
		{
			this.m.Items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 6)
		{
			this.m.Items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else if (r == 7)
		{
			this.m.Items.equip(this.new("scripts/items/armor/linen_tunic"));
		}
		else if (r == 8)
		{
			this.m.Items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}

		r = this.Math.rand(1, 4);

		if (r == 1)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/hood"));
		}
		else if (r == 2)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/aketon_cap"));
		}
		else if (r == 3)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/full_aketon_cap"));
		}

		r = this.Math.rand(1, 2);

		if (r == 1)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/throwing_axe"));
		}
		else if (r == 2)
		{
			this.m.Items.equip(this.new("scripts/items/weapons/javelin"));
		}
	}

	function setScenarioValues()
	{
		local b = this.m.BaseProperties;
		b.ActionPoints = 9;
		b.Hitpoints = 60;
		b.Bravery = this.Math.rand(45, 55);
		b.Stamina = 120;
		b.MeleeSkill = 65;
		b.RangedSkill = 65;
		b.MeleeDefense = 10;
		b.RangedDefense = 10;
		b.Initiative = 115;
		this.setName(this.Const.Tactical.Common.getRandomPlayerName());
		local background = this.new("scripts/skills/backgrounds/" + this.Const.CharacterBackgrounds[this.Math.rand(0, this.Const.CharacterBackgrounds.len() - 1)]);
		background.setScenarioOnly(true);
		this.m.Skills.add(background);
		background.buildDescription();
		background.setAppearance();
		local c = this.m.CurrentProperties;
		this.m.ActionPoints = c.ActionPoints;
		this.m.Hitpoints = c.Hitpoints;
		this.m.Talents.resize(this.Const.Attributes.COUNT, 0);
		this.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
	}

	function setStartValuesEx( _backgrounds, _addTraits = true )
	{
		if (this.isSomethingToSee() && this.World.getTime().Days >= 7)
		{
			_backgrounds = this.Const.CharacterPiracyBackgrounds;
		}

		local background = this.new("scripts/skills/backgrounds/" + _backgrounds[this.Math.rand(0, _backgrounds.len() - 1)]);
		this.m.Skills.add(background);
		this.m.Background = background;
		this.m.Ethnicity = this.m.Background.getEthnicity();
		background.buildAttributes();
		background.buildDescription();

		if (this.m.Name.len() == 0)
		{
			this.m.Name = background.m.Names[this.Math.rand(0, background.m.Names.len() - 1)];
		}

		if (_addTraits)
		{
			local maxTraits = this.Math.rand(this.Math.rand(0, 1) == 0 ? 0 : 1, 2);
			local traits = [
				background
			];

			for( local i = 0; i < maxTraits; i = ++i )
			{
				for( local j = 0; j < 10; j = ++j )
				{
					local trait = this.Const.CharacterTraits[this.Math.rand(0, this.Const.CharacterTraits.len() - 1)];
					local nextTrait = false;

					for( local k = 0; k < traits.len(); k = ++k )
					{
						if (traits[k].getID() == trait[0] || traits[k].isExcluded(trait[0]))
						{
							nextTrait = true;
							break;
						}
					}

					if (!nextTrait)
					{
						traits.push(this.new(trait[1]));
						break;
					}
				}
			}

			for( local i = 1; i < traits.len(); i = ++i )
			{
				this.m.Skills.add(traits[i]);

				if (traits[i].getContainer() != null)
				{
					traits[i].addTitle();
				}
			}
		}

		background.addEquipment();
		background.setAppearance();
		background.buildDescription(true);
		this.m.Skills.update();
		local p = this.m.CurrentProperties;
		this.m.Hitpoints = p.Hitpoints;

		if (_addTraits)
		{
			this.fillTalentValues();
			this.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
		}
	}

	function fillTalentValues()
	{
		this.m.Talents.resize(this.Const.Attributes.COUNT, 0);

		if (this.getBackground() != null && this.getBackground().isUntalented())
		{
			return;
		}

		for( local done = 0; done < 3;  )
		{
			local i = this.Math.rand(0, this.Const.Attributes.COUNT - 1);

			if (this.m.Talents[i] == 0 && (this.getBackground() == null || this.getBackground().getExcludedTalents().find(i) == null))
			{
				local r = this.Math.rand(1, 100);

				if (r <= 60)
				{
					this.m.Talents[i] = 1;
				}
				else if (r <= 90)
				{
					this.m.Talents[i] = 2;
				}
				else
				{
					this.m.Talents[i] = 3;
				}

				done = ++done;
			}
		}
	}

	function fillAttributeLevelUpValues( _amount, _maxOnly = false, _minOnly = false )
	{
		if (this.m.Attributes.len() == 0)
		{
			this.m.Attributes.resize(this.Const.Attributes.COUNT);

			for( local i = 0; i != this.Const.Attributes.COUNT; i = ++i )
			{
				this.m.Attributes[i] = [];
			}
		}

		for( local i = 0; i != this.Const.Attributes.COUNT; i = ++i )
		{
			for( local j = 0; j < _amount; j = ++j )
			{
				if (_minOnly)
				{
					this.m.Attributes[i].insert(0, 1);
				}
				else if (_maxOnly)
				{
					this.m.Attributes[i].insert(0, this.Const.AttributesLevelUp[i].Max);
				}
				else
				{
					this.m.Attributes[i].insert(0, this.Math.rand(this.Const.AttributesLevelUp[i].Min + (this.m.Talents[i] == 3 ? 2 : this.m.Talents[i]), this.Const.AttributesLevelUp[i].Max + (this.m.Talents[i] == 3 ? 1 : 0)));
				}
			}
		}
	}

	function getAttributeLevelUpValues()
	{
		local b = this.getBaseProperties();

		if (this.m.Attributes[0].len() == 0)
		{
			for( local i = 0; i != this.Const.Attributes.COUNT; i = ++i )
			{
				this.m.Attributes[i].push(1);
			}
		}

		local ret = {
			hitpoints = b.Hitpoints,
			hitpointsMax = 150,
			hitpointsIncrease = this.m.Attributes[this.Const.Attributes.Hitpoints][0],
			bravery = b.Bravery,
			braveryMax = 150,
			braveryIncrease = this.m.Attributes[this.Const.Attributes.Bravery][0],
			fatigue = b.Stamina,
			fatigueMax = 150,
			fatigueIncrease = this.m.Attributes[this.Const.Attributes.Fatigue][0],
			initiative = b.Initiative,
			initiativeMax = 200,
			initiativeIncrease = this.m.Attributes[this.Const.Attributes.Initiative][0],
			meleeSkill = b.MeleeSkill,
			meleeSkillMax = 120,
			meleeSkillIncrease = this.m.Attributes[this.Const.Attributes.MeleeSkill][0],
			rangeSkill = b.RangedSkill,
			rangeSkillMax = 120,
			rangeSkillIncrease = this.m.Attributes[this.Const.Attributes.RangedSkill][0],
			meleeDefense = b.MeleeDefense,
			meleeDefenseMax = 100,
			meleeDefenseIncrease = this.m.Attributes[this.Const.Attributes.MeleeDefense][0],
			rangeDefense = b.RangedDefense,
			rangeDefenseMax = 100,
			rangeDefenseIncrease = this.m.Attributes[this.Const.Attributes.RangedDefense][0]
		};
		return ret;
	}

	function setAttributeLevelUpValues( _v )
	{
		local b = this.getBaseProperties();
		b.Hitpoints += _v.hitpointsIncrease;
		this.m.Hitpoints += _v.hitpointsIncrease;
		b.Stamina += _v.maxFatigueIncrease;
		b.Bravery += _v.braveryIncrease;
		b.MeleeSkill += _v.meleeSkillIncrease;
		b.RangedSkill += _v.rangeSkillIncrease;
		b.MeleeDefense += _v.meleeDefenseIncrease;
		b.RangedDefense += _v.rangeDefenseIncrease;
		b.Initiative += _v.initiativeIncrease;
		this.m.LevelUps = this.Math.max(0, this.m.LevelUps - 1);

		for( local i = 0; i != this.Const.Attributes.COUNT; i = ++i )
		{
			this.m.Attributes[i].remove(0);
		}

		this.getSkills().update();
		this.setDirty(true);

		if (b.MeleeSkill >= 90)
		{
			this.updateAchievement("Swordmaster", 1, 1);
		}

		if (b.RangedSkill >= 90)
		{
			this.updateAchievement("Deadeye", 1, 1);
		}
	}

	function addInjury( _injuries, _maxThreshold = 1.0, _isOutOfCombat = true )
	{
		if (_injuries.len() == 0)
		{
			return null;
		}

		local candidates = [];

		foreach( inj in _injuries )
		{
			if (inj.Threshold <= _maxThreshold && !this.m.Skills.hasSkill(inj.ID))
			{
				candidates.push(inj.Script);
			}
		}

		if (candidates.len() == 0)
		{
			return null;
		}

		local injury;

		while (candidates.len() != 0)
		{
			local r = this.Math.rand(0, candidates.len() - 1);
			injury = this.new("scripts/skills/" + candidates[r]);

			if (!injury.isValid(this))
			{
				candidates.remove(r);
				injury = null;
				continue;
			}

			break;
		}

		if (injury == null)
		{
			return null;
		}

		if (_isOutOfCombat)
		{
			injury.setOutOfCombat(true);
		}
		else
		{
			this.worsenMood(this.Const.MoodChange.Injury, "A subi une blessure");
		}

		this.m.Skills.add(injury);
		this.setHitpoints(this.Math.max(1, this.getHitpoints() - this.Math.rand(5, 20)));
		this.updateInjuryVisuals();
		return injury;
	}

	function addLightInjury()
	{
		this.setHitpoints(this.Math.max(1, this.getHitpoints() - this.Math.rand(5, 20)));
	}

	function addHeavyInjury()
	{
		this.setHitpoints(this.Math.max(1, this.getHitpoints() - this.Math.rand(20, 40)));
	}

	function retreat()
	{
		if (!this.isHiddenToPlayer())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this) + " s\'est retiré de la bataille");
		}

		this.m.IsTurnDone = true;
		this.m.IsAbleToDie = false;
		this.Tactical.getRetreatRoster().add(this);
		this.removeFromMap();
		this.Tactical.Entities.setLastCombatResult(this.Const.Tactical.CombatResult.PlayerRetreated);
	}

	function onSerialize( _out )
	{
		this.human.onSerialize(_out);
		_out.writeU8(this.m.Level);
		_out.writeU8(this.m.PerkPoints);
		_out.writeU8(this.m.PerkPointsSpent);
		_out.writeU8(this.m.LevelUps);
		_out.writeF32(this.m.Mood);
		_out.writeU8(this.m.MoodChanges.len());

		for( local i = 0; i != this.m.MoodChanges.len(); i = ++i )
		{
			_out.writeBool(this.m.MoodChanges[i].Positive);
			_out.writeString(this.m.MoodChanges[i].Text);
			_out.writeF32(this.m.MoodChanges[i].Time);
		}

		_out.writeF32(this.m.HireTime);
		_out.writeF32(this.m.LastDrinkTime);

		for( local i = 0; i != this.Const.Attributes.COUNT; i = ++i )
		{
			_out.writeU8(this.m.Talents[i]);
		}

		for( local i = 0; i != this.Const.Attributes.COUNT; i = ++i )
		{
			_out.writeU8(this.m.Attributes[i].len());

			foreach( a in this.m.Attributes[i] )
			{
				_out.writeU8(a);
			}
		}

		_out.writeU8(this.m.PlaceInFormation);
		_out.writeU32(this.m.LifetimeStats.Kills);
		_out.writeU32(this.m.LifetimeStats.Battles);
		_out.writeU32(this.m.LifetimeStats.BattlesWithoutMe);
		_out.writeU16(this.m.LifetimeStats.MostPowerfulVanquishedType);
		_out.writeString(this.m.LifetimeStats.MostPowerfulVanquished);
		_out.writeU16(this.m.LifetimeStats.MostPowerfulVanquishedXP);
		_out.writeString(this.m.LifetimeStats.FavoriteWeapon);
		_out.writeU32(this.m.LifetimeStats.FavoriteWeaponUses);
		_out.writeU32(this.m.LifetimeStats.CurrentWeaponUses);
		_out.writeBool(this.m.IsTryoutDone);
	}

	function onDeserialize( _in )
	{
		if (_in.getMetaData().getVersion() >= 59)
		{
			this.human.onDeserialize(_in);
		}
		else
		{
			this.actor.onDeserialize(_in);
		}

		this.m.Surcoat = null;
		this.m.Level = _in.readU8();
		this.m.PerkPoints = _in.readU8();
		this.m.PerkPointsSpent = _in.readU8();
		this.m.LevelUps = _in.readU8();
		this.m.Mood = _in.readF32();
		local numMoodChanges = _in.readU8();
		this.m.MoodChanges.resize(numMoodChanges, 0);

		for( local i = 0; i != numMoodChanges; i = ++i )
		{
			local moodChange = {};
			moodChange.Positive <- _in.readBool();
			moodChange.Text <- _in.readString();
			moodChange.Time <- _in.readF32();
			this.m.MoodChanges[i] = moodChange;
		}

		this.m.HireTime = _in.readF32();
		this.m.LastDrinkTime = _in.readF32();
		this.m.Talents.resize(this.Const.Attributes.COUNT, 0);

		for( local i = 0; i != this.Const.Attributes.COUNT; i = ++i )
		{
			this.m.Talents[i] = _in.readU8();
		}

		this.m.Attributes.resize(this.Const.Attributes.COUNT);

		for( local i = 0; i != this.Const.Attributes.COUNT; i = ++i )
		{
			this.m.Attributes[i] = [];
			local n = _in.readU8();
			this.m.Attributes[i].resize(n);

			for( local j = 0; j != n; j = ++j )
			{
				this.m.Attributes[i][j] = _in.readU8();
			}
		}

		local ret = this.m.Skills.query(this.Const.SkillType.Background);

		if (ret.len() != 0)
		{
			this.m.Background = ret[0];
			this.m.Background.adjustHiringCostBasedOnEquipment();
			this.m.Background.buildDescription(true);
		}

		this.m.PlaceInFormation = _in.readU8();
		this.m.LifetimeStats.Kills = _in.readU32();
		this.m.LifetimeStats.Battles = _in.readU32();
		this.m.LifetimeStats.BattlesWithoutMe = _in.readU32();

		if (_in.getMetaData().getVersion() >= 37)
		{
			this.m.LifetimeStats.MostPowerfulVanquishedType = _in.readU16();
		}

		this.m.LifetimeStats.MostPowerfulVanquished = _in.readString();
		this.m.LifetimeStats.MostPowerfulVanquishedXP = _in.readU16();
		this.m.LifetimeStats.FavoriteWeapon = _in.readString();
		this.m.LifetimeStats.FavoriteWeaponUses = _in.readU32();
		this.m.LifetimeStats.CurrentWeaponUses = _in.readU32();
		this.m.IsTryoutDone = _in.readBool();
		this.m.Skills.update();
	}

});


this.skill <- {
	m = {
		ID = "",
		Name = "",
		Icon = "",
		IconDisabled = "",
		IconMini = "",
		Overlay = "",
		Description = "",
		KilledString = "Killed",
		Delay = 0,
		HitChanceBonus = 0,
		SoundOnUse = [],
		SoundOnHit = [],
		SoundOnMiss = [],
		SoundOnHitHitpoints = [],
		SoundOnHitArmor = [],
		SoundOnHitShield = [],
		SoundVolume = 1.0,
		SoundOnHitDelay = 0,
		ProjectileType = this.Const.ProjectileType.None,
		ProjectileTimeScale = 1.0,
		IsProjectileRotated = true,
		Type = this.Const.SkillType.None,
		Container = null,
		Item = null,
		ActionPointCost = 0,
		FatigueCost = 0,
		FatigueCostMult = 1.0,
		MinRange = 0,
		MaxRange = 0,
		MaxRangeBonus = 9,
		MaxLevelDifference = 1,
		Order = this.Const.SkillOrder.Any,
		DirectDamageMult = 0.0,
		ChanceDecapitate = 0,
		ChanceDisembowel = 0,
		ChanceSmash = 0,
		InjuriesOnBody = null,
		InjuriesOnHead = null,
		IsActive = false,
		IsTargeted = false,
		IsStacking = false,
		IsAttack = false,
		IsWeaponSkill = false,
		IsTargetingActor = true,
		IsVisibleTileNeeded = true,
		IsRanged = false,
		IsRangeLimitsEnforced = false,
		IsAOE = false,
		IsHidden = false,
		IsIgnoredAsAOO = false,
		IsIgnoringRiposte = false,
		IsUsingHitchance = true,
		IsUsingActorPitch = false,
		IsShieldRelevant = true,
		IsShieldwallRelevant = true,
		IsSpearwallRelevant = true,
		IsShowingProjectile = false,
		IsDoingAttackMove = true,
		IsDoingForwardMove = true,
		IsAudibleWhenHidden = true,
		IsSerialized = true,
		IsNew = true,
		IsRemovedAfterBattle = false,
		IsDisengagement = false,
		IsTooCloseShown = false,
		IsUsable = true,
		IsGarbage = false
	},
	function getContainer()
	{
		return this.m.Container;
	}

	function getName()
	{
		return this.m.Name;
	}

	function getID()
	{
		return this.m.ID;
	}

	function getIconColored()
	{
		return this.m.Icon;
	}

	function getIconDisabled()
	{
		return this.m.IconDisabled;
	}

	function getIconMini()
	{
		return this.m.IconMini;
	}

	function getDescription()
	{
		return this.m.Description;
	}

	function getKilledString()
	{
		return this.m.KilledString;
	}

	function getType()
	{
		return this.m.Type;
	}

	function isType( _t )
	{
		return (this.m.Type & _t) != 0;
	}

	function getProjectileType()
	{
		return this.m.ProjectileType;
	}

	function getDelay()
	{
		return this.m.Delay;
	}

	function getOrder()
	{
		return this.m.Order;
	}

	function getItem()
	{
		return this.m.Item;
	}

	function setOrder( _o )
	{
		this.m.Order = _o;
	}

	function getFatigueCostRaw()
	{
		return this.m.FatigueCost;
	}

	function setFatigueCost( _f )
	{
		this.m.FatigueCost = _f;
	}

	function getMinRange()
	{
		return this.m.MinRange;
	}

	function getMaxRange()
	{
		return this.m.MaxRange;
	}

	function getMaxLevelDifference()
	{
		return this.m.MaxLevelDifference;
	}

	function getMaxRangeBonus()
	{
		return this.m.MaxRangeBonus;
	}

	function getDirectDamage()
	{
		return this.m.DirectDamageMult;
	}

	function getChanceDecapitate()
	{
		return this.m.ChanceDecapitate;
	}

	function getChanceDisembowel()
	{
		return this.m.ChanceDisembowel;
	}

	function getChanceSmash()
	{
		return this.m.ChanceSmash;
	}

	function isActive()
	{
		return this.m.IsActive;
	}

	function isTargeted()
	{
		return this.m.IsTargeted;
	}

	function isStacking()
	{
		return this.m.IsStacking;
	}

	function isAttack()
	{
		return this.m.IsAttack;
	}

	function isAOE()
	{
		return this.m.IsAOE;
	}

	function isRanged()
	{
		return this.m.IsRanged;
	}

	function isTargetingActor()
	{
		return this.m.IsTargetingActor;
	}

	function isHidden()
	{
		return this.m.IsHidden;
	}

	function isDisabled()
	{
		return !this.m.IsUsable;
	}

	function isIgnoredAsAOO()
	{
		return this.m.IsIgnoredAsAOO;
	}

	function isIgnoringRiposte()
	{
		return this.m.IsIgnoringRiposte;
	}

	function isUsingHitchance()
	{
		return this.m.IsUsingHitchance;
	}

	function isShowingProjectile()
	{
		return this.m.IsShowingProjectile;
	}

	function isGarbage()
	{
		return this.m.IsGarbage;
	}

	function isSerialized()
	{
		return this.m.IsSerialized;
	}

	function isDisengagement()
	{
		return this.m.IsDisengagement;
	}

	function isSpearwallRelevant()
	{
		return this.m.IsSpearwallRelevant;
	}

	function isVisibleTileNeeded()
	{
		return this.m.IsVisibleTileNeeded;
	}

	function getIcon()
	{
		if (this.m.IsActive)
		{
			if (this.isUsable() && this.isAffordable())
			{
				return this.m.Icon;
			}
			else
			{
				return this.m.IconDisabled;
			}
		}
		else
		{
			return this.m.Icon;
		}
	}

	function getActionPointCost()
	{
		if (this.m.Container.getActor().getCurrentProperties().IsSkillUseFree)
		{
			return 0;
		}
		else if (this.m.Container.getActor().getCurrentProperties().IsSkillUseHalfCost)
		{
			return this.Math.max(1, this.Math.floor(this.m.ActionPointCost / 2));
		}
		else
		{
			return this.m.ActionPointCost;
		}
	}

	function setItem( _i )
	{
		if (_i == null)
		{
			this.m.Item = null;
		}
		else
		{
			if (typeof _i == "instance")
			{
				this.m.Item = _i;
			}
			else
			{
				this.m.Item = this.WeakTableRef(_i);
			}

			this.onItemSet();
		}
	}

	function getFatigueCost()
	{
		if (this.m.Container != null)
		{
			return this.Math.max(0, this.Math.round(this.Math.ceil(this.m.FatigueCost * this.m.FatigueCostMult * this.m.Container.getActor().getCurrentProperties().FatigueEffectMult) + this.m.Container.getActor().getCurrentProperties().FatigueOnSkillUse));
		}
		else
		{
			return this.Math.ceil(this.m.FatigueCost * this.m.Container.getActor().getCurrentProperties().FatigueEffectMult);
		}
	}

	function getTooltip()
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
				text = this.getDescription()
			}
		];
	}

	function getDefaultUtilityTooltip()
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
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			}
		];
	}

	function getDefaultTooltip()
	{
		local p = this.m.Container.buildPropertiesForUse(this, null);
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			}
		];
		local damage_regular_min = this.Math.floor(p.DamageRegularMin * p.DamageRegularMult * p.DamageTotalMult * (this.m.IsRanged ? p.RangedDamageMult : p.MeleeDamageMult) * p.DamageTooltipMinMult);
		local damage_regular_max = this.Math.floor(p.DamageRegularMax * p.DamageRegularMult * p.DamageTotalMult * (this.m.IsRanged ? p.RangedDamageMult : p.MeleeDamageMult) * p.DamageTooltipMaxMult);
		local damage_direct_min = this.Math.floor(damage_regular_min * this.Math.minf(1.0, p.DamageDirectMult * (this.m.DirectDamageMult + p.DamageDirectAdd)));
		local damage_direct_max = this.Math.floor(damage_regular_max * this.Math.minf(1.0, p.DamageDirectMult * (this.m.DirectDamageMult + p.DamageDirectAdd)));
		local damage_armor_min = this.Math.floor(p.DamageRegularMin * p.DamageArmorMult * p.DamageTotalMult * (this.m.IsRanged ? p.RangedDamageMult : p.MeleeDamageMult) * p.DamageTooltipMinMult);
		local damage_armor_max = this.Math.floor(p.DamageRegularMax * p.DamageArmorMult * p.DamageTotalMult * (this.m.IsRanged ? p.RangedDamageMult : p.MeleeDamageMult) * p.DamageTooltipMaxMult);

		if (this.m.DirectDamageMult == 1.0)
		{
			ret.push({
				id = 4,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "Inflicts [color=" + this.Const.UI.Color.DamageValue + "]" + damage_direct_min + "[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + damage_direct_max + "[/color] damage that ignores armor"
			});
		}
		else if (this.m.DirectDamageMult > 0.0)
		{
			ret.push({
				id = 4,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "Inflicts [color=" + this.Const.UI.Color.DamageValue + "]" + damage_regular_min + "[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + damage_regular_max + "[/color] damage to hitpoints, of which [color=" + this.Const.UI.Color.DamageValue + "]0[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + damage_direct_max + "[/color] can ignore armor"
			});
		}
		else
		{
			ret.push({
				id = 4,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "Inflicts [color=" + this.Const.UI.Color.DamageValue + "]" + damage_regular_min + "[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + damage_regular_max + " damage to hitpoints[/color]"
			});
		}

		if (damage_armor_max > 0)
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/icons/armor_damage.png",
				text = "Inflicts [color=" + this.Const.UI.Color.DamageValue + "]" + damage_armor_min + "[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + damage_armor_max + "[/color] damage to armor"
			});
		}

		return ret;
	}

	function getCostString()
	{
		return "[i]Coûte " + (this.isAffordableBasedOnAPPreview() ? "[b][color=" + this.Const.UI.Color.PositiveValue + "]" + this.getActionPointCost() : "[b][color=" + this.Const.UI.Color.NegativeValue + "]" + this.getActionPointCost()) + " PA[/color][/b] à utiliser et fait monter la fatigue de " + (this.isAffordableBasedOnFatiguePreview() ? "[b][color=" + this.Const.UI.Color.PositiveValue + "]" + this.getFatigueCost() : "[b][color=" + this.Const.UI.Color.NegativeValue + "]" + this.getFatigueCost()) + "[/color][/b][/i]\n";
	}

	function getCursorForTile( _tile )
	{
		return this.Const.UI.Cursor.Attack;
	}

	function getAffectedTiles( _targetTile )
	{
		return [
			_targetTile
		];
	}

	function isUsable()
	{
		return this.m.IsUsable && this.m.Container.getActor().getCurrentProperties().IsAbleToUseSkills && (!this.m.IsWeaponSkill || this.m.Container.getActor().getCurrentProperties().IsAbleToUseWeaponSkills) && !this.isHidden();
	}

	function isAffordable()
	{
		return this.getActionPointCost() + this.m.Container.getActor().getCurrentProperties().AdditionalActionPointCost <= this.m.Container.getActor().getActionPoints() && this.getFatigueCost() + this.m.Container.getActor().getFatigue() <= this.m.Container.getActor().getFatigueMax();
	}

	function isAffordablePreview()
	{
		return this.getActionPointCost() <= this.m.Container.getActor().getPreviewActionPoints() && this.getFatigueCost() + this.m.Container.getActor().getPreviewFatigue() <= this.m.Container.getActor().getFatigueMax();
	}

	function isAffordableBasedOnAP()
	{
		return this.getActionPointCost() <= this.m.Container.getActor().getActionPoints();
	}

	function isAffordableBasedOnAPPreview()
	{
		if (this.m.Container.getActor().getPreviewSkillID() == this.getID())
		{
			return true;
		}

		return this.getActionPointCost() <= this.m.Container.getActor().getPreviewActionPoints();
	}

	function isAffordableBasedOnFatigue()
	{
		return this.getFatigueCost() + this.m.Container.getActor().getFatigue() <= this.m.Container.getActor().getFatigueMax();
	}

	function isAffordableBasedOnFatiguePreview()
	{
		if (this.m.Container.getActor().getPreviewSkillID() == this.getID())
		{
			return true;
		}

		return this.getFatigueCost() + this.m.Container.getActor().getPreviewFatigue() <= this.m.Container.getActor().getFatigueMax();
	}

	function isUsableOn( _targetTile, _userTile = null )
	{
		if (!this.isAffordable() || !this.isUsable())
		{
			return false;
		}

		local user = this.m.Container.getActor();

		if (_userTile == null)
		{
			_userTile = user.getTile();
		}

		if (this.isTargeted())
		{
			if (this.m.IsVisibleTileNeeded && !_targetTile.IsVisibleForEntity)
			{
				return false;
			}

			if (!this.onVerifyTarget(_userTile, _targetTile))
			{
				return false;
			}

			local d = _userTile.getDistanceTo(_targetTile);
			local levelDifference = _userTile.Level - _targetTile.Level;

			if (d < this.m.MinRange || !this.m.IsRanged && d > this.getMaxRange())
			{
				return false;
			}

			if (this.m.IsRanged && d > this.getMaxRange() + this.Math.min(this.m.MaxRangeBonus, this.Math.max(0, levelDifference)))
			{
				return false;
			}
		}

		return true;
	}

	function isInRange( _targetTile, _userTile = null )
	{
		local user = this.m.Container.getActor();

		if (_userTile == null)
		{
			_userTile = user.getTile();
		}

		local d = _userTile.getDistanceTo(_targetTile);
		local levelDifference = _userTile.Level - _targetTile.Level;

		if (d < this.m.MinRange || !this.m.IsRanged && d > this.getMaxRange())
		{
			return false;
		}

		if (this.m.IsRanged && d > this.getMaxRange() + this.Math.min(this.m.MaxRangeBonus, this.Math.max(0, levelDifference)))
		{
			return false;
		}

		return true;
	}

	function use( _targetTile, _forFree = false )
	{
		if (!_forFree && !this.isAffordable() || !this.isUsable())
		{
			return false;
		}

		local user = this.m.Container.getActor();

		if (!_forFree)
		{
			this.logDebug(user.getName() + " uses skill " + this.getName());
		}

		if (this.isTargeted())
		{
			if (this.m.IsVisibleTileNeeded && !_targetTile.IsVisibleForEntity)
			{
				return false;
			}

			if (!this.onVerifyTarget(user.getTile(), _targetTile))
			{
				return false;
			}

			local d = user.getTile().getDistanceTo(_targetTile);
			local levelDifference = user.getTile().Level - _targetTile.Level;

			if (d < this.m.MinRange || !this.m.IsRanged && d > this.getMaxRange())
			{
				return false;
			}

			if (this.m.IsRanged && d > this.getMaxRange() + this.Math.min(this.m.MaxRangeBonus, this.Math.max(0, levelDifference)))
			{
				return false;
			}
		}

		if (!_forFree)
		{
			++this.Const.SkillCounter;
		}

		if ((this.m.IsAudibleWhenHidden || user.getTile().IsVisibleForPlayer) && this.m.SoundOnUse.len() != 0)
		{
			if (!this.m.IsUsingActorPitch)
			{
				this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill * this.m.SoundVolume, user.getPos());
			}
			else
			{
				this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill * this.m.SoundVolume, user.getPos(), user.getSoundPitch());
			}

			if (this.m.IsAttack)
			{
				user.playAttackSound();
			}
		}

		this.spawnOverlay(user, _targetTile);

		if (!_forFree)
		{
			user.setActionPoints(user.getActionPoints() - this.getActionPointCost() - user.getCurrentProperties().AdditionalActionPointCost);
			user.setFatigue(user.getFatigue() + this.getFatigueCost());
		}

		if (this.m.Item != null && !this.m.Item.isNull())
		{
			this.m.Item.onUse(this);
		}

		user.setPreviewSkillID("");
		return this.onUse(user, _targetTile);
	}

	function useForFree( _targetTile )
	{
		return this.use(_targetTile, true);
	}

	function getExpectedDamage( _target )
	{
		local actor = this.m.Container.getActor();
		local p = this.m.Container.buildPropertiesForUse(this, _target);
		local d = _target.getSkills().buildPropertiesForDefense(actor, this);
		local critical = 1.0 + p.getHitchance(this.Const.BodyPart.Head) / 100.0 * (p.DamageAgainstMult[this.Const.BodyPart.Head] - 1.0);
		local armor = _target.getArmor(this.Const.BodyPart.Head) * (p.getHitchance(this.Const.BodyPart.Head) / 100.0) + _target.getArmor(this.Const.BodyPart.Body) * (this.Math.max(0, p.getHitchance(this.Const.BodyPart.Body)) / 100.0);
		local armorDamage = this.Math.min(armor, p.getArmorDamageAverage());
		local directDamage = this.Math.max(0, p.getRegularDamageAverage() * (p.DamageDirectMult * (this.m.DirectDamageMult + p.DamageDirectAdd)) * critical - (p.DamageDirectMult * (this.m.DirectDamageMult + p.DamageDirectAdd) < 1.0 ? (armor - armorDamage) * this.Const.Combat.ArmorDirectDamageMitigationMult : 0));
		local hitpointDamage = this.Math.max(0, p.getRegularDamageAverage() * critical - directDamage - armorDamage);
		armorDamage = armorDamage * (d.DamageReceivedArmorMult * d.DamageReceivedTotalMult);
		directDamage = directDamage * (d.DamageReceivedDirectMult * d.DamageReceivedTotalMult);
		hitpointDamage = hitpointDamage * (d.DamageReceivedRegularMult * d.DamageReceivedTotalMult);

		if (this.m.IsRanged)
		{
			armorDamage = armorDamage * (p.RangedDamageMult * d.DamageReceivedRangedMult);
			directDamage = directDamage * (p.RangedDamageMult * d.DamageReceivedRangedMult);
			hitpointDamage = hitpointDamage * (p.RangedDamageMult * d.DamageReceivedRangedMult);
		}
		else
		{
			armorDamage = armorDamage * (p.MeleeDamageMult * d.DamageReceivedMeleeMult);
			directDamage = directDamage * (p.MeleeDamageMult * d.DamageReceivedMeleeMult);
			hitpointDamage = hitpointDamage * (p.MeleeDamageMult * d.DamageReceivedMeleeMult);
		}

		local ret = {
			ArmorDamage = armorDamage,
			DirectDamage = directDamage,
			HitpointDamage = hitpointDamage,
			TotalDamage = hitpointDamage + armorDamage + directDamage
		};
		return ret;
	}

	function removeSelf()
	{
		this.m.IsGarbage = true;
	}

	function addResources()
	{
		foreach( r in this.m.SoundOnUse )
		{
			this.Tactical.addResource(r);
		}

		foreach( r in this.m.SoundOnHit )
		{
			this.Tactical.addResource(r);
		}

		foreach( r in this.m.SoundOnMiss )
		{
			this.Tactical.addResource(r);
		}

		foreach( r in this.m.SoundOnHitHitpoints )
		{
			this.Tactical.addResource(r);
		}

		foreach( r in this.m.SoundOnHitArmor )
		{
			this.Tactical.addResource(r);
		}
	}

	function setContainer( _c )
	{
		this.m.Container = this.WeakTableRef(_c);

		if (_c != null && !this.m.IsHidden && _c.getActor().isPlacedOnMap() && this.isType(this.Const.SkillType.StatusEffect) && this.m.Overlay != "")
		{
			this.spawnIcon(this.m.Overlay, _c.getActor().getTile());
		}
	}

	function onItemSet()
	{
	}

	function onUse( _user, _targetTile )
	{
		return false;
	}

	function onAdded()
	{
	}

	function onRefresh()
	{
	}

	function onRemoved()
	{
	}

	function onDeath()
	{
	}

	function onUpdate( _properties )
	{
	}

	function onAfterUpdate( _properties )
	{
	}

	function onBeforeActivation()
	{
	}

	function onNewRound()
	{
	}

	function onRoundEnd()
	{
	}

	function onTurnStart()
	{
	}

	function onTurnEnd()
	{
	}

	function onResumeTurn()
	{
	}

	function onWaitTurn()
	{
	}

	function onNewDay()
	{
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
	}

	function onTargetMissed( _skill, _targetEntity )
	{
	}

	function onTargetKilled( _targetEntity, _skill )
	{
	}

	function onBeingAttacked( _attacker, _skill, _properties )
	{
	}

	function onMissed( _attacker, _skill )
	{
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
	}

	function onCombatStarted()
	{
	}

	function onCombatFinished()
	{
		if (this.m.IsRemovedAfterBattle || this.isType(this.Const.SkillType.Terrain))
		{
			this.removeSelf();
		}
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (this.m.IsTargetingActor && (_targetTile.IsEmpty || !_targetTile.getEntity().isAttackable() || !_targetTile.getEntity().isAlive() || _targetTile.getEntity().isDying()))
		{
			return false;
		}

		if (this.m.IsAttack && this.m.IsTargetingActor && this.m.Container.getActor().isAlliedWith(_targetTile.getEntity()))
		{
			return false;
		}

		if (this.Math.abs(_targetTile.Level - _originTile.Level) > this.m.MaxLevelDifference)
		{
			return false;
		}

		if (!this.m.IsRanged && this.m.IsVisibleTileNeeded && this.m.MaxRange > 1 && _originTile.getDistanceTo(_targetTile) > 1)
		{
			local myPos = _originTile.Pos;
			local targetPos = _targetTile.Pos;
			local Dx = (targetPos.X - myPos.X) / 2;
			local Dy = (targetPos.Y - myPos.Y) / 2;
			local x = myPos.X + Dx;
			local y = myPos.Y + Dy;
			local tileCoords = this.Tactical.worldToTile(this.createVec(x, y));
			local tile = this.Tactical.getTile(tileCoords);

			if (tile.Level > _originTile.Level && (_originTile.Level - tile.Level < -1 || _targetTile.Level - tile.Level < -1))
			{
				return false;
			}
		}

		return true;
	}

	function onTargetSelected( _targetTile )
	{
		local userTile = this.m.Container.getActor().getTile();

		if (this.m.IsRanged && userTile.getDistanceTo(_targetTile) > 1)
		{
			local blockedTiles = this.Const.Tactical.Common.getBlockedTiles(userTile, _targetTile, this.m.Container.getActor().getFaction(), true);

			foreach( tile in blockedTiles )
			{
				this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.RangedSkillBlockedIcon, tile, tile.Pos.X, tile.Pos.Y);
			}
		}
	}

	function onTargetDeselected()
	{
		this.Tactical.getHighlighter().clearOverlayIcons();
	}

	function spawnOverlay( _user, _targetTile )
	{
		if (this.m.Overlay == "")
		{
			return;
		}

		if (_user.isHiddenToPlayer() && (this.m.IsTargetingActor && !_targetTile.IsEmpty && _targetTile.getEntity().getFaction() != this.Const.Faction.Player || !this.m.IsTargetingActor))
		{
			return;
		}

		this.Tactical.spawnSpriteEffect(this.m.Overlay, this.createColor("#ffffff"), _user.getTile(), this.Const.Tactical.Settings.SkillOverlayOffsetX, this.Const.Tactical.Settings.SkillOverlayOffsetY, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayScale, this.Const.Tactical.Settings.SkillOverlayStayDuration + this.m.Delay, 0, this.Const.Tactical.Settings.SkillOverlayFadeDuration);
	}

	function spawnAttackEffect( _tile, _effect )
	{
		if (this.m.Container.getActor().isHiddenToPlayer() && (this.m.IsTargetingActor && !_tile.IsEmpty && _tile.getEntity().getFaction() != this.Const.Faction.Player || !this.m.IsTargetingActor && !_tile.IsVisibleForPlayer))
		{
			return;
		}

		local dir = this.m.Container.getActor().getTile().getDirectionTo(_tile);

		if (this.Tactical.getCamera().IsFlipped)
		{
			dir = dir + 3;

			if (dir >= this.Const.Direction.COUNT)
			{
				dir = dir - this.Const.Direction.COUNT;
			}
		}

		if (_effect[dir].Brush.len() == 0)
		{
			return;
		}

		local secondMovementDelay = (this.Const.Tactical.Settings.AttackEffectFadeInDuration + this.Const.Tactical.Settings.AttackEffectStayDuration + this.Const.Tactical.Settings.AttackEffectFadeOutDuration) / 2;
		this.Tactical.spawnAttackEffect(_effect[dir].Brush, _tile, _effect[dir].Offset.X + this.Const.Tactical.Settings.AttackEffectOffsetX, _effect[dir].Offset.Y + this.Const.Tactical.Settings.AttackEffectOffsetY, this.Const.Tactical.Settings.AttackEffectFadeInDuration, this.Const.Tactical.Settings.AttackEffectStayDuration, this.Const.Tactical.Settings.AttackEffectFadeOutDuration, _effect[dir].Movement0, secondMovementDelay, _effect[dir].Movement1, false);
	}

	function spawnIcon( _brush, _tile )
	{
		if (!_tile.IsVisibleForPlayer)
		{
			return;
		}

		this.Tactical.spawnIconEffect(_brush, _tile, this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
	}

	function applyFatigueDamage( _targetEntity, _damage )
	{
		local user = this.m.Container.getActor();
		local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(user, this);
		_targetEntity.setFatigue(_targetEntity.getFatigue() + _damage * defenderProperties.FatigueEffectMult);
	}

	function getHitFactors( _targetTile )
	{
		local ret = [];
		local user = this.m.Container.getActor();
		local myTile = user.getTile();
		local targetEntity = _targetTile.IsOccupiedByActor ? _targetTile.getEntity() : null;

		if (this.m.HitChanceBonus > 0)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = this.getName()
			});
		}

		if (!this.m.IsRanged && targetEntity != null && targetEntity.getSurroundedCount() != 0)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "Surrounded"
			});
		}

		if (_targetTile.Level < this.m.Container.getActor().getTile().Level)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "Height advantage"
			});
		}

		if (_targetTile.IsBadTerrain)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "Target on bad terrain"
			});
		}

		if (this.m.IsAttack)
		{
			local fast_adaption = this.m.Container.getSkillByID("perk.fast_adaption");

			if (fast_adaption != null && fast_adaption.isBonusActive())
			{
				ret.push({
					icon = "ui/tooltips/positive.png",
					text = "Fast Adaption"
				});
			}
		}

		if (this.m.IsTooCloseShown && this.m.HitChanceBonus < 0)
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "Too close"
			});
		}
		else if (this.m.HitChanceBonus < 0)
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = this.getName()
			});
		}

		if (_targetTile.Level > myTile.Level)
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "Height disadvantage"
			});
		}

		if (myTile.IsBadTerrain)
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "On bad terrain"
			});
		}

		if (this.m.IsShieldRelevant)
		{
			if (_targetTile.IsOccupiedByActor && targetEntity.isArmedWithShield())
			{
				ret.push({
					icon = "ui/tooltips/negative.png",
					text = "Armed with shield"
				});
			}
		}

		if (this.m.IsShieldwallRelevant)
		{
			if (_targetTile.IsOccupiedByActor && targetEntity.getSkills().hasSkill("effects.shieldwall"))
			{
				ret.push({
					icon = "ui/tooltips/negative.png",
					text = "Shieldwall"
				});
			}
		}

		if (_targetTile.IsOccupiedByActor && myTile.getDistanceTo(_targetTile) <= 1 && targetEntity.getSkills().hasSkill("effects.riposte"))
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "Riposte"
			});
		}

		if (this.m.IsRanged && myTile.getDistanceTo(_targetTile) > 1)
		{
			if (_targetTile.IsOccupiedByActor)
			{
				ret.push({
					icon = "ui/tooltips/negative.png",
					text = "Distance of " + _targetTile.getDistanceTo(user.getTile())
				});
			}

			if (this.m.IsUsingHitchance)
			{
				local blockedTiles = this.Const.Tactical.Common.getBlockedTiles(myTile, _targetTile, user.getFaction(), true);

				if (blockedTiles.len() != 0)
				{
					ret.push({
						icon = "ui/tooltips/negative.png",
						text = "Line of fire blocked"
					});
				}
			}
		}

		if (this.m.IsAttack && _targetTile.IsOccupiedByActor && (targetEntity.getFlags().has("skeleton") || targetEntity.getSkills().hasSkill("racial.golem")))
		{
			if (this.m.IsRanged)
			{
				ret.push({
					icon = "ui/tooltips/negative.png",
					text = "Resistance against ranged weapons"
				});
			}
			else if (this.m.ID == "actives.puncture" || this.m.ID == "actives.thrust" || this.m.ID == "actives.stab" || this.m.ID == "actives.deathblow" || this.m.ID == "actives.impale" || this.m.ID == "actives.rupture" || this.m.ID == "actives.prong" || this.m.ID == "actives.lunge")
			{
				ret.push({
					icon = "ui/tooltips/negative.png",
					text = "Resistance against piercing attacks"
				});
			}
		}

		if (_targetTile.IsOccupiedByActor && targetEntity.getCurrentProperties().IsImmuneToStun && (this.m.ID == "actives.knock_out" || this.m.ID == "actives.knock_over" || this.m.ID == "actives.strike_down"))
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "Immune to stun"
			});
		}

		if (_targetTile.IsOccupiedByActor && targetEntity.getCurrentProperties().IsImmuneToRoot && this.m.ID == "actives.throw_net")
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "Immune to being rooted"
			});
		}

		if (_targetTile.IsOccupiedByActor && (targetEntity.getCurrentProperties().IsImmuneToDisarm || targetEntity.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) == null) && this.m.ID == "actives.disarm")
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "Immune to being disarmed"
			});
		}

		if (_targetTile.IsOccupiedByActor && targetEntity.getCurrentProperties().IsImmuneToKnockBackAndGrab && (this.m.ID == "actives.knock_back" || this.m.ID == "actives.hook" || this.m.ID == "actives.repel"))
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "Immune to being knocked back or hooked"
			});
		}

		if (this.m.IsRanged && user.getCurrentProperties().IsAffectedByNight && user.getSkills().hasSkill("special.night"))
		{
			ret.push({
				icon = "ui/tooltips/negative.png",
				text = "Nighttime"
			});
		}

		return ret;
	}

	function getHitchance( _targetEntity )
	{
		if (!_targetEntity.isAttackable())
		{
			return 0;
		}

		local user = this.m.Container.getActor();
		local properties = this.m.Container.buildPropertiesForUse(this, _targetEntity);

		if (!this.isUsingHitchance())
		{
			return 100;
		}

		local allowDiversion = this.m.IsRanged && this.m.MaxRangeBonus > 1;
		local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(user, this);
		local skill = this.m.IsRanged ? properties.RangedSkill * properties.RangedSkillMult : properties.MeleeSkill * properties.MeleeSkillMult;
		local defense = _targetEntity.getDefense(user, this, defenderProperties);
		local levelDifference = _targetEntity.getTile().Level - user.getTile().Level;
		local distanceToTarget = user.getTile().getDistanceTo(_targetEntity.getTile());
		local toHit = skill - defense;

		if (this.m.IsRanged)
		{
			toHit = toHit + (distanceToTarget - this.m.MinRange) * properties.HitChanceAdditionalWithEachTile * properties.HitChanceWithEachTileMult;
		}

		if (levelDifference < 0)
		{
			toHit = toHit + this.Const.Combat.LevelDifferenceToHitBonus;
		}
		else
		{
			toHit = toHit + this.Const.Combat.LevelDifferenceToHitMalus * levelDifference;
		}

		if (!this.m.IsShieldRelevant)
		{
			local shield = _targetEntity.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);

			if (shield != null && shield.isItemType(this.Const.Items.ItemType.Shield))
			{
				local shieldBonus = (this.m.IsRanged ? shield.getRangedDefense() : shield.getMeleeDefense()) * (_targetEntity.getCurrentProperties().IsSpecializedInShields ? 1.25 : 1.0);
				toHit = toHit + shieldBonus;

				if (!this.m.IsShieldwallRelevant && _targetEntity.getSkills().hasSkill("effects.shieldwall"))
				{
					toHit = toHit + shieldBonus;
				}
			}
		}

		toHit = toHit * properties.TotalAttackToHitMult;
		toHit = toHit + this.Math.max(0, 100 - toHit) * (1.0 - defenderProperties.TotalDefenseToHitMult);
		local userTile = user.getTile();

		if (allowDiversion && this.m.IsRanged && userTile.getDistanceTo(_targetEntity.getTile()) > 1)
		{
			local blockedTiles = this.Const.Tactical.Common.getBlockedTiles(userTile, _targetEntity.getTile(), user.getFaction(), true);

			if (blockedTiles.len() != 0)
			{
				local blockChance = this.Const.Combat.RangedAttackBlockedChance * properties.RangedAttackBlockedChanceMult;
				toHit = this.Math.floor(toHit * (1.0 - blockChance));
			}
		}

		return this.Math.max(5, this.Math.min(95, toHit));
	}

	function attackEntity( _user, _targetEntity, _allowDiversion = true )
	{
		if (_targetEntity != null && !_targetEntity.isAlive())
		{
			return false;
		}

		local properties = this.m.Container.buildPropertiesForUse(this, _targetEntity);
		local userTile = _user.getTile();
		local astray = false;

		if (_allowDiversion && this.m.IsRanged && userTile.getDistanceTo(_targetEntity.getTile()) > 1)
		{
			local blockedTiles = this.Const.Tactical.Common.getBlockedTiles(userTile, _targetEntity.getTile(), _user.getFaction());

			if (blockedTiles.len() != 0 && this.Math.rand(1, 100) <= this.Math.ceil(this.Const.Combat.RangedAttackBlockedChance * properties.RangedAttackBlockedChanceMult * 100))
			{
				_allowDiversion = false;
				astray = true;
				_targetEntity = blockedTiles[this.Math.rand(0, blockedTiles.len() - 1)].getEntity();
			}
		}

		if (!_targetEntity.isAttackable())
		{
			if (this.m.IsShowingProjectile && this.m.ProjectileType != 0)
			{
				local flip = !this.m.IsProjectileRotated && _targetEntity.getPos().X > _user.getPos().X;

				if (_user.getTile().getDistanceTo(_targetEntity.getTile()) >= this.Const.Combat.SpawnProjectileMinDist)
				{
					this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), _targetEntity.getTile(), 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
				}
			}

			return false;
		}

		local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(_user, this);
		local defense = _targetEntity.getDefense(_user, this, defenderProperties);
		local levelDifference = _targetEntity.getTile().Level - _user.getTile().Level;
		local distanceToTarget = _user.getTile().getDistanceTo(_targetEntity.getTile());
		local toHit = 0;
		local skill = this.m.IsRanged ? properties.RangedSkill * properties.RangedSkillMult : properties.MeleeSkill * properties.MeleeSkillMult;
		toHit = toHit + skill;
		toHit = toHit - defense;

		if (this.m.IsRanged)
		{
			toHit = toHit + (distanceToTarget - this.m.MinRange) * properties.HitChanceAdditionalWithEachTile * properties.HitChanceWithEachTileMult;
		}

		if (levelDifference < 0)
		{
			toHit = toHit + this.Const.Combat.LevelDifferenceToHitBonus;
		}
		else
		{
			toHit = toHit + this.Const.Combat.LevelDifferenceToHitMalus * levelDifference;
		}

		local shieldBonus = 0;
		local shield = _targetEntity.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);

		if (shield != null && shield.isItemType(this.Const.Items.ItemType.Shield))
		{
			shieldBonus = (this.m.IsRanged ? shield.getRangedDefense() : shield.getMeleeDefense()) * (_targetEntity.getCurrentProperties().IsSpecializedInShields ? 1.25 : 1.0);

			if (!this.m.IsShieldRelevant)
			{
				toHit = toHit + shieldBonus;
			}

			if (_targetEntity.getSkills().hasSkill("effects.shieldwall"))
			{
				if (!this.m.IsShieldwallRelevant)
				{
					toHit = toHit + shieldBonus;
				}

				shieldBonus = shieldBonus * 2;
			}
		}

		toHit = toHit * properties.TotalAttackToHitMult;
		toHit = toHit + this.Math.max(0, 100 - toHit) * (1.0 - defenderProperties.TotalDefenseToHitMult);

		if (this.m.IsRanged && !_allowDiversion && this.m.IsShowingProjectile)
		{
			toHit = toHit - 15;
			properties.DamageTotalMult *= 0.75;
		}

		if (defense > -100 && skill > -100)
		{
			toHit = this.Math.max(5, this.Math.min(95, toHit));
		}

		_targetEntity.onAttacked(_user);

		if (this.m.IsDoingAttackMove && !_user.isHiddenToPlayer() && !_targetEntity.isHiddenToPlayer())
		{
			this.Tactical.getShaker().cancel(_user);

			if (this.m.IsDoingForwardMove)
			{
				this.Tactical.getShaker().shake(_user, _targetEntity.getTile(), 5);
			}
			else
			{
				local otherDir = _targetEntity.getTile().getDirectionTo(_user.getTile());

				if (_user.getTile().hasNextTile(otherDir))
				{
					this.Tactical.getShaker().shake(_user, _user.getTile().getNextTile(otherDir), 6);
				}
			}
		}

		if (!_targetEntity.isAbleToDie() && _targetEntity.getHitpoints() == 1)
		{
			toHit = 0;
		}

		if (!this.isUsingHitchance())
		{
			toHit = 100;
		}

		local r = this.Math.rand(1, 100);

		if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == 0)
		{
			if (_user.isPlayerControlled())
			{
				r = this.Math.max(1, r - 5);
			}
			else if (_targetEntity.isPlayerControlled())
			{
				r = this.Math.min(100, r + 5);
			}
		}

		local isHit = r <= toHit;

		if (!_user.isHiddenToPlayer() && !_targetEntity.isHiddenToPlayer())
		{
			local rolled = r;
			this.Tactical.EventLog.log_newline();

			if (astray)
			{
				if (this.isUsingHitchance())
				{
					if (isHit)
					{
						this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " and the shot goes astray and hits " + this.Const.UI.getColorizedEntityName(_targetEntity) + " (Chance: " + this.Math.min(95, this.Math.max(5, toHit)) + ", Rolled: " + rolled + ")");
					}
					else
					{
						this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " and the shot goes astray and misses " + this.Const.UI.getColorizedEntityName(_targetEntity) + " (Chance: " + this.Math.min(95, this.Math.max(5, toHit)) + ", Rolled: " + rolled + ")");
					}
				}
				else
				{
					this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " and the shot goes astray and hits " + this.Const.UI.getColorizedEntityName(_targetEntity));
				}
			}
			else if (this.isUsingHitchance())
			{
				if (isHit)
				{
					this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " and hits " + this.Const.UI.getColorizedEntityName(_targetEntity) + " (Chance: " + this.Math.min(95, this.Math.max(5, toHit)) + ", Rolled: " + rolled + ")");
				}
				else
				{
					this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " and misses " + this.Const.UI.getColorizedEntityName(_targetEntity) + " (Chance: " + this.Math.min(95, this.Math.max(5, toHit)) + ", Rolled: " + rolled + ")");
				}
			}
			else
			{
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " and hits " + this.Const.UI.getColorizedEntityName(_targetEntity));
			}
		}

		if (isHit && this.Math.rand(1, 100) <= _targetEntity.getCurrentProperties().RerollDefenseChance)
		{
			r = this.Math.rand(1, 100);
			isHit = r <= toHit;
		}

		if (isHit)
		{
			this.getContainer().setBusy(true);
			local info = {
				Skill = this,
				Container = this.getContainer(),
				User = _user,
				TargetEntity = _targetEntity,
				Properties = properties,
				DistanceToTarget = distanceToTarget
			};

			if (this.m.IsShowingProjectile && this.m.ProjectileType != 0 && _user.getTile().getDistanceTo(_targetEntity.getTile()) >= this.Const.Combat.SpawnProjectileMinDist && (!_user.isHiddenToPlayer() || !_targetEntity.isHiddenToPlayer()))
			{
				local flip = !this.m.IsProjectileRotated && _targetEntity.getPos().X > _user.getPos().X;
				local time = this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), _targetEntity.getTile(), 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
				this.Time.scheduleEvent(this.TimeUnit.Virtual, time, this.onScheduledTargetHit, info);

				if (this.m.SoundOnHit.len() != 0)
				{
					this.Time.scheduleEvent(this.TimeUnit.Virtual, time + this.m.SoundOnHitDelay, this.onPlayHitSound.bindenv(this), {
						Sound = this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)],
						Pos = _targetEntity.getPos()
					});
				}
			}
			else
			{
				if (this.m.SoundOnHit.len() != 0)
				{
					this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill * this.m.SoundVolume, _targetEntity.getPos());
				}

				if (this.Tactical.State.getStrategicProperties() != null && this.Tactical.State.getStrategicProperties().IsArenaMode && toHit <= 15)
				{
					this.Sound.play(this.Const.Sound.ArenaShock[this.Math.rand(0, this.Const.Sound.ArenaShock.len() - 1)], this.Const.Sound.Volume.Tactical * this.Const.Sound.Volume.Arena);
				}

				this.onScheduledTargetHit(info);
			}

			return true;
		}
		else
		{
			local distanceToTarget = _user.getTile().getDistanceTo(_targetEntity.getTile());
			_targetEntity.onMissed(_user, this, this.m.IsShieldRelevant && shield != null && r <= toHit + shieldBonus * 2);
			this.m.Container.onTargetMissed(this, _targetEntity);
			local prohibitDiversion = false;

			if (_allowDiversion && this.m.IsRanged && !_user.isPlayerControlled() && this.Math.rand(1, 100) <= 25 && distanceToTarget > 2)
			{
				local targetTile = _targetEntity.getTile();

				for( local i = 0; i < this.Const.Direction.COUNT; i = ++i )
				{
					if (!targetTile.hasNextTile(i))
					{
					}
					else
					{
						local tile = targetTile.getNextTile(i);

						if (tile.IsEmpty)
						{
						}
						else if (tile.IsOccupiedByActor && tile.getEntity().isAlliedWith(_user))
						{
							prohibitDiversion = true;
							break;
						}
					}
				}
			}

			if (_allowDiversion && this.m.IsRanged && !(this.m.IsShieldRelevant && shield != null && r <= toHit + shieldBonus * 2) && !prohibitDiversion && distanceToTarget > 2)
			{
				this.divertAttack(_user, _targetEntity);
			}
			else if (this.m.IsShieldRelevant && shield != null && r <= toHit + shieldBonus * 2)
			{
				local info = {
					Skill = this,
					User = _user,
					TargetEntity = _targetEntity,
					Shield = shield
				};

				if (this.m.IsShowingProjectile && this.m.ProjectileType != 0)
				{
					local divertTile = _targetEntity.getTile();
					local flip = !this.m.IsProjectileRotated && _targetEntity.getPos().X > _user.getPos().X;
					local time = 0;

					if (_user.getTile().getDistanceTo(divertTile) >= this.Const.Combat.SpawnProjectileMinDist)
					{
						time = this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), divertTile, 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
					}

					this.Time.scheduleEvent(this.TimeUnit.Virtual, time, this.onShieldHit, info);
				}
				else
				{
					this.onShieldHit(info);
				}
			}
			else
			{
				if (this.m.SoundOnMiss.len() != 0)
				{
					this.Sound.play(this.m.SoundOnMiss[this.Math.rand(0, this.m.SoundOnMiss.len() - 1)], this.Const.Sound.Volume.Skill * this.m.SoundVolume, _targetEntity.getPos());
				}

				if (this.m.IsShowingProjectile && this.m.ProjectileType != 0)
				{
					local divertTile = _targetEntity.getTile();
					local flip = !this.m.IsProjectileRotated && _targetEntity.getPos().X > _user.getPos().X;

					if (_user.getTile().getDistanceTo(divertTile) >= this.Const.Combat.SpawnProjectileMinDist)
					{
						this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), divertTile, 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
					}
				}

				if (this.Tactical.State.getStrategicProperties() != null && this.Tactical.State.getStrategicProperties().IsArenaMode)
				{
					if (toHit >= 90 || _targetEntity.getHitpointsPct() <= 0.1)
					{
						this.Sound.play(this.Const.Sound.ArenaMiss[this.Math.rand(0, this.Const.Sound.ArenaBigMiss.len() - 1)], this.Const.Sound.Volume.Tactical * this.Const.Sound.Volume.Arena);
					}
					else if (this.Math.rand(1, 100) <= 20)
					{
						this.Sound.play(this.Const.Sound.ArenaMiss[this.Math.rand(0, this.Const.Sound.ArenaMiss.len() - 1)], this.Const.Sound.Volume.Tactical * this.Const.Sound.Volume.Arena);
					}
				}
			}

			return false;
		}
	}

	function onShieldHit( _info )
	{
		local shield = _info.Shield;
		local user = _info.User;
		local targetEntity = _info.TargetEntity;

		if (_info.Skill.m.SoundOnHitShield.len() != 0)
		{
			this.Sound.play(_info.Skill.m.SoundOnHitShield[this.Math.rand(0, _info.Skill.m.SoundOnHitShield.len() - 1)], this.Const.Sound.Volume.Skill * this.m.SoundVolume, user.getPos());
		}

		shield.applyShieldDamage(this.Const.Combat.BasicShieldDamage, _info.Skill.m.SoundOnHitShield.len() == 0);

		if (shield.getCondition() == 0)
		{
			if (!user.isHiddenToPlayer())
			{
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(user) + " has destroyed " + this.Const.UI.getColorizedEntityName(targetEntity) + "\'s shield");
			}
		}
		else
		{
			if (!user.isHiddenToPlayer())
			{
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(user) + " has hit " + this.Const.UI.getColorizedEntityName(targetEntity) + "\'s shield for 1 damage");
			}

			if (!this.Tactical.getNavigator().isTravelling(targetEntity))
			{
				this.Tactical.getShaker().shake(targetEntity, user.getTile(), 2, this.Const.Combat.ShakeEffectSplitShieldColor, this.Const.Combat.ShakeEffectSplitShieldHighlight, this.Const.Combat.ShakeEffectSplitShieldFactor, 1.0, [
					"shield_icon"
				], 1.0);
			}
		}

		_info.TargetEntity.getItems().onShieldHit(_info.User, this);
	}

	function onPlayHitSound( _data )
	{
		this.Sound.play(_data.Sound, this.Const.Sound.Volume.Skill, _data.Pos);
	}

	function divertAttack( _user, _targetEntity )
	{
		local tile = _targetEntity.getTile();
		local dist = _user.getTile().getDistanceTo(tile);

		if (dist < this.Const.Combat.DiversionMinDist)
		{
			return;
		}

		local d = _user.getTile().getDirectionTo(tile);

		if (dist >= this.Const.Combat.DiversionSpreadMinDist)
		{
			d = this.Math.rand(0, this.Const.Direction.COUNT - 1);
		}

		if (tile.hasNextTile(d))
		{
			local divertTile = tile.getNextTile(d);
			local levelDifference = divertTile.Level - _targetEntity.getTile().Level;

			if (divertTile.IsOccupiedByActor && levelDifference <= this.Const.Combat.DiversionMaxLevelDifference)
			{
				this.attackEntity(_user, divertTile.getEntity(), false);
			}
			else
			{
				local flip = !this.m.IsProjectileRotated && _targetEntity.getPos().X > _user.getPos().X;
				local time = 0;

				if (this.m.IsShowingProjectile && this.m.ProjectileType != 0 && _user.getTile().getDistanceTo(tile) >= this.Const.Combat.SpawnProjectileMinDist)
				{
					time = this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), divertTile, 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
				}

				this.getContainer().setBusy(true);

				if (this.m.SoundOnMiss.len() != 0)
				{
					this.Sound.play(this.m.SoundOnMiss[this.Math.rand(0, this.m.SoundOnMiss.len() - 1)], this.Const.Sound.Volume.Skill * this.m.SoundVolume, divertTile.Pos);
				}

				if (divertTile.IsEmpty && !divertTile.IsCorpseSpawned && this.Const.Tactical.TerrainSubtypeAllowProjectileDecals[divertTile.Subtype] && this.Const.ProjectileDecals[this.m.ProjectileType].len() != 0 && this.Math.rand(0, 100) < this.Const.Combat.SpawnArrowDecalChance)
				{
					local info = {
						Skill = this,
						Container = this.getContainer(),
						User = _user,
						TileHit = divertTile
					};

					if (this.m.IsShowingProjectile && _user.getTile().getDistanceTo(divertTile) >= this.Const.Combat.SpawnProjectileMinDist && (!_user.isHiddenToPlayer() || divertTile.IsVisibleForPlayer))
					{
						this.Time.scheduleEvent(this.TimeUnit.Virtual, time, this.onScheduledProjectileSpawned, info);
					}
					else
					{
						this.onScheduledProjectileSpawned(info);
					}
				}
			}
		}
	}

	function onScheduledTargetHit( _info )
	{
		_info.Container.setBusy(false);

		if (!_info.TargetEntity.isAlive())
		{
			return;
		}

		local partHit = this.Math.rand(1, 100);
		local bodyPart = this.Const.BodyPart.Body;
		local bodyPartDamageMult = 1.0;

		if (partHit <= _info.Properties.getHitchance(this.Const.BodyPart.Head))
		{
			bodyPart = this.Const.BodyPart.Head;
		}
		else
		{
			bodyPart = this.Const.BodyPart.Body;
		}

		bodyPartDamageMult = bodyPartDamageMult * _info.Properties.DamageAgainstMult[bodyPart];
		local damageMult = this.m.IsRanged ? _info.Properties.RangedDamageMult : _info.Properties.MeleeDamageMult;
		damageMult = damageMult * _info.Properties.DamageTotalMult;
		local damageRegular = this.Math.rand(_info.Properties.DamageRegularMin, _info.Properties.DamageRegularMax) * _info.Properties.DamageRegularMult;
		local damageArmor = this.Math.rand(_info.Properties.DamageRegularMin, _info.Properties.DamageRegularMax) * _info.Properties.DamageArmorMult;
		damageRegular = this.Math.max(0, damageRegular + _info.DistanceToTarget * _info.Properties.DamageAdditionalWithEachTile);
		damageArmor = this.Math.max(0, damageArmor + _info.DistanceToTarget * _info.Properties.DamageAdditionalWithEachTile);
		local damageDirect = this.Math.minf(1.0, _info.Properties.DamageDirectMult * (this.m.DirectDamageMult + _info.Properties.DamageDirectAdd));
		local injuries;

		if (this.m.InjuriesOnBody != null && bodyPart == this.Const.BodyPart.Body)
		{
			injuries = this.m.InjuriesOnBody;
		}
		else if (this.m.InjuriesOnHead != null && bodyPart == this.Const.BodyPart.Head)
		{
			injuries = this.m.InjuriesOnHead;
		}

		local hitInfo = clone this.Const.Tactical.HitInfo;
		hitInfo.DamageRegular = damageRegular * damageMult;
		hitInfo.DamageArmor = damageArmor * damageMult;
		hitInfo.DamageDirect = damageDirect;
		hitInfo.DamageFatigue = this.Const.Combat.FatigueReceivedPerHit * _info.Properties.FatigueDealtPerHitMult;
		hitInfo.DamageMinimum = _info.Properties.DamageMinimum;
		hitInfo.BodyPart = bodyPart;
		hitInfo.BodyDamageMult = bodyPartDamageMult;
		hitInfo.FatalityChanceMult = _info.Properties.FatalityChanceMult;
		hitInfo.Injuries = injuries;
		hitInfo.InjuryThresholdMult = _info.Properties.ThresholdToInflictInjuryMult;
		hitInfo.Tile = _info.TargetEntity.getTile();
		_info.Container.onBeforeTargetHit(_info.Skill, _info.TargetEntity, hitInfo);
		local pos = _info.TargetEntity.getPos();
		local hasArmorHitSound = _info.TargetEntity.getItems().getAppearance().ImpactSound[bodyPart].len() != 0;
		_info.TargetEntity.onDamageReceived(_info.User, _info.Skill, hitInfo);

		if (hitInfo.DamageInflictedHitpoints >= this.Const.Combat.PlayHitSoundMinDamage)
		{
			if (this.m.SoundOnHitHitpoints.len() != 0)
			{
				this.Sound.play(this.m.SoundOnHitHitpoints[this.Math.rand(0, this.m.SoundOnHitHitpoints.len() - 1)], this.Const.Sound.Volume.Skill * this.m.SoundVolume, pos);
			}
		}

		if (hitInfo.DamageInflictedHitpoints == 0 && hitInfo.DamageInflictedArmor >= this.Const.Combat.PlayHitSoundMinDamage)
		{
			if (this.m.SoundOnHitArmor.len() != 0)
			{
				this.Sound.play(this.m.SoundOnHitArmor[this.Math.rand(0, this.m.SoundOnHitArmor.len() - 1)], this.Const.Sound.Volume.Skill * this.m.SoundVolume, pos);
			}
		}

		if (typeof _info.User == "instance" && _info.User.isNull() || !_info.User.isAlive() || _info.User.isDying())
		{
			return;
		}

		_info.Container.onTargetHit(_info.Skill, _info.TargetEntity, hitInfo.BodyPart, hitInfo.DamageInflictedHitpoints, hitInfo.DamageInflictedArmor);
		_info.User.getItems().onDamageDealt(_info.TargetEntity, this, hitInfo);

		if (hitInfo.DamageInflictedHitpoints >= this.Const.Combat.SpawnBloodMinDamage && !_info.Skill.isRanged() && (_info.TargetEntity.getBloodType() == this.Const.BloodType.Red || _info.TargetEntity.getBloodType() == this.Const.BloodType.Dark))
		{
			_info.User.addBloodied();
			local item = _info.User.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

			if (item != null && item.isItemType(this.Const.Items.ItemType.MeleeWeapon))
			{
				item.setBloodied(true);
			}
		}
	}

	function onScheduledProjectileSpawned( _info )
	{
		_info.Container.setBusy(false);
		local dir = _info.User.getTile().getDirectionTo(_info.TileHit);
		local flip = dir <= this.Const.Direction.S ? false : true;

		for( local n = this.Const.Combat.SpawnArrowDecalAttempts; n != 0;  )
		{
			local decal = this.Const.ProjectileDecals[_info.Skill.getProjectileType()][this.Math.rand(0, this.Const.ProjectileDecals[_info.Skill.getProjectileType()].len() - 1)];

			if (!_info.TileHit.spawnDetail(decal, 0, flip))
			{
				n = --n;
				continue;
			}
			else
			{
				local quantityMult = 0.5;

				if (_info.TileHit.IsVisibleForPlayer && this.Const.Tactical.TerrainDropdownParticles[_info.TileHit.Subtype].len() != 0)
				{
					for( local i = 0; i < this.Const.Tactical.TerrainDropdownParticles[_info.TileHit.Subtype].len(); i = ++i )
					{
						if (this.Tactical.getWeather().IsRaining && !this.Const.Tactical.TerrainDropdownParticles[_info.TileHit.Subtype][i].ApplyOnRain)
						{
						}
						else
						{
							this.Tactical.spawnParticleEffect(false, this.Const.Tactical.TerrainDropdownParticles[_info.TileHit.Subtype][i].Brushes, _info.TileHit, this.Const.Tactical.TerrainDropdownParticles[_info.TileHit.Subtype][i].Delay, this.Const.Tactical.TerrainDropdownParticles[_info.TileHit.Subtype][i].Quantity * quantityMult, this.Const.Tactical.TerrainDropdownParticles[_info.TileHit.Subtype][i].LifeTimeQuantity * quantityMult, this.Const.Tactical.TerrainDropdownParticles[_info.TileHit.Subtype][i].SpawnRate, this.Const.Tactical.TerrainDropdownParticles[_info.TileHit.Subtype][i].Stages);
						}
					}
				}
			}

			break;
		}
	}

	function onSerialize( _out )
	{
		_out.writeBool(this.m.IsNew);
	}

	function onDeserialize( _in )
	{
		if (_in.getMetaData().getVersion() >= 57)
		{
			this.m.IsNew = _in.readU8();
		}
		else
		{
			this.m.IsNew = false;
		}
	}

};


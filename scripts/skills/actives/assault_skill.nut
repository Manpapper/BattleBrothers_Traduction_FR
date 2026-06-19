this.assault_skill <- this.inherit("scripts/skills/skill", {
	m = {
		IsSecondAttack = false,
		StrikeOneSoundOnUse = [
			"sounds/combat/impale_01.wav",
			"sounds/combat/impale_02.wav",
			"sounds/combat/impale_03.wav"
		],
		StrikeOneSoundOnHit = [
			"sounds/combat/impale_hit_01.wav",
			"sounds/combat/impale_hit_02.wav",
			"sounds/combat/impale_hit_03.wav"
		],
		StrikeOneInjuriesBody = this.Const.Injury.PiercingBody,
		StrikeOneInjuriesHead = this.Const.Injury.PiercingHead,
		StrikeTwoSoundOnUse = [
			"sounds/combat/strike_01.wav",
			"sounds/combat/strike_02.wav",
			"sounds/combat/strike_03.wav"
		],
		StrikeTwoSoundOnHit = [
			"sounds/combat/strike_hit_01.wav",
			"sounds/combat/strike_hit_02.wav",
			"sounds/combat/strike_hit_03.wav"
		],
		StrikeTwoInjuriesBody = this.Const.Injury.CuttingBody,
		StrikeTwoInjuriesHead = this.Const.Injury.CuttingHead
	},
	function create()
	{
		this.m.ID = "actives.assault";
		this.m.Name = "Assaut";
		this.m.Description = "Une attaque en estoc difficile à parer. Elle est suivie d'un coup porté avec le fer de hache si la cible est déséquilibrée.";
		this.m.KilledString = "Aggressé";
		this.m.Icon = "skills/active_240.png";
		this.m.IconDisabled = "skills/active_240_sw.png";
		this.m.Overlay = "active_240";
		this.m.SoundOnUse = [
			"sounds/combat/impale_01.wav",
			"sounds/combat/impale_02.wav",
			"sounds/combat/impale_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/impale_hit_01.wav",
			"sounds/combat/impale_hit_02.wav",
			"sounds/combat/impale_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = false;
		this.m.IsTooCloseShown = false;
		this.m.IsWeaponSkill = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.DirectDamageMult = 0.4;
		this.m.HitChanceBonus = 0;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 25;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "A [color=" + this.Const.UI.Color.PositiveValue + "]+" + this.getHitChanceModifier() + "%[/color] de chance de toucher"
		});
		ret.push({
			id = 9,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Lance une attaque supplémentaire contre les cibles déséquilibrées"
		});
		return ret;
	}

	function getHitChanceModifier()
	{
		if (this.m.IsSecondAttack)
		{
			return 0;
		}

		return 10;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInPolearms ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
		this.m.ActionPointCost = _properties.IsSpecializedInPolearms ? 5 : 6;
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectImpale);
		local target = _targetTile.getEntity();
		this.setImpaleInfo();
		this.m.IsSecondAttack = false;
		local ret = this.attackEntity(_user, target);

		if (target.getSkills().hasSkill("effects.staggered"))
		{
			if (target.isAlive())
			{
				this.setStrikeInfo();
				this.m.IsSecondAttack = true;
			}

			if ((this.Tactical.TurnSequenceBar.getActiveEntity() == null || this.Tactical.TurnSequenceBar.getActiveEntity().getID() == _user.getID()) && (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer))
			{
				this.m.IsDoingAttackMove = false;
				this.getContainer().setBusy(true);
				this.Time.scheduleEvent(this.TimeUnit.Virtual, 275, function ( _skill )
				{
					if (target.isAlive() && _skill.getContainer() != null)
					{
						_skill.m.IsDoingAttackMove = true;
						_skill.getContainer().setBusy(false);
						_skill.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectChop);
						this.Sound.play(_skill.m.StrikeTwoSoundOnUse[this.Math.rand(0, _skill.m.StrikeTwoSoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill, _user.getPos());
						_skill.attackEntity(_user, target);
						_skill.setImpaleInfo();
						this.m.IsSecondAttack = false;
					}
				}.bindenv(this), this);
				return true;
			}
			else
			{
				if (target.isAlive() && this._skill.getContainer() != null)
				{
					ret = this.attackEntity(_user, target) || ret;
				}

				this.setImpaleInfo();
				this.m.IsSecondAttack = false;
				return ret;
			}
		}

		this.setImpaleInfo();
		return ret;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			if (this.m.IsSecondAttack)
			{
				_properties.DamageTotalMult *= 0.75;
				_properties.DamageArmorMult *= 1.2;
				_properties.DamageDirectAdd += 0.2;
			}
			else
			{
				_properties.MeleeSkill += 10;
				this.m.HitChanceBonus = 10;
			}
		}
	}

	function setImpaleInfo()
	{
		this.m.SoundOnHit = clone this.m.StrikeOneSoundOnHit;
		this.m.SoundOnUse = clone this.m.StrikeOneSoundOnUse;
		this.m.InjuriesOnBody = clone this.m.StrikeOneInjuriesBody;
		this.m.InjuriesOnHead = clone this.m.StrikeOneInjuriesHead;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 25;
		this.m.Name = "Empaler";
	}

	function setStrikeInfo()
	{
		this.m.SoundOnHit = clone this.m.StrikeTwoSoundOnHit;
		this.m.SoundOnUse = clone this.m.StrikeTwoSoundOnUse;
		this.m.InjuriesOnBody = clone this.m.StrikeTwoInjuriesBody;
		this.m.InjuriesOnHead = clone this.m.StrikeTwoInjuriesHead;
		this.m.ChanceDecapitate = 50;
		this.m.ChanceDisembowel = 33;
		this.m.Name = "Frappe";
	}

});


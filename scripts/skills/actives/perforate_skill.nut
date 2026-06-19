this.perforate_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.perforate";
		this.m.Name = "Perforer";
		this.m.Description = "Une série de deux coups d\'estoc ou plus, enchaînés rapidement, en fonction du nombre de blessures subies par l\'adversaire.";
		this.m.KilledString = "Transformé en pelote à épingles";
		this.m.Icon = "skills/active_237.png";
		this.m.IconDisabled = "skills/active_237_sw.png";
		this.m.Overlay = "active_237";
		this.m.SoundOnUse = [
			"sounds/combat/impale_01.wav",
			"sounds/combat/impale_02.wav",
			"sounds/combat/impale_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/dlc2/lunge_attack_hit_01.wav",
			"sounds/combat/dlc2/lunge_attack_hit_02.wav",
			"sounds/combat/dlc2/lunge_attack_hit_03.wav",
			"sounds/combat/dlc2/lunge_attack_hit_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsWeaponSkill = true;
		this.m.Delay = 250;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.HitChanceBonus = 0;
		this.m.DirectDamageMult = 0.45;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 33;
		this.m.ChanceSmash = 0;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Effectuera deux coups rapides"
			},
			{
				id = 9,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Effectue une attaque supplémentaire pour chaque blessure infligée à la cible"
			}
		]);
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		if (_properties.IsSpecializedInDaggers)
		{
			this.m.FatigueCostMult = this.Const.Combat.WeaponSpecFatigueMult;
			this.m.ActionPointCost = 5;
		}
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectStab);
		local target = _targetTile.getEntity();
		local injuryCount = target.getSkills().getAllSkillsOfType(this.Const.SkillType.TemporaryInjury).len();
		local ret = this.attackEntity(_user, target);
		local timeDelay = 200;

		if ((this.Tactical.TurnSequenceBar.getActiveEntity() == null || this.Tactical.TurnSequenceBar.getActiveEntity().getID() == _user.getID()) && (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer))
		{
			this.m.IsDoingAttackMove = false;
			this.getContainer().setBusy(true);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 150, this.onAdditionalAttack, {
				User = _user,
				Skill = this,
				Target = target,
				IsLast = injuryCount < 1
			});

			for( local i = 0; i < injuryCount; i = ++i )
			{
				this.Time.scheduleEvent(this.TimeUnit.Virtual, timeDelay + this.Math.rand(0, 55), this.onAdditionalAttack, {
					User = _user,
					Skill = this,
					Target = target,
					IsLast = i == injuryCount - 1
				});
				timeDelay = timeDelay + 150;
			}

			return true;
		}
		else
		{
			if (target.isAlive())
			{
				this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill, _user.getPos());
				ret = this.attackEntity(_user, target) || ret;
			}

			return ret;
		}
	}

	function onAdditionalAttack( _tag )
	{
		local user = _tag.User;
		local skill = _tag.Skill;
		local target = _tag.Target;
		local isLast = _tag.IsLast;

		if (target.isAlive() && skill.getContainer() != null)
		{
			skill.spawnAttackEffect(target.getTile(), this.Const.Tactical.AttackEffectStab);
			this.Sound.play(skill.m.SoundOnUse[this.Math.rand(0, skill.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill, user.getPos());
			skill.attackEntity(user, target);
		}

		if (isLast)
		{
			skill.m.IsDoingAttackMove = true;
			skill.getContainer().setBusy(false);
		}
	}

});


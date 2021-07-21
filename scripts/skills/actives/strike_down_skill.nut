this.strike_down_skill <- this.inherit("scripts/skills/skill", {
	m = {
		StunChance = 75
	},
	function create()
	{
		this.m.ID = "actives.strike_down";
		this.m.Name = "Frapper avec le Plat de la Lame";
		this.m.Description = "Donne un coup puissant qui a pour but d\'incapaciter et d\'étourdir la cible pour deux tours, mais ne fait pas le plus de dégâts. Les cibles étourdis ne peuvent pas garder en place leur Mur de Bouclier, Mur de Lance ou toute autre compétence similaire.";
		this.m.KilledString = "Cudgeled to death";
		this.m.Icon = "skills/active_134.png";
		this.m.IconDisabled = "skills/active_134_sw.png";
		this.m.Overlay = "active_134";
		this.m.SoundOnUse = [
			"sounds/combat/strike_down_01.wav",
			"sounds/combat/strike_down_02.wav",
			"sounds/combat/strike_down_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/strike_down_hit_01.wav",
			"sounds/combat/strike_down_hit_02.wav",
			"sounds/combat/strike_down_hit_03.wav",
			"sounds/combat/strike_down_hit_04.wav"
		];
		this.m.SoundVolume = 1.25;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.5;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 30;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 66;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Inflicts [color=" + this.Const.UI.Color.DamageValue + "]" + this.Const.Combat.FatigueReceivedPerHit * 4 + "[/color] extra fatigue"
		});

		if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInMaces)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "A [color=" + this.Const.UI.Color.PositiveValue + "]100%[/color] de chance d\'assommer sévèremment en touchant la cible"
			});
		}
		else
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "A [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.StunChance + "%[/color] de chance d\'assommer pendant deux tours en touchant la cible"
			});
		}

		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInMaces ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectBash);
		local success = this.attackEntity(_user, target);

		if (!_user.isAlive() || _user.isDying())
		{
			return success;
		}

		if (success && target.isAlive())
		{
			if ((_user.getCurrentProperties().IsSpecializedInMaces || this.Math.rand(1, 100) <= this.m.StunChance) && !target.getCurrentProperties().IsImmuneToStun && !target.getSkills().hasSkill("effects.stunned"))
			{
				local stun = this.new("scripts/skills/effects/stunned_effect");
				target.getSkills().add(stun);
				stun.setTurns(2);

				if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " a étourdi " + this.Const.UI.getColorizedEntityName(_targetTile.getEntity()) + " pour deux tours");
				}
			}
		}

		return success;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.FatigueDealtPerHitMult += 4.0;
			_properties.DamageTotalMult *= 0.5;
		}
	}

});


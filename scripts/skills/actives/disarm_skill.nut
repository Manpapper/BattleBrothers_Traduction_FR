this.disarm_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.disarm";
		this.m.Name = "Désarme";
		this.m.Description = "Utilise le fouet d\'une certaine distance pour désarmer temporairement la cible touchée. Un adversaire désarmé ne peut utiliser des compétences d\'armes, mais il peut toujours utiliser ses autres compétences. Les cibles qui n\'ont pas d\'armes ne peuvent être désarmées.";
		this.m.Icon = "skills/active_170.png";
		this.m.IconDisabled = "skills/active_170_sw.png";
		this.m.Overlay = "active_170";
		this.m.SoundOnUse = [
			"sounds/combat/whip_01.wav",
			"sounds/combat/whip_02.wav",
			"sounds/combat/whip_03.wav"
		];
		this.m.SoundOnHit = [];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.DirectDamageMult = 0.0;
		this.m.HitChanceBonus = -20;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 30;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "A une istance d\'attaque de [color=" + this.Const.UI.Color.PositiveValue + "]3" + "[/color] tuiles"
		});

		if (this.m.HitChanceBonus != 0)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "A [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.HitChanceBonus + "%[/color] de chance de toucher"
			});
		}

		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "A [color=" + this.Const.UI.Color.PositiveValue + "]100%[/color] de chance de désarmer la cible quand elle est touchée"
		});
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInCleavers ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;

		if (this.getContainer().getActor().getCurrentProperties().IsSpecializedInCleavers)
		{
			this.m.HitChanceBonus = -10;
		}
		else
		{
			this.m.HitChanceBonus = -20;
		}
	}

	function onUse( _user, _targetTile )
	{
		local success = this.attackEntity(_user, _targetTile.getEntity());

		if (success)
		{
			local target = _targetTile.getEntity();

			if (!target.getCurrentProperties().IsStunned && !target.getCurrentProperties().IsImmuneToDisarm)
			{
				target.getSkills().add(this.new("scripts/skills/effects/disarmed_effect"));

				if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " has disarmed " + this.Const.UI.getColorizedEntityName(target) + " for one turn");
				}
			}
		}

		return success;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			if (!this.getContainer().getActor().getCurrentProperties().IsSpecializedInCleavers)
			{
				_properties.MeleeSkill -= 20;
			}
			else
			{
				_properties.MeleeSkill -= 10;
			}

			_properties.DamageTotalMult = 0.0;
			_properties.HitChanceMult[this.Const.BodyPart.Head] = 0.0;
		}
	}

});


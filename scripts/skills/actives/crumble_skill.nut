this.crumble_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.crumble";
		this.m.Name = "Effondrement";
		this.m.Description = "Un puissant coup qui cause la formation ennemie à s\'effondrer. Cette compétence peut atteindre une distance de 2 tuiles et peut être utilisée derrière la ligne de front, ce qui est plus que la plupart des armes de mêlée.";
		this.m.KilledString = "Ecrasé";
		this.m.Icon = "skills/active_205.png";
		this.m.IconDisabled = "skills/active_205_sw.png";
		this.m.Overlay = "active_205";
		this.m.SoundOnUse = [
			"sounds/combat/dlc6/crumble_01.wav",
			"sounds/combat/dlc6/crumble_02.wav",
			"sounds/combat/dlc6/crumble_03.wav",
			"sounds/combat/dlc6/crumble_04.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/dlc6/crumble_hit_01.wav",
			"sounds/combat/dlc6/crumble_hit_02.wav",
			"sounds/combat/dlc6/crumble_hit_03.wav",
			"sounds/combat/dlc6/crumble_hit_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = false;
		this.m.IsTooCloseShown = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.4;
		this.m.HitChanceBonus = 0;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 50;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "A une distance d\'attaque de [color=" + this.Const.UI.Color.PositiveValue + "]2" + "[/color] tuiles"
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Inflige [color=" + this.Const.UI.Color.DamageValue + "]" + this.Const.Combat.FatigueReceivedPerHit * 2 + "[/color] de fatigue"
		});

		if (!this.getContainer().getActor().getCurrentProperties().IsSpecializedInMaces)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "A [color=" + this.Const.UI.Color.NegativeValue + "]-15%[/color] de chance de toucher les cibles adjacentes car l\'arme est peu maniable"
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
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectBash);
		return this.attackEntity(_user, _targetTile.getEntity());
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.FatigueDealtPerHitMult += 2.0;

			if (_targetEntity != null && !this.getContainer().getActor().getCurrentProperties().IsSpecializedInMaces && this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile()) == 1)
			{
				_properties.MeleeSkill += -15;
				this.m.HitChanceBonus = -15;
			}
			else
			{
				this.m.HitChanceBonus = 0;
			}
		}
	}

});


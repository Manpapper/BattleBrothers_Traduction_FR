this.skewer_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.skewer";
		this.m.Name = "Embrocher";
		this.m.Description = "Une attaque précise et puissante qui tire parti de l'élan et du poids de l'attaquant pour transpercer l'armure.";
		this.m.KilledString = "Embroché";
		this.m.Icon = "skills/active_238.png";
		this.m.IconDisabled = "skills/active_238_sw.png";
		this.m.Overlay = "active_238";
		this.m.SoundOnUse = [
			"sounds/combat/puncture_01.wav",
			"sounds/combat/puncture_02.wav",
			"sounds/combat/puncture_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/puncture_hit_01.wav",
			"sounds/combat/puncture_hit_02.wav",
			"sounds/combat/puncture_hit_03.wav"
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
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Ne tient pas compte de l\'armure supplémentaire, plus l\'Initiative actuelle de l\'attaquant est élevée,"
			}
		]);
		return ret;
	}

	function isUsable()
	{
		return this.skill.isUsable();
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
		return this.attackEntity(_user, _targetTile.getEntity());
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local a = this.getContainer().getActor();
			local s = this.Math.minf(0.55, 0.55 * (this.Math.max(0, a.getInitiative() + (_targetEntity != null ? this.getFatigueCost() * a.getCurrentProperties().FatigueToInitiativeRate : 0)) / 175.0));
			_properties.DamageDirectAdd += s;
			_properties.DamageRegularMin += 20;
			_properties.DamageRegularMax += 20;
		}
	}

});


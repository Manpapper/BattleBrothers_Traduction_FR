this.hammer <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.hammer";
		this.m.Name = "Ecraser";
		this.m.Description = "Un coup dont les effets peuvent être ressentis même au travers des armures les plus robustes et y laisseront une marque.";
		this.m.KilledString = "Martelé à mort";
		this.m.Icon = "skills/active_35.png";
		this.m.IconDisabled = "skills/active_35_sw.png";
		this.m.Overlay = "active_35";
		this.m.SoundOnUse = [
			"sounds/combat/hammer_strike_01.wav",
			"sounds/combat/hammer_strike_02.wav",
			"sounds/combat/hammer_strike_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/hammer_strike_hit_01.wav",
			"sounds/combat/hammer_strike_hit_02.wav",
			"sounds/combat/hammer_strike_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.5;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 14;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
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
			icon = "ui/icons/special.png",
			text = "Inflige toujours au moins [color=" + this.Const.UI.Color.DamageValue + "]" + 10 + "[/color] de dégâts aux points de vie, sans prendre en compte l\'armure"
		});
		return ret;
	}

	function getExpectedDamage( _target )
	{
		local ret = this.skill.getExpectedDamage(_target);
		ret.HitpointDamage = this.Math.max(10, ret.HitpointDamage);
		ret.TotalDamage = this.Math.max(10, ret.TotalDamage);
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInHammers ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectBash);
		local target = _targetTile.getEntity();
		return this.attackEntity(_user, target);
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageMinimum = this.Math.max(_properties.DamageMinimum, 10);
		}
	}

});


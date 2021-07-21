this.deathblow_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.deathblow";
		this.m.Name = "Coup Mortel";
		this.m.Description = "Donne un coup mortel sur une cible affaibli pour la terminer.";
		this.m.KilledString = "Poignardé";
		this.m.Icon = "skills/active_199.png";
		this.m.IconDisabled = "skills/active_199_sw.png";
		this.m.Overlay = "active_199";
		this.m.SoundOnUse = [
			"sounds/combat/dlc6/deathblow_01.wav",
			"sounds/combat/dlc6/deathblow_02.wav",
			"sounds/combat/dlc6/deathblow_03.wav",
			"sounds/combat/dlc6/deathblow_04.wav"
		];
		this.m.SoundOnHitHitpoints = [
			"sounds/combat/dlc6/deathblow_hit_01.wav",
			"sounds/combat/dlc6/deathblow_hit_02.wav",
			"sounds/combat/dlc6/deathblow_hit_03.wav",
			"sounds/combat/dlc6/deathblow_hit_04.wav"
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
		this.m.DirectDamageMult = 0.2;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Inflige [color=" + this.Const.UI.Color.DamageValue + "]33%[/color] plus de dégâts et ignore [color=" + this.Const.UI.Color.DamageValue + "]20%[/color] d\'armure pour les cibles qui sont Affaibli, Etourdi ou Piégé dans un filet"
		});
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		if (_properties.IsSpecializedInDaggers)
		{
			this.m.FatigueCostMult = this.Const.Combat.WeaponSpecFatigueMult;
			this.m.ActionPointCost = 3;
		}
	}

	function onUse( _user, _targetTile )
	{
		return this.attackEntity(_user, _targetTile.getEntity());
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_targetEntity == null)
		{
			return;
		}

		local targetStatus = _targetEntity.getSkills();

		if (_skill == this && (targetStatus.hasSkill("effects.dazed") || targetStatus.hasSkill("effects.stunned") || targetStatus.hasSkill("effects.sleeping") || targetStatus.hasSkill("effects.net") || targetStatus.hasSkill("effects.web") || targetStatus.hasSkill("effects.rooted")))
		{
			_properties.DamageTotalMult *= 1.33;
			_properties.DamageDirectAdd += 0.2;
		}
	}

});


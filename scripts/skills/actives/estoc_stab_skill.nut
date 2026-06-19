this.estoc_stab_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.estoc_stab";
		this.m.Name = "Poignarder";
		this.m.Description = "Un coup de couteau rapide et sec.";
		this.m.KilledString = "Poignardé";
		this.m.Icon = "skills/active_236.png";
		this.m.IconDisabled = "skills/active_236_sw.png";
		this.m.Overlay = "active_236";
		this.m.SoundOnUse = [
			"sounds/combat/stab_01.wav",
			"sounds/combat/stab_02.wav",
			"sounds/combat/stab_03.wav"
		];
		this.m.SoundOnHitHitpoints = [
			"sounds/combat/stab_hit_01.wav",
			"sounds/combat/stab_hit_02.wav",
			"sounds/combat/stab_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.DirectDamageMult = 0.45;
		this.m.HitChanceBonus = 0;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 11;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
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
		return ret;
	}

	function getHitChanceModifier()
	{
		return 5;
	}

	function onAfterUpdate( _properties )
	{
		if (_properties.IsSpecializedInDaggers)
		{
			this.m.FatigueCostMult = this.Const.Combat.WeaponSpecFatigueMult;
			this.m.ActionPointCost = 4;
		}
	}

	function onUse( _user, _targetTile )
	{
		return this.attackEntity(_user, _targetTile.getEntity());
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.MeleeSkill += this.getHitChanceModifier();
			this.m.HitChanceBonus += this.getHitChanceModifier();
		}
	}

});


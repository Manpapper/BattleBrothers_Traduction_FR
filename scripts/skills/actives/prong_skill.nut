this.prong_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.prong";
		this.m.Description = "Attaque en thrust qui peut couvrir la distance de 2 tiles et peut être utilisée depuis l'arrière de la ligne de front, en dehors de la portée de la plupart des armes de mêlée.";
		this.m.KilledString = "Estocadé";
		this.m.KilledString = "Pronged";
		this.m.Icon = "skills/active_123.png";
		this.m.IconDisabled = "skills/active_123_sw.png";
		this.m.Overlay = "active_123";
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
		this.m.IsTooCloseShown = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.DirectDamageMult = 0.25;
		this.m.HitChanceBonus = 10;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "A une distance de tir de [color=" + this.Const.UI.Color.PositiveValue + "]2[/color] tiles"
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "A une chance de toucher de [color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color]"
		});

		if (!this.getContainer().getActor().getCurrentProperties().IsSpecializedInSpears)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "A une chance de toucher de [color=" + this.Const.UI.Color.NegativeValue + "]-15%[/color] sur les cibles directement adjacentes car l'arme est trop difficile à manier"
			});
		}

		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInSpears ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectImpale);
		return this.attackEntity(_user, _targetTile.getEntity());
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.MeleeSkill += 10;

			if (_targetEntity != null && !this.getContainer().getActor().getCurrentProperties().IsSpecializedInSpears && this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile()) == 1)
			{
				_properties.MeleeSkill += -15;
				this.m.HitChanceBonus = -5;
			}
			else
			{
				this.m.HitChanceBonus = 10;
			}
		}
	}

});


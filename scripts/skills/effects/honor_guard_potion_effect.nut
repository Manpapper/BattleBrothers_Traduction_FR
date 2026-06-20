this.honor_guard_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.honor_guard_potion";
		this.m.Name = "Suture sous-cutanée";
		this.m.Icon = "skills/status_effect_132.png";
		this.m.IconMini = "status_effect_132_mini";
		this.m.Overlay = "status_effect_132";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "La peau et les tissus sous-cutanés de ce personnage ont subi une mutation et se reconstituent rapidement d\'eux-mêmes. Ce phénomène est particulièrement marqué au niveau des petites plaies punctiformes, où la chair parvient à refermer la plaie de manière uniforme dans toutes les directions.";
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Ce personnage prend de [color=" + this.Const.UI.Color.PositiveValue + "]25%[/color] à [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] des Dégâts perçant, telles que celles provenant d’arcs ou de lances"
			},
			{
				id = 12,
				type = "hint",
				icon = "ui/tooltips/warning.png",
				text = "D\'autres mutations entraîneront une durée de maladie plus longue."
			}
		];
		return ret;
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_skill == null)
		{
			return;
		}

		if (_skill.getID() == "actives.aimed_shot" || _skill.getID() == "actives.quick_shot")
		{
			_properties.DamageReceivedRegularMult *= 0.5;
		}
		else if (_skill.getID() == "actives.shoot_bolt" || _skill.getID() == "actives.shoot_stake" || _skill.getID() == "actives.sling_stone" || _skill.getID() == "actives.fire_handgonne")
		{
			_properties.DamageReceivedRegularMult *= 0.5;
		}
		else if (_skill.getID() == "actives.throw_javelin" || _skill.getID() == "actives.ignite_firelance")
		{
			_properties.DamageReceivedRegularMult *= 0.5;
		}
		else if (_skill.getID() == "actives.puncture" || _skill.getID() == "actives.thrust" || _skill.getID() == "actives.stab" || _skill.getID() == "actives.deathblow" || _skill.getID() == "actives.impale" || _skill.getID() == "actives.rupture" || _skill.getID() == "actives.prong" || _skill.getID() == "actives.lunge" || _skill.getID() == "actives.throw_spear")
		{
			_properties.DamageReceivedRegularMult *= 0.75;
		}
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isHonorGuardPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isHonorGuardPotionAcquired", false);
	}

});


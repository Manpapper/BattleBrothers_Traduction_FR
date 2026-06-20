this.shellshocked_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 3
	},
	function create()
	{
		this.m.ID = "effects.shellshocked";
		this.m.Name = "Sous le Choc";
		this.m.Icon = "skills/status_effect_119.png";
		this.m.IconMini = "status_effect_119_mini";
		this.m.Overlay = "status_effect_119";
		this.m.SoundOnUse = [
			"sounds/combat/dlc6/shellshocked_01.wav",
			"sounds/combat/dlc6/shellshocked_02.wav",
			"sounds/combat/dlc6/shellshocked_03.wav"
		];
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Ce personnage est en état de choc après s\'être retrouvé à proximité d\'une explosion de mortier. Il a des bourdonnements dans les oreilles, sa vision est floue et il est légèrement désorienté. L\'effet s\'estompera progressivement au bout de [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] tour(s).";
	}

	function getTooltip()
	{
		return [
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
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + 5 * this.m.TurnsLeft + "%[/color] de Dégâts"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + 5 * this.m.TurnsLeft + "%[/color] d\'Initiative"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + 5 * this.m.TurnsLeft + "%[/color] de Détermination"
			},
			{
				id = 14,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + 5 * this.m.TurnsLeft + "%[/color] Compétence en Mêlée"
			},
			{
				id = 15,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + 5 * this.m.TurnsLeft + "%[/color] Compétence à Distance"
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + 5 * this.m.TurnsLeft + "%[/color] de Défense en Mêlée"
			},
			{
				id = 17,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + 5 * this.m.TurnsLeft + "%[/color] de Défense à Distance"
			}
		];
	}

	function onAdded()
	{
		if (this.getContainer().getActor().getCurrentProperties().IsResistantToAnyStatuses && this.Math.rand(1, 100) <= 50)
		{
			if (!this.getContainer().getActor().isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " résiste au choc grâce à sa physiologie hors du commun");
			}

			this.removeSelf();
		}
		else
		{
			this.m.TurnsLeft = this.Math.max(1, 3 + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);

			if (this.m.SoundOnUse.len() != 0)
			{
				this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 0.8, this.getContainer().getActor().getPos());
			}

			this.getContainer().getActor().checkMorale(-1, 0);
		}
	}

	function onRefresh()
	{
		this.m.TurnsLeft = this.Math.max(1, 3 + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);
		this.spawnIcon("status_effect_119", this.getContainer().getActor().getTile());

		if (this.m.SoundOnUse.len() != 0)
		{
			this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 0.8, this.getContainer().getActor().getPos());
		}
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		_properties.DamageTotalMult *= 1.0 - 0.05 * this.m.TurnsLeft;
		_properties.InitiativeMult *= 1.0 - 0.05 * this.m.TurnsLeft;
		_properties.BraveryMult *= 1.0 - 0.05 * this.m.TurnsLeft;
		_properties.MeleeSkillMult *= 1.0 - 0.05 * this.m.TurnsLeft;
		_properties.RangedSkillMult *= 1.0 - 0.05 * this.m.TurnsLeft;
		_properties.MeleeDefenseMult *= 1.0 - 0.05 * this.m.TurnsLeft;
		_properties.RangedDefenseMult *= 1.0 - 0.05 * this.m.TurnsLeft;
	}

	function onTurnStart()
	{
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

});


this.morale_check <- this.inherit("scripts/skills/skill", {
	function create()
	{
		this.m.ID = "special.morale.check";
		this.m.Name = "Morale Check";
		this.m.Icon = "skills/status_effect_02.png";
		this.m.IconMini = "status_effect_02_mini";
		this.m.Type = this.Const.SkillType.Special | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsHidden = true;
		this.m.IsSerialized = false;
	}

	function getTooltip()
	{
		switch(this.m.Container.getActor().getMoraleState())
		{
		case this.Const.MoraleState.Confident:
			local ret = [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = "Nous serons victorieux ! Ce personnage est convaincu que la victoire lui reviendra."
				},
				{
					id = 11,
					type = "text",
					icon = "ui/icons/melee_skill.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] de Maîtrise de Mêlée"
				},
				{
					id = 13,
					type = "text",
					icon = "ui/icons/ranged_skill.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] de Maîtrise à distance"
				},
				{
					id = 12,
					type = "text",
					icon = "ui/icons/melee_defense.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] de Défense de Mêlée"
				},
				{
					id = 14,
					type = "text",
					icon = "ui/icons/ranged_defense.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] de Défense à Distance"
				}
			];
			return ret;

		case this.Const.MoraleState.Wavering:
			local ret = [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = "Oh oh. Ce personnage est hésitant et ne sait pas si la bataille tournera à son avantage."
				},
				{
					id = 11,
					type = "text",
					icon = "ui/icons/bravery.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] de Détermination"
				},
				{
					id = 12,
					type = "text",
					icon = "ui/icons/melee_skill.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] de Maîtrise de Mêlée"
				},
				{
					id = 13,
					type = "text",
					icon = "ui/icons/ranged_skill.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] de Maîtrise à distance"
				},
				{
					id = 14,
					type = "text",
					icon = "ui/icons/melee_defense.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] de Défense de Mêlée"
				},
				{
					id = 15,
					type = "text",
					icon = "ui/icons/ranged_defense.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] de Défense à Distance"
				}
			];
			return ret;

		case this.Const.MoraleState.Breaking:
			local ret = [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = "On ne peut pas gagner ! Le moral de ce personnage est au plus bas et il est sur le point de fuir le champ de bataille."
				},
				{
					id = 11,
					type = "text",
					icon = "ui/icons/bravery.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20%[/color] de Détermination"
				},
				{
					id = 11,
					type = "text",
					icon = "ui/icons/melee_skill.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20%[/color] de Maîtrise de Mêlée"
				},
				{
					id = 13,
					type = "text",
					icon = "ui/icons/ranged_skill.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20%[/color] de Maîtrise à distance"
				},
				{
					id = 14,
					type = "text",
					icon = "ui/icons/melee_defense.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20%[/color] de Défense de Mêlée"
				},
				{
					id = 15,
					type = "text",
					icon = "ui/icons/ranged_defense.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20%[/color] de Défense à Distance"
				}
			];
			return ret;

		case this.Const.MoraleState.Fleeing:
			local ret = [
				{
					id = 1,
					type = "title",
					text = this.getName()
				},
				{
					id = 2,
					type = "description",
					text = "Fuyez pour vos vies ! Ce personnage a perdu la tête et fuit le champ de bataille en panique."
				},
				{
					id = 11,
					type = "text",
					icon = "ui/icons/bravery.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-30%[/color] de Détermination"
				},
				{
					id = 11,
					type = "text",
					icon = "ui/icons/melee_skill.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-30%[/color] de Maîtrise de Mêlée"
				},
				{
					id = 13,
					type = "text",
					icon = "ui/icons/ranged_skill.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-30%[/color] de Maîtrise à distance"
				},
				{
					id = 14,
					type = "text",
					icon = "ui/icons/melee_defense.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-30%[/color] de Défense de Mêlée"
				},
				{
					id = 15,
					type = "text",
					icon = "ui/icons/ranged_defense.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-30%[/color] de Défense à Distance"
				},
				{
					id = 16,
					type = "text",
					icon = "ui/icons/special.png",
					text = "Acts at the end of the round"
				}
			];
			return ret;
		}
	}

	function onUpdate( _properties )
	{
		this.m.IsHidden = this.m.Container.getActor().getMoraleState() == this.Const.MoraleState.Steady;
		this.m.Name = this.Const.MoraleStateName[this.m.Container.getActor().getMoraleState()];

		switch(this.m.Container.getActor().getMoraleState())
		{
		case this.Const.MoraleState.Confident:
			this.m.Icon = "skills/status_effect_14.png";
			this.m.IconMini = "status_effect_14_mini";
			_properties.MeleeSkillMult *= 1.1;
			_properties.RangedSkillMult *= 1.1;
			_properties.MeleeDefenseMult *= 1.1;
			_properties.RangedDefenseMult *= 1.1;
			break;

		case this.Const.MoraleState.Wavering:
			this.m.Icon = "skills/status_effect_02_c.png";
			this.m.IconMini = "status_effect_02_c_mini";
			_properties.BraveryMult *= 0.9;
			_properties.MeleeSkillMult *= 0.9;
			_properties.RangedSkillMult *= 0.9;
			_properties.MeleeDefenseMult *= 0.9;
			_properties.RangedDefenseMult *= 0.9;
			break;

		case this.Const.MoraleState.Breaking:
			this.m.Icon = "skills/status_effect_02_b.png";
			this.m.IconMini = "status_effect_02_b_mini";
			_properties.BraveryMult *= 0.8;
			_properties.MeleeSkillMult *= 0.8;
			_properties.RangedSkillMult *= 0.8;
			_properties.MeleeDefenseMult *= 0.8;
			_properties.RangedDefenseMult *= 0.8;
			break;

		case this.Const.MoraleState.Fleeing:
			this.m.Icon = "skills/status_effect_02_a.png";
			this.m.IconMini = "status_effect_02_a_mini";
			_properties.BraveryMult *= 0.7;
			_properties.MeleeSkillMult *= 0.7;
			_properties.RangedSkillMult *= 0.7;
			_properties.MeleeDefenseMult *= 0.7;
			_properties.RangedDefenseMult *= 0.7;
			_properties.InitiativeForTurnOrderAdditional -= 1000;
			break;
		}
	}

});


this.brute_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.brute";
		this.m.Name = "Brute";
		this.m.Icon = "ui/traits/trait_icon_01.png";
		this.m.Description = "Pas du genre à faire dans la finesse, ce personnage causera des dégâts supplémentaires en frappant la tête de l\'ennemi en mêlée contre un malus de précision.";
		this.m.Titles = [
			"le Taureau",
			"le Boeuf",
			"le Marteau"
		];
		this.m.Excluded = [
			"trait.tiny",
			"trait.fragile",
			"trait.insecure",
			"trait.hesitant"
		];
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
				id = 10,
				type = "text",
				icon = "ui/icons/chance_to_hit_head.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15%[/color] de dégâts à la tête"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] de Maîtrise de Mêlée"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.MeleeSkill += -5;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill.isAttack() && !_skill.isRanged())
		{
			_properties.DamageAgainstMult[this.Const.BodyPart.Head] += 0.15;
		}
	}

});


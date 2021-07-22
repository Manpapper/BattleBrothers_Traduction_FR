this.drunkard_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.drunkard";
		this.m.Name = "Ivrogne";
		this.m.Icon = "ui/traits/trait_icon_29.png";
		this.m.Description = "Il n\'y a jamais de questions quand ce personnage doit dépenser ses couronnes. Compter sur lui pour boire avant chaque bataille, en secret si nécessaire. ";
		this.m.Titles = [
			"le Bourré",
			"l\'Ivrogne"
		];
		this.m.Excluded = [
			"trait.teamplayer"
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
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] Damage"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] de Détermination"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] de Maîtrise de Melée"
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] de Maîtrise à Distance"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.DamageTotalMult *= 1.1;
		_properties.Bravery += 5;
		_properties.MeleeSkill += -5;
		_properties.RangedSkill += -10;
	}

});


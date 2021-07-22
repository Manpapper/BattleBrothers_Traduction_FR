this.survivor_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.survivor";
		this.m.Name = "Survivant";
		this.m.Icon = "ui/traits/trait_icon_43.png";
		this.m.Description = "Pourquoi tu ne restes pas mort? Ce personnage est un survivant et survivra ses alliés.";
		this.m.Titles = [
			"le Survivant",
			"le Chanceux",
			"le Saint"
		];
		this.m.Excluded = [
			"trait.bleeder",
			"trait.pessimist",
			"trait.deathwish",
			"trait.ailing"
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
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]90%[/color] de chance de survive le dernier coup n\'est par une fatalité"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.SurviveWithInjuryChanceMult *= 2.72;
	}

});


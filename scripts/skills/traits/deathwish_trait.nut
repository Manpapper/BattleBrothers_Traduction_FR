this.deathwish_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.deathwish";
		this.m.Name = "Désir de Mort";
		this.m.Icon = "ui/traits/trait_icon_13.png";
		this.m.Description = "Je ne suis pas encore mort! Ce personnage ne se soucie pas de recevoir des blessures et continuera de se battre.";
		this.m.Titles = [
			"le Fou",
			"l\'Etrange",
			"le Sans Peur"
		];
		this.m.Excluded = [
			"trait.weasel",
			"trait.hesitant",
			"trait.dastard",
			"trait.fainthearted",
			"trait.craven",
			"trait.survivor"
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
				icon = "ui/icons/morale.png",
				text = "Pas de test de morale en perdant des points de vie"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.IsAffectedByLosingHitpoints = false;
	}

});


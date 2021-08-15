this.loyal_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.loyal";
		this.m.Name = "Loyal";
		this.m.Icon = "ui/traits/trait_icon_39.png";
		this.m.Description = "Je suis avec toi ! Ce personnage est loyal jusqu\'à la fin et à moins de probabilité de partir quand vous arrivez à court de couronnes ou de provisions.";
		this.m.Titles = [
			"le Loyal",
			"le Suiveur",
			"le Chien"
		];
		this.m.Excluded = [
			"trait.disloyal",
			"trait.craven",
			"trait.fainthearted",
			"trait.dastard"
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
			}
		];
	}

});


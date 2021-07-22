this.gluttonous_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.gluttonous";
		this.m.Name = "Glouton";
		this.m.Icon = "ui/traits/trait_icon_07.png";
		this.m.Description = "Délicieux, prenons en un autre! Il serait mieux de prendre des provisions supplémentaires en voyageant avec ce personnage et prévoyez à ce qu\'il parte vite si vous n\'avez plus de provisions.";
		this.m.Titles = [
			"le Porc"
		];
		this.m.Excluded = [
			"trait.athletic",
			"trait.iron_lungs",
			"trait.spartan",
			"trait.fragile"
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

	function addTitle()
	{
		this.character_trait.addTitle();
	}

	function onUpdate( _properties )
	{
		_properties.DailyFood += 1.0;
	}

});


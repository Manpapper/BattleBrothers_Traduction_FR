this.ailing_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.ailing";
		this.m.Name = "Malade";
		this.m.Icon = "ui/traits/trait_icon_59.png";
		this.m.Description = "Ce personnage est toujours pale et malade, ce qui le rend particulièrement susceptible aux poisons.";
		this.m.Titles = [
			"le Pale",
			"le Malade",
			"le Souffrant"
		];
		this.m.Excluded = [
			"trait.tough",
			"trait.iron_jaw",
			"trait.survivor",
			"trait.strong",
			"trait.athletic",
			"trait.iron_lungs",
			"trait.lucky",
			"trait.clubfooted"
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
				icon = "ui/icons/special.png",
				text = "Le poison dure [color=" + this.Const.UI.Color.NegativeValue + "]1[/color] tour supplémentaire"
			}
		];
	}

});


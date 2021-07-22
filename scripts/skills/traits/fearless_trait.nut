this.fearless_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.fearless";
		this.m.Name = "Intrépide";
		this.m.Icon = "ui/traits/trait_icon_30.png";
		this.m.Description = "Il y a beaucoup de vos vieux amis qui vous attendent dans la vie après la mort. Ce personnage n\'a pas peur de la mort.";
		this.m.Titles = [
			"l\'Intrépide"
		];
		this.m.Excluded = [
			"trait.weasel",
			"trait.insecure",
			"trait.craven",
			"trait.hesitant",
			"trait.dastard",
			"trait.fainthearted",
			"trait.brave",
			"trait.superstitious",
			"trait.paranoid",
			"trait.fear_beasts",
			"trait.fear_undead",
			"trait.fear_greenskins"
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
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] de Détermination"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.Bravery += 10;
	}

});


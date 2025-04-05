this.iron_lungs_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.iron_lungs";
		this.m.Name = "Poumons en Fer";
		this.m.Icon = "ui/traits/trait_icon_33.png";
		this.m.Description = "Ce personnage sera rarement à bout de souffle, que ce soit en utilisant une arme lourde ou en courant d\'un côté à l\'autre du champ de bataille.";
		this.m.Titles = [];
		this.m.Excluded = [
			"trait.asthmatic",
			"trait.fat",
			"trait.gluttonous",
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
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+3[/color] de Fatigue Récupérée par tour"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.FatigueRecoveryRate += 3;
	}

});


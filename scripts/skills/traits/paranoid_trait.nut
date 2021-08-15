this.paranoid_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.paranoid";
		this.m.Name = "Paranoïaque";
		this.m.Icon = "ui/traits/trait_icon_55.png";
		this.m.Description = "Je le jure le buisson était en train de bouger ! Ce personnage est très prudent et est réticent à aller de l\'avant.";
		this.m.Titles = [
			"le Fou",
			"Le Paranoïaque"
		];
		this.m.Excluded = [
			"trait.optimist",
			"trait.fearless",
			"trait.brave",
			"trait.determined",
			"trait.cocky",
			"trait.bloodthirsty"
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
				icon = "ui/icons/melee_defense.png",
				text = "Has [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] de Défense en Mêlée"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "Has [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] de Défense à Distance"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "Has [color=" + this.Const.UI.Color.NegativeValue + "]-30[/color] d\'Initiative"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.MeleeDefense += 5;
		_properties.RangedDefense += 5;
		_properties.Initiative += -30;
	}

});


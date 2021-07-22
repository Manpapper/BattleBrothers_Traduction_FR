this.night_owl_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.night_owl";
		this.m.Name = "Vision de Nuit";
		this.m.Icon = "ui/traits/trait_icon_57.png";
		this.m.Description = "Certains personnages s\'adaptent plus facilement dans les zones avec des lumières faibles, ce personnage est d\'ailleurs particulièrement bon à cela.";
		this.m.Titles = [
			"le Hibou",
			"les Yeux d\'Aigle"
		];
		this.m.Excluded = [
			"trait.short_sighted",
			"trait.night_blind"
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
				icon = "ui/icons/vision.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+1[/color] de Vision durant la Nuit"
			}
		];
	}

	function onUpdate( _properties )
	{
		if (this.getContainer().hasSkill("special.night"))
		{
			_properties.Vision += 1;
		}
	}

});


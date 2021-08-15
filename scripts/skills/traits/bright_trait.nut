this.bright_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.bright";
		this.m.Name = "Illuminé";
		this.m.Icon = "ui/traits/trait_icon_11.png";
		this.m.Description = "Ce personnage a plus de facilité à comprendre de nouveaux concepts et à s\'adapter à la situation.";
		this.m.Titles = [
			"le Rapide",
			"le Renard",
			"l\'Illuminé",
			"le Sage"
		];
		this.m.Excluded = [
			"trait.dumb"
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] de Gain d\'Expérience"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.XPGainMult *= 1.1;
	}

});


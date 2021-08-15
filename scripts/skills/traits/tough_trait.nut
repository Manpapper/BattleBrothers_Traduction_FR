this.tough_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.tough";
		this.m.Name = "Résistant";
		this.m.Icon = "ui/traits/trait_icon_14.png";
		this.m.Description = "Ce personnage est un dur à cuire, ignorant la plupart des coups et des frappes.";
		this.m.Titles = [
			"the Rock",
			"le Boeuf",
			"le Taureau",
			"l\'Ours"
		];
		this.m.Excluded = [
			"trait.tiny",
			"trait.fragile",
			"trait.bleeder",
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
				id = 10,
				type = "text",
				icon = "ui/icons/health.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] de Points de Vie"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.Hitpoints += 10;
	}

});


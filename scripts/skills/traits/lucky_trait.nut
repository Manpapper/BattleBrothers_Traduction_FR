this.lucky_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.lucky";
		this.m.Name = "Chanceux";
		this.m.Icon = "ui/traits/trait_icon_54.png";
		this.m.Description = "Ce personnage a un talent naturel de se sortir de situation délicate à la dernière seconde.";
		this.m.Titles = [
			"le Chanceux",
			"le Saint"
		];
		this.m.Excluded = [
			"trait.pessimist",
			"trait.clumsy",
			"trait.ailing",
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
				text = "A [color=" + this.Const.UI.Color.PositiveValue + "]10%[/color] de chance que l\'attaquant ait besoin de deux jets d\'attaque réussis pour toucher"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.RerollDefenseChance += 10;
	}

});


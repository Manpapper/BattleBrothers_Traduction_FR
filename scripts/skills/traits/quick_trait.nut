this.quick_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.quick";
		this.m.Name = "Rapide";
		this.m.Icon = "ui/traits/trait_icon_18.png";
		this.m.Description = "J\'y suis déjà ! Ce personnage agit rapidement, souvent avant l\'ennemi.";
		this.m.Titles = [
			"le Rapide"
		];
		this.m.Excluded = [
			"trait.huge",
			"trait.hesitant",
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
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] d\'Initiative"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.Initiative += 10;
	}

});


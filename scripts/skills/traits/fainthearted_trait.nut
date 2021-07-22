this.fainthearted_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.fainthearted";
		this.m.Name = "Faible d\'Esprit";
		this.m.Icon = "ui/traits/trait_icon_41.png";
		this.m.Description = "Ce personnage à besoin régulièrement de mots réconfortants ou d\'une tape sur l\'épaule.";
		this.m.Titles = [
			"la poule Mouillée",
			"le Docile"
		];
		this.m.Excluded = [
			"trait.fearless",
			"trait.brave",
			"trait.determined",
			"trait.deathwish",
			"trait.craven",
			"trait.cocky",
			"trait.bloodthirsty",
			"trait.iron_jaw",
			"trait.hate_greenskins",
			"trait.hate_undead",
			"trait.hate_beasts"
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
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] de Détermination"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.Bravery += -5;
	}

});


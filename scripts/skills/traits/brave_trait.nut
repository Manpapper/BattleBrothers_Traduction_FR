this.brave_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.brave";
		this.m.Name = "Courageux";
		this.m.Icon = "ui/traits/trait_icon_37.png";
		this.m.Description = "Continue d\'avancer, ce personnage ira courageusement vers l\'inconnu.";
		this.m.Titles = [
			"le Brave",
			"le Héro"
		];
		this.m.Excluded = [
			"trait.weasel",
			"trait.insecure",
			"trait.craven",
			"trait.hesitant",
			"trait.dastard",
			"trait.fainthearted",
			"trait.fearless",
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] de Détermination"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.Bravery += 5;
	}

});


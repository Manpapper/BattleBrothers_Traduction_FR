this.cocky_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.cocky";
		this.m.Name = "Arrogant";
		this.m.Icon = "ui/traits/trait_icon_24.png";
		this.m.Description = "C\'etait trop facile! Ce personnage est un peu trop arrogant pour son bien. ";
		this.m.Titles = [
			"le Brave",
			"l\'Arrogant"
		];
		this.m.Excluded = [
			"trait.weasel",
			"trait.hesitant",
			"trait.pessimist",
			"trait.dastard",
			"trait.insecure",
			"trait.craven",
			"trait.fainthearted",
			"trait.paranoid",
			"trait.fear_beasts",
			"trait.fear_undead",
			"trait.fear_greenskins",
			"trait.teamplayer"
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
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] de Défense en Melée"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] de Défense à Distance"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.Bravery += 5;
		_properties.MeleeDefense += -5;
		_properties.RangedDefense += -5;
	}

});


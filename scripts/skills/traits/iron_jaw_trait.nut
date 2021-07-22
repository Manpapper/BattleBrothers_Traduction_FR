this.iron_jaw_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.iron_jaw";
		this.m.Name = "Mâchoire de Fer";
		this.m.Icon = "ui/traits/trait_icon_44.png";
		this.m.Description = "Ce personnage peut ignorer des coups qui paralyseraient un homme moyen.";
		this.m.Titles = [
			"Mâchoire de Fer",
			"the Rock",
			"l\'étalon"
		];
		this.m.Excluded = [
			"trait.fragile",
			"trait.fainthearted",
			"trait.bleeder",
			"trait.tiny",
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
				icon = "ui/icons/special.png",
				text = "Le seuil pour subir des blessures en étant touché est augmenté de [color=" + this.Const.UI.Color.PositiveValue + "]25%[/color]"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.ThresholdToReceiveInjuryMult *= 1.25;
	}

});


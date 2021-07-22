this.dumb_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.dumb";
		this.m.Name = "Idiot";
		this.m.Icon = "ui/traits/trait_icon_17.png";
		this.m.Description = "De quoi? Ce personnage n\'est pas le plus brillant, et de nouveaux concepts mettent très longtemps à rentrer.";
		this.m.Titles = [
			"l\'Attardé",
			"l\'Idiot",
			"l\'Etrange"
		];
		this.m.Excluded = [
			"trait.bright",
			"trait.aspiring",
			"trait.sophisticated",
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
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15%[/color] de gain d\'Experience"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.XPGainMult *= 0.85;
	}

});


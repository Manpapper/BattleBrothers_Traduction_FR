this.craven_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.craven";
		this.m.Name = "Lâche";
		this.m.Icon = "ui/traits/trait_icon_40.png";
		this.m.Description = "Fuyez pour vos vies ! Ce personnage est un lâche et fuira au moindre signe de défaite.";
		this.m.Titles = [
			"le Lâche",
			"le Traître",
			"l\'Invertébré"
		];
		this.m.Excluded = [
			"trait.fearless",
			"trait.brave",
			"trait.determined",
			"trait.fainthearted",
			"trait.deathwish",
			"trait.cocky",
			"trait.bloodthirsty",
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
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] de Détermination"
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Est toujours content d\'être placé en réserve"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.Bravery += -10;
		_properties.IsContentWithBeingInReserve = true;
	}

});


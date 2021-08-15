this.superstitious_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.superstitious";
		this.m.Name = "Superticieux";
		this.m.Icon = "ui/traits/trait_icon_26.png";
		this.m.Description = "C\'est maudit ! Ce personnage est extrêmement supersticieux et est donc plus vulnérable aux attaques qui visent sa Détermination.";
		this.m.Excluded = [
			"trait.fearless",
			"trait.brave"
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
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] de Détermination aux tests de moral contre la Peur, la Panique ou le Contrôle Mental"
			}
		];
	}

});


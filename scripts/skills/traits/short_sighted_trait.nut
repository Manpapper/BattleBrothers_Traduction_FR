this.short_sighted_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.short_sighted";
		this.m.Name = "Bigleux";
		this.m.Icon = "ui/traits/trait_icon_27.png";
		this.m.Description = "Est-ce que c\'est un orc ou un arbre là bas? Ce personnage est bigleux et ne voit pas très loin.";
		this.m.Excluded = [
			"trait.eagle_eyes",
			"trait.night_owl"
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
				icon = "ui/icons/vision.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-1[/color] de Vision"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.Vision -= 1;
	}

});


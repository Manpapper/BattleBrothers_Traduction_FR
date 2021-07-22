this.pessimist_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.pessimist";
		this.m.Name = "Pessimiste";
		this.m.Icon = "ui/traits/trait_icon_20.png";
		this.m.Description = "Le verre est a moitié vide.";
		this.m.Excluded = [
			"trait.optimist",
			"trait.irrational",
			"trait.cocky",
			"trait.determined",
			"trait.survivor"
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
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] de Détermination aux tests de morale négatifs"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "La bonne humeur se dissipe plus rapidement"
			}
		];
	}

});


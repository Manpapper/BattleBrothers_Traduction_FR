this.irrational_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.irrational";
		this.m.Name = "Irrationnel";
		this.m.Icon = "ui/traits/trait_icon_28.png";
		this.m.Description = "Le verre est à moitié vide maintenant mais il était à moitié plein un moment plus tôt.";
		this.m.Excluded = [
			"trait.pessimist",
			"trait.optimist",
			"trait.insecure"
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
				text = "A aléatoirement [color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] ou [color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] de Détermination à chaque vérification de moral"
			}
		];
	}

});


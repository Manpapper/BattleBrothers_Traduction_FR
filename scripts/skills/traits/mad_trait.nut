this.mad_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.mad";
		this.m.Name = "Fou";
		this.m.Icon = "ui/traits/trait_icon_76.png";
		this.m.Description = "Ce personnage a regarder dans les abysses, et les abysses l\'ont regardé, cela l\'a rendu fou. Il divague souvent de manière inintelligible, et son esprit tourmenté est devenu inacessible que ce soit ses alliés ou ses ennemis.";
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
				text = "A aléatoirement [color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] ou [color=" + this.Const.UI.Color.NegativeValue + "]-15[/color] de Détermination à chaque vérification de morale"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "Est immunisé contre la Peur et le Contrôle Mental"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack] *= 1000.0;
	}

});


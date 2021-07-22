this.cultist_zealot_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.cultist_zealot";
		this.m.Name = "Fanatique de Davkul";
		this.m.Icon = "ui/traits/trait_icon_65.png";
		this.m.Description = "Ce personnage est un fanatique de Davkul, qui croit que Davkul accepte les hommes dans la mort.";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] de Détermination"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/morale.png",
				text = "Pas de test de moral quand un allié est tué"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/morale.png",
				text = "Pas de test de moral en perdant des Points de Vie"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.Bravery += 10;
		_properties.IsAffectedByDyingAllies = false;
		_properties.IsAffectedByLosingHitpoints = false;
	}

});


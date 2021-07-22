this.cultist_fanatic_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.cultist_fanatic";
		this.m.Name = "Fanatique de Davkul";
		this.m.Icon = "ui/traits/trait_icon_64.png";
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] de Détermination"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/morale.png",
				text = "Pas de test de moral quand un allié est tué"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.Bravery += 5;
		_properties.IsAffectedByDyingAllies = false;
	}

});


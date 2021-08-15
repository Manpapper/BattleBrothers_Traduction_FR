this.sure_footing_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.sure_footing";
		this.m.Name = "Pied Sûr";
		this.m.Icon = "ui/traits/trait_icon_05.png";
		this.m.Description = "Un pas déterminé qui rend difficile de déséquilibrer ce personnage pour donner un coup.";
		this.m.Excluded = [
			"trait.clumsy",
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
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] de Défense en Mêlée"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.MeleeDefense += 5;
	}

});


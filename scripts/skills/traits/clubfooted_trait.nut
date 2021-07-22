this.clubfooted_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.clubfooted";
		this.m.Name = "Pied-Bot";
		this.m.Icon = "ui/traits/trait_icon_23.png";
		this.m.Description = "Affligé par un Pied-Bot depuis son enfance, ce personnage aura plus de problème à marcher que la normale.";
		this.m.Titles = [];
		this.m.Excluded = [
			"trait.weasel",
			"trait.athletic",
			"trait.quick",
			"trait.sure_footing",
			"trait.impatient",
			"trait.swift",
			"trait.lucky"
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
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]2[/color] de Fatigue additionnel pour chaque tuile parcourue"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.MovementFatigueCostAdditional += 2;
	}

});


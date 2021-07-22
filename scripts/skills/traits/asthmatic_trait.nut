this.asthmatic_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.asthmatic";
		this.m.Name = "Asthmatique";
		this.m.Icon = "ui/traits/trait_icon_22.png";
		this.m.Description = "A voir le souffle court et sujet à tousser, ce personnage prend plus de temps à récupérer que les autres.";
		this.m.Titles = [];
		this.m.Excluded = [
			"trait.athletic",
			"trait.iron_lungs"
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
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-3[/color] de Fatigue par tour"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.FatigueRecoveryRate += -3;
	}

});


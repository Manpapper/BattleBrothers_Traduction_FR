this.bleeder_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.bleeder";
		this.m.Name = "Hémophile";
		this.m.Icon = "ui/traits/trait_icon_16.png";
		this.m.Description = "Ce personnage a tendance à saigner pour un rien et saignera plus longtemps que les autres.";
		this.m.Excluded = [
			"trait.tough",
			"trait.iron_jaw",
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
				icon = "ui/icons/special.png",
				text = "Souffre de dégâts par saignement pendant [color=" + this.Const.UI.Color.NegativeValue + "]1[/color] tour supplémentaire"
			}
		];
	}

});


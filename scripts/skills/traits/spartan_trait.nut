this.spartan_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.spartan";
		this.m.Name = "Spartiate";
		this.m.Icon = "ui/traits/trait_icon_08.png";
		this.m.Description = "Qui a besoin d\'un repas chaud ou d\'eau ? Ce personnage n\'apprécie pas de manger et utilisera moins de provisions, et donc vous quittera moins rapidement si vous arrivez à court de provisions.";
		this.m.Excluded = [
			"trait.fat",
			"trait.gluttonous"
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
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.DailyFood -= 1.0;
	}

});


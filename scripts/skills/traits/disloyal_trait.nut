this.disloyal_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.disloyal";
		this.m.Name = "Déloyale";
		this.m.Icon = "ui/traits/trait_icon_35.png";
		this.m.Description = "Je dois être le premier! Ce personnage est déloyale et sera rapide à partir dès que vous arriverez à court de couronnes ou de provisions.";
		this.m.Titles = [
			"Le Menteur"
		];
		this.m.Excluded = [
			"trait.loyal",
			"trait.brave",
			"trait.fearless"
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
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Est toujours content d\'être placé en réserve"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.IsContentWithBeingInReserve = true;
	}

});


this.greedy_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.greedy";
		this.m.Name = "Avare";
		this.m.Icon = "ui/traits/trait_icon_06.png";
		this.m.Description = "J\'en veux plus! Ce personnage est avare et demandera un paiement journalier plus élevé que quelqu\'un avec une origine similaire, et poartira plus vite si vous arrivez à cours de couronnes.";
		this.m.Excluded = [];
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

	function addTitle()
	{
		this.character_trait.addTitle();
	}

	function onUpdate( _properties )
	{
		_properties.DailyWageMult *= 1.15;
	}

});


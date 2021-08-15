this.fear_undead_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.fear_undead";
		this.m.Name = "Peur des Morts-Vivants";
		this.m.Icon = "ui/traits/trait_icon_47.png";
		this.m.Description = "Un événement passé ou une histoire particulièrement convaincante dans la vie de ce personnage l\'a effrayé de ce que les Morts-Vivants étaient capable de faire, le rendant moins fiable lors de batailles contre eux.";
		this.m.Excluded = [
			"trait.fearless",
			"trait.brave",
			"trait.determined",
			"trait.cocky",
			"trait.bloodthirsty",
			"trait.hate_undead"
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
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] de Détermination quand vous êtes en bataille contre des Morts-Vivants"
			}
		];
	}

	function onUpdate( _properties )
	{
		if (!this.getContainer().getActor().isPlacedOnMap())
		{
			return;
		}

		if (this.Tactical.Entities.getInstancesNum(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getID()) != 0 || this.Tactical.Entities.getInstancesNum(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID()) != 0)
		{
			_properties.Bravery -= 10;
		}
	}

});


this.fear_beasts_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.fear_beasts";
		this.m.Name = "Peur des Bêtes";
		this.m.Icon = "ui/traits/trait_icon_48.png";
		this.m.Description = "Des évènements passés ou des histoires particulièrement convaiquantes dans la vie de ce personnage l'a laissé appeuré de ce que les monstrueuses bêtes sauvages étaient capable de faire, le rendant moins fiable lors de bataille contre eux.";
		this.m.Excluded = [
			"trait.fearless",
			"trait.brave",
			"trait.determined",
			"trait.cocky",
			"trait.bloodthirsty",
			"trait.hate_beasts"
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
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] de Détermination quand vous êtes en bataille contre des bêtes"
			}
		];
	}

	function onUpdate( _properties )
	{
		if (!this.getContainer().getActor().isPlacedOnMap())
		{
			return;
		}

		if (this.Tactical.Entities.getInstancesNum(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID()) != 0)
		{
			_properties.Bravery -= 10;
		}
	}

});


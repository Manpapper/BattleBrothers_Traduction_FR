this.impatient_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.impatient";
		this.m.Name = "Impatient";
		this.m.Icon = "ui/traits/trait_icon_46.png";
		this.m.Description = "Allons-y ! Qu\'est-ce qui prend si longtemps ? Ce personnage veut que les choses commencent le plus tôt possible.";
		this.m.Titles = [
			"le Rapide",
			"le Désireux",
			"l\'Anxieux"
		];
		this.m.Excluded = [
			"trait.hesitant",
			"trait.clubfooted",
			"trait.teamplayer"
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
				text = "Agit toujours en premier d\'un tour de combat"
			}
		];
	}

	function onUpdate( _properties )
	{
		if (this.getContainer().getActor().isPlacedOnMap() && this.Time.getRound() <= 1)
		{
			_properties.InitiativeForTurnOrderAdditional += 1000;
		}
	}

});


this.dastard_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.dastard";
		this.m.Name = "Scélérat";
		this.m.Icon = "ui/traits/trait_icon_38.png";
		this.m.Description = "Ce personnage partira la queue entre les jambes à la première occasion. Il faudrait mieux le garder à l\'oeil!";
		this.m.Titles = [
			"le Lâche",
			"le Scélérat",
			"la Poule Mouillée"
		];
		this.m.Excluded = [
			"trait.determined",
			"trait.brave",
			"trait.deathwish",
			"trait.bloodthirsty",
			"trait.fearless",
			"trait.cocky",
			"trait.optimist",
			"trait.hate_greenskins",
			"trait.hate_undead",
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
				icon = "ui/icons/morale.png",
				text = "Commence le combat avec un moral vaccilant"
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Est toujours content d'être placé en réserve"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.IsContentWithBeingInReserve = true;
	}

	function onCombatStarted()
	{
		local actor = this.getContainer().getActor();

		if (actor.getMoodState() >= this.Const.MoodState.Disgruntled && actor.getMoraleState() > this.Const.MoraleState.Wavering)
		{
			actor.setMoraleState(this.Const.MoraleState.Wavering);
		}
	}

});


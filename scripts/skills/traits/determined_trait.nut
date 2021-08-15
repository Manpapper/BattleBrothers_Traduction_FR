this.determined_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.determined";
		this.m.Name = "Déterminé";
		this.m.Icon = "ui/traits/trait_icon_31.png";
		this.m.Description = "Vous inquiétez pas, je gère. Ce personnage montre un niveau incroyable de confiance en soi.";
		this.m.Excluded = [
			"trait.weasel",
			"trait.dastard",
			"trait.insecure",
			"trait.fainthearted",
			"trait.craven",
			"trait.paranoid",
			"trait.fear_beasts",
			"trait.fear_undead",
			"trait.fear_greenskins"
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
				text = "Commencera le combat avec un moral confiant si son humeur lui permet"
			}
		];
	}

	function onCombatStarted()
	{
		local actor = this.getContainer().getActor();

		if (actor.getMoodState() >= this.Const.MoodState.Neutral && actor.getMoraleState() < this.Const.MoraleState.Confident)
		{
			actor.setMoraleState(this.Const.MoraleState.Confident);
		}
	}

});


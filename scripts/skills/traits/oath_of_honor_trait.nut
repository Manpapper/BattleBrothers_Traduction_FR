this.oath_of_honor_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.oath_of_honor";
		this.m.Name = "Serment d\'Honneur";
		this.m.Icon = "ui/traits/trait_icon_82.png";
		this.m.Description = "Ce personnage a prêté un serment d\'honneur, et a juré de saisir la victoire au corps à corps.";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
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
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/morale.png",
				text = "Commence le combat avec un moral Confiant si l\'humeur le permet."
			},
			{
				id = 11,
				type = "hint",
				icon = "ui/icons/warning.png",
				text = "Ne peut pas utiliser d\'attaques à distance ou d\'outils"
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


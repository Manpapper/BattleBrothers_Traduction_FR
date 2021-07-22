this.arena_fighter_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.arena_fighter";
		this.m.Name = "Combattant d\'Arène";
		this.m.Icon = "ui/traits/trait_icon_74.png";
		this.m.Description = "Entendre une foule scander votre nom peut être addictif. Ce personnage commence à apprécier les combats à mort de l\'arène et gère ses ennemis d\'une façon à divertir le public.";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
	}

	function getTooltip()
	{
		local matches = this.getContainer().getActor().getFlags().getAsInt("ArenaFights");
		local won = this.getContainer().getActor().getFlags().getAsInt("ArenaFightsWon");

		if (won == matches)
		{
			won = "all";
		}

		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription() + " Jusqu\'à maintenant, ce personnage a combattu dans " + matches + " matches et en a gagné " + won 
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] de Détermination"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.Bravery += 5;
	}

});


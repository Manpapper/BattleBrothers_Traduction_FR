this.arena_veteran_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.arena_veteran";
		this.m.Name = "Vétéran d\'Arène";
		this.m.Icon = "ui/traits/trait_icon_75.png";
		this.m.Description = "Un vétéran de l\'arène avec beaucoup de cicatrices, ce personnage sait comment agir pour faire rugir la foule dans un spectable ensanglanté. Plus les chances de gagner sont mauvaises, le meilleur est le spectacle!";
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] de Détermination"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Has a [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] de chance de survivre si abattu sauf s\'il s\'agit d\'une fatalité"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.Bravery += 10;
		_properties.SurviveWithInjuryChanceMult *= 1.51;
	}

});


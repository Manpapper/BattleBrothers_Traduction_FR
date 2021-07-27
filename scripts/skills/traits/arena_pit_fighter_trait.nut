this.arena_pit_fighter_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.pit_fighter";
		this.m.Name = "Combattant de fosse";
		this.m.Icon = "ui/traits/trait_icon_73.png";
		this.m.Description = "Ce personnage vient juste de mettre le pied dans la profession brutale que sont les combats d\'arène et a survécu pour en raconter les histoires.";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
	}

	function getTooltip()
	{
		local matches = this.getContainer().getActor().getFlags().getAsInt("ArenaFights");
		local won = this.getContainer().getActor().getFlags().getAsInt("ArenaFightsWon");
		local text;

		if (matches == 1)
		{
			text = " Jusqu\'à maintenant, ce personnage n\'a combattu que dans un seul match";

			if (won == 1)
			{
				text = text + " et l\'a gagné";
			}
			else
			{
				text = text + " mais l\'a perdu.";
			}
		}
		else
		{
			if (won == matches)
			{
				text = " Jusqu\'à maintenant, ce personnage a combattu dans " + matches + " matches et les a tous gagnés" ;
			}
			else
			{
				text = " Jusqu\'à maintenant, ce personnage a combattu dans " + matches + " matches et en a gagné " + won ;			
			}
			
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
				text = this.getDescription() + text
			}
		];
	}

});


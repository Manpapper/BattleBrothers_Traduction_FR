this.glorious_resolve_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.glorious";
		this.m.Name = "Détermination Glorieuse";
		this.m.Icon = "ui/traits/trait_icon_72.png";
		this.m.Description = "Forgé dans les arènes du Sud, ce personnage a combattu des hommes et des bêtes sans distinction, et il en faudra beaucoup pour briser sa détermination. Son niveau de vie fabuleux demande une grosse paie, mais il ne désertera jamais et ne peut être renvoyé. Si les trois membres du départ meurent la campagne se terminera.";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
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
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Rejoue une deuxième fois chaque test de moral échoué pour une seconde chance"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.RerollMoraleChance = 100;
	}

});


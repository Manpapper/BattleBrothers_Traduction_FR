this.public_executions_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.public_executions";
		this.m.Name = "Exécutions Publiques";
		this.m.Description = "Une exécution publique est à ne pas manquer et constitue un divertissement pour toute la famille. La nourriture et les boissons sont abondantes lors d\'une telle occasion, mais les marchands peuvent aussi essayer de profiter des spectateurs.";
		this.m.Icon = "ui/settlement_status/settlement_effect_14.png";
		this.m.Rumors = [
			"Une foule de gens se dirige vers %settlement% pour le grand spectacle ! Hommes, femmes, jeunes, tous en route pour assister aux prochaines exécutions !",
			"J\'ai entendu dire qu\'ils ont attrapé des brigands près de %settlement% et qu\'ils les mettent au pilori. Ça leur apprendra à assassiner les pauvres gens sur les routes...",
			"Nous, les pauvres, n\'avons pas beaucoup de choses à apprécier ces temps-ci, mais une bonne pendaison est toujours la bienvenue. Il n\'y en a pas eu ici depuis l\'automne, mais ils pendent des gens à %settlement%, c\'est ce que %randomname% m\'a dit."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 2;
	}

	function getAddedString( _s )
	{
		return _s + " a maintenant " + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return _s + " n\'a plus " + this.m.Name;
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.FoodRarityMult *= 1.35;
		_modifiers.FoodPriceMult *= 1.15;
	}

});


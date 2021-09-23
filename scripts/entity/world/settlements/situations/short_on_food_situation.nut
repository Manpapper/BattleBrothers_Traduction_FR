this.short_on_food_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.short_on_food";
		this.m.Name = "Manque de Nourriture";
		this.m.Description = "Les récents événements ont laissé cet endroit à court de nourriture. Alors que les gens sont au bord de la famine, la nourriture est difficile à trouver et les prix sont en hausse.";
		this.m.Icon = "ui/settlement_status/settlement_effect_04.png";
		this.m.Rumors = [
			"Les hommes et les femmes de %settlement% sont affamés, j\'ai entendu dire, avec rien d\'autre que de la terre à manger. Je ne pense pas que je me plaindrai encore de ma soupe aux céréales moisie !",
			"Un fermier est arrivé aujourd\'hui de %settlement%. Il a raconté des histoires de bétail tué, de champs brûlés et de garde-manger vides. Il ressemblait lui-même à un foutu squelette ambulant !"
		];
		this.m.IsStacking = false;
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
		_modifiers.FoodRarityMult *= 0.5;
		_modifiers.FoodPriceMult *= 3.0;
	}

});


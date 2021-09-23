this.bread_and_games_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.bread_and_games";
		this.m.Name = "Pain et Jeux";
		this.m.Description = "Le conseil municipal a ordonné une période de nourriture, de boisson et de jeux pour tout le monde afin de garder la population heureuse. La nourriture et la boisson sont faciles à trouver, les gladiateurs affluent dans la ville et les combats d\'arène rapportent plus que d\'habitude.";
		this.m.Icon = "ui/settlement_status/settlement_effect_39.png";
		this.m.Rumors = [
			"Louons le sage conseil de %settlement% ! Le temps de la nourriture, de la boisson et des jeux est à nos portes !",
			"Vous avez déjà assisté aux célèbres jeux du Sud ? Rendez-vous à %settlement% et voyez par vous-même la gloire des festivités !",
			"Tout ce dur labeur tout au long de l\'année et pour quoi ? Je vais vous le dire : De la nourriture, des boissons et des jeux ! Je vais me rendre à %settlement% pour participer, et vous devriez faire de même."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 3;
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
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.FoodRarityMult *= 1.5;
		_modifiers.FoodPriceMult *= 0.9;
	}

	function onUpdateDraftList( _draftList )
	{
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
	}

});


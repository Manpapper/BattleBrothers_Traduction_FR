this.razed_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.razed";
		this.m.Name = "Rasé";
		this.m.Description = "Cet endroit a été rasé. Beaucoup de ses habitants ont été tués, et tous les objets de valeur ont été pillés.";
		this.m.Icon = "ui/settlement_status/settlement_effect_10.png";
		this.m.Rumors = [
			"Les colonnes de fumée sont visibles à des kilomètres et des kilomètres à la ronde. Il n\'y a plus qu\'un tas de décombres en feu là où se trouvait %settlement%.",
			"Des flots de réfugiés sont arrivés de %settlement%. Ils prétendent que la plupart des bâtiments ont été brûlés ! Est-ce que c\'est vrai ?",
			"%settlement% n\'est plus, juste un squelette noir carbonisé fumant et se consumant... Comment en est-on arrivé là ?"
		];
		this.m.IsStacking = false;
	}

	function getAddedString( _s )
	{
		return _s + " est maintenant " + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return _s + " n\'est plus " + this.m.Name;
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
		_settlement.resetRoster(false);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.SellPriceMult *= 0.5;
		_modifiers.BuyPriceMult *= 2.0;
		_modifiers.FoodPriceMult *= 2.0;
		_modifiers.RecruitsMult *= 0.25;
		_modifiers.RarityMult *= 0.25;
	}

});


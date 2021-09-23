this.snow_storms_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.snow_storms";
		this.m.Name = "Tempêtes de Neige";
		this.m.Description = "Les tempêtes de neige ont plus ou moins isolé cette colonie du commerce. Comme peu de nouvelles marchandises sont arrivées, l\'offre est plus faible et les prix plus élevés.";
		this.m.Icon = "ui/settlement_status/settlement_effect_20.png";
		this.m.Rumors = [
			"Mauvais temps là-bas vers %settlement%, on dirait un véritable blizzard."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 3;
	}

	function getAddedString( _s )
	{
		return _s + " suffers from " + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return _s + " no longer suffers from " + this.m.Name;
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.BuyPriceMult *= 1.2;
		_modifiers.SellPriceMult *= 1.1;
		_modifiers.RarityMult *= 0.75;
	}

});


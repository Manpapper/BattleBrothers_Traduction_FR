this.well_supplied_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.well_supplied";
		this.m.Name = "Bien Approvisionné";
		this.m.Description = "Cet endroit a été récemment approvisionné en marchandises fraîches, et beaucoup d\'entre elles peuvent maintenant être achetées à bon prix.";
		this.m.Icon = "ui/settlement_status/settlement_effect_03.png";
		this.m.Rumors = [
			"Le commerce avec %settlement% est prospère, mon ami ! Des routes sûres et des stocks pleins, espérons que cela reste ainsi...",
			"Mon cousin à %settlement% se vante de la qualité de leur vie là-bas. Des stands de marché bien achalandés et tout. Pas comme cet endroit pourri."
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
		_settlement.removeSituationByID("situation.ambushed_trade_routes");
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.PriceMult *= 0.9;
		_modifiers.RarityMult *= 1.15;
	}

});


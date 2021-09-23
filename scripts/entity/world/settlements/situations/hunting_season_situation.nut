this.hunting_season_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.hunting_season";
		this.m.Name = "Saison de la Chasse";
		this.m.Description = "Les forêts regorgent de cerfs et c\'est la saison de la chasse. La venaison et les fourrures sont en abondance.";
		this.m.Icon = "ui/settlement_status/settlement_effect_36.png";
		this.m.Rumors = [
			"Vous aimez le gibier, mercenaire ? Et vos hommes ? J\'ai entendu dire que la saison de la chasse a commencé dans %settlement%. Je dis ça comme ça.",
			"C\'est le moment de l\'année que tous les chasseurs attendaient avec impatience. La saison de chasse vient de commencer aux alentours de %settlement% !",
			"Chasser en dehors de la saison peut vous faire couper les mains ! Mais cela n\'a pas d\'importance, car la saison va commencer d\'un jour à l\'autre dans les forêts près de %settlement%."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 5;
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
		_modifiers.FoodRarityMult *= 2.0;
		_modifiers.FoodPriceMult *= 0.5;
	}

});


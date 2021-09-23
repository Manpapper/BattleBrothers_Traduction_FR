this.preparing_feast_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.preparing_feast";
		this.m.Name = "Préparation d\'un festin";
		this.m.Description = "Les nobles se préparent à un festin. Les cuisinières et les cuisines achètent de la nourriture en quantité.";
		this.m.Icon = "ui/settlement_status/settlement_effect_29.png";
		this.m.Rumors = [
			"Les nobles préparent un festin à %settlement% alors que nous, les paysans, n\'avons que du vieux grain pour nous étouffer...",
			"Mon oncle est un servant à %settlement%, et il me dit qu\'ils préparent un grand festin. Mais il est inutile d\'y aller si vous n\'êtes pas invité."
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
	}

	function onUpdate( _modifiers )
	{
		_modifiers.FoodRarityMult *= 0.25;
		_modifiers.FoodPriceMult *= 2.0;
	}

});


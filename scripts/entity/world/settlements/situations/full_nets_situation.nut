this.full_nets_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.full_nets";
		this.m.Name = "Filets pleins";
		this.m.Description = "Les eaux grouillent d\'une multitude de poissons. Le poisson frais est abondant et bon marché.";
		this.m.Icon = "ui/settlement_status/settlement_effect_19.png";
		this.m.Rumors = [
			"À cette époque de l\'année, de grands bancs de poissons viennent toujours s\'installer près de %settlement%. Tout ce qu\'ils ont à faire, c\'est de jeter quelques filets dans l\'eau et d\'en retirer plus de poissons qu\'ils ne pourront jamais en manger ! Salauds de chanceux !",
			"Demain, je vais aller à %settlement% et remplir mes chariots de poissons. La rumeur dit que les pêcheurs de là-bas ont eu de la chance !",
			"Vous êtes dans le commerce ? J\'ai entendu dire qu\'ils ont leurs filets remplis à ras bord de poissons à %settlement%."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 3;
	}

	function getAddedString( _s )
	{
		return _s + " a " + this.m.Name;
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


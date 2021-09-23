this.ambushed_trade_routes_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.ambushed_trade_routes";
		this.m.Name = "Routes Commerciales Embusquées";
		this.m.Description = "Les routes qui y mènent ici sont peu sûres ces derniers temps, et de nombreuses caravanes ont été prises en embuscade et pillées. Avec un commerce peu fructueux, la variété des marchandises est moindre et les prix plus élevés.";
		this.m.Icon = "ui/settlement_status/settlement_effect_12.png";
		this.m.Rumors = [
			"Les brigands et les voleurs sont le fléau des marchands ambulants ! Un vieil ami à moi a été pris en embuscade, volé et battu juste à l\'extérieur de %settlement% !",
			"Si vous avez des objets de valeur sur vous, restez loin de %settlement%. L\'endroit est infesté d\'égorgeurs, de bandits et de bandits de grand chemin !",
			"Les gardes font ce qu\'ils peuvent, mais ces brigands passent à la ville suivante et attaquent les commerçants sur la route. On dit qu\'ils rôdent autour de %settlement% maintenant !"
		];
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
		_settlement.removeSituationByID("situation.safe_roads");
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.BuyPriceMult *= 1.2;
		_modifiers.SellPriceMult *= 1.1;
		_modifiers.RarityMult *= 0.75;
	}

});


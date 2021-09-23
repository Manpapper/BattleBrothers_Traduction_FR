this.good_harvest_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.good_harvest";
		this.m.Name = "Bonne Récolte";
		this.m.Description = "Les conditions pour les cultures ont été parfaites. Les aliments sont facilement disponibles et proposés à des prix plus bas.";
		this.m.Icon = "ui/settlement_status/settlement_effect_17.png";
		this.m.Rumors = [
			"Allez à %settlement% si vous avez besoin de vous réapprovisionner en nourriture. Ces bâtards chanceux ont eu une saison de récolte abondante cette année.",
			"Je suis venu de %settlement% pour vendre notre surplus de produits. Les dieux nous ont souri et nous ont accordé la meilleure récolte depuis de nombreuses années !",
			"Je viens d\'apprendre qu\'à %settlement% les greniers et les garde-manger sont remplis à ras bord grâce à une bonne récolte. "
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 7;
	}

	function getAddedString( _s )
	{
		return _s + " bénéficie de " + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return _s + " ne bénéficie plus de " + this.m.Name;
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


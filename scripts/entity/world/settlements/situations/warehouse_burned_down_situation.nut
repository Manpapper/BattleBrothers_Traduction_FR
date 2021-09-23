this.warehouse_burned_down_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.warehouse_burned_down";
		this.m.Name = "Entrepôt Incendié";
		this.m.Description = "Un récent incendie dans un entrepôt a causé d\'importants dégâts. Ce qui a survécu à l\'incendie est maintenant vendu à des prix élevés.";
		this.m.Icon = "ui/settlement_status/settlement_effect_21.png";
		this.m.Rumors = [
			"Vous avez vu la fumée à l\'horizon la nuit dernière ? Ils disent que c\'est le grand entrepôt de %settlement% qui a brûlé.",
			"J\'ai entendu dire qu\'ils ont attrapé le pyromane qui a mis le feu à l\'entrepôt à %settlement%. Ils l\'ont pendu à un arbre à cet instant précis, mais ça va leur prendre beaucoup plus de temps pour reconstruire l\'entrepôt."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 5;
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
		_modifiers.BuyPriceMult *= 1.25;
		_modifiers.SellPriceMult *= 1.05;
		_modifiers.RarityMult *= 0.5;
	}

});


this.high_spirits_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.high_spirits";
		this.m.Name = "Bonne Humeur";
		this.m.Description = "L\'humeur est bonne ici, et les gens sont impatients de faire des affaires avec vous.";
		this.m.Icon = "ui/settlement_status/settlement_effect_05.png";
		this.m.Rumors = [
			"Je suis arrivé de %settlement% aujourd\'hui, mes vêtements sont encore poussiéreux à cause de la route. Les gens là-bas étaient sûrement de bonne humeur, mais je ne sais pas vraiment pourquoi...",
			"Pas besoin de m\'apporter un mug, je suis encore ivre des célébrations de %settlement%. Ils savent vraiment comment s\'amuser !",
			"La rumeur dit que les habitants de %settlement% viennent de récupérer une relique importante.."
		];
		this.m.IsStacking = false;
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
		_modifiers.SellPriceMult *= 1.05;
		_modifiers.BuyPriceMult *= 0.95;
		_modifiers.RarityMult *= 1.1;
	}

});


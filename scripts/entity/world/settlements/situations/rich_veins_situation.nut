this.rich_veins_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.rich_veins";
		this.m.Name = "Veines Riches";
		this.m.Description = "Un mineur chanceux a trouvé un filon particulièrement riche ! L\'extraction des minéraux et des métaux sera fortement augmentée jusqu\'à épuisement, mais la colonie connaît également une inflation des prix.";
		this.m.Icon = "ui/settlement_status/settlement_effect_33.png";
		this.m.Rumors = [
			"Ils ont trouvé un filon principal à %settlement%. J\'ai moi-même travaillé dans les mines pendant des décennies, et tout ce que j\'ai eu, c\'est une mauvaise toux.",
			"Ces bâtards chanceux de %settlement% ont trouvé un nouveau filon dans la mine. Les caravanes ne peuvent pas venir assez vite maintenant avec ce qu\'ils ramassent à la pelle.",
			"J\'ai entendu dire que les mines de %settlement% sont très productives en ce moment. Ce n\'est pas un mauvais moyen de gagner de l\'argent si vous êtes dans le commerce."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 4;
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
		_modifiers.SellPriceMult *= 1.1;
		_modifiers.BuyPriceMult *= 1.1;
		_modifiers.MineralRarityMult = 1.5;
	}

});


this.besieged_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.besieged";
		this.m.Name = "Assiégé";
		this.m.Description = "Cet endroit est ou a été jusqu\'à récemment assiégé par l\'ennemi ! Il y a eu des dégâts, les réserves sont faibles et beaucoup ont perdu la vie.";
		this.m.Icon = "ui/settlement_status/settlement_effect_13.png";
		this.m.Rumors = [
			"Des rochers et des flèches de feu qui volent, de l\'huile chaude qui est versée, des gens qui meurent de faim et de mort, voilà ce qu\'est un siège. Vous pouvez vous rendre à %settlement% et y jeter un coup d\'œil de près.",
			"Quand j\'étais plus jeune, j\'ai servi dans l\'armée de %randomnoble%. Le pire était un siège auquel nous avons participé, il a duré des mois. C\'est dommage que cela se reproduise en ce moment même en %settlement%.",
			"Vous avez entendu le mot ? %settlement% est assiégé ! Les pauvres gens de là-haut vont beaucoup souffrir."
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
		_settlement.resetShop();
		_settlement.resetRoster(false);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.SellPriceMult *= 1.0;
		_modifiers.BuyPriceMult *= 1.25;
		_modifiers.FoodPriceMult *= 2.0;
		_modifiers.RecruitsMult *= 0.5;
		_modifiers.RarityMult *= 0.5;
	}

});


this.raided_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.raided";
		this.m.Name = "Pillé";
		this.m.Description = "Cet endroit a été récemment attaqué ! Il a subi des dommages, a perdu des biens et des fournitures de valeur, et des vies ont été perdues.";
		this.m.Icon = "ui/settlement_status/settlement_effect_08.png";
		this.m.Rumors = [
			"Vous êtes l\'un de ces bandits ? Vous en avez l\'air et l\'odeur ! Tes hommes ont pillé %settlement% ? Allez-vous-en, j\'ai dit, on ne veut pas des gens de votre espèce ici !",
			"Des gens arrivent de %settlement% et disent qu\'elle a été pillée et saccagée. Pauvres gens, mais qu\'allons-nous faire ? Nous n\'avons pas grand-chose nous-mêmes. C\'est au seigneur de les protéger !",
			"Ce sont des temps dangereux en effet, mercenaire. Je viens d\'apprendre que %settlement% a été pillé et saccagé il n\'y a pas deux nuits."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 4;
	}

	function getAddedString( _s )
	{
		return _s + " a été " + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return _s + " n\'est plus " + this.m.Name;
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.RecruitsMult *= 0.5;
		_modifiers.RarityMult *= 0.5;
	}

});


this.greenskins_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.greenskins";
		this.m.Name = "Peaux-Vertes Aperçus";
		this.m.Description = "Les peaux vertes terrorisent les terres environnantes, et de nombreuses vies ont été perdues alors que les orcs ou les gobelins continuent à faire des raids sur les fermes isolées et à raser les caravanes. Les réserves commencent à s\'épuiser et les gens sont désespérés.";
		this.m.Icon = "ui/settlement_status/settlement_effect_01.png";
		this.m.Rumors = [
			"J\'ai entendu des rumeurs selon lesquelles de vils peaux-vertes ont été aperçus autour de %settlement% ! C\'est vrai ? J\'espère qu\'ils n\'arriveront pas jusqu\'ici...",
			"Avez-vous vu les colonnes de fumée dans le ciel du soir ? Elles s\'élèvent au-dessus de %settlement% où les peaux vertes brûlent et pillent la campagne.",
			"Tiens, regarde ce qu\'il reste de ma main ! Je ne peux presque plus m\'en servir, car elle n\'a plus de doigts depuis mon altercation avec les peaux-vertes il y a quelque temps. J\'ai entendu dire qu\'ils étaient de retour, autour de %settlement% au moment où nous parlons."
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
		_settlement.resetShop();
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.RarityMult *= 0.75;
		_modifiers.RecruitsMult *= 0.75;
	}

});


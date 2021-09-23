this.sickness_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.sickness";
		this.m.Name = "Maladie";
		this.m.Description = "Une maladie a frappé de nombreuses personnes dans cette colonie. Il y a moins de recrues disponibles, et la nourriture et les fournitures médicales sont rares.";
		this.m.Icon = "ui/settlement_status/settlement_effect_23.png";
		this.m.Rumors = [
			"Ne vous approchez pas de %settlement% ! Une maladie a frappé cette pauvre ville et les gens meurent comme des mouches là-bas...",
			"Des gens de %settlement% venaient ici, mais nous avons dû les renvoyer aux portes. Tout le monde sait qu\'une maladie cruelle se répand dans cette ville maudite.",
			"Vous aimez mon collier d\'herbes ? Il me protège même contre les maladies les plus pestilentielles. Vous devriez vous en procurer un aussi, si vous comptez poursuivre votre route vers %settlement%."
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
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.FoodPriceMult *= 2.0;
		_modifiers.MedicalPriceMult *= 3.0;
		_modifiers.RecruitsMult *= 0.25;
	}

});


this.seasonal_fair_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.seasonal_fair";
		this.m.Name = "Foire Saisonnière";
		this.m.Description = "Des commerçants de tous horizons se réunissent ici pour la foire saisonnière. De nombreuses personnes affluent de la campagne environnante, et c\'est le moment idéal pour vendre des marchandises ou fouiller dans les offres abondantes.";
		this.m.Icon = "ui/settlement_status/settlement_effect_28.png";
		this.m.Rumors = [
			"Qu\'est-ce qui se passe ici, vous vous demandez ? Eh bien, il y a une foire à %settlement%. Des marchands venus de loin se rassemblent pour proposer leurs marchandises.",
			"Moi, je suis plutôt du genre solitaire. Les grandes foires comme celle de %settlement% ne me plaisent pas du tout....."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 3;
	}

	function onAdded( _settlement )
	{
		_settlement.removeSituationByID("situation.ambushed_trade_routes");
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.PriceMult *= 1.25;
		_modifiers.RarityMult *= 1.25;
		_modifiers.FoodRarityMult *= 1.25;
		_modifiers.MedicalRarityMult *= 1.25;
		_modifiers.RecruitsMult *= 1.25;
	}

	function onUpdateDraftList( _draftList )
	{
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
		_draftList.push("peddler_background");
	}

});


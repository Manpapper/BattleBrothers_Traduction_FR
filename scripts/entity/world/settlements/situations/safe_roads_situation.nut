this.safe_roads_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.safe_roads";
		this.m.Name = "Routes Sûres";
		this.m.Description = "Les routes qui y mènent ont été raisonnablement sûres ces derniers temps, ce qui a permis à de nombreux commerces rentables de se développer et à la colonie de prospérer quelque peu.";
		this.m.Icon = "ui/settlement_status/settlement_effect_06.png";
		this.m.Rumors = [
			"Il semble que les brigands autour de %settlement% passent un mauvais moment maintenant avec toutes ces patrouilles en place.",
			"Je suis revenu de %settlement% la nuit dernière. Aucun brigand en vue sur les routes, Dieu merci.",
			"Je dis à mon cousin depuis des années d\'arrêter de voler les gens sur la route. Il n\'y avait pas d\'autre moyen pour que ça finisse mal. Et j\'avais raison, ça a fini. Il a eu sa revanche l\'autre jour à %settlement%. L\'endroit grouille de miliciens."
		];
		this.m.IsStacking = false;
	}

	function onAdded( _settlement )
	{
		_settlement.removeSituationByID("situation.ambushed_trade_routes");
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.PriceMult *= 1.1;
		_modifiers.RarityMult *= 1.1;
	}

});


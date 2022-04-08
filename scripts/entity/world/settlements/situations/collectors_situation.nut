this.collectors_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.collectors";
		this.m.Name = "Collectionneurs";
		this.m.Description = "Plusieurs collectionneurs de curiosités exotiques sont venus en ville. Il y a de l'argent à gagner en vendant des trophées de bêtes et autres ici.";
		this.m.Icon = "ui/settlement_status/settlement_effect_46.png";
		this.m.Rumors = [
			"Êtes-vous des chasseurs de bêtes rares ? J'ai entendu dire que d'étranges personnages sont apparus à %settlement% et achètent tous les trophées de monstres exotiques qu'ils peuvent trouver.",
			"Vous voyez cette dent de chien ? J'ai l'intention de la vendre à %settlement%, j'ai entendu dire qu'ils payaient bien les parties de bêtes là-bas.",
			"Il semble que toutes sortes de tueurs de bêtes et de ramasseurs de cadavres se rassemblent à %settlement%. J'ai entendu parler de la vente de trophées de bêtes. Ça ressemble à de la sorcellerie pour moi."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 3;
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
		_modifiers.BeastPartsPriceMult *= 2.0;
		_modifiers.RecruitsMult *= 1.25;
	}

	function onUpdateDraftList( _draftList )
	{
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");

		if (this.Const.DLC.Unhold)
		{
			_draftList.push("beast_hunter_background");
			_draftList.push("beast_hunter_background");
			_draftList.push("beast_hunter_background");
			_draftList.push("beast_hunter_background");
			_draftList.push("beast_hunter_background");
		}

		if (this.Const.DLC.Paladins)
		{
			_draftList.push("anatomist_background");
			_draftList.push("anatomist_background");
			_draftList.push("anatomist_background");
			_draftList.push("anatomist_background");
			_draftList.push("anatomist_background");
		}
	}

});


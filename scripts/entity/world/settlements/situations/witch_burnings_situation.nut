this.witch_burnings_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.witch_burnings";
		this.m.Name = "Bûchers de Sorcières";
		this.m.Description = "Spectacle enflammé, les bûchers de sorcières attirent les spectateurs, et les spectateurs attirent les stands de nourriture. Et puis, il y a forcément un certain nombre de chasseurs de sorcières en ville...";
		this.m.Icon = "ui/settlement_status/settlement_effect_32.png";
		this.m.Rumors = [
			"Des chasseurs de sorcières sont passés hier. Ils n\'ont pas trouvé ce qu\'ils cherchaient et sont partis vers %settlement%.",
			"D\'après ce que j\'ai entendu, ils ont trouvé une sorcière à %settlement% et vont la mettre sur le bûcher. En y réfléchissant, je devrais peut-être dénoncer cette vieille mégère qui m\'a battu au marché l\'autre jour, c\'est une sorcière, c\'est sûr !"
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

	function onRemoved( _settlement )
	{
		_settlement.resetShop();
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.FoodRarityMult *= 1.35;
		_modifiers.FoodPriceMult *= 1.15;
	}

	function onUpdateDraftList( _draftList )
	{
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
		_draftList.push("witchhunter_background");
	}

});


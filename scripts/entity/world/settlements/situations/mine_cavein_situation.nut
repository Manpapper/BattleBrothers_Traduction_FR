this.mine_cavein_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.mine_cavein";
		this.m.Name = "Effondrement de la Mine";
		this.m.Description = "Un accident tragique s\'est produit, et un effondrement s\'est produit dans l\'une des mines. La production s\'est arrêtée jusqu\'à ce que les dégâts soient réparés, et les mineurs sont sans moyens pour nourrir leurs familles.";
		this.m.Icon = "ui/settlement_status/settlement_effect_24.png";
		this.m.Rumors = [
			"Je ne travaillerai jamais sous terre, je ne suis pas une taupe puante ! C\'est un putain de piège mortel ! Il n\'y a pas longtemps, une mine a cédé à %settlement%, je ne veux même pas savoir combien sont morts ce jour-là...",
			"Une livraison de minerais et de minéraux provenant des mines de %settlement% était attendue aujourd\'hui, mais hélas elle n\'est pas encore arrivée. Il a dû se passer quelque chose là-bas.",
			"Il paraît qu\'il y a eu un effondrement dans une des mines à %settlement%. Imaginez être enterré vivant sous la roche et la terre..."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 5;
	}

	function getAddedString( _s )
	{
		return _s + " a " + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return _s + " ne souffre plus de l\'" + this.m.Name;
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.RecruitsMult *= 1.25;
	}

	function onUpdateShop( _stash )
	{
		do
		{
		}
		while (_stash.removeByID("misc.uncut_gems") != null);

		do
		{
		}
		while (_stash.removeByID("misc.copper_ingots") != null);
	}

	function onUpdateDraftList( _draftList )
	{
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
		_draftList.push("miner_background");
	}

});


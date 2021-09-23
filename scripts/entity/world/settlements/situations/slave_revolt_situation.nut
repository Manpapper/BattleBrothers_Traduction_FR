this.slave_revolt_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.slave_revolt";
		this.m.Name = "Révolte des Esclaves";
		this.m.Description = "Les endettés, la classe des esclaves des cités-états, ont pris les armes et se soulèvent contre leurs maîtres ! Les endettés sont difficiles à trouver, et les armes et armures ont été balayées du marché.";
		this.m.Icon = "ui/settlement_status/settlement_effect_40.png";
		this.m.Rumors = [
			"Les esclaves de %settlement% ont pris les armes et se sont tournés vers le banditisme et le pillage. Les Immaculés, ou quel que soit le nom qu\'on leur donne, je veux dire. Il y a sûrement du travail à faire pour un mercenaire comme vous.",
			"La rumeur court que les esclaves de %settlement% se rebellent. Une vraie révolte pourrait renverser toute la ville, et je l\'espère."
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
		_modifiers.RecruitsMult *= 0.75;
		_modifiers.RarityMult *= 0.5;
	}

	function onUpdateDraftList( _draftList )
	{
		for( local i = _draftList.len() - 1; i >= 0; i = --i )
		{
			if (_draftList[i] == "slave_background" || _draftList[i] == "slave_southern_background")
			{
				_draftList.remove(i);
			}
		}
	}

});


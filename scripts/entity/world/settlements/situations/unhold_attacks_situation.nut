this.unhold_attacks_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.unhold_attacks";
		this.m.Name = "Attaques de Unhold";
		this.m.Description = "De grands Unholds ont été vus et entendus dans la région. Les habitants ont peur de quitter les environs de la colonie.";
		this.m.Icon = "ui/settlement_status/settlement_effect_26.png";
		this.m.Rumors = [
			"Un marchand ambulant m\'a parlé d\'empreintes de pas géantes près de la route de %settlement%. Je ne voudrais certainement pas rencontrer la bête qui les a laissées !",
			"Quand j\'étais à %settlement% l\'autre jour, un groupe de chasseurs a disparu. Ils étaient à la recherche d\'une sorte de géant...",
			"Vous avez déjà entendu parler des Unholds ? D\'énormes monstres qui écrasent des chariots entiers sous un pied ! J\'ai entendu des rumeurs comme quoi on en a aperçus près de %settlement%."
		];
		this.m.IsStacking = false;
	}

	function getAddedString( _s )
	{
		return _s + " has " + this.m.Name;
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
		_modifiers.BuyPriceMult *= 1.1;
		_modifiers.SellPriceMult *= 0.9;
		_modifiers.RarityMult *= 0.9;
		_modifiers.RecruitsMult *= 0.75;
	}

});


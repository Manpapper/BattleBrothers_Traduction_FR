this.abducted_children_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.abducted_children";
		this.m.Name = "Enfants Enlevés";
		this.m.Description = "Des enfants ont disparu de cette colonie. La méfiance et la peur règnent dans les rues et empoisonnent lentement la communauté.";
		this.m.Icon = "ui/settlement_status/settlement_effect_34.png";
		this.m.Rumors = [
			"La rumeur dit que des enfants disparaissent de leur berceau à %settlement% dans la nature. Imaginez la terreur des parents...",
			"Ma grand-mère m\'a raconté une histoire de sorcières qui enlevaient des enfants pour leur sang innocent. Et maintenant, à %settlement%, des enfants ont disparu, comme dans les histoires.",
			"Ne concluez jamais un marché avec des sorcières ! Un parent de %settlement% l\'a fait il y a des années et maintenant son enfant a disparu."
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
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.BuyPriceMult *= 1.25;
		_modifiers.SellPriceMult *= 0.75;
		_modifiers.RecruitsMult *= 0.5;
	}

});


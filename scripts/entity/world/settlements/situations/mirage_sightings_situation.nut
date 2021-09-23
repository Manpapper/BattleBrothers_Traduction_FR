this.mirage_sightings_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.mirage_sightings";
		this.m.Name = "Observations de Mirage";
		this.m.Description = "Le craquement de la chaleur et le scintillement de l\'air ont provoqué l\'apparition de nombreux mirages dans lesquels des personnages étranges se déplaceraient. ";
		this.m.Icon = "ui/settlement_status/settlement_effect_43.png";
		this.m.Rumors = [
			"Je vous le dis, une merveilleuse oasis luxuriante, des toits dorés qui scintillent au loin, des oiseaux aux couleurs de l\'arc-en-ciel devant nous ! Où j\'ai vu ça ? Eh bien, c\'était sur la route de %settlement%. Je le jure !",
			"Certains maux ne viennent pas dans le noir de la nuit ou se cachent dans l\'ombre. Ils sortent sous le soleil brûlant, au milieu de la journée. Allez sur %settlement% si vous voulez savoir de quoi je parle.",
			"Les mirages peuvent être vus occasionnellement dans les déserts, et les suivre peut mener à un destin bien pire que de se perdre dans le désert."
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
		_settlement.removeSituationByID("situation.safe_roads");
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
	}

});


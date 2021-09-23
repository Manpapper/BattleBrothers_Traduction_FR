this.arena_tournament_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.arena_tournament";
		this.m.Name = "Tournoi";
		this.m.Description = "Un grand tournoi va être organisé dans l\'arène. Participez-y pour gagner de merveilleux prix !";
		this.m.Icon = "ui/settlement_status/settlement_effect_45.png";
		this.m.Rumors = [
			"Vous avez l\'air d\'un combattant compétent. L\'arène de %settlement% organise un tournoi et vous pouvez sûrement encore y participer !",
			"Après ce verre, je me dirigerai directement vers %settlement% pour regarder le grand tournoi d\'arène ! Le meilleur divertissement de l\'année !",
			"J\'ai entendu dire que le prix pour le gagnant du tournoi d\'arène dans %settlement% est encore plus merveilleux cette année !"
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 5;
	}

	function getAddedString( _s )
	{
		return _s + " organise maintenant un " + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return "Le " + this.m.Name + " de " + _s + " est maintenant terminé";
	}

	function onAdded( _settlement )
	{
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
	}

	function onUpdateDraftList( _draftList )
	{
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
		_draftList.push("gladiator_background");
	}

});


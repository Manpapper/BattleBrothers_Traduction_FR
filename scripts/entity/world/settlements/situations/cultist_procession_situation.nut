this.cultist_procession_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.cultist_procession";
		this.m.Name = "Procession Cultistes";
		this.m.Description = "Une procession de cultistes traverse la ville ; un flot continu de personnes qui semblent s\'être matérialisées à partir de rien et qui se dirigent maintenant lentement le long des routes principales. Vêtus de couleurs sombres, ils font sonner des cloches et chantent de façon monotone le nom de Davkul.";
		this.m.Icon = "ui/settlement_status/settlement_effect_37.png";
		this.m.Rumors = [
			"Je viens de voir la procession la plus effrayante qui soit passer par %settlement% ! Des personnages masqués, se fouettant le dos jusqu\'à ce qu\'ils soient couverts de sang...",
			"%settlement% est envahi par d\'étranges cultistes, ils ne font sûrement rien de bon ! Quelqu\'un devrait envoyer les chasseurs de sorcières sur leur chemin, je dirais !",
			"Il s\'est réveillé ! La bête endormie est sur le point de sortir de son sommeil séculaire ! Allez à %settlement% et mes frères dans la foi vous diront la même chose ! Davkul viendra !"
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 2;
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

	function onRemoved( _settlement )
	{
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
	}

	function onUpdateDraftList( _draftList )
	{
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
		_draftList.push("cultist_background");
	}

});


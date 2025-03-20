this.ceremonial_season_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.ceremonial_season";
		this.m.Name = "Saison des Cérémonies";
		this.m.Description = "Pendant la saison des cérémonies, de grandes quantités d\'encens sont utilisées par les temples. La demande et les prix de l\'encens atteignent des sommets.";
		this.m.Icon = "ui/settlement_status/settlement_effect_44.png";
		this.m.Rumors = [
			"À cette époque de l\'année, les temples de %settlement% fument comme une masure en feu ! Je me demande où ils trouvent tout cet encens...",
			"Si vous êtes une personne pieuse, vous pouvez vous rendre à %settlement% pour brûler de l\'encens et dire quelques prières."
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
	}

	function onUpdate( _modifiers )
	{
		_modifiers.IncensePriceMult *= 1.5;
	}

});


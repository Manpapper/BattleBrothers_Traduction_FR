this.disappearing_villagers_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.disappearing_villagers";
		this.m.Name = "Villageois Disparus";
		this.m.Description = "Des villageois ont disparu de cette ville, ce qui a mis tout le monde sur les nerfs. On trouve moins de recrues potentielles dans les rues, et les gens sont moins bien disposés envers les étrangers.";
		this.m.Icon = "ui/settlement_status/settlement_effect_11.png";
		this.m.Rumors = [
			"Je viens d\'annuler ma visite à %settlement% après avoir entendu que des gens disparaissaient là-bas. Rester à l\'écart des problèmes m\'a bien servi jusqu\'à présent !",
			"Mon voisin %randomname% est parti à %settlement% il y a environ une semaine. Je n\'ai plus entendu parler de lui depuis. J\'espère juste que rien ne lui est arrivé, vous savez, avec ces brigands et ces monstres qui errent dans le coin...",
			"Les forces du mal sont fortes dans ce monde. Elles se cachent dans les bois, les montagnes et les ombres, et parfois les gens disparaissent sans laisser de trace. C\'est ce qui se passe en ce moment même à %settlement%."
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

	function onUpdate( _modifiers )
	{
		_modifiers.BuyPriceMult *= 1.25;
		_modifiers.SellPriceMult *= 0.75;
		_modifiers.RecruitsMult *= 0.5;
	}

});


this.lost_at_sea_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.lost_at_sea";
		this.m.Name = "Perdus en Mer";
		this.m.Description = "Un bateau avec des pêcheurs a été perdu en mer pendant une tempête. Le poisson frais et les recrues volontaires sont rares.";
		this.m.Icon = "ui/settlement_status/settlement_effect_18.png";
		this.m.Rumors = [
			"Ils ne sont jamais revenus de la mer... penser à toutes les pauvres âmes perdues  à %settlement% me fait frissonner.",
			"Ces satanées sorcières de %settlement%, qui gémissent et gémissent. Je suis allé leur vendre quelques-uns de mes porcs, mais elles ne font que gémir et on ne trouve pas un seul homme. Un bateau perdu en mer ou quelque chose comme ça. Je suis reparti sans avoir vendu un seul cochon.",
			"La navigation maritime a toujours été un métier dangereux. C\'est pourquoi j\'ai tourné le dos à l\'eau. Et juste à temps, si je puis dire, car sinon, c\'est peut-être moi sur ce bateau qui aurait été perdu à %settlement%."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 4;
	}

	function getAddedString( _s )
	{
		return _s + " a " + this.m.Name;
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
		_modifiers.FoodRarityMult *= 0.5;
		_modifiers.FoodPriceMult *= 2.0;
		_modifiers.RecruitsMult *= 0.5;
	}

});


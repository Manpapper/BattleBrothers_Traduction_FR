this.terrified_villagers_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.terrified_villagers";
		this.m.Name = "Villageois Terrifiés";
		this.m.Description = "Les villageois sont terrifiés par des horreurs inconnues. Il y a moins de recrues potentielles dans les rues, et les gens sont moins bien disposés envers les étrangers.";
		this.m.Icon = "ui/settlement_status/settlement_effect_09.png";
		this.m.Rumors = [
			"Les morts ne sont pas vraiment morts, parfois ils reviennent hanter les vivants ! Vous ne me croyez pas ? Rendez-vous sur %settlement% et voyez par vous-même !",
			"Vous avez l\'air d\'un bon épéiste ! J\'ai entendu des rumeurs sur les morts qui marchent à nouveau près de %settlement%. C\'est sûrement une blague, mais les gens effrayés paient souvent de bonnes couronnes pour se sentir à nouveau en sécurité."
		];
	}

	function onUpdate( _modifiers )
	{
		_modifiers.BuyPriceMult *= 1.25;
		_modifiers.SellPriceMult *= 0.75;
		_modifiers.RecruitsMult *= 0.5;
	}

});


this.conquered_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.conquered";
		this.m.Name = "Conquis";
		this.m.Description = "Cet endroit a été conquis récemment. De nombreuses vies ont été perdues, et les survivants ont dû supporter que les conquérants prennent leur butin de guerre. Une grande partie de la colonie est encore endommagée, et le moral est bas.";
		this.m.Icon = "ui/settlement_status/settlement_effect_02.png";
		this.m.Rumors = [
			"%settlement% a été capturé récemment, du moins c\'est ce que j\'ai entendu. \"Nouveaux seigneurs - même merde\", c\'est ce que je dis toujours...",
			"Conquérir de nouvelles terres est le jeu des nobles. J\'ai entendu dire qu\'ils venaient de mettre à sac %settlement%",
			"Oh, salut mercenaire ! Étiez-vous au siège de %settlement% ? Eh bien, putain de félicitations. Combien en avez-vous tué ? Combien en avez-vous violé ?"
		];
		this.m.IsStacking = false;
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.SellPriceMult *= 0.9;
		_modifiers.BuyPriceMult *= 1.1;
		_modifiers.RarityMult *= 0.6;
		_modifiers.FoodRarityMult *= 0.9;
	}

});


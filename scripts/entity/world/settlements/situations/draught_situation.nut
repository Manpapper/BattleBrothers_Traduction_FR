this.draught_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.draught";
		this.m.Name = "Sécheresse";
		this.m.Description = "Une vague de chaleur inattendue a brûlé une grande partie des cultures locales. Il y a moins de nourriture disponible et les prix sont plus élevés.";
		this.m.Icon = "ui/settlement_status/settlement_effect_16.png";
		this.m.Rumors = [
			"D\'après ce que j\'ai entendu, une terrible sécheresse affecte %settlement%. Ça a toujours été dur pour les gens là-bas, mais cette fois, c\'est terrible.",
			"Si vous êtes aussi téméraire que vous en avez l\'air, vous pourriez faire des couronnes rapidement en vendant de la nourriture à %settlement%. Une sécheresse sévère a affamé les gens, ils sont donc prêts à payer n\'importe quoi pour avoir quelque chose sous la dent.",
			"Oh, fils, j\'étais un faiseur de pluie à %settlement%, mais ces idiots m\'ont chassé ! Maintenant, il est paraît que le village souffre d\'une sécheresse, mais n\'est-ce pas une raison de plus de compter sur moi ? Imbéciles, je dis !"
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 7;
	}

	function getAddedString( _s )
	{
		return _s + " souffre de " + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return _s + " ne souffre plus de la " + this.m.Name;
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.FoodRarityMult *= 0.5;
		_modifiers.FoodPriceMult *= 2.0;
	}

	function onUpdateDraftList( _draftList )
	{
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
		_draftList.push("farmhand_background");
	}

});


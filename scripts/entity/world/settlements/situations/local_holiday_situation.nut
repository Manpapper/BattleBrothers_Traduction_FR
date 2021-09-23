this.local_holiday_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.local_holiday";
		this.m.Name = "Fête Locale";
		this.m.Description = "La population est d\'humeur généreuse à l\'occasion d\'une fête locale. C\'est l\'heure de manger et de boire !";
		this.m.Icon = "ui/settlement_status/settlement_effect_22.png";
		this.m.Rumors = [
			"Si vous voulez passer un bon moment, rendez-vous sur %settlement% et rejoignez leur fête ! Bon sang, j\'aimerais être là-bas",
			"Vous n\'avez pas l\'air du genre à faire la fête, si je puis dire, mais peut-être que vos hommes apprécieraient un peu de nourriture et de boisson. Hélas, on peut trouver les deux en abondance à %settlement%, car ils célèbrent une fête là-bas.",
			"Les habitants de %settlement% font leur fête annuelle en ce moment. Je serais bien allé là-bas à boire et à manger, si seulement j\'avais les couronnes. Une autre bière, l\'ami ?"
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 2;
	}

	function getAddedString( _s )
	{
		return _s + " organise une " + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return "La " + this.m.Name + " à " + _s + " est maintenant terminée";
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.SellPriceMult *= 1.05;
		_modifiers.BuyPriceMult *= 0.95;
		_modifiers.FoodRarityMult *= 1.5;
		_modifiers.FoodPriceMult *= 0.9;
	}

});


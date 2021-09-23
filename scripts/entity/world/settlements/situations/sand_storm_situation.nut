this.sand_storm_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.sand_storm";
		this.m.Name = "Tempête de Sable";
		this.m.Description = "Des tempêtes de sable hurlantes ont englouti la ville et empêchent les commerçants d\'y entrer et d\'en sortir en toute sécurité. Les marchandises deviennent plus rares et les prix plus élevés.";
		this.m.Icon = "ui/settlement_status/settlement_effect_38.png";
		this.m.Rumors = [
			"Je viens de rentrer de %settlement%, j\'ai à peine réussi à sortir ! Une tempête de sable a englouti toute la ville !",
			"C\'est encore arrivé, %settlement% a été englouti par la plus terrible des tempêtes de sable."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 3;
	}

	function getAddedString( _s )
	{
		return _s + " souffre d\'une " + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return _s + " ne souffre plus d\'une " + this.m.Name;
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.BuyPriceMult *= 1.2;
		_modifiers.SellPriceMult *= 1.1;
		_modifiers.RarityMult *= 0.75;
	}

});


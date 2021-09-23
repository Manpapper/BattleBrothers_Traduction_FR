this.moving_sands_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.moving_sands";
		this.m.Name = "Sables mouvants";
		this.m.Description = "La zone autour de la ville a été infestée de serpents grouillants, certains particulièrement grands. Le commerce a souffert et les marchandises sont devenues plus rares et plus chères.";
		this.m.Icon = "ui/settlement_status/settlement_effect_42.png";
		this.m.Rumors = [
			"On dit que les commerçants sur la route de %settlement% ont été entièrement avalés par les sables mouvants. Mais qui croit de telles sornettes ?",
			"Vous avez peur des serpents ? On en a vu beaucoup près de %settlement% dernièrement, certains aussi longs que mon bras, d\'autres aussi longs qu\'un wagon entier de commerçants !"
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

	function onAdded( _settlement )
	{
		_settlement.removeSituationByID("situation.safe_roads");
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.SellPriceMult *= 1.1;
		_modifiers.RarityMult *= 0.85;
	}

});


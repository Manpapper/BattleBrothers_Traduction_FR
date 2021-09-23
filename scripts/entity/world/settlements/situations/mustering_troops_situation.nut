this.mustering_troops_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.mustering_troops";
		this.m.Name = "Rassemblement de Troupes";
		this.m.Description = "L\'ordre a été donné de rassembler les troupes pour le service dans cette colonie. L\'équipement et les recrues manquent, mais des couronnes peuvent être rapidement gagnée en vendant des armes et des armures ici.";
		this.m.Icon = "ui/settlement_status/settlement_effect_35.png";
		this.m.Rumors = [
			"Un autre noble pressurise des jeunes dans un régiment à %settlement%. Ach, pourquoi est-ce que je vous parle de ça, mercenaire ? Vous n\'êtes pas mieux !",
			"Si j\'étais un marchand avec un chariot rempli d\'armes et d\'armures, je saurais où les vendre - ils rassemblent des troupes à %settlement% et paieront sûrement une bonne somme. Hélas, je ne suis pas un marchand et je n\'ai pas d\'armes.",
			"Je suis juste de passage. J\'ai échappé de justesse à l\'embrigadement à %settlement%. Ils voulaient me forcer à me battre pour un seigneur, mais non merci, j\'ai dit, ça n\'arrivera pas, et je suis parti. Je vais tenter ma chance plus au sud."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 4;
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
		_settlement.resetShop();
		_settlement.resetRoster(false);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.PriceMult *= 1.25;
		_modifiers.RecruitsMult *= 0.5;
		_modifiers.RarityMult *= 0.5;
	}

});


this.disbanded_troops_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.disbanded_troops";
		this.m.Name = "Troupes Dissoutes";
		this.m.Description = "Avec un conflit local maintenant résolu, de nombreuses troupes levées et leurs armes ne sont plus nécessaires. C\'est le bon moment pour faire de bonnes affaires ou engager de nouveaux hommes expérimentés.";
		this.m.Icon = "ui/settlement_status/settlement_effect_30.png";
		this.m.Rumors = [
			"Les armées permanentes coûtent cher, mon ami. J\'ai entendu dire qu\'un régiment entier a été dissous à %settlement%. Il doit sûrement y avoir des combattants vétérans qui s\'y attardent, à la recherche d\'argent.",
			"Quand j\'étais jeune, j\'étais soldat, et j\'aimais ça. Même les marches. Mais quand mon unité a été dissoute, je ne savais pas quoi faire de moi-même. Maintenant, ils sont en train de dissoudre un de leurs régiments à %settlement%, d\'après ce que j\'ai entendu.",
			"Je suis inquiet pour ma nièce, une unité entière de soldats a été dissoute à %settlement%, juste à côté d\'où elle vit. Les choses ne vont pas bien se terminer si ces brutes ne trouvent pas rapidement du travail !"
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
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.PriceMult *= 0.9;
		_modifiers.RecruitsMult *= 1.25;
	}

	function onUpdateDraftList( _draftList )
	{
		_draftList.push("deserter_background");
		_draftList.push("deserter_background");
		_draftList.push("deserter_background");
		_draftList.push("deserter_background");
		_draftList.push("deserter_background");
		_draftList.push("deserter_background");
		_draftList.push("militia_background");
		_draftList.push("militia_background");
		_draftList.push("militia_background");
		_draftList.push("militia_background");
		_draftList.push("militia_background");
		_draftList.push("militia_background");
		_draftList.push("militia_background");
		_draftList.push("militia_background");
		_draftList.push("militia_background");
		_draftList.push("militia_background");
		_draftList.push("sellsword_background");
		_draftList.push("sellsword_background");
		_draftList.push("sellsword_background");
		_draftList.push("retired_soldier_background");
		_draftList.push("retired_soldier_background");
		_draftList.push("retired_soldier_background");
		_draftList.push("retired_soldier_background");
		_draftList.push("retired_soldier_background");
		_draftList.push("retired_soldier_background");
		_draftList.push("retired_soldier_background");
		_draftList.push("retired_soldier_background");
		_draftList.push("squire_background");
		_draftList.push("squire_background");
		_draftList.push("squire_background");
		_draftList.push("squire_background");
		_draftList.push("hedge_knight_background");
		_draftList.push("hedge_knight_background");
		_draftList.push("hedge_knight_background");
	}

});


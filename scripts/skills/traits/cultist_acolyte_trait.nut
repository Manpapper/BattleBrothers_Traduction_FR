this.cultist_acolyte_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.cultist_acolyte";
		this.m.Name = "Acolyte de Davkul";
		this.m.Icon = "ui/traits/trait_icon_66.png";
		this.m.Description = "Ce personnage est un acolyte de Davkul, un individu avec une connaissance intime des enseignements sur l'ancien Dieu. Il embrasse les douleurs physique et la mise en péril car ça le rapproche du salut.";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+2[/color] de Fatigue Recupéré par tour"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] de Détermination"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/morale.png",
				text = "Pas de test de moral quand un allié est tué"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/morale.png",
				text = "Pas de test de moral en perdant des Points de Vie"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.FatigueRecoveryRate += 2;
		_properties.Bravery += 10;
		_properties.IsAffectedByDyingAllies = false;
		_properties.IsAffectedByLosingHitpoints = false;
	}

});


this.bloodthirsty_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.bloodthirsty";
		this.m.Name = "Sanguinaire";
		this.m.Icon = "ui/traits/trait_icon_42.png";
		this.m.Description = "Ce personnage a tendance à être excessivement violent et cruel contre ses ennemis. Un ennemie mort ce n\'est pas assez, sa tête doit aussi être sur une pique!";
		this.m.Titles = [
			"le Boucher",
			"le Cruel",
			"le Fou"
		];
		this.m.Excluded = [
			"trait.weasel",
			"trait.fainthearted",
			"trait.hesistant",
			"trait.craven",
			"trait.insecure",
			"trait.craven",
			"trait.paranoid",
			"trait.fear_beasts",
			"trait.fear_undead",
			"trait.fear_greenskins",
			"trait.teamplayer"
		];
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
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Tous les tués sont des fatalités (si l\'arme le permet)."
			}
		];
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		_properties.FatalityChanceMult = 1000.0;
	}

});


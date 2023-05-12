this.oath_of_endurance_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.oath_of_endurance";
		this.m.Name = "Serment d\'Endurance";
		this.m.Icon = "ui/traits/trait_icon_84.png";
		this.m.Description = "Ce personnage a prêté un serment d\'endurance, et a juré de survivre à n\'importe quel ennemi au combat.";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
		this.m.Excluded = [];
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+3[/color] de Regéneration de Fatigue par tour"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.FatigueRecoveryRate += 3;
	}

});


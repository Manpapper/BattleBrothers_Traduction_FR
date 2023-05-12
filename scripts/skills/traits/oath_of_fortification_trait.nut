this.oath_of_fortification_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.oath_of_fortification";
		this.m.Name = "Serment de Fortification";
		this.m.Icon = "ui/traits/trait_icon_86.png";
		this.m.Description = "Ce personnage a prêté un serment de fortification, et a juré de faire confiance à son bouclier par-dessus tout.";
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
				text = "Les compétences au Bouclier génèrent [color=" + this.Const.UI.Color.NegativeValue + "]25%[/color] moins de Fatigue."
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/special.png",
				text = "La compétence au Bouclier \'Mur de Bouclier\' se voit attribué les bonus supplémentaires suivants [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] Défense en Mêlée et [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] Défense à Distance."
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/special.png",
				text = "La compétence au Bouclier \'Repousser\' a maintenant [color=" + this.Const.UI.Color.PositiveValue + "]100%[/color] de chance de faire tituber en touchant."
			},
			{
				id = 14,
				type = "hint",
				icon = "ui/icons/warning.png",
				text = "Se concentre sur la défense et ne peut pas se déplacer au cours du premier round de combat."
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.IsProficientWithShieldSkills = true;
	}

});


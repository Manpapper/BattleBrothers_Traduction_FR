this.oath_of_sacrifice_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.oath_of_sacrifice";
		this.m.Name = "Serment de Sacrifice";
		this.m.Icon = "ui/traits/trait_icon_87.png";
		this.m.Description = "Ce personnage a prêté un serment de sacrifice et a juré de renoncer à prendre soin de lui-même pour assurer le succès de la compagnie. Cependant, une telle motivation a des conséquences sur son bien-être physique.";
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
				icon = "ui/icons/special.png",
				text = "Ne reçoit pas de salaire"
			},
			{
				id = 10,
				type = "hint",
				icon = "ui/icons/warning.png",
				text = "Les blessures ne guérissent pas"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.DailyWageMult *= 0.0;
	}

});


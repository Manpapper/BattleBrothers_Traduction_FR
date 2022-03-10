this.oath_of_fortification_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.oath_of_fortification";
		this.m.Name = "Oath of Fortification";
		this.m.Icon = "ui/traits/trait_icon_86.png";
		this.m.Description = "This character has taken an Oath of Fortification, and is sworn to trust in his shield above all else.";
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
				text = "Shield skills build up [color=" + this.Const.UI.Color.NegativeValue + "]25%[/color] less Fatigue."
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/special.png",
				text = "The \'Knock Back\' shield skill has a [color=" + this.Const.UI.Color.PositiveValue + "]100%[/color] chance to Stagger on hits."
			},
			{
				id = 13,
				type = "hint",
				icon = "ui/icons/warning.png",
				text = "Is focused on defense, and cannot move in the first round of combat"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.IsProficientWithShieldSkills = true;
	}

});


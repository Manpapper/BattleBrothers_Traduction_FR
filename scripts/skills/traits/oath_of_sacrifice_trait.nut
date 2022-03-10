this.oath_of_sacrifice_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.oath_of_sacrifice";
		this.m.Name = "Oath of Sacrifice";
		this.m.Icon = "ui/traits/trait_icon_87.png";
		this.m.Description = "This character has taken an Oath of Sacrifice, and is sworn to forgo self-care to see the company succeed. Such drive takes a toll on physical well-being, however.";
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
				text = "Is not paid any wage"
			},
			{
				id = 10,
				type = "hint",
				icon = "ui/icons/warning.png",
				text = "Injuries do not heal"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.DailyWageMult *= 0.0;
	}

});


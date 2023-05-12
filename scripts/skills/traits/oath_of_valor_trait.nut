this.oath_of_valor_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.oath_of_valor";
		this.m.Name = "Serment de Courage";
		this.m.Icon = "ui/traits/trait_icon_83.png";
		this.m.Description = "Ce personnage a prêté un serment de Courage et a juré de tenir bon dans la bataille, quel qu\'en soit le prix.";
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
				icon = "ui/icons/morale.png",
				text = "Ne fuit pas au combat"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15%[/color] d\'expérience"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.XPGainMult *= 0.85;
	}

});


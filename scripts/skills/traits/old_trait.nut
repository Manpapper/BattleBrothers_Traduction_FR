this.old_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.old";
		this.m.Name = "Vieux";
		this.m.Icon = "skills/status_effect_60.png";
		this.m.Description = "L\'Age a rattrapé ce personnage.";
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
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] de Détermination"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/health.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] de Points de Vie"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] de Fatigue Maximum"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] d\'Initiative"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-1[/color] de Vision"
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Est toujours content d'etre placé en réserve"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.Bravery += 10;
		_properties.Hitpoints -= 10;
		_properties.Stamina -= 10;
		_properties.Initiative -= 10;
		_properties.Vision -= 1;
		_properties.IsContentWithBeingInReserve = true;
	}

});


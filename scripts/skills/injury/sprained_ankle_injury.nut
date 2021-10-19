this.sprained_ankle_injury <- this.inherit("scripts/skills/injury/injury", {
	m = {},
	function create()
	{
		this.injury.create();
		this.m.ID = "injury.sprained_ankle";
		this.m.Name = "Cheville Foulée";
		this.m.Description = "Une cheville foulée fait que même l\'homme le plus rapide boitille sur le champ de bataille.";
		this.m.Type = this.m.Type | this.Const.SkillType.TemporaryInjury;
		this.m.DropIcon = "injury_icon_24";
		this.m.Icon = "ui/injury/injury_icon_24.png";
		this.m.IconMini = "injury_icon_24_mini";
		this.m.HealingTimeMin = 2;
		this.m.HealingTimeMax = 3;
	}

	function getTooltip()
	{
		local ret = [
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
				id = 7,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]1[/color] Point d\'action supplémentaire par tuile"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20%[/color] d\'Initiative"
			}
		];
		this.addTooltipHint(ret);
		return ret;
	}

	function onUpdate( _properties )
	{
		this.injury.onUpdate(_properties);

		if (!_properties.IsAffectedByInjuries || this.m.IsFresh && !_properties.IsAffectedByFreshInjuries)
		{
			return;
		}

		_properties.MovementAPCostAdditional += 1;
		_properties.InitiativeMult *= 0.8;
	}

});


this.infected_wound_injury <- this.inherit("scripts/skills/injury/injury", {
	m = {},
	function create()
	{
		this.injury.create();
		this.m.ID = "injury.infected_wound";
		this.m.Name = "Blessure Infectée";
		this.m.Description = "Une blessure sale qui s\'est infectée drainant la constitution de ce personne.";
		this.m.Type = this.m.Type | this.Const.SkillType.TemporaryInjury;
		this.m.DropIcon = "injury_icon_16";
		this.m.Icon = "ui/injury/injury_icon_16.png";
		this.m.IconMini = "injury_icon_16_mini";
		this.m.HealingTimeMin = 3;
		this.m.HealingTimeMax = 4;
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
				icon = "ui/icons/health.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] de Points de vie"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] de Fatigue Maximum"
			}
		];
		this.addTooltipHint(ret);
		return ret;
	}

	function onUpdate( _properties )
	{
		this.injury.onUpdate(_properties);

		if (this.m.IsShownOutOfCombat)
		{
			_properties.HitpointsMult *= 0.75;
			_properties.StaminaMult *= 0.75;
		}
	}

});


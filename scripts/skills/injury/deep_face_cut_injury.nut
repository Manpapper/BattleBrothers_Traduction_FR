this.deep_face_cut_injury <- this.inherit("scripts/skills/injury/injury", {
	m = {},
	function create()
	{
		this.injury.create();
		this.m.ID = "injury.deep_face_cut";
		this.m.Name = "Entaille Profonde sur le Visage";
		this.m.Description = "Une entaille Profonde d\'un bout à l\'autre du visage qui saigne abondamment sur les yeux, le nez et la bouche.";
		this.m.Type = this.m.Type | this.Const.SkillType.TemporaryInjury;
		this.m.DropIcon = "injury_icon_10";
		this.m.Icon = "ui/injury/injury_icon_10.png";
		this.m.IconMini = "injury_icon_10_mini";
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
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] de Maîtrise de Mélée"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] de Maîtrise à Distance"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] de Défense en Mêlée"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] de Défense à Distance"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/Vision.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-2[/color] de Vision"
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

		_properties.MeleeSkillMult *= 0.75;
		_properties.RangedSkillMult *= 0.75;
		_properties.MeleeDefenseMult *= 0.75;
		_properties.RangedDefenseMult *= 0.75;
		_properties.Vision -= 2;
	}

});


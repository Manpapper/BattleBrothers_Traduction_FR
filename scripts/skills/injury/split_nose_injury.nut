this.split_nose_injury <- this.inherit("scripts/skills/injury/injury", {
	m = {},
	function create()
	{
		this.injury.create();
		this.m.ID = "injury.split_nose";
		this.m.Name = "Nez Fendu";
		this.m.Description = "Un coup a fendu le nez de ce personnage ce qui rend la respirantion un exercice difficile qui fait avaler de grosse quantités de sang à ce personnage.";
		this.m.Type = this.m.Type | this.Const.SkillType.TemporaryInjury;
		this.m.DropIcon = "injury_icon_34";
		this.m.Icon = "ui/injury/injury_icon_34.png";
		this.m.IconMini = "injury_icon_34_mini";
		this.m.HealingTimeMin = 2;
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
				id = 11,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5[/color] de Fatigue par tour"
			}
		];
		this.addTooltipHint(ret);
		return ret;
	}

	function isValid( _actor )
	{
		if (_actor.getSkills().hasSkill("injury.missing_nose"))
		{
			return false;
		}

		return true;
	}

	function onUpdate( _properties )
	{
		this.injury.onUpdate(_properties);

		if (!_properties.IsAffectedByInjuries || this.m.IsFresh && !_properties.IsAffectedByFreshInjuries)
		{
			return;
		}

		_properties.FatigueRecoveryRate -= 5;
	}

});


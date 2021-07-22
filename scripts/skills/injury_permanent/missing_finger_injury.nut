this.missing_finger_injury <- this.inherit("scripts/skills/injury_permanent/permanent_injury", {
	m = {},
	function create()
	{
		this.permanent_injury.create();
		this.m.ID = "injury.missing_finger";
		this.m.Name = "Doigt Manquant";
		this.m.Description = "Un doigt manquant qui rend difficile d\'aggriper correctement une arme ou un bouclier. Mais, c\'est toujours une bonne histoire à raconter.";
		this.m.Icon = "ui/injury/injury_permanent_icon_02.png";
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
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5%[/color] de Maîtrise de Mêlée"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5%[/color] de Maîtrise à Distance"
			}
		];
		this.addTooltipHint(ret);
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.MeleeSkillMult *= 0.95;
		_properties.RangedSkillMult *= 0.95;
	}

	function onApplyAppearance()
	{
	}

});


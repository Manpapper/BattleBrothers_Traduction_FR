this.maimed_foot_injury <- this.inherit("scripts/skills/injury_permanent/permanent_injury", {
	m = {},
	function create()
	{
		this.permanent_injury.create();
		this.m.ID = "injury.maimed_foot";
		this.m.Name = "Pied Mutilé";
		this.m.Description = "Une blessure au pied qui n\'a jamais vraiment guérie complètement, ce qui rend difficile de gagner des compétitions de dance et aussi de bouger rapidement.";
		this.m.Icon = "ui/injury/injury_permanent_icon_06.png";
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
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]1[/color] de Point d\'Action supplémentaire nécessaire par tuile"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20%[/color] d\'Initiative"
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Est toujours content d'être placé en réserve"
			}
		];
		this.addTooltipHint(ret);
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.MovementAPCostAdditional += 1;
		_properties.InitiativeMult *= 0.8;
		_properties.IsContentWithBeingInReserve = true;
	}

	function onApplyAppearance()
	{
	}

});


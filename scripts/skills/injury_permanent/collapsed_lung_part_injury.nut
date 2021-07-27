this.collapsed_lung_part_injury <- this.inherit("scripts/skills/injury_permanent/permanent_injury", {
	m = {},
	function create()
	{
		this.permanent_injury.create();
		this.m.ID = "injury.collapsed_lung_part";
		this.m.Name = "Affaissement Partiel du Poumon";
		this.m.Description = "Une partie du poumon est morte, ce qui rend difficile pour ce personnage de récupérer après un effort.";
		this.m.Icon = "ui/injury/injury_permanent_icon_05.png";
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
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-40%[/color] de Fatigue Maximum"
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Est toujours content d\'être placé en réserve"
			}
		];
		this.addTooltipHint(ret);
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.StaminaMult *= 0.6;
		_properties.IsContentWithBeingInReserve = true;
	}

	function onApplyAppearance()
	{
	}

});


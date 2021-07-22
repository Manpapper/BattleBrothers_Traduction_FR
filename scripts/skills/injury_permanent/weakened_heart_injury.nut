this.weakened_heart_injury <- this.inherit("scripts/skills/injury_permanent/permanent_injury", {
	m = {},
	function create()
	{
		this.permanent_injury.create();
		this.m.ID = "injury.weakened_heart";
		this.m.Name = "Coeur Affaibli";
		this.m.Description = "Les blessures du passé ont laissé ce personnage avec un coeur affaibli, diminuant drastiquement sa constitution.";
		this.m.Icon = "ui/injury/injury_permanent_icon_14.png";
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
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-30%[/color] de Points de Vie"
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
		_properties.HitpointsMult *= 0.7;
		_properties.IsContentWithBeingInReserve = true;
	}

	function onApplyAppearance()
	{
	}

});


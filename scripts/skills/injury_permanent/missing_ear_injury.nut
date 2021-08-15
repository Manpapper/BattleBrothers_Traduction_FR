this.missing_ear_injury <- this.inherit("scripts/skills/injury_permanent/permanent_injury", {
	m = {},
	function create()
	{
		this.permanent_injury.create();
		this.m.ID = "injury.missing_ear";
		this.m.Name = "Oreille Manquante";
		this.m.Description = "Heureusement, une oreille manquante n\'est pas vraiment un problème dans la vie de tous les jours pour ce personnage. Mais c\'est vraiment immonde.";
		this.m.Icon = "ui/injury/injury_permanent_icon_01.png";
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
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] d\'Initiative"
			}
		];
		this.addTooltipHint(ret);
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.InitiativeMult *= 0.9;
	}

	function onApplyAppearance()
	{
		local sprite = this.getContainer().getActor().getSprite("permanent_injury_2");
		sprite.setBrush("permanent_injury_02");
		sprite.Visible = true;
	}

});


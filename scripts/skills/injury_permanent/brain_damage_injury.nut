this.brain_damage_injury <- this.inherit("scripts/skills/injury_permanent/permanent_injury", {
	m = {},
	function create()
	{
		this.permanent_injury.create();
		this.m.ID = "injury.brain_damage";
		this.m.Name = "Dommages Cérébraux";
		this.m.Description = "Un coup lourd à la tête secoue des choses et qui n\'aide pas vraiment les compétences cognitives de ce personnage. Le bon côté, il est maintenant probablement trop bête pour réaliser quand il faut fuir.";
		this.m.Icon = "ui/injury/injury_permanent_icon_12.png";
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
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15%[/color] de Détermination"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] de Gain d\'Expérience"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] d\'Initiative"
			}
		];
		this.addTooltipHint(ret);
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.BraveryMult *= 1.15;
		_properties.XPGainMult *= 0.75;
		_properties.InitiativeMult *= 0.75;
	}

	function onApplyAppearance()
	{
		local sprite = this.getContainer().getActor().getSprite("permanent_injury_1");
		sprite.setBrush("permanent_injury_01");
		sprite.Visible = true;
	}

});


this.net_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.net";
		this.m.Name = "Piégé dans un filet";
		this.m.Description = "Un grand filet retient ce personnage et l\'empêche de se défendre. Pour se libérer, il faudra couper le filet.";
		this.m.Icon = "skills/status_effect_58.png";
		this.m.IconMini = "status_effect_58_mini";
		this.m.Overlay = "status_effect_58";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		return [
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
				id = 9,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Impossible de bouger[/color]"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-45%[/color] de Défense en Mêlée"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-45%[/color] de Défense à Distance"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-45%[/color] d\'Initiative"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.IsRooted = true;
		_properties.MeleeDefenseMult *= 0.55;
		_properties.RangedDefenseMult *= 0.55;
		_properties.InitiativeMult *= 0.55;
	}

});


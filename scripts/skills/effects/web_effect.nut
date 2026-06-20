this.web_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.web";
		this.m.Name = "Piégé dans la toile";
		this.m.Description = "Une toile immense et collante retient ce personnage et l\'empêche de se défendre et de frapper avec force. Pour se libérer, il faudra couper la toile.";
		this.m.Icon = "skills/status_effect_80.png";
		this.m.IconMini = "status_effect_80_mini";
		this.m.Overlay = "status_effect_80";
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
				id = 13,
				type = "text",
				icon = "ui/icons/direct_damage.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Les dégâts infligés par l\'attaque d\'un Webknecht, multipliés par deux, ne tiendront pas compte de l\'armure[/color]"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50%[/color] de Dégâts"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50%[/color] de Défense en Mêlée"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50%[/color] de Défense à Distance"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50%[/color] d\'Initiative"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.IsRooted = true;
		_properties.DamageTotalMult *= 0.5;
		_properties.MeleeDefenseMult *= 0.5;
		_properties.RangedDefenseMult *= 0.5;
		_properties.InitiativeMult *= 0.5;
		_properties.TargetAttractionMult *= 1.5;
	}

});


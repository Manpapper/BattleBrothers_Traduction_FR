this.cat_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.cat_potion";
		this.m.Name = "Réflexes aiguisés";
		this.m.Icon = "skills/status_effect_93.png";
		this.m.IconMini = "status_effect_93_mini";
		this.m.Overlay = "status_effect_93";
		this.m.Type = this.Const.SkillType.StatusEffect | this.Const.SkillType.DrugEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
		this.m.IsSerialized = true;
	}

	function getDescription()
	{
		return "Grâce à un mélange de substances psychoactives, les sens de ce personnage sont exacerbés et ses réflexes aiguisés, ce qui s\'accompagne d\'une tendance à adopter un comportement paranoïaque.";
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
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20[/color] d\'Initiative"
			},
			{
				id = 7,
				type = "hint",
				icon = "ui/icons/action_points.png",
				text = "Disparaitra après encore une bataille"
			}
		];
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.Initiative += 20;
	}

});


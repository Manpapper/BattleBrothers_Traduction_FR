this.swamp_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "terrain.swamp";
		this.m.Name = "Swamp";
		this.m.Description = "Le sol marécageux entrave considérablement les mouvements et les capacités de combat.";
		this.m.Icon = "skills/terrain_icon_03.png";
		this.m.IconMini = "terrain_icon_03_mini";
		this.m.Type = this.Const.SkillType.Terrain | this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsHidden = false;
		this.m.IsSerialized = false;
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
				id = 10,
				type = "text",
				icon = "/ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] de Maîtrise de Mêlée"
			},
			{
				id = 11,
				type = "text",
				icon = "/ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] de Défense de Mêlée"
			},
			{
				id = 12,
				type = "text",
				icon = "/ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] de Défense à Distance"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.MeleeDefenseMult *= 0.75;
		_properties.RangedDefenseMult *= 0.75;
		_properties.MeleeSkillMult *= 0.75;
	}

});


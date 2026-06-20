this.night_vision_effect <- this.inherit("scripts/skills/skill", {
	m = {
		IsCountingBattle = false
	},
	function create()
	{
		this.m.ID = "effects.night_vision";
		this.m.Name = "Vision Nocturne";
		this.m.Icon = "skills/status_effect_98.png";
		this.m.IconMini = "status_effect_98_mini";
		this.m.Overlay = "status_effect_98";
		this.m.Type = this.Const.SkillType.StatusEffect | this.Const.SkillType.DrugEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
		this.m.IsSerialized = true;
	}

	function getDescription()
	{
		return "Grâce à une merveille alchimique, la nuit est aussi claire que le jour pour ce personnage.";
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
				icon = "ui/icons/special.png",
				text = "Non soumis aux pénalités nocturnes"
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

	function onCombatStarted()
	{
		this.m.IsCountingBattle = true;
	}

	function onCombatFinished()
	{
		if (!this.m.IsCountingBattle)
		{
			return;
		}

		this.removeSelf();
	}

	function onUpdate( _properties )
	{
		_properties.IsAffectedByNight = false;
	}

});


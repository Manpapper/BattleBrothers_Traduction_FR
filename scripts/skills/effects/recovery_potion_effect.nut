this.recovery_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {
		IsCountingBattle = false
	},
	function create()
	{
		this.m.ID = "effects.recovery_potion";
		this.m.Name = "Endurance Améliorée";
		this.m.Icon = "skills/status_effect_89.png";
		this.m.IconMini = "status_effect_89_mini";
		this.m.Overlay = "status_effect_89";
		this.m.Type = this.Const.SkillType.StatusEffect | this.Const.SkillType.DrugEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Je pourrais continuer comme ça toute la nuit ! Grâce à un cocktail de substances ergogéniques, appelé par euphémisme \"Potion du second souffle\", le cœur de ce personnage bat à tout rompre, il ne se fatigue pas facilement et son endurance est décuplée. Au fait, il commence à faire chaud ici, non ?";
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
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+4[/color] de récupération de Fatigue par tour"
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
		_properties.FatigueRecoveryRate += 4;
	}

});


this.iron_will_effect <- this.inherit("scripts/skills/skill", {
	m = {
		IsCountingBattle = false
	},
	function create()
	{
		this.m.ID = "effects.iron_will";
		this.m.Name = "Volonté de Fer";
		this.m.Icon = "skills/status_effect_92.png";
		this.m.IconMini = "status_effect_92_mini";
		this.m.Overlay = "status_effect_92";
		this.m.Type = this.Const.SkillType.StatusEffect | this.Const.SkillType.DrugEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Je me sens invincible ! Bon, ses sentiments pourraient bien trahir ce personnage, mais comme il ne ressent aucune blessure, ancienne ou récente, celles-ci ne l\'affecteront pas avant la fin du combat et la dissipation de l\'adrénaline.";
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
				text = "Non affecté par les blessures non permanentes"
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
		_properties.IsAffectedByInjuries = false;
	}

});


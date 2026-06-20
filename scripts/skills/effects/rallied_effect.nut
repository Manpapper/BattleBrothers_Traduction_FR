this.rallied_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.rallied";
		this.m.Name = "Rallié";
		this.m.Description = "Vous pouvez faire la différence ! Un chef charismatique a remonté le moral de ce personnage pour qu\'il mobilise toutes ses forces et continue d\'avancer. Un personnage ne peut être encouragé qu\'une seule fois par tour et ne peut pas encourager les autres lorsqu\'il vient lui-même d\'être encouragé.";
		this.m.Icon = "skills/status_effect_56.png";
		this.m.IconMini = "status_effect_56_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function onTurnEnd()
	{
		this.removeSelf();
	}

});


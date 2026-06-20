this.stealth_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.stealth";
		this.m.Name = "Furtif";
		this.m.Description = "TODO";
		this.m.Icon = "skills/status_effect_03.png";
		this.m.IconMini = "status_effect_03_mini";
		this.m.Overlay = "status_effect_03";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function onAdded()
	{
	}

	function onUpdate( _properties )
	{
		_properties.IsStealthed = true;
	}

	function onTurnStart()
	{
		this.removeSelf();
	}

	function onRemoved()
	{
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		this.removeSelf();
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		this.removeSelf();
	}

});


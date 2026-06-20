this.riposte_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.riposte";
		this.m.Name = "Riposte";
		this.m.Icon = "skills/status_effect_33.png";
		this.m.IconMini = "status_effect_33_mini";
		this.m.Overlay = "status_effect_33";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Ce personnage est prêt à riposter immédiatement en cas d\'échec d\'une tentative d\'attaque au corps à corps à son encontre.";
	}

	function onUpdate( _properties )
	{
		_properties.IsRiposting = true;
	}

	function onTurnStart()
	{
		this.removeSelf();
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (this.Tactical.TurnSequenceBar.getActiveEntity() == null || this.Tactical.TurnSequenceBar.getActiveEntity().getID() != this.getContainer().getActor().getID())
		{
			if (!this.getContainer().getActor().getCurrentProperties().IsSpecializedInSwords)
			{
				_properties.MeleeSkill -= 10;
			}
		}
	}

});


this.oath_of_fortification_warning <- this.inherit("scripts/skills/skill", {
	function create()
	{
		this.m.ID = "special.oath_of_fortification_warning";
		this.m.Name = "Fortification !";
		this.m.Icon = "skills/status_effect_159.png";
		this.m.IconMini = "status_effect_159_mini";
		this.m.Overlay = "status_effect_159";
		this.m.Description = "Ce personnage a prêté un serment de fortification et ne peut pas bouger pendant qu\'il se prépare au combat !";
		this.m.Type = this.Const.SkillType.Special | this.Const.SkillType.StatusEffect | this.Const.SkillType.Alert;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsActive = false;
		this.m.IsHidden = true;
	}

	function onTurnStart()
	{
		if (!this.isHidden())
		{
			this.spawnIcon("status_effect_159", this.getContainer().getActor().getTile());
		}
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();

		if (actor.getSkills().hasSkill("trait.oath_of_fortification") && actor.isPlacedOnMap() && this.Time.getRound() <= 1)
		{
			_properties.IsRooted = true;
			this.m.IsHidden = false;
		}
		else
		{
			this.m.IsHidden = true;
		}
	}

});


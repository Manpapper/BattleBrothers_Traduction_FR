this.perk_killing_frenzy <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.killing_frenzy";
		this.m.Name = this.Const.Strings.PerkName.KillingFrenzy;
		this.m.Description = this.Const.Strings.PerkDescription.KillingFrenzy;
		this.m.Icon = "ui/perks/perk_36.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		if (!_targetEntity.isAlliedWith(this.getContainer().getActor()))
		{
			local effect = this.getContainer().getActor().getSkills().getSkillByID("effects.killing_frenzy");

			if (effect != null)
			{
				effect.reset();
			}
			else
			{
				this.getContainer().add(this.new("scripts/skills/effects/killing_frenzy_effect"));
			}
		}
	}

	function onUpdated( _properties )
	{
		_properties.TargetAttractionMult *= 1.2;
	}

});


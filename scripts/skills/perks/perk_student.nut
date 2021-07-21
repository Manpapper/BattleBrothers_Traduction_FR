this.perk_student <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.student";
		this.m.Name = this.Const.Strings.PerkName.Student;
		this.m.Description = this.Const.Strings.PerkDescription.Student;
		this.m.Icon = "ui/perks/perk_21.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		if (this.getContainer().getActor().getLevel() < 11)
		{
			_properties.XPGainMult *= 1.2;
		}
	}

});


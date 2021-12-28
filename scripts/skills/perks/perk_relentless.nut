this.perk_relentless <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.relentless";
		this.m.Name = this.Const.Strings.PerkName.Relentless;
		this.m.Description = this.Const.Strings.PerkDescription.Relentless;
		this.m.Icon = "ui/perks/perk_26.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.FatigueToInitiativeRate *= 0.5;
		_properties.InitiativeAfterWaitMult = 1.0;
	}

});


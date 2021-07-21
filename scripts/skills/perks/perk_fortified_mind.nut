this.perk_fortified_mind <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.fortified_mind";
		this.m.Name = this.Const.Strings.PerkName.FortifiedMind;
		this.m.Description = this.Const.Strings.PerkDescription.FortifiedMind;
		this.m.Icon = "ui/perks/perk_08.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.BraveryMult *= 1.25;
	}

});


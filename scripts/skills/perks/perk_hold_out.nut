this.perk_hold_out <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.hold_out";
		this.m.Name = this.Const.Strings.PerkName.HoldOut;
		this.m.Description = this.Const.Strings.PerkDescription.HoldOut;
		this.m.Icon = "ui/perks/perk_04.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.NegativeStatusEffectDuration += -5;
	}

});


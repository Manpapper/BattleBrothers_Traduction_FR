this.perk_bullseye <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.bullseye";
		this.m.Name = this.Const.Strings.PerkName.Bullseye;
		this.m.Description = this.Const.Strings.PerkDescription.Bullseye;
		this.m.Icon = "ui/perks/perk_17.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.RangedAttackBlockedChanceMult *= 0.66;
	}

});


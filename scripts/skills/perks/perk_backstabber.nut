this.perk_backstabber <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.backstabber";
		this.m.Name = this.Const.Strings.PerkName.Backstabber;
		this.m.Description = this.Const.Strings.PerkDescription.Backstabber;
		this.m.Icon = "ui/perks/perk_40.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.SurroundedBonus = 10;
	}

});


this.perk_mastery_axe <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.mastery.axe";
		this.m.Name = this.Const.Strings.PerkName.SpecAxe;
		this.m.Description = this.Const.Strings.PerkDescription.SpecAxe;
		this.m.Icon = "ui/perks/perk_10.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInAxes = true;
	}

});


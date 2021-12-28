this.perk_captain <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.captain";
		this.m.Name = this.Const.Strings.PerkName.Captain;
		this.m.Description = this.Const.Strings.PerkDescription.Captain;
		this.m.Icon = "ui/perks/perk_26.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

});


this.perk_shield_bash <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.shield_bash";
		this.m.Name = this.Const.Strings.PerkName.ShieldBash;
		this.m.Description = this.Const.Strings.PerkDescription.ShieldBash;
		this.m.Icon = "ui/perks/perk_22.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

});


this.perk_dodge <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.dodge";
		this.m.Name = this.Const.Strings.PerkName.Dodge;
		this.m.Description = this.Const.Strings.PerkDescription.Dodge;
		this.m.Icon = "ui/perks/perk_01.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onCombatStarted()
	{
		this.getContainer().add(this.new("scripts/skills/effects/dodge_effect"));
	}

	function onRemoved()
	{
		this.getContainer().removeByID("effects.dodge");
	}

});


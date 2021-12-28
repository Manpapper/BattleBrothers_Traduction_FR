this.perk_recover <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.recover";
		this.m.Name = this.Const.Strings.PerkName.Recover;
		this.m.Description = this.Const.Strings.PerkDescription.Recover;
		this.m.Icon = "ui/perks/perk_21.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.m.Container.hasSkill("actives.recover"))
		{
			this.m.Container.add(this.new("scripts/skills/actives/recover_skill"));
		}
	}

	function onRemoved()
	{
		this.m.Container.removeByID("actives.recover");
	}

});


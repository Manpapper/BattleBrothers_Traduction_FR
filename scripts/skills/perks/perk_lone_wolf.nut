this.perk_lone_wolf <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lone_wolf";
		this.m.Name = this.Const.Strings.PerkName.LoneWolf;
		this.m.Description = this.Const.Strings.PerkDescription.LoneWolf;
		this.m.Icon = "ui/perks/perk_37.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.m.Container.hasSkill("effects.lone_wolf"))
		{
			this.m.Container.add(this.new("scripts/skills/effects/lone_wolf_effect"));
		}
	}

	function onRemoved()
	{
		this.m.Container.removeByID("effects.lone_wolf");
	}

});


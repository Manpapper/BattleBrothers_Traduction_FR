this.perk_footwork <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.footwork";
		this.m.Name = this.Const.Strings.PerkName.Footwork;
		this.m.Description = this.Const.Strings.PerkDescription.Footwork;
		this.m.Icon = "ui/perks/perk_25.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.m.Container.hasSkill("actives.footwork"))
		{
			this.m.Container.add(this.new("scripts/skills/actives/footwork"));
		}
	}

	function onRemoved()
	{
		this.m.Container.removeByID("actives.footwork");
	}

});


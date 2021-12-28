this.perk_rotation <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.rotation";
		this.m.Name = this.Const.Strings.PerkName.Rotation;
		this.m.Description = this.Const.Strings.PerkDescription.Rotation;
		this.m.Icon = "ui/perks/perk_11.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.m.Container.hasSkill("actives.rotation"))
		{
			this.m.Container.add(this.new("scripts/skills/actives/rotation"));
		}
	}

	function onRemoved()
	{
		this.m.Container.removeByID("actives.rotation");
	}

});


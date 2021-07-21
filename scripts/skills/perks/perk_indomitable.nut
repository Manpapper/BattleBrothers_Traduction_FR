this.perk_indomitable <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.indomitable";
		this.m.Name = this.Const.Strings.PerkName.Indomitable;
		this.m.Description = this.Const.Strings.PerkDescription.Indomitable;
		this.m.Icon = "ui/perks/perk_30.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.m.Container.hasSkill("actives.indomitable"))
		{
			this.m.Container.add(this.new("scripts/skills/actives/indomitable"));
		}
	}

	function onRemoved()
	{
		this.m.Container.removeByID("actives.indomitable");
	}

});


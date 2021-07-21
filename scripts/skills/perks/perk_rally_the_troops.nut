this.perk_rally_the_troops <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.rally_the_troops";
		this.m.Name = this.Const.Strings.PerkName.RallyTheTroops;
		this.m.Description = this.Const.Strings.PerkDescription.RallyTheTroops;
		this.m.Icon = "ui/perks/perk_42.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.m.Container.hasSkill("actives.rally_the_troops"))
		{
			this.m.Container.add(this.new("scripts/skills/actives/rally_the_troops"));
		}
	}

	function onRemoved()
	{
		this.m.Container.removeByID("actives.rally_the_troops");
	}

	function onUpdated( _properties )
	{
		_properties.TargetAttractionMult *= 1.33;
	}

});


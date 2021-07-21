this.perk_adrenalin <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.adrenaline";
		this.m.Name = this.Const.Strings.PerkName.Adrenaline;
		this.m.Description = this.Const.Strings.PerkDescription.Adrenaline;
		this.m.Icon = "ui/perks/perk_37.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.m.Container.hasSkill("actives.adrenaline"))
		{
			this.m.Container.add(this.new("scripts/skills/actives/adrenaline_skill"));
		}
	}

	function onRemoved()
	{
		this.m.Container.removeByID("actives.adrenaline");
	}

	function onUpdated( _properties )
	{
		_properties.TargetAttractionMult *= 1.1;
	}

});


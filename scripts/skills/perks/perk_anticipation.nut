this.perk_anticipation <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.anticipation";
		this.m.Name = this.Const.Strings.PerkName.Anticipation;
		this.m.Description = this.Const.Strings.PerkDescription.Anticipation;
		this.m.Icon = "ui/perks/perk_10.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onBeingAttacked( _attacker, _skill, _properties )
	{
		local dist = _attacker.getTile().getDistanceTo(this.getContainer().getActor().getTile());
		_properties.RangedDefense += this.Math.max(10, this.Math.floor(dist * (1 + this.getContainer().getActor().getBaseProperties().getRangedDefense() * 0.1)));
	}

});


this.perk_mastery_throwing <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.mastery.throwing";
		this.m.Name = this.Const.Strings.PerkName.SpecThrowing;
		this.m.Description = this.Const.Strings.PerkDescription.SpecThrowing;
		this.m.Icon = "ui/perks/perk_10.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsSpecializedInThrowing = true;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_targetEntity == null)
		{
			return;
		}

		if (_skill.isRanged() && (_skill.getID() == "actives.throw_axe" || _skill.getID() == "actives.throw_balls" || _skill.getID() == "actives.throw_javelin" || _skill.getID() == "actives.throw_spear" || _skill.getID() == "actives.sling_stone"))
		{
			local d = this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile());

			if (d <= 2)
			{
				_properties.DamageTotalMult *= 1.4;
			}
			else if (d <= 3)
			{
				_properties.DamageTotalMult *= 1.2;
			}
		}
	}

});


this.perk_gifted <- this.inherit("scripts/skills/skill", {
	m = {
		IsApplied = false
	},
	function create()
	{
		this.m.ID = "perk.gifted";
		this.m.Name = this.Const.Strings.PerkName.Gifted;
		this.m.Description = this.Const.Strings.PerkDescription.Gifted;
		this.m.Icon = "ui/perks/perk_21.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.m.IsApplied)
		{
			this.m.IsApplied = true;
			local actor = this.getContainer().getActor();
			actor.m.LevelUps += 1;
			actor.fillAttributeLevelUpValues(1, true);
		}
	}

	function onDeserialize( _in )
	{
		this.skill.onDeserialize(_in);
		this.m.IsApplied = true;
	}

});


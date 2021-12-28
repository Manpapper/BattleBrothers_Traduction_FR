this.perk_battle_flow <- this.inherit("scripts/skills/skill", {
	m = {
		IsSpent = false
	},
	function create()
	{
		this.m.ID = "perk.battle_flow";
		this.m.Name = this.Const.Strings.PerkName.BattleFlow;
		this.m.Description = this.Const.Strings.PerkDescription.BattleFlow;
		this.m.Icon = "ui/perks/perk_41.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		if (!this.m.IsSpent)
		{
			this.m.IsSpent = true;
			local actor = this.getContainer().getActor();
			actor.setFatigue(this.Math.max(0, actor.getFatigue() - actor.getBaseProperties().Stamina * actor.getBaseProperties().StaminaMult * 0.15));
			actor.setDirty(true);
		}
	}

	function onTurnStart()
	{
		this.m.IsSpent = false;
	}

});


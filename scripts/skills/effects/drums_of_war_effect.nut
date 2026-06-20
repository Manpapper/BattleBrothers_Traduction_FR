this.drums_of_war_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.drums_of_war";
		this.m.Name = "Tambours de la guerre";
		this.m.Description = "";
		this.m.Icon = "skills/status_effect_105.png";
		this.m.Overlay = "status_effect_105";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsHidden = true;
		this.m.IsRemovedAfterBattle = true;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		actor.setFatigue(this.Math.max(0, actor.getFatigue() - 15));
		this.spawnIcon(this.m.Overlay, actor.getTile());
	}

	function onTurnEnd()
	{
		this.removeSelf();
	}

});


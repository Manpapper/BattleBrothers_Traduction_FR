this.voice_of_davkul_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.voice_of_davkul";
		this.m.Name = "Voix de Davkul";
		this.m.Description = "Ce personnage a entendu la voix de Davkul proclamer la vérité à travers son vaisseau de chair. Il est prêt à dépasser ses limites physiques pour obéir aux ordres de son dieu.";
		this.m.Icon = "skills/status_effect_112.png";
		this.m.IconMini = "status_effect_112_mini";
		this.m.Overlay = "status_effect_112";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsHidden = true;
		this.m.IsRemovedAfterBattle = true;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		actor.setFatigue(this.Math.max(0, actor.getFatigue() - 10));
		this.spawnIcon(this.m.Overlay, actor.getTile());
	}

	function onTurnEnd()
	{
		this.removeSelf();
	}

});


this.lesser_flesh_golem_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.lesser_flesh_golem_potion";
		this.m.Name = "Stéroïde Etrange";
		this.m.Icon = "skills/status_effect_155.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_155";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Le corps de ce personnage a changé, sans doute pour le mieux, à la suite de l\'utilisation d\'un stéroïde de synthèse.";
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isLesserFleshGolemPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isLesserFleshGolemPotionAcquired", false);
	}

});


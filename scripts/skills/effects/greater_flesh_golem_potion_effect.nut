this.greater_flesh_golem_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.greater_flesh_golem_potion";
		this.m.Name = "Glandes Mutées";
		this.m.Icon = "skills/status_effect_156.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_156";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Le corps de ce personnage a subi une mutation irréversible, son équilibre chimique ayant été bouleversé par une surproduction glandulaire. Par miracle, cet état semble s\'être stabilisé de manière bénéfique.";
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isGreaterFleshGolemPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isGreaterFleshGolemPotionAcquired", false);
	}

});


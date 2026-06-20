this.grand_diviner_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.grand_diviner_potion";
		this.m.Name = "Regard Maudit";
		this.m.Icon = "skills/status_effect_152.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_152";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Ce personnage a été témoin de choses qu\'il n\'aurait jamais dû voir et puise dans une expérience qui n\'est pas la sienne. On peut entrevoir la terreur sans bornes qui se lit sur son visage dans ces rares moments où on le surprend seul. À moins que ce ne soit simplement le poids de la vie de mercenaire qui finisse par avoir raison de lui.";
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isGrandDivinerPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isGrandDivinerPotionAcquired", false);
	}

});


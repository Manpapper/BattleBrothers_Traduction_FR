this.fallen_hero_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.fallen_hero_potion";
		this.m.Name = "Tissu musculaire réactif";
		this.m.Icon = "skills/status_effect_136.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_136";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Le corps de ce personnage réagit aux traumatismes physiques en sécrétant une substance calcaire qui provoque une contraction réflexe des muscles aux points d\'impact, afin de minimiser les lésions musculaires.";
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Ce personnage n\'accumule pas de fatigue suite aux attaques ennemies, qu\'elles touchent ou non leur cible."
			},
			{
				id = 12,
				type = "hint",
				icon = "ui/tooltips/warning.png",
				text = "D\'autres mutations entraîneront une durée de maladie plus longue."
			}
		];
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.FatigueLossOnAnyAttackMult = 0.0;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isFallenHeroPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isFallenHeroPotionAcquired", false);
	}

});


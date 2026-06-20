this.schrat_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.schrat_potion";
		this.m.Name = "Ligaments Souples";
		this.m.Icon = "skills/status_effect_146.png";
		this.m.IconMini = "status_effect_146_mini";
		this.m.Overlay = "status_effect_146";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Les jambes de ce personnage ont subi une mutation qui leur permet de réagir beaucoup plus rapidement et avec beaucoup plus de puissance aux forces extérieures. Concrètement, elles lui permettent de conserver son équilibre et de résister à pratiquement toute tentative visant à le repousser ou à le déséquilibrer.";
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
				text = "Immunisé contre les repoussements et les saisies"
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
		_properties.IsImmuneToKnockBackAndGrab = true;
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isSchratPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isSchratPotionAcquired", false);
	}

});


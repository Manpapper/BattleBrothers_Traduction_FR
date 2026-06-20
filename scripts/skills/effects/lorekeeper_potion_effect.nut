this.lorekeeper_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {
		IsSpent = false,
		LastFrameUsed = 0
	},
	function isSpent()
	{
		return this.m.IsSpent;
	}

	function getLastFrameUsed()
	{
		return this.m.LastFrameUsed;
	}

	function create()
	{
		this.m.ID = "effects.lorekeeper_potion";
		this.m.Name = "Os de côte du Gardien du savoir";
		this.m.Icon = "skills/status_effect_151.png";
		this.m.IconMini = "status_effect_151_mini";
		this.m.Overlay = "status_effect_151";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Ce personnage a vu une partie du squelette du Gardien du savoir fusionner avec son corps, ce qui lui confère la capacité de se remettre rapidement de blessures apparemment mortelles. Maintenant, s\'il pouvait seulement passer la nuit sans hurler dans son sommeil…";
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
				text = "Une fois par combat, lorsque vous recevez un coup fatal, vous survivez et retrouvez tous vos points de vie."
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

	function setSpent( _f )
	{
		this.m.IsSpent = _f;
		this.m.LastFrameUsed = this.Time.getFrame();
	}

	function onCombatStarted()
	{
		this.m.IsSpent = false;
		this.m.LastFrameUsed = 0;
	}

	function onCombatFinished()
	{
		this.m.IsSpent = false;
		this.m.LastFrameUsed = 0;
		this.skill.onCombatFinished();
	}

	function onUpdate( _properties )
	{
		if (this.m.IsSpent && this.m.LastFrameUsed == this.Time.getFrame())
		{
			this.getContainer().removeByType(this.Const.SkillType.DamageOverTime);
		}
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isLorekeeperPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isLorekeeperPotionAcquired", false);
	}

});


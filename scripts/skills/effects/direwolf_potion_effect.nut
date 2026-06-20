this.direwolf_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {
		SkillsUsed = {}
	},
	function create()
	{
		this.m.ID = "effects.direwolf_potion";
		this.m.Name = "Tendon Elastique";
		this.m.Icon = "skills/status_effect_139.png";
		this.m.IconMini = "";
		this.m.Overlay = "status_effect_139";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
	}

	function getDescription()
	{
		return "Les muscles de ce personnage ont subi une mutation et réagissent différemment aux impulsions de mouvement. Il est donc beaucoup moins fatigant d\'interrompre ou d\'arrêter un mouvement en cours, ce qui facilite grandement la récupération après des attaques ratées ou bloquées.";
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
				text = "Les attaques qui ratent leur cible ont [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color] d\'avoir le coup en Fatigue remboursé"
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

	function getSkillsUsed()
	{
		return this.m.SkillsUsed;
	}

	function onTurnStarted()
	{
		this.m.SkillsUsed = {};
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		if (!(this.Const.SkillCounter in this.m.SkillsUsed))
		{
			this.m.SkillsUsed[this.Const.SkillCounter] <- _skill.getFatigueCost() / 2;
			local tag = {
				Actor = this.getContainer().getActor(),
				SkillCounter = this.Const.SkillCounter,
				Skill = this
			};
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 400, this.onTargedMissedCallback, tag);
		}
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (this.Const.SkillCounter in this.m.SkillsUsed)
		{
			this.m.SkillsUsed[this.Const.SkillCounter] = 0;
		}
		else
		{
			this.m.SkillsUsed[this.Const.SkillCounter] <- 0;
		}
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		if (this.Const.SkillCounter in this.m.SkillsUsed)
		{
			this.m.SkillsUsed[this.Const.SkillCounter] = 0;
		}
		else
		{
			this.m.SkillsUsed[this.Const.SkillCounter] <- 0;
		}
	}

	function onTargedMissedCallback( _tag )
	{
		local SkillsUsed = _tag.Skill.getSkillsUsed();

		if ((_tag.SkillCounter in SkillsUsed) && _tag.Actor.isAlive() && this.Tactical.TurnSequenceBar.getActiveEntity().getID() == _tag.Actor.getID())
		{
			_tag.Actor.setFatigue(_tag.Actor.getFatigue() - SkillsUsed[_tag.SkillCounter]);
			_tag.Actor.setDirty(true);
		}
	}

	function onDeath( _fatalityType )
	{
		if (_fatalityType != this.Const.FatalityType.Unconscious)
		{
			this.World.Statistics.getFlags().set("isDirewolfPotionAcquired", false);
		}
	}

	function onDismiss()
	{
		this.World.Statistics.getFlags().set("isDirewolfPotionAcquired", false);
	}

});


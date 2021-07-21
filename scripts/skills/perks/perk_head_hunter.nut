this.perk_head_hunter <- this.inherit("scripts/skills/skill", {
	m = {
		Stacks = 0,
		SkillCount = 0
	},
	function create()
	{
		this.m.ID = "perk.head_hunter";
		this.m.Name = this.Const.Strings.PerkName.HeadHunter;
		this.m.Description = this.Const.Strings.PerkDescription.HeadHunter;
		this.m.Icon = "ui/perks/perk_15.png";
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk | this.Const.SkillOrder.Any;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}

	function getDescription()
	{
		return "This character is guaranteed to land a hit to the head if the next attack connects.";
	}

	function onUpdate( _properties )
	{
		this.m.IsHidden = this.m.Stacks == 0;

		if (this.m.Stacks != 0)
		{
			_properties.HitChance[this.Const.BodyPart.Head] = 100.0;
		}
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_bodyPart == this.Const.BodyPart.Head)
		{
			if (this.m.Stacks == 0 && this.m.SkillCount != this.Const.SkillCounter)
			{
				this.m.Stacks = 1;
				this.m.SkillCount = this.Const.SkillCounter;
			}
			else
			{
				this.m.Stacks = 0;
			}

			this.getContainer().getActor().setDirty(true);
		}
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		if (this.m.Stacks != 0)
		{
			this.m.Stacks = 0;
			this.getContainer().getActor().setDirty(true);
		}
	}

	function onCombatStarted()
	{
		this.m.Stacks = 0;
		this.m.SkillCount = 0;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.Stacks = 0;
		this.m.SkillCount = 0;
		this.m.IsHidden = true;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill.isAttack() && this.m.Stacks != 0)
		{
			_properties.HitChanceMult[this.Const.BodyPart.Body] = 0.0;
		}
	}

});


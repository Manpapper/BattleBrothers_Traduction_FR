this.perk_fast_adaption <- this.inherit("scripts/skills/skill", {
	m = {
		Stacks = 0,
		Frame = 0,
		SkillCount = 0
	},
	function create()
	{
		this.m.ID = "perk.fast_adaption";
		this.m.Name = this.Const.Strings.PerkName.FastAdaption;
		this.m.Description = this.Const.Strings.PerkDescription.FastAdaption;
		this.m.Icon = "ui/perks/perk_33.png";
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk | this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}

	function isBonusActive()
	{
		return this.m.Stacks != 0;
	}

	function getDescription()
	{
		return "This character is adapting fast to their opponent\'s moves and gains an additional [color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.Stacks * 10 + "%[/color] chance to hit with any attack.";
	}

	function onUpdate( _properties )
	{
		this.m.IsHidden = this.m.Stacks == 0;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_targetEntity != null && this.isKindOf(_targetEntity, "actor"))
		{
			local dirty = this.m.Stacks != 0;
			this.m.Stacks = 0;
			this.m.Frame = 0;
			this.m.SkillCount = 0;
			this.m.IsHidden = true;

			if (dirty)
			{
				this.getContainer().getActor().setDirty(true);
			}
		}
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		if (this.Time.getFrame() != this.m.Frame && this.m.SkillCount != this.Const.SkillCounter)
		{
			++this.m.Stacks;
			this.m.Frame = this.Time.getFrame();
			this.m.SkillCount = this.Const.SkillCounter;
			this.m.IsHidden = false;

			if (this.m.Stacks == 1)
			{
				this.getContainer().getActor().setDirty(true);
			}
		}
	}

	function onCombatStarted()
	{
		this.m.Stacks = 0;
		this.m.Frame = 0;
		this.m.SkillCount = 0;
		this.m.IsHidden = true;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.Stacks = 0;
		this.m.Frame = 0;
		this.m.SkillCount = 0;
		this.m.IsHidden = true;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (this.m.Stacks != 0 && _skill.isAttack())
		{
			_properties.MeleeSkill += 10 * this.m.Stacks;
			_properties.RangedSkill += 10 * this.m.Stacks;
		}
	}

});


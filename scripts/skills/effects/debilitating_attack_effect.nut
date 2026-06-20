this.debilitating_attack_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.debilitating_attack";
		this.m.Name = "Attaque Invalidante";
		this.m.Description = "Ce personnage dispose d\'une attaque invalidante. Si l\'attaque touche sa cible, celle-ci verra sa capacité à infliger des dégâts temporairement réduite pendant un tour. Si l\'attaque rate, l\'effet sera perdu.";
		this.m.Icon = "ui/perks/perk_34.png";
		this.m.IconMini = "perk_34_mini";
		this.m.SoundOnHit = [
			"sounds/combat/cleave_hit_hitpoints_01.wav",
			"sounds/combat/cleave_hit_hitpoints_02.wav",
			"sounds/combat/cleave_hit_hitpoints_03.wav"
		];
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		return [
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
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50%[/color] de Dégâts infligés à la cible touchée pendant un tour"
			}
		];
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (!this.isGarbage() && _skill.isAttack() && _targetEntity.isAlive() && !_targetEntity.isDying())
		{
			local user = this.getContainer().getActor();

			if (this.m.SoundOnHit.len() > 0)
			{
				this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, _targetEntity.getPos());
			}

			local effect = this.new("scripts/skills/effects/debilitated_effect");
			_targetEntity.getSkills().add(effect);
			this.removeSelf();
		}
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		this.removeSelf();
	}

});


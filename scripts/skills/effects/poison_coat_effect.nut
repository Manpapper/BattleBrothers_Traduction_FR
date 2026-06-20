this.poison_coat_effect <- this.inherit("scripts/skills/skill", {
	m = {
		AttacksLeft = 4
	},
	function create()
	{
		this.m.ID = "effects.poison_coat";
		this.m.Name = "Arme enduite de poison";
		this.m.Icon = "skills/status_effect_66.png";
		this.m.IconMini = "status_effect_66_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Ce personnage utilise une arme enduite de poison. Les prochains coups infligeant au moins [color=" + this.Const.UI.Color.NegativeValue + "]" + this.Const.Combat.PoisonEffectMinDamage + "[/color] de Dégâts l\'appliqueront. Les cibles touchées auront une vision floue et auront du mal à coordonner leurs mouvements jusqu\'à ce que l\'effet se dissipe.";
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
			}
		];
	}

	function resetTime()
	{
		if (this.getContainer().getActor().isPlacedOnMap())
		{
			this.spawnIcon("status_effect_54", this.getContainer().getActor().getTile());
		}

		this.m.AttacksLeft = 4;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		--this.m.AttacksLeft;

		if (this.m.AttacksLeft <= 0)
		{
			this.removeSelf();
		}

		if (!_targetEntity.isAlive())
		{
			return;
		}

		if (_targetEntity.getCurrentProperties().IsImmuneToPoison || _damageInflictedHitpoints < this.Const.Combat.PoisonEffectMinDamage || _targetEntity.getHitpoints() <= 0)
		{
			return;
		}

		if (_targetEntity.getFlags().has("undead"))
		{
			return;
		}

		if (!_targetEntity.isHiddenToPlayer())
		{
			if (this.m.SoundOnUse.len() != 0)
			{
				this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 1.5, _targetEntity.getPos());
			}

			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_targetEntity) + " est empoissoné");
		}

		local poison = _targetEntity.getSkills().getSkillByID("effects.goblin_poison");

		if (poison == null)
		{
			_targetEntity.getSkills().add(this.new("scripts/skills/effects/goblin_poison_effect"));
		}
		else
		{
			poison.resetTime();
		}
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		--this.m.AttacksLeft;

		if (this.m.AttacksLeft <= 0)
		{
			this.removeSelf();
		}
	}

});


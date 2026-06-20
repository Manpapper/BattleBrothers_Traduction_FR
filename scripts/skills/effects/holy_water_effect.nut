this.holy_water_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 3,
		LastRoundApplied = 0
	},
	function create()
	{
		this.m.ID = "effects.holy_water";
		this.m.Name = "Aspergé d\'eau bénite";
		this.m.Icon = "skills/status_effect_68.png";
		this.m.IconMini = "status_effect_68_mini";
		this.m.Overlay = "status_effect_68";
		this.m.SoundOnUse = [
			"sounds/combat/poison_applied_01.wav",
			"sounds/combat/poison_applied_02.wav"
		];
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = true;
		this.m.IsRemovedAfterBattle = true;
	}

	function resetTime()
	{
		this.m.TurnsLeft = this.Math.max(1, 3 + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);

		if (this.m.SoundOnUse.len() != 0)
		{
			this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 1.25, this.getContainer().getActor().getPos());
		}

		this.spawnIcon(this.m.Overlay, this.getContainer().getActor().getTile());
	}

	function applyDamage( _dropIcon = true )
	{
		if (this.m.LastRoundApplied != this.Time.getRound())
		{
			this.m.LastRoundApplied = this.Time.getRound();
			local actor = this.getContainer().getActor();

			if (!actor.isHiddenToPlayer())
			{
				if (_dropIcon)
				{
					this.spawnIcon(this.m.Overlay, this.getContainer().getActor().getTile());
				}

				if (this.m.SoundOnUse.len() != 0)
				{
					this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 1.2, actor.getPos());
				}

				for( local i = 0; i < this.Const.Tactical.AcidParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(true, this.Const.Tactical.AcidParticles[i].Brushes, this.getContainer().getActor().getTile(), this.Const.Tactical.AcidParticles[i].Delay, this.Const.Tactical.AcidParticles[i].Quantity, this.Const.Tactical.AcidParticles[i].LifeTimeQuantity, this.Const.Tactical.AcidParticles[i].SpawnRate, this.Const.Tactical.AcidParticles[i].Stages);
				}
			}

			local hitInfo = clone this.Const.Tactical.HitInfo;
			hitInfo.DamageRegular = 20;
			hitInfo.DamageDirect = 1.0;
			hitInfo.BodyPart = this.Const.BodyPart.Body;
			hitInfo.BodyDamageMult = 1.0;
			hitInfo.FatalityChanceMult = 0.0;
			this.getContainer().getActor().onDamageReceived(this.getContainer().getActor(), this, hitInfo);

			if (--this.m.TurnsLeft <= 0)
			{
				this.removeSelf();
			}
		}
	}

	function onAdded()
	{
		this.m.TurnsLeft = this.Math.max(1, 3 + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);

		if (!this.getContainer().getActor().isHiddenToPlayer())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " a été aspergé d\'eau bénite");
		}

		this.applyDamage(false);
	}

	function onUpdate( _properties )
	{
	}

	function onTurnEnd()
	{
		this.applyDamage();
	}

	function onWaitTurn()
	{
		this.applyDamage();
	}

});


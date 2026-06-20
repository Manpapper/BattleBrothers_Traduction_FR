this.bleeding_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 2,
		Damage = 5,
		LastRoundApplied = 0
	},
	function getDamage()
	{
		return this.m.Damage;
	}

	function setDamage( _d )
	{
		this.m.Damage = _d;
	}

	function create()
	{
		this.m.ID = "effects.bleeding";
		this.m.Name = "Saignement";
		this.m.KilledString = "Mort par hémorragie";
		this.m.Icon = "skills/status_effect_01.png";
		this.m.IconMini = "status_effect_01_mini";
		this.m.Overlay = "status_effect_01";
		this.m.Type = this.Const.SkillType.StatusEffect | this.Const.SkillType.DamageOverTime;
		this.m.IsActive = false;
		this.m.IsStacking = true;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Ce personnage saigne abondamment d\'une blessure récente et va perdre [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.Damage + "[/color] points de vie à chaque tour pendant encore [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] tour(s).";
	}

	function applyDamage()
	{
		if (this.m.LastRoundApplied != this.Time.getRound())
		{
			this.m.LastRoundApplied = this.Time.getRound();
			local actor = this.getContainer().getActor();
			this.spawnIcon("status_effect_01", actor.getTile());
			local hitInfo = clone this.Const.Tactical.HitInfo;
			hitInfo.DamageRegular = this.m.Damage * (actor.getSkills().hasSkill("effects.hyena_potion") ? 0.5 : 1.0);
			hitInfo.DamageDirect = 1.0;
			hitInfo.BodyPart = this.Const.BodyPart.Body;
			hitInfo.BodyDamageMult = 1.0;
			hitInfo.FatalityChanceMult = 0.0;
			actor.onDamageReceived(actor, this, hitInfo);

			if (--this.m.TurnsLeft <= 0)
			{
				this.removeSelf();
			}
		}
	}

	function onAdded()
	{
		if (this.getContainer().getActor().getCurrentProperties().IsResistantToAnyStatuses && this.Math.rand(1, 100) <= 50)
		{
			if (!this.getContainer().getActor().isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " sa blessure sanglante s\'est rapidement refermée grâce à sa physiologie hors du commun");
			}

			this.removeSelf();
		}
		else
		{
			this.m.TurnsLeft = this.Math.max(1, 2 + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);

			if (this.getContainer().hasSkill("trait.bleeder"))
			{
				++this.m.TurnsLeft;
			}
		}
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


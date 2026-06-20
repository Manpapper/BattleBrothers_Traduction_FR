this.staggered_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 2
	},
	function create()
	{
		this.m.ID = "effects.staggered";
		this.m.Name = "Désorienté";
		this.m.Icon = "skills/status_effect_65.png";
		this.m.IconMini = "status_effect_65_mini";
		this.m.Overlay = "status_effect_65";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Ce personnage a reçu un coup si violent qu’il a perdu l’équilibre, qu’il est désorienté et qu’il réagit trop tard. Cet effet s’estompera dans [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] tour(s).";
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
				id = 12,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50%[/color] d\'Initiative"
			}
		];
	}

	function getEffectDurationString()
	{
		local ret = "";

		if (this.m.TurnsLeft == 2)
		{
			ret = "deux tours";
		}
		else
		{
			ret = "un tour";
		}

		return ret;
	}

	function getLogEntryOnAdded( _user, _victim )
	{
		return _user + " a désorienté " + _victim + " pour " + this.getEffectDurationString();
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		local statusResisted = actor.getCurrentProperties().IsResistantToAnyStatuses ? this.Math.rand(1, 100) <= 50 : false;
		statusResisted = statusResisted || actor.getCurrentProperties().IsResistantToPhysicalStatuses ? this.Math.rand(1, 100) <= 33 : false;

		if (statusResisted)
		{
			if (!actor.isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " a réussi à se remettre de son étourdissement grâce à sa constitution physique hors du commun");
			}

			this.removeSelf();
		}
		else
		{
			this.m.TurnsLeft = this.Math.max(1, 2 + actor.getCurrentProperties().NegativeStatusEffectDuration);
			this.Tactical.TurnSequenceBar.pushEntityBack(actor.getID());
		}
	}

	function onRefresh()
	{
		this.m.TurnsLeft = this.Math.max(1, 2 + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);
		this.Tactical.TurnSequenceBar.pushEntityBack(this.getContainer().getActor().getID());
		this.spawnIcon("status_effect_65", this.getContainer().getActor().getTile());
	}

	function onUpdate( _properties )
	{
		_properties.InitiativeMult *= 0.5;
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

});


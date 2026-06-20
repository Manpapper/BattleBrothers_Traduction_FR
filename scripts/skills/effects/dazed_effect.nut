this.dazed_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 2
	},
	function create()
	{
		this.m.ID = "effects.dazed";
		this.m.Name = "Étourdi";
		this.m.Icon = "skills/status_effect_87.png";
		this.m.IconMini = "status_effect_87_mini";
		this.m.Overlay = "status_effect_87";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Ce personnage a reçu un coup si violent qu\'il est sonné, désorienté et a du mal à respirer. L\'effet s\'estompera dans [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] tour(s).";
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
				id = 11,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] de Dégâts"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] de Fatigue Maximum"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] d\'Initiative"
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
		return _user + " a étourdi " + _victim + " pendant " + this.getEffectDurationString();
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
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " a réussi à se remettre de son étourdissement grâce à sa constitution physique hors du commun.");
			}

			this.removeSelf();
		}
		else if (!this.m.Container.getActor().getCurrentProperties().IsImmuneToDaze)
		{
			this.m.TurnsLeft = this.Math.max(1, 2 + actor.getCurrentProperties().NegativeStatusEffectDuration);
		}
		else
		{
			this.m.IsGarbage = true;
		}
	}

	function onRefresh()
	{
		this.m.TurnsLeft = this.Math.max(1, 2 + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);
		this.spawnIcon("status_effect_87", this.getContainer().getActor().getTile());
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();

		if (actor.hasSprite("status_stunned") && !this.getContainer().hasSkill("effects.stunned"))
		{
			actor.getSprite("status_stunned").Visible = false;
		}

		actor.setDirty(true);
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();

		if (!actor.getCurrentProperties().IsImmuneToDaze)
		{
			_properties.DamageTotalMult *= 0.75;
			_properties.InitiativeMult *= 0.75;
			_properties.StaminaMult *= 0.75;

			if (actor.hasSprite("status_stunned") && !this.getContainer().hasSkill("effects.stunned"))
			{
				actor.getSprite("status_stunned").setBrush("bust_dazed");
				actor.getSprite("status_stunned").Visible = true;
				actor.setDirty(true);
			}
		}
		else
		{
			this.removeSelf();
		}
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

});


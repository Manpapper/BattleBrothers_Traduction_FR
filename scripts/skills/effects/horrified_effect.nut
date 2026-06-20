this.horrified_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 1
	},
	function create()
	{
		this.m.ID = "effects.horrified";
		this.m.Name = "Horrifié";
		this.m.Icon = "skills/status_effect_70.png";
		this.m.IconMini = "status_effect_70_mini";
		this.m.Overlay = "status_effect_70";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Ce personnage est terrifié et incapable d\'agir jusqu\'au prochain tour.";
	}

	function addTurns( _t )
	{
		this.m.TurnsLeft += _t;
	}

	function onAdded()
	{
		if (this.getContainer().getActor().getCurrentProperties().IsResistantToAnyStatuses && this.Math.rand(1, 100) <= 50)
		{
			if (!this.getContainer().getActor().isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this.actor) + " ne se laisse pas paralyser par la peur grâce à sa physiologie hors du commun");
			}

			this.removeSelf();
		}
		else if (!this.m.Container.getActor().getCurrentProperties().IsImmuneToStun)
		{
			this.m.Container.removeByID("effects.shieldwall");
			this.m.Container.removeByID("effects.spearwall");
			this.m.Container.removeByID("effects.riposte");
			this.m.Container.removeByID("effects.return_favor");
			this.m.Container.removeByID("effects.possessed_undead");
		}
		else
		{
			this.m.IsGarbage = true;
		}
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();

		if (actor.hasSprite("status_stunned"))
		{
			actor.getSprite("status_stunned").Visible = false;
		}
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();

		if (this.m.TurnsLeft != 0)
		{
			_properties.IsStunned = true;
			actor.setActionPoints(0);

			if (actor.hasSprite("status_stunned"))
			{
				actor.getSprite("status_stunned").setBrush("bust_horror");
				actor.getSprite("status_stunned").Visible = true;
			}

			actor.setDirty(true);
		}
		else
		{
			if (actor.hasSprite("status_stunned"))
			{
				actor.getSprite("status_stunned").Visible = false;
			}

			actor.setDirty(true);
		}
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
			local actor = this.getContainer().getActor();

			if (actor.hasSprite("status_stunned"))
			{
				actor.getSprite("status_stunned").Visible = false;
			}

			actor.setDirty(true);
		}
	}

});


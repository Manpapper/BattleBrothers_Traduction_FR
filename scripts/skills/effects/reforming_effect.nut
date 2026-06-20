this.reforming_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 1
	},
	function create()
	{
		this.m.ID = "effects.reforming";
		this.m.Name = "Regénéré";
		this.m.Icon = "skills/status_effect_05.png";
		this.m.IconMini = "status_effect_05_mini";
		this.m.Overlay = "status_effect_05";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Le corps de ce personnage est en train de se régénérer et il est temporairement hors d\'état d\'agir pendant [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] tour(s), et incapable d\'agir.";
	}

	function addTurns( _t )
	{
		this.m.TurnsLeft += _t;
	}

	function setTurns( _t )
	{
		if (this.getContainer() != null)
		{
			this.m.TurnsLeft = _t;
		}
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();

		if (actor.hasSprite("status_stunned"))
		{
			actor.getSprite("status_stunned").Visible = false;
		}

		actor.setDirty(true);
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
				actor.getSprite("status_stunned").setBrush(this.Const.Combat.StunnedBrush);
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


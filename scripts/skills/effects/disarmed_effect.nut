this.disarmed_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 1,
		WeaponID = ""
	},
	function create()
	{
		this.m.ID = "effects.disarmed";
		this.m.Name = "Désarmé";
		this.m.Icon = "skills/status_effect_111.png";
		this.m.IconMini = "status_effect_111_mini";
		this.m.Overlay = "status_effect_111";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Ce personnage a été temporairement désarmé pour [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] tour(s) supplémentaires et ne peut utiliser aucune compétence liée aux armes. Changer d\'arme mettra immédiatement fin à cet effet.";
	}

	function addTurns( _t )
	{
		this.m.TurnsLeft += _t;
	}

	function setTurns( _t )
	{
		if (this.getContainer() != null)
		{
			this.m.TurnsLeft = this.Math.max(1, _t + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);
		}
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
		return _user + " a été désarmé " + _victim + " pour " + this.getEffectDurationString();
	}

	function onAdded()
	{
		if (this.getContainer().getActor().getCurrentProperties().IsResistantToAnyStatuses && this.Math.rand(1, 100) <= 50)
		{
			if (!this.getContainer().getActor().isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " se remet rapidement après avoir été désarmé grâce à sa physiologie hors du commun.");
			}

			this.removeSelf();
		}
		else
		{
			local items = this.m.Container.getActor().getItems();

			if (items.getItemAtSlot(this.Const.ItemSlot.Mainhand) != null && !this.m.Container.getActor().getCurrentProperties().IsImmuneToDisarm)
			{
				this.m.WeaponID = items.getItemAtSlot(this.Const.ItemSlot.Mainhand).getInstanceID();
				this.m.Container.removeByID("effects.spearwall");
				this.m.Container.removeByID("effects.riposte");
				this.m.Container.removeByID("effects.return_favor");
			}
			else
			{
				this.m.IsGarbage = true;
			}
		}
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();
		actor.getSprite("arms_icon").Visible = true;

		if (!this.getContainer().hasSkill("effects.stunned"))
		{
			if (actor.hasSprite("status_stunned"))
			{
				actor.getSprite("status_stunned").Visible = false;
			}
		}

		actor.setDirty(true);
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();

		if (actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) == null || actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).getInstanceID() != this.m.WeaponID)
		{
			this.removeSelf();
			return;
		}

		if (!actor.getCurrentProperties().IsImmuneToDisarm)
		{
			if (this.m.TurnsLeft != 0)
			{
				_properties.IsAbleToUseWeaponSkills = false;
				actor.getSprite("arms_icon").Visible = false;

				if (!this.getContainer().hasSkill("effects.stunned") && actor.hasSprite("status_stunned"))
				{
					actor.getSprite("status_stunned").setBrush("bust_disarmed");
					actor.getSprite("status_stunned").Visible = true;
				}

				actor.setDirty(true);
			}
			else
			{
				actor.getSprite("arms_icon").Visible = true;

				if (!this.getContainer().hasSkill("effects.stunned") && actor.hasSprite("status_stunned"))
				{
					actor.getSprite("status_stunned").Visible = false;
				}

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
			local actor = this.getContainer().getActor();
			actor.getSprite("arms_icon").Visible = true;

			if (!this.getContainer().hasSkill("effects.stunned"))
			{
				if (actor.hasSprite("status_stunned"))
				{
					actor.getSprite("status_stunned").Visible = false;
				}
			}

			actor.setDirty(true);
		}
	}

});


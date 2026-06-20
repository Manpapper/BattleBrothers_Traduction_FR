this.distracted_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 1
	},
	function create()
	{
		this.m.ID = "effects.distracted";
		this.m.Name = "Distrait";
		this.m.Icon = "skills/status_effect_122.png";
		this.m.IconMini = "status_effect_122_mini";
		this.m.Overlay = "status_effect_122";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Ce personnage a été victime d\'un coup bas. Distrait pour [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] tour(s), ses réflexes sont moins vifs et il ont plus de mal à placer des coups précis.";
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
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-35%[/color] de Dégâts"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-35%[/color] d\'Initiative"
			}
		];
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
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " a retrouvé sa concentration grâce à sa physiologie hors du commun");
			}

			this.removeSelf();
		}
		else
		{
			this.m.TurnsLeft = this.Math.max(1, 1 + actor.getCurrentProperties().NegativeStatusEffectDuration);
		}
	}

	function onRefresh()
	{
		this.m.TurnsLeft = this.Math.max(1, 1 + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);
		this.spawnIcon("status_effect_122", this.getContainer().getActor().getTile());
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();

		if (actor.hasSprite("status_stunned") && !this.getContainer().hasSkill("effects.stunned") && !this.getContainer().hasSkill("effects.dazed"))
		{
			actor.getSprite("status_stunned").Visible = false;
		}

		actor.setDirty(true);
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		_properties.DamageTotalMult *= 0.65;
		_properties.InitiativeMult *= 0.65;

		if (actor.hasSprite("status_stunned") && !this.getContainer().hasSkill("effects.stunned") && !this.getContainer().hasSkill("effects.dazed"))
		{
			actor.getSprite("status_stunned").setBrush("bust_distracted");
			actor.getSprite("status_stunned").Visible = true;
			actor.setDirty(true);
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


this.chilled_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 2
	},
	function create()
	{
		this.m.ID = "effects.chilled";
		this.m.Name = "Transi de froid";
		this.m.Icon = "skills/status_effect_109.png";
		this.m.IconMini = "status_effect_109_mini";
		this.m.Overlay = "status_effect_109";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Ce personnage est transi de froid jusqu\'aux os. Ses membres étant complètement gelés, il lui faut déployer beaucoup d\'efforts pour coordonner ses mouvements. L\'effet s\'estompera progressivement au bout de [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] tour(s).";
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
				icon = "ui/icons/action_points.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + (1 + this.m.TurnsLeft) + "[/color] de Points d\'Action"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + (10 + 20 * this.m.TurnsLeft) + "[/color] d\'Initiative"
			}
		];
	}

	function resetTime()
	{
		this.m.TurnsLeft = this.Math.max(1, 2 + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);
	}

	function onAdded()
	{
		if (this.getContainer().getActor().getCurrentProperties().IsResistantToAnyStatuses && this.Math.rand(1, 100) <= 50)
		{
			if (!this.getContainer().getActor().isHiddenToPlayer())
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " n\'est pas affecté par le froid grâce à sa physiologie hors du commun");
			}

			this.removeSelf();
		}
		else
		{
			this.m.TurnsLeft = this.Math.max(1, 2 + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);

			if (this.getContainer().getActor().hasSprite("dirt"))
			{
				local chilled = this.getContainer().getActor().getSprite("dirt");
				chilled.setBrush("bust_frozen");
				chilled.Visible = true;
			}
		}
	}

	function onRemoved()
	{
		if (this.getContainer().getActor().hasSprite("dirt"))
		{
			local chilled = this.getContainer().getActor().getSprite("dirt");
			chilled.resetBrush();
			chilled.Visible = false;
		}
	}

	function onUpdate( _properties )
	{
		_properties.ActionPoints -= 1 + this.m.TurnsLeft;
		_properties.Initiative -= 10 + 20 * this.m.TurnsLeft;
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

});


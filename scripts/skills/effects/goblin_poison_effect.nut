this.goblin_poison_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 3
	},
	function create()
	{
		this.m.ID = "effects.goblin_poison";
		this.m.Name = "Empoisonné";
		this.m.Icon = "skills/status_effect_54.png";
		this.m.IconMini = "status_effect_54_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = true;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Ce personnage a du poison qui coule dans ses veines. Sa vision est trouble, il a du mal à articuler et il lui faut beaucoup d\'efforts pour se déplacer de manière coordonnée. L\'effet s\'estompera progressivement au bout de [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] tour(s).";
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
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + 1 * this.m.TurnsLeft + "[/color] de Points d\'Action"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + 1 * this.m.TurnsLeft + "[/color] de Vision"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + 10 * this.m.TurnsLeft + "[/color] d\'Initiative"
			}
		];
	}

	function resetTime()
	{
		this.m.TurnsLeft = this.Math.max(1, 3 + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);

		if (this.getContainer().hasSkill("trait.ailing"))
		{
			++this.m.TurnsLeft;
		}
	}

	function onAdded()
	{
		this.m.TurnsLeft = this.Math.max(1, 3 + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);

		if (this.getContainer().hasSkill("trait.ailing"))
		{
			++this.m.TurnsLeft;
		}
	}

	function onUpdate( _properties )
	{
		_properties.ActionPoints -= 1 * this.m.TurnsLeft;
		_properties.Initiative -= 10 * this.m.TurnsLeft;
		_properties.Vision -= 1 * this.m.TurnsLeft;
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

});


this.whipped_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 2,
		Level = 0
	},
	function create()
	{
		this.m.ID = "effects.whipped";
		this.m.Name = "Fouetté";
		this.m.Icon = "skills/status_effect_121.png";
		this.m.IconMini = "status_effect_121_mini";
		this.m.Overlay = "status_effect_121";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Ce personnage vient de recevoir un rappel douloureux de ce qu’il doit faire pour ses maîtres. Cela va durer encore " + this.m.TurnsLeft + " tour(s).";
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
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + (9 + this.m.Level) + "[/color] Compétence en Mêlée"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + (9 + this.m.Level) + "[/color] Compétence à Distance"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + (9 + this.m.Level) + "[/color] de Détermination"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + (9 + this.m.Level) + "[/color] d\'Initiative"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + (0 + this.m.Level) + "[/color] de Défense en Mêlée"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + (0 + this.m.Level) + "[/color] de Défense à Distance"
			}
		];
	}

	function setLevel( _l )
	{
		this.m.Level = _l;
	}

	function onAdded()
	{
		this.m.TurnsLeft = 2;
		local actor = this.getContainer().getActor();
		actor.getSprite("status_sweat").setBrush("bust_slave_whipped");
		actor.setDirty(true);
	}

	function onRefresh()
	{
		this.m.TurnsLeft = 2;
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();
		actor.getSprite("status_sweat").resetBrush();
		actor.setDirty(true);
	}

	function onUpdate( _properties )
	{
		_properties.MeleeSkill += 9 + this.m.Level;
		_properties.RangedSkill += 9 + this.m.Level;
		_properties.MeleeDefense += 0 + this.m.Level;
		_properties.RangedDefense += 0 + this.m.Level;
		_properties.Bravery += 9 + this.m.Level;
		_properties.Initiative += 9 + this.m.Level;
		local actor = this.getContainer().getActor();
		actor.getSprite("status_sweat").setBrush(this.m.TurnsLeft > 1 ? "bust_slave_whipped" : "bust_slave_whipped_expiring");
		actor.setDirty(true);
	}

	function onRoundEnd()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

});


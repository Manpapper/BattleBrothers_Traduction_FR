this.lone_wolf_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.lone_wolf";
		this.m.Name = "Loup Solitaire";
		this.m.Description = "I work best alone.";
		this.m.Icon = "ui/perks/perk_61.png";
		this.m.IconMini = "perk_61_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
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
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15%[/color] Compétence en Mêlée"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15%[/color] Compétence à Distance"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15%[/color] de Défense en Mêlée"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15%[/color] de Défense à Distance"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15%[/color] de Détermination"
			}
		];
	}

	function onUpdate( _properties )
	{
		if (!this.getContainer().getActor().isPlacedOnMap())
		{
			this.m.IsHidden = true;
			return;
		}

		local actor = this.getContainer().getActor();
		local myTile = actor.getTile();
		local allies = this.Tactical.Entities.getInstancesOfFaction(actor.getFaction());
		local isAlone = true;

		foreach( ally in allies )
		{
			if (ally.getID() == actor.getID() || !ally.isPlacedOnMap())
			{
				continue;
			}

			if (ally.getTile().getDistanceTo(myTile) <= 3)
			{
				isAlone = false;
				break;
			}
		}

		if (isAlone)
		{
			this.m.IsHidden = false;
			_properties.MeleeSkillMult *= 1.15;
			_properties.RangedSkillMult *= 1.15;
			_properties.MeleeDefenseMult *= 1.15;
			_properties.RangedDefenseMult *= 1.15;
			_properties.BraveryMult *= 1.15;
		}
		else
		{
			this.m.IsHidden = true;
		}
	}

	function onCombatFinished()
	{
		this.m.IsHidden = true;
	}

});


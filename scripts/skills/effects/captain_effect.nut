this.captain_effect <- this.inherit("scripts/skills/skill", {
	m = {
		Difference = 0
	},
	function create()
	{
		this.m.ID = "effects.captain";
		this.m.Name = "Inspiré par un fugure d\'Autorité";
		this.m.Description = "Grâce à la présence d\'un capitaine à ses côtés qui le guide et l\'encourage à aller de l\'avant, ce personnage bénéficie d\'une détermination temporairement renforcée.";
		this.m.Icon = "ui/perks/perk_26.png";
		this.m.IconMini = "perk_26_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
	}

	function getTooltip()
	{
		local bonus = this.m.Difference;
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
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + bonus + "[/color] de Détermination"
			}
		];
	}

	function getBonus()
	{
		local actor = this.getContainer().getActor();

		if (!actor.isPlacedOnMap() || ("State" in this.Tactical) && this.Tactical.State.isBattleEnded())
		{
			return 0;
		}

		local myTile = actor.getTile();
		local allies = this.Tactical.Entities.getInstancesOfFaction(actor.getFaction());
		local bestBravery = 0;

		foreach( ally in allies )
		{
			if (ally.getID() == actor.getID() || !ally.isPlacedOnMap())
			{
				continue;
			}

			if (ally.getTile().getDistanceTo(myTile) > 5)
			{
				continue;
			}

			if (this.getContainer().getActor().getBravery() >= ally.getBravery())
			{
				continue;
			}

			if (ally.getSkills().hasSkill("perk.captain"))
			{
				if (ally.getBravery() > bestBravery)
				{
					bestBravery = ally.getBravery();
				}
			}
		}

		if (bestBravery != 0)
		{
			bestBravery = this.Math.min(bestBravery * 0.15, bestBravery - this.getContainer().getActor().getBravery());
		}

		return bestBravery;
	}

	function onAfterUpdate( _properties )
	{
		local bonus = this.getBonus();

		if (bonus != 0)
		{
			this.m.IsHidden = false;
			_properties.Bravery += bonus;
			this.m.Difference = bonus;
		}
		else
		{
			this.m.IsHidden = true;
			this.m.Difference = 0;
		}
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.IsHidden = true;
		this.m.Difference = 0;
	}

});


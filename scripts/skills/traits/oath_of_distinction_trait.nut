this.oath_of_distinction_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.oath_of_distinction";
		this.m.Name = "Serment de Distinction";
		this.m.Icon = "ui/traits/trait_icon_88.png";
		this.m.Description = "Ce personnage a fait un serment de distinction, et a juré de remporter ses propres victoires sans le soutien d\'alliés.";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
		this.m.Excluded = [];
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
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] de Détermination s\'il n\'y a pas d\'alliés dans les tuiles adjacentes"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+3[/color] de Regéneration de Fatigue par tour s\'il n\'y a pas d\'alliés dans les tuiles adjacentes"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/damage_dealt.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] de Dégâts s\'il n\'y a pas d\'alliés dans les tuiles adjacentes"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]0%[/color] d\'expérience pour les ennemis tués par les alliés"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.XPGainMult *= 1.5;
		_properties.IsAllyXPBlocked = true;
		local actor = this.getContainer().getActor();

		if (!actor.isPlacedOnMap())
		{
			return;
		}

		local myTile = actor.getTile();
		local allies = this.Tactical.Entities.getInstancesOfFaction(actor.getFaction());
		local isAlone = true;

		foreach( ally in allies )
		{
			if (ally.getID() == actor.getID() || !ally.isPlacedOnMap())
			{
				continue;
			}

			if (ally.getTile().getDistanceTo(myTile) <= 1)
			{
				isAlone = false;
				break;
			}
		}

		if (isAlone)
		{
			_properties.Bravery += 10;
			_properties.FatigueRecoveryRate += 3;
			_properties.DamageTotalMult *= 1.1;
		}
	}

});


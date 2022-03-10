this.oath_of_distinction_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.oath_of_distinction";
		this.m.Name = "Oath of Distinction";
		this.m.Icon = "ui/traits/trait_icon_88.png";
		this.m.Description = "This character has taken an Oath of Distinction, and is sworn to seek his own victories without the support of allies.";
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
				icon = "ui/icons/morale.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] Resolve if there are no allies in adjacent tiles"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+3[/color] Fatigue Regeneration per turn if there are no allies in adjacent tiles"
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/damage_dealt.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] damage if there are no allies in adjacent tiles"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+40%[/color] Experience Gain"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]0%[/color] Experience Gain for allied kills"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.XPGainMult *= 1.4;

		if (!this.getContainer().getActor().isPlacedOnMap())
		{
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


this.rally_the_troops <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.rally_the_troops";
		this.m.Name = "Rally";
		this.m.Description = "Raaaaally! Use this character\'s inspirational resolve to rally nearby fleeing allies and push everyone to go the extra mile. A single character can only be rallied once per round.";
		this.m.Icon = "ui/perks/perk_42_active.png";
		this.m.IconDisabled = "ui/perks/perk_42_active_sw.png";
		this.m.Overlay = "perk_42_active";
		this.m.SoundOnUse = [
			"sounds/combat/rally_the_troops_01.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function getTooltip()
	{
		local bravery = this.Math.max(0, this.Math.floor(this.getContainer().getActor().getCurrentProperties().getBravery() * 0.4));
		local ret = [
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
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Triggers a morale check to rally fleeing allies within 4 tiles distance, with a bonus to Resolve of [color=" + this.Const.UI.Color.PositiveValue + "]+" + bravery + "[/color] based on this character\'s Resolve"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Triggers a morale check to raise the morale of anyone wavering or worse within 4 tiles distance, with a bonus to Resolve of [color=" + this.Const.UI.Color.PositiveValue + "]+" + bravery + "[/color] based on this character\'s Resolve, but lowered by [color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] per tile distance"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Removes the Sleeping status effect of allies within 4 tiles distance"
			}
		];

		if (this.getContainer().hasSkill("effects.rallied"))
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can not rally others the same turn as being rallied himself[/color]"
			});
		}

		return ret;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.getContainer().hasSkill("effects.rallied");
	}

	function onUse( _user, _targetTile )
	{
		local myTile = _user.getTile();
		local bravery = this.Math.floor(_user.getCurrentProperties().getBravery() * 0.4);
		local actors = this.Tactical.Entities.getInstancesOfFaction(_user.getFaction());

		foreach( a in actors )
		{
			if (a.getID() == _user.getID())
			{
				continue;
			}

			if (myTile.getDistanceTo(a.getTile()) > 4)
			{
				continue;
			}

			if (a.getFaction() == _user.getFaction() && !a.getSkills().hasSkill("effects.rallied"))
			{
				a.getSkills().removeByID("effects.sleeping");

				for( ; a.getMoraleState() >= this.Const.MoraleState.Steady;  )
				{
				}

				local difficulty = bravery;
				local distance = a.getTile().getDistanceTo(myTile) * 10;
				local morale = a.getMoraleState();

				if (a.getMoraleState() == this.Const.MoraleState.Fleeing)
				{
					a.checkMorale(this.Const.MoraleState.Wavering - this.Const.MoraleState.Fleeing, difficulty, this.Const.MoraleCheckType.Default, "status_effect_56");
				}
				else
				{
					a.checkMorale(1, difficulty - distance, this.Const.MoraleCheckType.Default, "status_effect_56");
				}

				if (morale != a.getMoraleState())
				{
					a.getSkills().add(this.new("scripts/skills/effects/rallied_effect"));
				}
			}
		}

		this.getContainer().add(this.new("scripts/skills/effects/rallied_effect"));
		return true;
	}

});


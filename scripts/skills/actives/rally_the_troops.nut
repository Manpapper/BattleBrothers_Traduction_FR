this.rally_the_troops <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.rally_the_troops";
		this.m.Name = "Rallier les troupes";
		this.m.Description = "Ralliemment ! Utilisez la détermination inspirante de ce personnage pour rallier les alliés en fuite qui se trouvent à proximité et pousser tout le monde à se surpasser. Un même personnage ne peut être rallié qu\'une seule fois par tour.";
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
				text = "Déclenche un test de moral pour rallier les alliés en fuite dans un rayon de 4 tuiles, avec un bonus à la Détermination de [color=" + this.Const.UI.Color.PositiveValue + "]+" + bravery + "[/color] basé sur la résolution de ce personnage"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Déclenche un test de moral pour remonter le moral de toute personne vacillante ou pire dans un rayon de 4 tuiles, avec un bonus à la Détermination de [color=" + this.Const.UI.Color.PositiveValue + "]+" + bravery + "[/color] basé sur la résolution de ce personnage, mais diminuée de [color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] par tuile de distance"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Supprime l\'effet d\'endormissement des alliés dans un rayon de 4 tuiles."
			}
		];

		if (this.getContainer().hasSkill("effects.rallied"))
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Ne peut pas rallier d\'autres personnes pendant le même tour que celui où il est lui-même rallié[/color]"
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


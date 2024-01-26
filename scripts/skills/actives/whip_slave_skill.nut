this.whip_slave_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.whip_slave";
		this.m.Name = "Fouetter l'Esclave";
		this.m.Description = "Rappelez à vos endettés qui est leur maître en les fouettant, afin qu'ils donnent tout, y compris leur vie même.";
		this.m.KilledString = "Whipped to death";
		this.m.Icon = "skills/active_214.png";
		this.m.IconDisabled = "skills/active_214_sw.png";
		this.m.Overlay = "active_214";
		this.m.SoundOnUse = [
			"sounds/combat/dlc6/whip_slave_01.wav",
			"sounds/combat/dlc6/whip_slave_02.wav",
			"sounds/combat/dlc6/whip_slave_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsVisibleTileNeeded = true;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
	}

	function getTooltip()
	{
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
				id = 6,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "Inflige [color=" + this.Const.UI.Color.DamageValue + "]1[/color] - [color=" + this.Const.UI.Color.DamageValue + "]3[/color] dégâts qui ignorent l'armure à la cible"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Donne à l'endetté ciblé l'effet de statut 'Fouetté', augmentant plusieurs de leurs statistiques pendant 2 rounds. Plus le niveau du personnage utilisant cette compétence est élevé, plus l'augmentation est grande."
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Réinitialise la morale de l'endetté ciblé à 'Stable' s'il est actuellement inférieur"
			}
		];
		return ret;
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}

		local actor = this.getContainer().getActor();
		local allies = this.Tactical.Entities.getInstancesOfFaction(actor.getFaction());

		foreach( ally in allies )
		{
			if (ally.getID() == actor.getID() || !ally.isPlacedOnMap())
			{
				continue;
			}

			if (ally.getSkills().hasSkill("background.slave"))
			{
				return true;
			}
		}

		return false;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local target = _targetTile.getEntity();

		if (!this.isKindOf(target, "player") || target.getBackground() == null || target.getBackground().getID() != "background.slave")
		{
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		local t = _targetTile.getEntity();
		local hitInfo = clone this.Const.Tactical.HitInfo;
		hitInfo.DamageRegular = this.Math.rand(1, 3);
		hitInfo.DamageDirect = 1.0;
		hitInfo.BodyPart = this.Const.BodyPart.Body;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;
		t.onDamageReceived(_user, this, hitInfo);

		if (t.isAlive() && !t.isDying())
		{
			if (t.getSkills().hasSkill("effects.whipped"))
			{
				local s = t.getSkills().getSkillByID("effects.whipped");
				s.onRefresh();
				s.setLevel(this.Math.min(11, _user.getLevel()));
				t.getSkills().update();
			}
			else
			{
				local s = this.new("scripts/skills/effects/whipped_effect");
				s.setLevel(this.Math.min(11, _user.getLevel()));
				t.getSkills().add(s);
			}

			if (t.getMoraleState() < this.Const.MoraleState.Steady)
			{
				t.setMoraleState(this.Const.MoraleState.Steady);
			}
		}

		return true;
	}

});


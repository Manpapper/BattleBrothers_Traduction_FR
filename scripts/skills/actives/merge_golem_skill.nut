this.merge_golem_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.merge_golem";
		this.m.Name = "Merge Living Sands";
		this.m.Description = "";
		this.m.Icon = "skills/active_194.png";
		this.m.IconDisabled = "skills/active_194.png";
		this.m.Overlay = "active_194";
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.NonTargeted;
		this.m.Delay = 550;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsTargetingActor = false;
		this.m.IsVisibleTileNeeded = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsAudibleWhenHidden = false;
		this.m.IsUsingActorPitch = true;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 25;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
		this.m.MaxLevelDifference = 4;
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}

		local myTile = this.getContainer().getActor().getTile();
		local mySize = this.getContainer().getActor().getSize();
		local drops = 0;

		for( local i = 0; i < 6; i = ++i )
		{
			if (!myTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = myTile.getNextTile(i);

				if (!tile.IsOccupiedByActor || tile.getEntity().getType() != this.Const.EntityType.SandGolem || tile.getEntity().getSize() != mySize)
				{
				}
				else
				{
					drops = ++drops;
				}
			}
		}

		return drops >= 2;
	}

	function onRemoveOthers( _originTile )
	{
		local drops = 0;
		local mySize = this.getContainer().getActor().getSize();

		for( local i = 0; i < 6; i = ++i )
		{
			if (!_originTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _originTile.getNextTile(i);

				if (!tile.IsOccupiedByActor || tile.getEntity().getType() != this.Const.EntityType.SandGolem || tile.getEntity().getSize() != mySize)
				{
				}
				else
				{
					tile.getEntity().fadeTo(this.createColor("ffffff00"), 150);
					this.Time.scheduleEvent(this.TimeUnit.Virtual, 200, function ( _entity )
					{
						_entity.setIsAlive(false);
						_entity.onRemovedFromMap();
						_entity.die();
					}, tile.getEntity());

					if (tile.IsVisibleForPlayer)
					{
						for( local i = 0; i < this.Const.Tactical.SandGolemParticles.len(); i = ++i )
						{
							this.Tactical.spawnParticleEffect(false, this.Const.Tactical.SandGolemParticles[i].Brushes, tile, this.Const.Tactical.SandGolemParticles[i].Delay, this.Const.Tactical.SandGolemParticles[i].Quantity, this.Const.Tactical.SandGolemParticles[i].LifeTimeQuantity, this.Const.Tactical.SandGolemParticles[i].SpawnRate, this.Const.Tactical.SandGolemParticles[i].Stages);
						}
					}

					drops = ++drops;

					if (drops >= 2)
					{
						break;
					}
				}
			}
		}
	}

	function onGrow( _effect )
	{
		local actor = _effect.getContainer().getActor();
		_effect.addStack();
		_effect.getContainer().update();
		actor.setHitpoints(actor.getHitpointsMax());
		actor.getBaseProperties().Armor[0] = actor.getBaseProperties().ArmorMax[0];
		actor.getBaseProperties().Armor[1] = actor.getBaseProperties().ArmorMax[1];
		actor.setDirty(true);
	}

	function onUse( _user, _targetTile )
	{
		_targetTile = _user.getTile();

		if (_targetTile.IsVisibleForPlayer)
		{
			for( local i = 0; i < this.Const.Tactical.SandGolemParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.SandGolemParticles[i].Brushes, _targetTile, this.Const.Tactical.SandGolemParticles[i].Delay, this.Const.Tactical.SandGolemParticles[i].Quantity, this.Const.Tactical.SandGolemParticles[i].LifeTimeQuantity, this.Const.Tactical.SandGolemParticles[i].SpawnRate, this.Const.Tactical.SandGolemParticles[i].Stages);
			}

			if (_user.isDiscovered() && (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer))
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " merges into something bigger");
			}
		}

		if (!_user.isHiddenToPlayer())
		{
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 250, this.onRemoveOthers.bindenv(this), _targetTile);
		}
		else
		{
			this.onRemoveOthers(_targetTile);
		}

		_user.setHitpoints(_user.getHitpointsMax());
		_user.onUpdateInjuryLayer();
		local effect = _user.getSkills().getSkillByID("racial.golem");

		if (!_user.isHiddenToPlayer())
		{
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 250, this.onGrow.bindenv(this), effect);
		}
		else
		{
			this.onGrow(effect);
		}

		return true;
	}

});


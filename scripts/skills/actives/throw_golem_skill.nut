this.throw_golem_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.throw_golem";
		this.m.Name = "Throw Living Sand";
		this.m.Description = "";
		this.m.Icon = "skills/active_193.png";
		this.m.IconDisabled = "skills/active_193.png";
		this.m.Overlay = "active_193";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc6/sand_golem_throw_01.wav",
			"sounds/enemies/dlc6/sand_golem_throw_02.wav",
			"sounds/enemies/dlc6/sand_golem_throw_03.wav",
			"sounds/enemies/dlc6/sand_golem_throw_04.wav",
			"sounds/enemies/dlc6/sand_golem_throw_05.wav",
			"sounds/enemies/dlc6/sand_golem_throw_06.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/dlc6/sand_golem_throw_hit_01.wav",
			"sounds/enemies/dlc6/sand_golem_throw_hit_02.wav",
			"sounds/enemies/dlc6/sand_golem_throw_hit_03.wav",
			"sounds/enemies/dlc6/sand_golem_throw_hit_04.wav"
		];
		this.m.SoundOnHitDelay = 0;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.Delay = 600;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = true;
		this.m.IsDoingForwardMove = true;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
		this.m.MinRange = 2;
		this.m.MaxRange = 5;
		this.m.MaxLevelDifference = 3;
		this.m.ProjectileType = this.Const.ProjectileType.Rock;
		this.m.ProjectileTimeScale = 1.33;
		this.m.IsProjectileRotated = true;
		this.m.ChanceSmash = 50;
	}

	function onUpdate( _properties )
	{
		this.m.DirectDamageMult = 0.4;
	}

	function isUsable()
	{
		local actor = this.getContainer().getActor();
		local myTile = actor.getTile();
		local empty = 0;

		for( local j = 0; j < 6; j = ++j )
		{
			if (!myTile.hasNextTile(j))
			{
			}
			else if (myTile.getNextTile(j).IsEmpty)
			{
				empty = ++empty;
			}
		}

		return this.skill.isUsable() && this.getContainer().getActor().getSize() > 1 && (this.getContainer().getActor().getSize() == 2 && empty >= 1 || this.getContainer().getActor().getSize() == 3 && empty >= 3);
	}

	function onVerifyTarget( _userTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_userTile, _targetTile))
		{
			return false;
		}

		for( local i = 0; i < 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else if (_targetTile.getNextTile(i).IsEmpty)
			{
				return true;
			}
		}

		return false;
	}

	function onUse( _user, _targetTile )
	{
		local targetEntity = _targetTile.getEntity();
		local isAttackOfOpportunity = this.Tactical.TurnSequenceBar.getActiveEntity() == null || this.Tactical.TurnSequenceBar.getActiveEntity().getID() != _user.getID();

		if (!isAttackOfOpportunity)
		{
			if (_user.getSize() > 1)
			{
				if (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer)
				{
					this.Time.scheduleEvent(this.TimeUnit.Virtual, 300, this.onSpawn, {
						User = _user,
						Skill = this,
						TargetTile = _targetTile
					});
				}
				else
				{
					this.onSpawn({
						User = _user,
						Skill = this,
						TargetTile = _targetTile
					});
				}
			}

			this.attackEntity(_user, targetEntity);
			return true;
		}
		else
		{
			return this.attackEntity(_user, targetEntity);
		}
	}

	function onSpawn( _data )
	{
		local freeTiles = [];
		local lucky = this.Math.rand(1, 100) <= 20;

		if (_data.TargetTile.IsEmpty)
		{
			freeTiles.push({
				Tile = _data.TargetTile,
				Score = 1
			});
		}
		else
		{
			for( local i = 0; i < 6; i = ++i )
			{
				if (!_data.TargetTile.hasNextTile(i))
				{
				}
				else
				{
					local nextTile = _data.TargetTile.getNextTile(i);

					if (nextTile.Level > _data.TargetTile.Level + 1)
					{
					}
					else if (nextTile.IsEmpty)
					{
						local score = 1;

						if (lucky)
						{
							for( local j = 0; j < 6; j = ++j )
							{
								if (!nextTile.hasNextTile(j))
								{
								}
								else
								{
									local veryNextTile = nextTile.getNextTile(j);

									if (veryNextTile.IsOccupiedByActor && veryNextTile.getEntity().getType() == this.Const.EntityType.SandGolem && veryNextTile.getEntity().getSize() == 1)
									{
										score = score + 5;
									}
								}
							}
						}

						freeTiles.push({
							Tile = nextTile,
							Score = score
						});
					}
				}
			}
		}

		if (lucky)
		{
			freeTiles.sort(function ( _a, _b )
			{
				if (_a.Score > _b.Score)
				{
					return -1;
				}
				else if (_a.Score < _b.Score)
				{
					return 1;
				}

				return 0;
			});
		}
		else
		{
			freeTiles[0] = freeTiles[this.Math.rand(0, freeTiles.len() - 1)];
		}

		if (freeTiles.len() != 0)
		{
			local rock = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/sand_golem", freeTiles[0].Tile.Coords.X, freeTiles[0].Tile.Coords.Y);
			rock.setFaction(_data.User.getFaction());

			if (_data.User.getWorldTroop() != null && ("Party" in _data.User.getWorldTroop()) && _data.User.getWorldTroop().Party != null)
			{
				local e = this.Const.World.Common.addTroop(_data.User.getWorldTroop().Party.get(), {
					Type = this.Const.World.Spawn.Troops.SandGolem
				}, false);
				rock.setWorldTroop(e);
			}

			rock.getSprite("body").Color = _data.User.getSprite("body").Color;
			rock.getSprite("body").Saturation = _data.User.getSprite("body").Saturation;
			freeTiles = [];

			for( local i = 0; i < 6; i = ++i )
			{
				if (!_data.User.getTile().hasNextTile(i))
				{
				}
				else
				{
					local nextTile = _data.User.getTile().getNextTile(i);

					if (nextTile.Level > _data.User.getTile().Level + 1)
					{
					}
					else if (nextTile.IsEmpty)
					{
						local score = 1;

						for( local j = 0; j < 6; j = ++j )
						{
							if (!nextTile.hasNextTile(j))
							{
							}
							else
							{
								local veryNextTile = nextTile.getNextTile(j);

								if (veryNextTile.IsOccupiedByActor && veryNextTile.getEntity().getType() == this.Const.EntityType.SandGolem && veryNextTile.getEntity().getSize() == _data.User.getSize() - 1)
								{
									score = score + 5;
								}
							}
						}

						freeTiles.push({
							Tile = nextTile,
							Score = score
						});
					}
				}
			}

			freeTiles.sort(function ( _a, _b )
			{
				if (_a.Score > _b.Score)
				{
					return -1;
				}
				else if (_a.Score < _b.Score)
				{
					return 1;
				}

				return 0;
			});

			if (freeTiles.len() != 0)
			{
				_data.User.shrink();
				_data.User.setHitpoints(_data.User.getHitpointsMax());
				_data.User.getBaseProperties().Armor[0] = _data.User.getBaseProperties().ArmorMax[0];
				_data.User.getBaseProperties().Armor[1] = _data.User.getBaseProperties().ArmorMax[1];

				if (_data.User.getTile().IsVisibleForPlayer)
				{
					for( local i = 0; i < this.Const.Tactical.SandGolemParticles.len(); i = ++i )
					{
						this.Tactical.spawnParticleEffect(false, this.Const.Tactical.SandGolemParticles[i].Brushes, _data.User.getTile(), this.Const.Tactical.SandGolemParticles[i].Delay, this.Const.Tactical.SandGolemParticles[i].Quantity, this.Const.Tactical.SandGolemParticles[i].LifeTimeQuantity, this.Const.Tactical.SandGolemParticles[i].SpawnRate, this.Const.Tactical.SandGolemParticles[i].Stages);
					}
				}
			}

			local n = 0;

			if (_data.User.getSize() == 2)
			{
				n = 1;
			}

			n = --n;

			while (n >= 0 && freeTiles.len() >= 1)
			{
				local tile = freeTiles[0].Tile;
				freeTiles.remove(0);
				local rock = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/sand_golem_medium", tile.Coords.X, tile.Coords.Y);
				rock.setFaction(_data.User.getFaction());

				if (_data.User.getWorldTroop() != null && ("Party" in _data.User.getWorldTroop()) && _data.User.getWorldTroop().Party != null)
				{
					local e = this.Const.World.Common.addTroop(_data.User.getWorldTroop().Party.get(), {
						Type = this.Const.World.Spawn.Troops.SandGolemMEDIUM
					}, false);
					rock.setWorldTroop(e);
				}

				rock.getSprite("body").Color = _data.User.getSprite("body").Color;
				rock.getSprite("body").Saturation = _data.User.getSprite("body").Saturation;

				if (tile.IsVisibleForPlayer)
				{
					for( local i = 0; i < this.Const.Tactical.SandGolemParticles.len(); i = ++i )
					{
						this.Tactical.spawnParticleEffect(false, this.Const.Tactical.SandGolemParticles[i].Brushes, tile, this.Const.Tactical.SandGolemParticles[i].Delay, this.Const.Tactical.SandGolemParticles[i].Quantity, this.Const.Tactical.SandGolemParticles[i].LifeTimeQuantity, this.Const.Tactical.SandGolemParticles[i].SpawnRate, this.Const.Tactical.SandGolemParticles[i].Stages);
					}
				}
			}

			if (_data.User.getSize() == 2)
			{
				n = 2;
			}
			else
			{
				n = 1;
			}

			n = --n;

			while (n >= 0 && freeTiles.len() >= 1)
			{
				local tile = freeTiles[0].Tile;
				freeTiles.remove(0);
				local rock = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/sand_golem", tile.Coords.X, tile.Coords.Y);
				rock.setFaction(_data.User.getFaction());

				if (_data.User.getWorldTroop() != null && ("Party" in _data.User.getWorldTroop()) && _data.User.getWorldTroop().Party != null)
				{
					local e = this.Const.World.Common.addTroop(_data.User.getWorldTroop().Party.get(), {
						Type = this.Const.World.Spawn.Troops.SandGolem
					}, false);
					rock.setWorldTroop(e);
				}

				rock.getSprite("body").Color = _data.User.getSprite("body").Color;
				rock.getSprite("body").Saturation = _data.User.getSprite("body").Saturation;

				if (tile.IsVisibleForPlayer)
				{
					for( local i = 0; i < this.Const.Tactical.SandGolemParticles.len(); i = ++i )
					{
						this.Tactical.spawnParticleEffect(false, this.Const.Tactical.SandGolemParticles[i].Brushes, tile, this.Const.Tactical.SandGolemParticles[i].Delay, this.Const.Tactical.SandGolemParticles[i].Quantity, this.Const.Tactical.SandGolemParticles[i].LifeTimeQuantity, this.Const.Tactical.SandGolemParticles[i].SpawnRate, this.Const.Tactical.SandGolemParticles[i].Stages);
					}
				}
			}
		}
	}

});


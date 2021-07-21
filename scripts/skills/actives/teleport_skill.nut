this.teleport_skill <- this.inherit("scripts/skills/skill", {
	m = {
		SnowTiles = []
	},
	function create()
	{
		this.m.ID = "actives.teleport";
		this.m.Name = "Spirit Walk";
		this.m.Description = "";
		this.m.Icon = "skills/active_167.png";
		this.m.IconDisabled = "skills/active_167.png";
		this.m.Overlay = "active_167";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc4/thing_teleport_01.wav",
			"sounds/enemies/dlc4/thing_teleport_02.wav",
			"sounds/enemies/dlc4/thing_teleport_03.wav",
			"sounds/enemies/dlc4/thing_teleport_04.wav"
		];
		this.m.SoundOnHit = [];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 30;
		this.m.MaxLevelDifference = 4;

		for( local i = 1; i <= 3; i = ++i )
		{
			this.m.SnowTiles.push(this.MapGen.get("tactical.tile.snow" + i));
		}
	}

	function getTooltip()
	{
		local p = this.getContainer().getActor().getCurrentProperties();
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
				id = 3,
				type = "text",
				text = this.getCostString()
			}
		];
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!_targetTile.IsEmpty)
		{
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		local tag = {
			Skill = this,
			User = _user,
			TargetTile = _targetTile,
			OnDone = this.onTeleportDone.bindenv(this),
			OnFadeIn = this.onFadeIn.bindenv(this),
			OnFadeDone = this.onFadeDone.bindenv(this),
			OnTeleportStart = this.onTeleportStart.bindenv(this),
			IgnoreColors = false
		};

		if (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " uses Spirit Walk");
		}

		local myTile = _user.getTile();

		for( local i = 0; i < 6; i = ++i )
		{
			if (!myTile.hasNextTile(i))
			{
			}
			else
			{
				local nextTile = myTile.getNextTile(i);

				if (nextTile.IsOccupiedByActor)
				{
					nextTile.getEntity().getSkills().add(this.new("scripts/skills/effects/chilled_effect"));
				}

				if (nextTile.Subtype != this.Const.Tactical.TerrainSubtype.Snow && nextTile.Subtype != this.Const.Tactical.TerrainSubtype.LightSnow)
				{
					this.Time.scheduleEvent(this.TimeUnit.Virtual, 350, function ( _data )
					{
						_data.Tile.clear();
						_data.Tile.Type = 0;
						_data.Skill.m.SnowTiles[this.Math.rand(0, _data.Skill.m.SnowTiles.len() - 1)].onFirstPass({
							X = _data.Tile.SquareCoords.X,
							Y = _data.Tile.SquareCoords.Y,
							W = 1,
							H = 1,
							IsEmpty = true,
							SpawnObjects = false
						});
					}, {
						Tile = nextTile,
						Skill = this
					});
				}
			}
		}

		if (myTile.Subtype != this.Const.Tactical.TerrainSubtype.Snow && myTile.Subtype != this.Const.Tactical.TerrainSubtype.LightSnow)
		{
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 350, function ( _data )
			{
				_data.Tile.clear();
				_data.Tile.Type = 0;
				_data.Skill.m.SnowTiles[this.Math.rand(0, _data.Skill.m.SnowTiles.len() - 1)].onFirstPass({
					X = _data.Tile.SquareCoords.X,
					Y = _data.Tile.SquareCoords.Y,
					W = 1,
					H = 1,
					IsEmpty = true,
					SpawnObjects = false
				});
			}, {
				Tile = myTile,
				Skill = this
			});
		}

		if (_user.getTile().IsVisibleForPlayer)
		{
			if (this.Const.Tactical.SpiritWalkStartParticles.len() != 0)
			{
				for( local i = 0; i < this.Const.Tactical.SpiritWalkStartParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.SpiritWalkStartParticles[i].Brushes, _user.getTile(), this.Const.Tactical.SpiritWalkStartParticles[i].Delay, this.Const.Tactical.SpiritWalkStartParticles[i].Quantity, this.Const.Tactical.SpiritWalkStartParticles[i].LifeTimeQuantity, this.Const.Tactical.SpiritWalkStartParticles[i].SpawnRate, this.Const.Tactical.SpiritWalkStartParticles[i].Stages);
				}
			}

			_user.storeSpriteColors();
			_user.fadeTo(this.createColor("4cccf300"), 900);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 900, this.onTeleportStart, tag);
		}
		else if (_targetTile.IsVisibleForPlayer)
		{
			_user.storeSpriteColors();
			_user.fadeTo(this.createColor("4cccf300"), 0);
			this.onTeleportStart(tag);
		}
		else
		{
			tag.IgnoreColors = true;
			this.onTeleportStart(tag);
		}

		return true;
	}

	function onTeleportStart( _tag )
	{
		this.Tactical.getNavigator().teleport(_tag.User, _tag.TargetTile, _tag.OnDone, _tag, false, 3.0);
	}

	function onTeleportDone( _entity, _tag )
	{
		if (!_entity.isHiddenToPlayer())
		{
			if (this.Const.Tactical.SpiritWalkEndParticles.len() != 0)
			{
				for( local i = 0; i < this.Const.Tactical.SpiritWalkEndParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.SpiritWalkEndParticles[i].Brushes, _entity.getTile(), this.Const.Tactical.SpiritWalkEndParticles[i].Delay, this.Const.Tactical.SpiritWalkEndParticles[i].Quantity, this.Const.Tactical.SpiritWalkEndParticles[i].LifeTimeQuantity, this.Const.Tactical.SpiritWalkEndParticles[i].SpawnRate, this.Const.Tactical.SpiritWalkEndParticles[i].Stages);
				}
			}

			this.Time.scheduleEvent(this.TimeUnit.Virtual, 100, _tag.OnFadeIn, _tag);

			if (_entity.getTile().IsVisibleForPlayer && _tag.Skill.m.SoundOnHit.len() > 0)
			{
				this.Sound.play(_tag.Skill.m.SoundOnHit[this.Math.rand(0, _tag.Skill.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill, _entity.getPos());
			}
		}
		else
		{
			_tag.OnFadeIn(_tag);
		}
	}

	function onFadeIn( _tag )
	{
		local myTile = _tag.User.getTile();

		for( local i = 0; i < 6; i = ++i )
		{
			if (!myTile.hasNextTile(i))
			{
			}
			else
			{
				local nextTile = myTile.getNextTile(i);

				if (nextTile.IsOccupiedByActor)
				{
					nextTile.getEntity().getSkills().add(this.new("scripts/skills/effects/chilled_effect"));
				}

				if (nextTile.Subtype != this.Const.Tactical.TerrainSubtype.Snow && nextTile.Subtype != this.Const.Tactical.TerrainSubtype.LightSnow)
				{
					nextTile.clear();
					nextTile.Type = 0;
					_tag.Skill.m.SnowTiles[this.Math.rand(0, _tag.Skill.m.SnowTiles.len() - 1)].onFirstPass({
						X = nextTile.SquareCoords.X,
						Y = nextTile.SquareCoords.Y,
						W = 1,
						H = 1,
						IsEmpty = true,
						SpawnObjects = false
					});
				}
			}
		}

		if (myTile.Subtype != this.Const.Tactical.TerrainSubtype.Snow && myTile.Subtype != this.Const.Tactical.TerrainSubtype.LightSnow)
		{
			myTile.clear();
			myTile.Type = 0;
			_tag.Skill.m.SnowTiles[this.Math.rand(0, _tag.Skill.m.SnowTiles.len() - 1)].onFirstPass({
				X = myTile.SquareCoords.X,
				Y = myTile.SquareCoords.Y,
				W = 1,
				H = 1,
				IsEmpty = true,
				SpawnObjects = false
			});
		}

		if (!_tag.IgnoreColors)
		{
			if (_tag.User.isHiddenToPlayer())
			{
				_tag.User.restoreSpriteColors();
			}
			else
			{
				_tag.User.fadeToStoredColors(900);
				this.Time.scheduleEvent(this.TimeUnit.Virtual, 900, _tag.OnFadeDone, _tag);
			}
		}
	}

	function onFadeDone( _tag )
	{
		_tag.User.restoreSpriteColors();
	}

});


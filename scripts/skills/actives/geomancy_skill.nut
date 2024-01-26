this.geomancy_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 0
	},
	function create()
	{
		this.m.ID = "actives.geomancy";
		this.m.Name = "Géomancie";
		this.m.Description = "";
		this.m.Icon = "skills/active_220.png";
		this.m.IconDisabled = "skills/active_220.png";
		this.m.Overlay = "active_220";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc6/sand_golem_death_01.wav",
			"sounds/enemies/dlc6/sand_golem_death_02.wav",
			"sounds/enemies/dlc6/sand_golem_death_03.wav",
			"sounds/enemies/dlc6/sand_golem_death_04.wav"
		];
		this.m.SoundOnHit = this.m.SoundOnUse;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.NonTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 0;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}

	function isUsable()
	{
		local entities = this.Tactical.Entities.getInstancesOfFaction(this.getContainer().getActor().getFaction());
		local phylacteries = 0;

		foreach( e in entities )
		{
			if (e.getType() == this.Const.EntityType.SkeletonPhylactery)
			{
				phylacteries = ++phylacteries;
			}
		}

		phylacteries = this.Math.max(0, phylacteries - this.Time.getRound() / 9);
		return this.skill.isUsable() && this.m.Cooldown == 0 && phylacteries <= 3;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return true;
	}

	function onTurnStart()
	{
		this.m.Cooldown = this.Math.max(0, this.m.Cooldown - 1);
	}

	function onUse( _user, _targetTile )
	{
		this.m.Cooldown = 2;
		this.onSwapTiles(_user);
		return true;
	}

	function onDeath( _fatalityType )
	{
		this.onLowerTiles(this.getContainer().getActor());
	}

	function onSwapTiles( _user )
	{
		this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], 1.0, _user.getPos());

		if (!_user.isHiddenToPlayer())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " commande la terre!");
		}

		local entities = this.Tactical.Entities.getInstancesOfFaction(_user.getFaction());
		local tiles = [];

		foreach( e in entities )
		{
			if (e.getType() == this.Const.EntityType.SkeletonPhylactery || e.getType() == this.Const.EntityType.SkeletonLich)
			{
				tiles.push(e.getTile());
			}
		}

		local max = this.Math.max(1, tiles.len() / 2);
		local n = 0;

		while (tiles.len() != 0)
		{
			n = ++n;

			if (n > max)
			{
				break;
			}

			local r = this.Math.rand(0, tiles.len() - 1);
			local tile = tiles[r];
			tiles.remove(r);

			for( local i = 0; i < 6; i = ++i )
			{
				if (!tile.hasNextTile(i))
				{
				}
				else
				{
					local next = tile.getNextTile(i);

					if (next.IsOccupiedByActor)
					{
						if (next.getEntity().hasZoneOfControl())
						{
							next.getEntity().setZoneOfControl(next, false);
						}

						next.removeZoneOfOccupation(next.getEntity().getFaction());
					}
				}
			}

			if (tile.Level == 0)
			{
				tile.Level = 3;
			}
			else if (tile.Level == 3)
			{
				tile.Level = 0;
			}

			for( local i = 0; i < 6; i = ++i )
			{
				if (!tile.hasNextTile(i))
				{
				}
				else
				{
					local next = tile.getNextTile(i);

					if (next.IsOccupiedByActor)
					{
						if (next.getEntity().hasZoneOfControl())
						{
							next.getEntity().setZoneOfControl(next, next.getEntity().hasZoneOfControl());
						}

						next.addZoneOfOccupation(next.getEntity().getFaction());
					}
				}
			}

			for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, tile, this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity, this.Const.Tactical.DustParticles[i].LifeTimeQuantity, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages);
			}
		}

		if (this.Tactical.getCamera().Level < 3)
		{
			this.Tactical.getCamera().Level = 3;
		}
	}

	function onLowerTiles( _user )
	{
		this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], 1.0, _user.getPos());
		this.Tactical.EventLog.log("The earth lowers again");
		local entities = this.Tactical.Entities.getInstancesOfFaction(_user.getFaction());
		local tiles = [];

		foreach( e in entities )
		{
			if (e.getTile().Level == 3 && (e.getType() == this.Const.EntityType.SkeletonPhylactery || e.getType() == this.Const.EntityType.SkeletonLich))
			{
				tiles.push(e.getTile());
			}
		}

		foreach( tile in tiles )
		{
			for( local i = 0; i < 6; i = ++i )
			{
				if (!tile.hasNextTile(i))
				{
				}
				else
				{
					local next = tile.getNextTile(i);

					if (next.IsOccupiedByActor)
					{
						if (next.getEntity().hasZoneOfControl())
						{
							next.getEntity().setZoneOfControl(next, false);
						}

						next.removeZoneOfOccupation(next.getEntity().getFaction());
					}
				}
			}

			tile.Level = 0;

			for( local i = 0; i < 6; i = ++i )
			{
				if (!tile.hasNextTile(i))
				{
				}
				else
				{
					local next = tile.getNextTile(i);

					if (next.IsOccupiedByActor)
					{
						if (next.getEntity().hasZoneOfControl())
						{
							next.getEntity().setZoneOfControl(next, next.getEntity().hasZoneOfControl());
						}

						next.addZoneOfOccupation(next.getEntity().getFaction());
					}
				}
			}

			for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, tile, this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity, this.Const.Tactical.DustParticles[i].LifeTimeQuantity, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages);
			}
		}

		if (this.Tactical.getCamera().Level == 3)
		{
			this.Tactical.getCamera().Level = 2;
		}
	}

});


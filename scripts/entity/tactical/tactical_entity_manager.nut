this.tactical_entity_manager <- {
	m = {
		Instances = [],
		InstancesMax = [],
		Corpses = [],
		TileEffects = [],
		Strategies = [],
		OnCombatFinishedListener = null,
		LastIdleSound = 0.0,
		AmmoSpent = 0,
		ArmorParts = 0,
		Flags = null,
		IsDirty = false,
		IsCombatFinished = false,
		IsEnemyRetreating = false,
		IsLineVSLine = false,
		CombatResult = this.Const.Tactical.CombatResult.None,
		LastCombatResult = this.Const.Tactical.CombatResult.None
	},
	function getInstancesOfFaction( _f )
	{
		return this.m.Instances[_f];
	}

	function getAllInstances()
	{
		return this.m.Instances;
	}

	function getAllInstancesMax()
	{
		return this.m.InstancesMax;
	}

	function getInstancesNum( _f )
	{
		return this.m.Instances[_f].len();
	}

	function getInstancesMax( _f )
	{
		return this.m.InstancesMax[_f];
	}

	function getCorpses()
	{
		return this.m.Corpses;
	}

	function getStrategy( _f )
	{
		return this.m.Strategies[_f];
	}

	function getFlags()
	{
		return this.m.Flags;
	}

	function getAmmoSpent()
	{
		return this.m.AmmoSpent;
	}

	function getArmorParts()
	{
		return this.m.ArmorParts;
	}

	function spendAmmo( _a = 1 )
	{
		this.m.AmmoSpent += _a;
	}

	function addArmorParts( _a = 1 )
	{
		this.m.ArmorParts += _a;
	}

	function isCombatFinished()
	{
		return this.m.IsCombatFinished;
	}

	function isEnemyRetreating()
	{
		return this.m.IsEnemyRetreating;
	}

	function isLineVSLine()
	{
		return this.m.IsLineVSLine;
	}

	function getCombatResult()
	{
		return this.m.CombatResult;
	}

	function setLastCombatResult( _r )
	{
		this.m.LastCombatResult = _r;
	}

	function checkCombatFinished( _forceFinish = false )
	{
		if (this.m.IsCombatFinished)
		{
			return;
		}

		if (this.isNoCombatantsLeft())
		{
			this.killNonCombatants();
		}

		this.m.IsCombatFinished = _forceFinish || this.getHostilesNum() == 0 || this.getInstancesOfFaction(this.Const.Faction.Player).len() == 0;

		if (this.m.IsCombatFinished)
		{
			this.m.CombatResult = this.m.LastCombatResult;
		}
	}

	function setOnCombatFinishedListener( _l )
	{
		this.m.OnCombatFinishedListener = _l;
	}

	function killNonCombatants()
	{
		if (this.Tactical.State.isScenarioMode())
		{
			return;
		}

		for( local i = this.Const.Faction.Player + 2; i != this.World.FactionManager.getFactions().len(); i = ++i )
		{
			if (!this.World.FactionManager.isAlliedWithPlayer(i))
			{
				foreach( e in this.m.Instances[i] )
				{
					if (e.isNonCombatant())
					{
						e.killSilently();
					}
				}
			}
		}
	}

	function isNoCombatantsLeft()
	{
		if (this.m.IsCombatFinished)
		{
			return true;
		}

		if (this.Tactical.State.isScenarioMode())
		{
			for( local i = this.Const.Faction.Player + 2; i != this.Const.Faction.COUNT; i = ++i )
			{
				if (this.Const.FactionAlliance[i].find(this.Const.Faction.Player) == null)
				{
					foreach( e in this.m.Instances[i] )
					{
						if (!e.isNonCombatant())
						{
							return false;
						}
					}
				}
			}
		}
		else
		{
			for( local i = this.Const.Faction.Player + 2; i != this.World.FactionManager.getFactions().len(); i = ++i )
			{
				if (!this.World.FactionManager.isAlliedWithPlayer(i))
				{
					foreach( e in this.m.Instances[i] )
					{
						if (!e.isNonCombatant())
						{
							return false;
						}
					}
				}
			}
		}

		return true;
	}

	function checkEnemyRetreating()
	{
		if (this.m.IsEnemyRetreating || this.m.IsCombatFinished)
		{
			return;
		}

		if (this.Tactical.State.isScenarioMode())
		{
			for( local i = this.Const.Faction.Player + 2; i != this.Const.Faction.COUNT; i = ++i )
			{
				if (this.Const.FactionAlliance[i].find(this.Const.Faction.Player) == null)
				{
					foreach( e in this.m.Instances[i] )
					{
						if (!e.isNonCombatant() && !e.getAIAgent().getOrders().IsRetreating && e.getMoraleState() != this.Const.MoraleState.Fleeing && e.getXPValue() != 0)
						{
							return;
						}
					}
				}
			}
		}
		else
		{
			for( local i = this.Const.Faction.Player + 2; i != this.World.FactionManager.getFactions().len(); i = ++i )
			{
				if (!this.World.FactionManager.isAlliedWithPlayer(i))
				{
					foreach( e in this.m.Instances[i] )
					{
						if (!e.isNonCombatant() && !e.getAIAgent().getOrders().IsRetreating && e.getMoraleState() != this.Const.MoraleState.Fleeing && e.getXPValue() != 0)
						{
							return;
						}
					}
				}
			}
		}

		this.m.IsEnemyRetreating = true;
	}

	function addInstance( _actor )
	{
		local faction = _actor.getFaction();

		foreach( i in this.m.Instances[faction] )
		{
			if (i.getID() == _actor.getID())
			{
				return;
			}
		}

		this.m.Instances[faction].push(_actor);

		if (_actor.getXPValue() > 0)
		{
			++this.m.InstancesMax[faction];
		}

		this.m.IsDirty = true;
	}

	function removeInstance( _actor, _removeMax = false )
	{
		local faction = _actor.getFaction();
		local i = this.m.Instances[faction].find(_actor);

		if (i != null)
		{
			this.m.Instances[faction].remove(i);

			if (_removeMax && _actor.getXPValue() > 0)
			{
				--this.m.InstancesMax[faction];
			}

			this.m.IsDirty = true;
		}
	}

	function getAllInstancesAsArray()
	{
		local ret = [];

		for( local i = 0; i != this.m.Instances.len(); i = ++i )
		{
			for( local j = 0; j != this.m.Instances[i].len(); j = ++j )
			{
				ret.push(this.m.Instances[i][j]);
			}
		}

		return ret;
	}

	function getNonPlayerInstancesNum()
	{
		local n = 0;

		for( local i = this.Const.Faction.Player + 1; i != this.m.Instances.len(); i = ++i )
		{
			n = n + this.m.Instances[i].len();
		}

		return n;
	}

	function getAlliesNum()
	{
		local n = 0;

		if (this.Tactical.State.isScenarioMode())
		{
			for( local i = this.Const.Faction.Player; i != this.Const.Faction.COUNT; i = ++i )
			{
				if (i == this.Const.Faction.Player || this.Const.FactionAlliance[i].find(this.Const.Faction.Player) != null)
				{
					n = n + this.m.Instances[i].len();
				}
			}
		}
		else
		{
			for( local i = this.Const.Faction.Player; i != this.m.Instances.len(); i = ++i )
			{
				if (i == this.Const.Faction.Player || this.World.FactionManager.isAlliedWithPlayer(i))
				{
					n = n + this.m.Instances[i].len();
				}
			}
		}

		return n;
	}
	
	function getAllHostilesAsArray()
	{
		local ret = [];

		if (this.Tactical.State.isScenarioMode())
		{
			for( local i = this.Const.Faction.Player + 1; i != this.Const.Faction.COUNT; i = ++i )
			{
				if (this.Const.FactionAlliance[i].find(this.Const.Faction.Player) == null)
				{
					for( local j = 0; j != this.m.Instances[i].len(); j = ++j )
					{
						ret.push(this.m.Instances[i][j]);
					}
				}
			}
		}
		else
		{
			for( local i = 0; i != this.World.FactionManager.getFactions().len(); i = ++i )
			{
				if (!this.World.FactionManager.isAlliedWithPlayer(i))
				{
					for( local j = 0; j != this.m.Instances[i].len(); j = ++j )
					{
						ret.push(this.m.Instances[i][j]);
					}
				}
			}
		}

		return ret;
	}

	function getHostilesNum()
	{
		local n = 0;

		if (this.Tactical.State.isScenarioMode())
		{
			for( local i = this.Const.Faction.Player + 1; i != this.Const.Faction.COUNT; i = ++i )
			{
				if (this.Const.FactionAlliance[i].find(this.Const.Faction.Player) == null)
				{
					n = n + this.m.Instances[i].len();
				}
			}
		}
		else
		{
			for( local i = 0; i != this.World.FactionManager.getFactions().len(); i = ++i )
			{
				if (!this.World.FactionManager.isAlliedWithPlayer(i))
				{
					n = n + this.m.Instances[i].len();
				}
			}
		}

		return n;
	}

	function getHostileFactionWithMostInstances()
	{
		local mostNum = 0;
		local mostFaction = 0;

		if (this.Tactical.State.isScenarioMode())
		{
			for( local i = this.Const.Faction.Bandits; i != this.m.Instances.len(); i = ++i )
			{
				if (this.m.Instances[i].len() > mostNum)
				{
					mostNum = this.m.Instances[i].len();
					mostFaction = i;
				}
			}
		}
		else
		{
			for( local i = this.Const.Faction.Player + 1; i != this.m.Instances.len(); i = ++i )
			{
				if (this.World.FactionManager.isAlliedWithPlayer(i))
				{
				}
				else if (this.m.Instances[i].len() > mostNum)
				{
					mostNum = this.m.Instances[i].len();
					mostFaction = i;
				}
			}
		}

		return mostFaction;
	}

	function addCorpse( _tile )
	{
		this.m.Corpses.push(_tile);
	}

	function removeCorpse( _tile )
	{
		local len = this.m.Corpses.len();

		for( local i = 0; i != len; i = ++i )
		{
			if (_tile.isSameTileAs(this.m.Corpses[i]))
			{
				this.m.Corpses.remove(i);
				break;
			}
		}
	}

	function create()
	{
		local maxFactions = this.Tactical.State.isScenarioMode() ? 32 : this.World.FactionManager.getFactions().len();

		for( local i = 0; i != maxFactions; i = ++i )
		{
			this.m.Instances.push([]);
			this.m.InstancesMax.push(0.0);
			local s = this.new("scripts/ai/tactical/strategy");
			s.setFaction(i);
			this.m.Strategies.push(s);
		}

		this.m.Flags = this.new("scripts/tools/tag_collection");
	}

	function clear()
	{
		for( local i = 0; i != this.m.Instances.len(); i = ++i )
		{
			this.m.Instances[i] = [];
			this.m.InstancesMax[i] = 0.0;
		}

		this.m.Corpses = [];
		this.m.IsDirty = true;
	}

	function update()
	{
		this.checkCombatFinished();

		if (this.isCombatFinished())
		{
			return;
		}

		if (this.Tactical.TurnSequenceBar.getActiveEntity() == null || this.Tactical.TurnSequenceBar.getActiveEntity().isPlayerControlled())
		{
			local instances = [];

			for( local i = this.Const.Faction.Player + 1; i != this.m.Instances.len(); i = ++i )
			{
				for( local j = 0; j != this.m.Instances[i].len(); j = ++j )
				{
					instances.push(this.m.Instances[i][j]);
				}
			}

			if (instances.len() != 0 && this.m.LastIdleSound + this.Math.maxf(this.Const.Sound.IdleSoundMinDelay, this.Const.Sound.IdleSoundBaseDelay - this.Const.Sound.IdleSoundReducedDelay * instances.len()) < this.Time.getVirtualTimeF())
			{
				this.m.LastIdleSound = this.Time.getVirtualTimeF();
				instances[this.Math.rand(0, instances.len() - 1)].playIdleSound();
			}
		}

		if (this.m.IsDirty)
		{
			this.m.IsDirty = false;
			this.Tactical.TopbarRoundInformation.update();
		}
	}

	function addTileEffect( _tile, _effect, _particles )
	{
		this.m.TileEffects.push({
			Tile = _tile,
			Effect = _effect,
			Particles = _particles
		});
	}

	function removeTileEffect( _tile )
	{
		foreach( i, tile in this.m.TileEffects )
		{
			if (_tile.ID == tile.Tile.ID)
			{
				this.m.TileEffects[i].Tile.Properties.Effect = null;
				this.m.TileEffects[i].Tile.clear(this.Const.Tactical.DetailFlag.Effect);

				foreach( p in this.m.TileEffects[i].Particles )
				{
					p.die();
				}

				this.m.TileEffects.remove(i);
			}
		}
	}

	function updateTileEffects()
	{
		local garbage = [];

		foreach( i, tile in this.m.TileEffects )
		{
			if (tile.Effect.Timeout <= this.Time.getRound())
			{
				garbage.push(i);
			}
		}

		garbage.reverse();

		foreach( trash in garbage )
		{
			this.m.TileEffects[trash].Tile.Properties.Effect = null;
			this.m.TileEffects[trash].Tile.clear(this.Const.Tactical.DetailFlag.Effect);

			foreach( p in this.m.TileEffects[trash].Particles )
			{
				p.die();
			}

			this.m.TileEffects.remove(trash);
		}

		if (this.Time.getRound() == 1 && !this.Tactical.State.isScenarioMode() && !this.Tactical.State.getStrategicProperties().IsArenaMode || this.Tactical.State.isScenarioMode() && this.Time.getRound() == 2)
		{
			local spiders = 0;
			local entities = this.Tactical.TurnSequenceBar.getAllEntities();

			foreach( e in entities )
			{
				if (e.getType() == this.Const.EntityType.Spider && !this.isKindOf(e, "spider_bodyguard"))
				{
					spiders = ++spiders;
				}
			}

			local mapSize = this.Tactical.getMapSize();

			if (spiders > 5)
			{
				for( local x = 0; x < mapSize.X; x = ++x )
				{
					for( local y = 0; y < mapSize.Y; y = ++y )
					{
						local tile = this.Tactical.getTileSquare(x, y);

						if (tile.IsEmpty || this.Math.rand(1, 100) > 30)
						{
						}
						else if (tile.getEntity().hasSprite("web"))
						{
							tile.getEntity().getSprite("web").Visible = true;
						}
					}
				}

				local eggs = spiders / 5;

				for( local attempts = 0; attempts < 750; attempts = ++attempts )
				{
					local x = this.Math.rand(5, mapSize.X - 8);
					local y = this.Math.rand(7, mapSize.Y - 7);
					local tile = this.Tactical.getTileSquare(x, y);

					if (!tile.IsEmpty)
					{
					}
					else if (tile.IsVisibleForPlayer)
					{
					}
					else if (tile.IsHidingEntity)
					{
					}
					else if (this.isTileIsolated(tile))
					{
					}
					else
					{
						local nest = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/spider_eggs", tile.Coords);
						nest.setFaction(this.Tactical.State.isScenarioMode() ? this.Const.Faction.Beasts : this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						eggs = --eggs;

						if (eggs <= 0)
						{
							break;
						}
					}
				}
			}
		}
	}

	function makeEnemiesKnownToAI( _ignorePlayer = false )
	{
		for( local i = this.Const.Faction.Player + 1; i != this.m.Instances.len(); i = ++i )
		{
			for( local j = 0; j != this.m.Instances[i].len(); j = ++j )
			{
				if (this.m.Instances[i][j].getAIAgent() == null)
				{
				}
				else
				{
					for( local k = 0; k != this.m.Instances.len(); k = ++k )
					{
						if (_ignorePlayer && k == this.Const.Faction.Player)
						{
						}
						else if (this.m.Instances[i][j].isAlliedWith(k))
						{
						}
						else
						{
							for( local p = 0; p != this.m.Instances[k].len(); p = ++p )
							{
								this.m.Instances[i][j].getAIAgent().onOpponentSighted(this.m.Instances[k][p]);
							}
						}
					}
				}
			}
		}
	}

	function makeAllHostilesRetreat()
	{
		if (this.Tactical.State.isScenarioMode())
		{
			for( local i = this.Const.Faction.Bandits; i != this.m.Instances.len(); i = ++i )
			{
				foreach( e in this.m.Instances[i] )
				{
					e.retreat();
				}
			}
		}
		else
		{
			for( local i = this.Const.Faction.Player + 1; i != this.m.Instances.len(); i = ++i )
			{
				if (this.m.Instances[i].len() == 0 || this.World.FactionManager.isAlliedWithPlayer(i))
				{
				}
				else
				{
					local instances = clone this.m.Instances[i];

					foreach( e in instances )
					{
						e.retreat();
					}
				}
			}
		}
	}

	function assignBases()
	{
		if (!("FactionManager" in this.World) || this.World.FactionManager == null)
		{
			return;
		}

		for( local i = this.Const.Faction.Player + 1; i != this.m.Instances.len(); i = ++i )
		{
			if (this.World.FactionManager.getFaction(i) == null)
			{
			}
			else
			{
				local b = this.World.FactionManager.getFaction(i).getTacticalBase();

				if (b == "")
				{
				}
				else
				{
					foreach( p in this.m.Instances[i] )
					{
						if (p.hasSprite("socket"))
						{
							p.getSprite("socket").setBrush(b);
						}
					}
				}
			}
		}
	}

	function makeAIKnownToPlayer()
	{
		for( local i = this.Const.Faction.Player + 1; i != this.m.Instances.len(); i = ++i )
		{
			for( local j = 0; j != this.m.Instances[i].len(); j = ++j )
			{
				this.m.Instances[i][j].setDiscovered(true);
			}
		}
	}

	function onResurrect( _info, _force = false )
	{
		if (this.Tactical.State.m.TacticalDialogScreen.isVisible() || this.Tactical.State.m.TacticalDialogScreen.isAnimating())
		{
			this.Time.scheduleEvent(this.TimeUnit.Rounds, 1, this.Tactical.Entities.resurrect, _info);
			return null;
		}

		if (this.Tactical.Entities.isCombatFinished() || !_force && this.Tactical.Entities.isEnemyRetreating())
		{
			return null;
		}

		local targetTile = _info.Tile;

		if (!targetTile.IsEmpty)
		{
			local knockToTile;

			for( local i = 0; i < this.Const.Direction.COUNT; i = ++i )
			{
				if (!targetTile.hasNextTile(i))
				{
				}
				else
				{
					local newTile = targetTile.getNextTile(i);

					if (!newTile.IsEmpty || newTile.IsCorpseSpawned)
					{
					}
					else if (newTile.Level > targetTile.Level + 1)
					{
					}
					else
					{
						knockToTile = newTile;
						break;
					}
				}
			}

			if (knockToTile == null)
			{
				this.Time.scheduleEvent(this.TimeUnit.Rounds, 1, this.Tactical.Entities.resurrect, _info);
				return null;
			}

			this.Tactical.getNavigator().teleport(targetTile.getEntity(), knockToTile, null, null, true);

			if (_info.Tile.IsVisibleForPlayer)
			{
				this.Tactical.CameraDirector.pushMoveToTileEvent(0, _info.Tile, -1, this.onResurrect.bindenv(this), _info, 200, this.Const.Tactical.Settings.CameraNextEventDelay);
				this.Tactical.CameraDirector.addDelay(0.2);
			}
			else if (knockToTile.IsVisibleForPlayer)
			{
				this.Tactical.CameraDirector.pushMoveToTileEvent(0, knockToTile, -1, this.onResurrect.bindenv(this), _info, 200, this.Const.Tactical.Settings.CameraNextEventDelay);
				this.Tactical.CameraDirector.addDelay(0.2);
			}
			else
			{
				this.Tactical.CameraDirector.pushIdleEvent(0, this.onResurrect.bindenv(this), _info, 200, this.Const.Tactical.Settings.CameraNextEventDelay);
				this.Tactical.CameraDirector.addDelay(0.2);
			}

			return null;
		}

		this.Tactical.Entities.removeCorpse(targetTile);
		targetTile.clear(this.Const.Tactical.DetailFlag.Corpse);
		targetTile.Properties.remove("Corpse");
		targetTile.Properties.remove("IsSpawningFlies");
		this.Const.Movement.AnnounceDiscoveredEntities = false;
		local entity = this.Tactical.spawnEntity(_info.Type, targetTile.Coords.X, targetTile.Coords.Y);
		this.Const.Movement.AnnounceDiscoveredEntities = true;
		entity.onResurrected(_info);
		entity.riseFromGround();

		if (!entity.isHiddenToPlayer())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(entity) + " s\'est relevé d\'entre les morts");
		}

		return entity;
	}

	function resurrect( _info, _delay = 0 )
	{
		if (!_info.Tile.IsCorpseSpawned)
		{
			return;
		}

		if (_info.Tile.IsVisibleForPlayer)
		{
			this.Tactical.CameraDirector.addMoveToTileEvent(_delay, _info.Tile, -1, this.onResurrect.bindenv(this), _info, this.Const.Tactical.Settings.CameraWaitForEventDelay, this.Const.Tactical.Settings.CameraNextEventDelay);
			this.Tactical.CameraDirector.addDelay(1.5);
		}
		else
		{
			this.onResurrect(_info);

			if (this.Tactical.TurnSequenceBar.getActiveEntity() != null && this.Tactical.TurnSequenceBar.getActiveEntity().isPlayerControlled())
			{
				this.Tactical.TurnSequenceBar.getActiveEntity().setDirty(true);
			}
		}
	}

	function setupAmbience( _worldTile )
	{
		local weather = this.Tactical.getWeather();
		local hostileFaction = this.getHostileFactionWithMostInstances();
		local time = this.World.getTime().TimeOfDay;
		weather.setAmbientLightingColor(this.createColor(this.Const.Tactical.AmbientLightingColor.Time[time]));
		weather.setAmbientLightingSaturation(this.Const.Tactical.AmbientLightingSaturation.Time[time]);

		if (time != this.Const.World.TimeOfDay.Morning && time != this.Const.World.TimeOfDay.Dusk && (time == this.Const.World.TimeOfDay.Dawn || this.Math.rand(1, 100) <= 15 || hostileFaction == this.Const.Faction.Undead && this.Math.rand(1, 100) <= 33 || _worldTile.TacticalType == this.Const.World.TerrainTacticalType.Quarry) && _worldTile.TacticalType != this.Const.World.TerrainTacticalType.Desert && _worldTile.TacticalType != this.Const.World.TerrainTacticalType.DesertHills && _worldTile.TacticalType != this.Const.World.TerrainTacticalType.Steppe)
		{
			local clouds = weather.createCloudSettings();
			clouds.Type = this.getconsttable().CloudType.Fog;
			clouds.MinClouds = 20;
			clouds.MaxClouds = 20;
			clouds.MinVelocity = 3.0;
			clouds.MaxVelocity = 9.0;
			clouds.MinAlpha = 0.35;
			clouds.MaxAlpha = 0.45;
			clouds.MinScale = 2.0;
			clouds.MaxScale = 3.0;
			weather.buildCloudCover(clouds);
		}
		else if (this.Math.rand(1, 100) <= 10 && _worldTile.TacticalType != this.Const.World.TerrainTacticalType.SteppeHills && _worldTile.TacticalType != this.Const.World.TerrainTacticalType.Steppe && _worldTile.TacticalType != this.Const.World.TerrainTacticalType.Snow && _worldTile.TacticalType != this.Const.World.TerrainTacticalType.SnowyForest && _worldTile.TacticalType != this.Const.World.TerrainTacticalType.SnowyHills && _worldTile.TacticalType != this.Const.World.TerrainTacticalType.AutumnForest && _worldTile.TacticalType != this.Const.World.TerrainTacticalType.Desert && _worldTile.TacticalType != this.Const.World.TerrainTacticalType.DesertHills)
		{
			if (this.World.getTime().IsDaytime)
			{
				weather.setAmbientLightingColor(this.createColor(this.Const.Tactical.AmbientLightingColor.Storm));
				weather.setAmbientLightingSaturation(this.Const.Tactical.AmbientLightingSaturation.Storm);
			}

			local clouds = weather.createCloudSettings();
			clouds.Type = this.getconsttable().CloudType.StaticFog;
			clouds.MinClouds = 12;
			clouds.MaxClouds = 18;
			clouds.MinAlpha = 0.25;
			clouds.MaxAlpha = 0.5;
			clouds.MinScale = 2.0;
			clouds.MaxScale = 3.0;
			weather.buildCloudCover(clouds);
			local rain = weather.createRainSettings();
			rain.MinDrops = 150;
			rain.MaxDrops = 150;
			rain.NumSplats = 50;
			rain.MinVelocity = 400.0;
			rain.MaxVelocity = 500.0;
			rain.MinAlpha = 1.0;
			rain.MaxAlpha = 1.0;
			rain.MinScale = 0.75;
			rain.MaxScale = 1.0;
			weather.buildRain(rain);
			this.Sound.setAmbience(0, this.Const.SoundAmbience.Rain, this.Const.Sound.Volume.Ambience, 0);
		}
		else if (this.Math.rand(1, 100) <= 10 && _worldTile.TacticalType != this.Const.World.TerrainTacticalType.Snow && _worldTile.TacticalType != this.Const.World.TerrainTacticalType.SnowyForest && _worldTile.TacticalType != this.Const.World.TerrainTacticalType.SnowyHills && _worldTile.TacticalType != this.Const.World.TerrainTacticalType.AutumnForest && _worldTile.TacticalType != this.Const.World.TerrainTacticalType.Desert && _worldTile.TacticalType != this.Const.World.TerrainTacticalType.DesertHills)
		{
			if (this.World.getTime().IsDaytime && time != this.Const.World.TimeOfDay.Dusk && time != this.Const.World.TimeOfDay.Dawn && time != this.Const.World.TimeOfDay.Morning)
			{
				weather.setAmbientLightingColor(this.createColor(this.Const.Tactical.AmbientLightingColor.LightRain));
				weather.setAmbientLightingSaturation(this.Const.Tactical.AmbientLightingSaturation.LightRain);
			}

			local rain = weather.createRainSettings();
			rain.MinDrops = 40;
			rain.MaxDrops = 40;
			rain.NumSplats = 20;
			rain.MinVelocity = 300.0;
			rain.MaxVelocity = 400.0;
			rain.MinAlpha = 0.4;
			rain.MaxAlpha = 0.6;
			rain.SplatAlpha = 0.5;
			rain.MinScale = 0.75;
			rain.MaxScale = 1.0;
			weather.buildRain(rain);
			this.Sound.setAmbience(0, this.Const.SoundAmbience.RainLight, this.Const.Sound.Volume.Ambience, 0);
		}
		else if (this.Math.rand(1, 100) <= 25 && (_worldTile.TacticalType == this.Const.World.TerrainTacticalType.Snow || _worldTile.TacticalType == this.Const.World.TerrainTacticalType.SnowyForest || _worldTile.TacticalType == this.Const.World.TerrainTacticalType.SnowyHills))
		{
			local rain = weather.createRainSettings();
			rain.MinDrops = 200;
			rain.MaxDrops = 200;
			rain.NumSplats = 0;
			rain.MinVelocity = 100.0;
			rain.MaxVelocity = 200.0;
			rain.MinAlpha = 0.5;
			rain.MaxAlpha = 0.9;
			rain.MinScale = 0.25;
			rain.MaxScale = 0.4;
			rain.clearDropBrushes();
			rain.addDropBrush("ice_crystal");
			weather.buildRain(rain);
		}
		else if (this.Math.rand(1, 100) <= 15 && (_worldTile.TacticalType == this.Const.World.TerrainTacticalType.Highlands || _worldTile.TacticalType == this.Const.World.TerrainTacticalType.HighlandsHills))
		{
			local rain = weather.createRainSettings();
			rain.MinDrops = 200;
			rain.MaxDrops = 200;
			rain.NumSplats = 0;
			rain.MinVelocity = 100.0;
			rain.MaxVelocity = 200.0;
			rain.MinAlpha = 0.5;
			rain.MaxAlpha = 0.9;
			rain.MinScale = 0.15;
			rain.MaxScale = 0.3;
			rain.clearDropBrushes();
			rain.addDropBrush("ice_crystal");
			weather.buildRain(rain);
		}
		else if (this.Math.rand(1, 100) <= 25 && (_worldTile.TacticalType == this.Const.World.TerrainTacticalType.Snow || _worldTile.TacticalType == this.Const.World.TerrainTacticalType.SnowyForest || _worldTile.TacticalType == this.Const.World.TerrainTacticalType.SnowyHills))
		{
			local rain = weather.createRainSettings();
			rain.MinDrops = 300;
			rain.MaxDrops = 300;
			rain.NumSplats = 0;
			rain.MinVelocity = 900.0;
			rain.MaxVelocity = 1200.0;
			rain.MinAlpha = 0.5;
			rain.MaxAlpha = 1.0;
			rain.MinScale = 0.5;
			rain.MaxScale = 1.0;
			rain.clearDropBrushes();
			rain.addDropBrush("rain_03");
			rain.Direction = this.createVec(-0.45, -0.55);
			weather.buildRain(rain);
			local clouds = weather.createCloudSettings();
			clouds.Type = this.getconsttable().CloudType.Custom;
			clouds.MinClouds = 150;
			clouds.MaxClouds = 150;
			clouds.MinVelocity = 400.0;
			clouds.MaxVelocity = 500.0;
			clouds.MinAlpha = 0.6;
			clouds.MaxAlpha = 1.0;
			clouds.MinScale = 1.0;
			clouds.MaxScale = 4.0;
			clouds.Sprite = "wind_01";
			clouds.RandomizeDirection = false;
			clouds.RandomizeRotation = false;
			clouds.Direction = this.createVec(-1.0, -0.7);
			weather.buildCloudCover(clouds);
			this.Sound.setAmbience(0, this.Const.SoundAmbience.Blizzard, this.Const.Sound.Volume.Ambience, 0);
		}
		else if (this.Math.rand(1, 100) <= 60 && _worldTile.TacticalType != this.Const.World.TerrainTacticalType.Desert && _worldTile.TacticalType != this.Const.World.TerrainTacticalType.DesertHills)
		{
			local clouds = weather.createCloudSettings();
			clouds.MinClouds = 5;
			clouds.MaxClouds = 5;
			clouds.MinVelocity = 30.0;
			clouds.MaxVelocity = 50.0;
			clouds.MinAlpha = 0.35;
			clouds.MaxAlpha = 0.5;
			clouds.MinScale = 1.5;
			clouds.MaxScale = 3.0;
			weather.buildCloudCover(clouds);
		}

		if (_worldTile.Type == this.Const.World.TerrainType.AutumnForest)
		{
			local rain = weather.createRainSettings();
			rain.MinDrops = 20;
			rain.MaxDrops = 20;
			rain.DropLifetime = 7000;
			rain.NumSplats = 0;
			rain.MinVelocity = 50.0;
			rain.MaxVelocity = 100.0;
			rain.MinAlpha = 1.0;
			rain.MaxAlpha = 1.0;
			rain.MinScale = 0.3;
			rain.MaxScale = 0.5;
			rain.ScaleDropsWithTime = true;
			rain.clearDropBrushes();
			rain.addDropBrush("leaf_01");
			rain.addDropBrush("leaf_02");
			rain.addDropBrush("leaf_03");
			rain.addDropBrush("leaf_04");
			weather.buildRain(rain);
		}
	}

	function spawn( _properties )
	{
		if (this.World.State.getCombatSeed() != 0)
		{
			this.Math.seedRandom(this.World.State.getCombatSeed());
		}

		this.Time.setRound(0);
		this.World.Assets.updateFormation();
		local all_players = _properties.IsUsingSetPlayers ? _properties.Players : this.World.getPlayerRoster().getAll();
		local players = [];

		foreach( e in _properties.TemporaryEnemies )
		{
			if (e > 2)
			{
				this.World.FactionManager.getFaction(e).setIsTemporaryEnemy(true);
			}
		}

		local num = 0;

		foreach( p in all_players )
		{
			if (!_properties.IsUsingSetPlayers && p.getPlaceInFormation() > 17)
			{
				continue;
			}

			players.push(p);
			local items = p.getItems().getAllItemsAtSlot(this.Const.ItemSlot.Bag);

			foreach( item in items )
			{
				if ("setLoaded" in item)
				{
					item.setLoaded(false);
				}
			}

			num = ++num;

			if (num >= this.World.Assets.getBrothersMaxInCombat())
			{
				break;
			}
		}

		if (this.World.State.isUsingGuests() && this.World.getGuestRoster().getSize() != 0)
		{
			players.extend(this.World.getGuestRoster().getAll());
		}

		if (_properties.BeforeDeploymentCallback != null)
		{
			_properties.BeforeDeploymentCallback();
		}

		local isPlayerInitiated = _properties.IsPlayerInitiated;

		if (_properties.PlayerDeploymentType == this.Const.Tactical.DeploymentType.Auto)
		{
			if (this.World.State.getEscortedEntity() != null && !this.World.State.getEscortedEntity().isNull())
			{
				_properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
			}
			else if (_properties.LocationTemplate != null && _properties.LocationTemplate.Fortification != this.Const.Tactical.FortificationType.None && !_properties.LocationTemplate.ForceLineBattle)
			{
				_properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
			}
			else if ((this.Const.World.TerrainTypeLineBattle[_properties.Tile.Type] || _properties.IsAttackingLocation || isPlayerInitiated) && !_properties.InCombatAlready)
			{
				_properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
			}
			else if (!_properties.InCombatAlready)
			{
				_properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
			}
			else
			{
				_properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
			}
		}

		_properties.Entities.sort(this.onFactionCompare);
		local ai_entities = [];

		foreach( e in _properties.Entities )
		{
			if (ai_entities.len() == 0 || ai_entities[ai_entities.len() - 1].Faction != e.Faction)
			{
				local f = {
					Faction = e.Faction,
					IsAlliedWithPlayer = this.World.FactionManager.isAlliedWithPlayer(e.Faction),
					IsOwningLocation = false,
					DeploymentType = _properties.EnemyDeploymentType,
					Entities = []
				};
				ai_entities.push(f);

				if (_properties.LocationTemplate != null && this.World.FactionManager.isAllied(f.Faction, _properties.LocationTemplate.OwnedByFaction))
				{
					f.IsOwningLocation = true;
				}

				if (f.DeploymentType == this.Const.Tactical.DeploymentType.Auto)
				{
					if (this.World.State.getEscortedEntity() != null && !this.World.State.getEscortedEntity().isNull())
					{
						f.DeploymentType = this.Const.Tactical.DeploymentType.Line;
					}
					else if (f.IsAlliedWithPlayer && !_properties.InCombatAlready)
					{
						f.DeploymentType = _properties.PlayerDeploymentType;
					}
					else if (_properties.LocationTemplate != null && _properties.LocationTemplate.Fortification != this.Const.Tactical.FortificationType.None && !this.World.FactionManager.isAllied(f.Faction, _properties.LocationTemplate.OwnedByFaction) && !_properties.LocationTemplate.ForceLineBattle)
					{
						f.DeploymentType = this.Const.Tactical.DeploymentType.LineBack;
					}
					else if (_properties.LocationTemplate != null && _properties.LocationTemplate.Fortification != this.Const.Tactical.FortificationType.None && this.World.FactionManager.isAllied(f.Faction, _properties.LocationTemplate.OwnedByFaction) && !_properties.LocationTemplate.ForceLineBattle)
					{
						f.DeploymentType = this.Const.Tactical.DeploymentType.Camp;
					}
					else if (_properties.LocationTemplate != null && (_properties.LocationTemplate.Fortification == this.Const.Tactical.FortificationType.None || _properties.LocationTemplate.ForceLineBattle))
					{
						f.DeploymentType = this.Const.Tactical.DeploymentType.Line;
					}
					else if (this.Const.World.TerrainTypeLineBattle[_properties.Tile.Type] || _properties.IsAttackingLocation || isPlayerInitiated || _properties.InCombatAlready)
					{
						f.DeploymentType = this.Const.Tactical.DeploymentType.Line;
					}
					else
					{
						f.DeploymentType = this.Const.Tactical.DeploymentType.Circle;
					}
				}
			}

			ai_entities[ai_entities.len() - 1].Entities.push(e);
		}

		ai_entities.sort(function ( _a, _b )
		{
			if (_a.IsOwningLocation && !_b.IsOwningLocation)
			{
				return -1;
			}
			else if (!_a.IsOwningLocation && _b.IsOwningLocation)
			{
				return 1;
			}

			return 0;
		});
		local hasCampDeployment = false;

		foreach( ai in ai_entities )
		{
			if (ai.DeploymentType == this.Const.Tactical.DeploymentType.Camp)
			{
				hasCampDeployment = true;
				break;
			}
		}

		local shiftX = _properties.LocationTemplate != null ? _properties.LocationTemplate.ShiftX : 0;
		local shiftY = _properties.LocationTemplate != null ? _properties.LocationTemplate.ShiftY : 0;

		switch(_properties.PlayerDeploymentType)
		{
		case this.Const.Tactical.DeploymentType.Line:
			this.placePlayersInFormation(players);
			break;

		case this.Const.Tactical.DeploymentType.LineBack:
			if (_properties.InCombatAlready)
			{
				this.placePlayersInFormation(players, -10);
			}
			else
			{
				this.placePlayersInFormation(players, -10 + shiftX);
			}

			break;

		case this.Const.Tactical.DeploymentType.LineForward:
			this.placePlayersInFormation(players, 8 + shiftX);
			break;

		case this.Const.Tactical.DeploymentType.Arena:
			this.placePlayersInFormation(players, -4, -3);
			break;

		case this.Const.Tactical.DeploymentType.Center:
			this.placePlayersAtCenter(players);
			break;

		case this.Const.Tactical.DeploymentType.Edge:
			this.placePlayersAtBorder(players);
			break;

		case this.Const.Tactical.DeploymentType.Random:
		case this.Const.Tactical.DeploymentType.Circle:
			this.placePlayersInCircle(players);
			break;

		case this.Const.Tactical.DeploymentType.Custom:
			if (_properties.PlayerDeploymentCallback != null)
			{
				_properties.PlayerDeploymentCallback();
			}

			break;
		}

		local factionsNotAlliedWithPlayer = hasCampDeployment || this.World.State.getEscortedEntity() == null && _properties.InCombatAlready && ai_entities.len() <= 2 ? 1 : 0;
		local lastFaction = 99;

		foreach( i, f in ai_entities )
		{
			if ((!f.IsAlliedWithPlayer || this.World.State.getEscortedEntity() == null && _properties.InCombatAlready) && f.DeploymentType != this.Const.Tactical.DeploymentType.Camp && (lastFaction == 99 || !this.World.FactionManager.isAllied(lastFaction, f.Faction)))
			{
				factionsNotAlliedWithPlayer = ++factionsNotAlliedWithPlayer;
			}

			if (factionsNotAlliedWithPlayer > 3)
			{
				continue;
			}

			local n = f.IsAlliedWithPlayer && (!_properties.InCombatAlready || this.World.State.getEscortedEntity() != null) ? 0 : factionsNotAlliedWithPlayer;
			lastFaction = f.Faction;

			switch(f.DeploymentType)
			{
			case this.Const.Tactical.DeploymentType.Line:
				if (_properties.InCombatAlready)
				{
					if (n == 1)
					{
						this.spawnEntitiesInFormation(f.Entities, n, -5, 0);
					}
					else
					{
						this.spawnEntitiesInFormation(f.Entities, n, 0, 7);
					}
				}
				else
				{
					this.spawnEntitiesInFormation(f.Entities, n);
				}

				break;

			case this.Const.Tactical.DeploymentType.Camp:
				this.spawnEntitiesAtCamp(f.Entities, shiftX, shiftY);
				break;

			case this.Const.Tactical.DeploymentType.LineBack:
				if (f.IsAlliedWithPlayer && _properties.PlayerDeploymentType == this.Const.Tactical.DeploymentType.LineForward)
				{
					this.spawnEntitiesInFormation(f.Entities, n, 8 + shiftX);
				}
				else if (!f.IsAlliedWithPlayer && _properties.PlayerDeploymentType == this.Const.Tactical.DeploymentType.LineForward)
				{
					this.spawnEntitiesInFormation(f.Entities, n, -10 - shiftX);
				}
				else
				{
					this.spawnEntitiesInFormation(f.Entities, n, -10 + shiftX);
				}

				break;

			case this.Const.Tactical.DeploymentType.Arena:
				this.spawnEntitiesInFormation(f.Entities, n, 3, -3);
				break;

			case this.Const.Tactical.DeploymentType.Center:
				this.spawnEntitiesAtCenter(f.Entities);
				break;

			case this.Const.Tactical.DeploymentType.Random:
				this.spawnEntitiesRandomly(f.Entities);
				break;

			case this.Const.Tactical.DeploymentType.Circle:
				this.spawnEntitiesInCircle(f.Entities);
				break;
			}
		}

		if (_properties.EnemyDeploymentCallback != null)
		{
			_properties.EnemyDeploymentCallback();
		}

		this.m.IsLineVSLine = _properties.PlayerDeploymentType == this.Const.Tactical.DeploymentType.Line && _properties.EnemyDeploymentType == this.Const.Tactical.DeploymentType.Line;

		if (!this.Tactical.State.isScenarioMode() && !_properties.IsPlayerInitiated && !_properties.InCombatAlready)
		{
			foreach( i, s in this.m.Strategies )
			{
				if (!this.World.FactionManager.isAllied(this.Const.Faction.Player, i))
				{
					s.setIsAttackingOnWorldmap(true);
				}
			}
		}

		if (_properties.AfterDeploymentCallback != null)
		{
			_properties.AfterDeploymentCallback();
		}

		if (_properties.IsAutoAssigningBases)
		{
			this.assignBases();
		}

		this.makeEnemiesKnownToAI(_properties.InCombatAlready);

		if (this.World.Assets.getOrigin().getID() == "scenario.manhunters")
		{
			local roster = this.World.getPlayerRoster().getAll();
			local slaves = 0;
			local nonSlaves = 0;

			foreach( bro in roster )
			{
				if (!bro.isPlacedOnMap())
				{
					continue;
				}

				if (bro.getBackground().getID() == "background.slave")
				{
					slaves = ++slaves;
				}
				else
				{
					nonSlaves = ++nonSlaves;
				}
			}

			if (slaves <= nonSlaves)
			{
				foreach( bro in roster )
				{
					if (!bro.isPlacedOnMap())
					{
						continue;
					}

					if (bro.getBackground().getID() != "background.slave")
					{
						bro.worsenMood(this.Const.MoodChange.TooFewSlavesInBattle, "Trop peu d\'endettés au combat");
					}
				}
			}
		}

		foreach( player in this.m.Instances[this.Const.Faction.Player] )
		{
			player.onCombatStart();
		}

		this.Math.seedRandom(this.Time.getRealTime());
	}

	function spawnEntitiesRandomly( _entities )
	{
		foreach( e in _entities )
		{
			local x = 0;
			local y = 0;

			while (1)
			{
				x = this.Math.rand(3, 29);
				y = this.Math.rand(3, 29);

				if (!this.Tactical.isValidTileSquare(x, y) || !this.Tactical.getTileSquare(x, y).IsEmpty)
				{
					continue;
				}

				if (x >= 6 && x <= 28 && y <= 7)
				{
					continue;
				}

				if (this.isTileIsolated(this.Tactical.getTileSquare(x, y)))
				{
					continue;
				}

				break;
			}

			local tile = this.Tactical.getTileSquare(x, y);
			local entity = this.Tactical.spawnEntity(e.Script, tile.Coords.X, tile.Coords.Y);
			this.setupEntity(entity, e);
		}
	}

	function spawnEntitiesInCircle( _entities )
	{
		foreach( e in _entities )
		{
			local x = 0;
			local y = 0;
			local tries = 0;

			if (!this.World.FactionManager.isAlliedWithPlayer(e.Faction))
			{
				while (1)
				{
					x = this.Math.rand(8, 24);
					y = this.Math.rand(8, 24);

					if (x > 9 && x < 23 && y > 9 && y < 23)
					{
						continue;
					}

					if (this.Tactical.isValidTileSquare(x, y) && this.Tactical.getTileSquare(x, y).IsEmpty && !this.isTileIsolated(this.Tactical.getTileSquare(x, y)))
					{
						break;
					}

					tries = ++tries;

					if (tries >= 500)
					{
						break;
					}
				}
			}
			else
			{
				while (1)
				{
					x = this.Math.rand(12, 20);
					y = this.Math.rand(12, 20);

					if (this.Tactical.isValidTileSquare(x, y) && this.Tactical.getTileSquare(x, y).IsEmpty && !this.isTileIsolated(this.Tactical.getTileSquare(x, y)))
					{
						break;
					}

					tries = ++tries;

					if (tries >= 500)
					{
						break;
					}
				}
			}

			if (tries >= 500)
			{
				continue;
			}

			local tile = this.Tactical.getTileSquare(x, y);
			local entity = this.Tactical.spawnEntity(e.Script, tile.Coords.X, tile.Coords.Y);
			this.setupEntity(entity, e);
		}
	}

	function spawnEntitiesAtCamp( _entities, _shiftX = 0, _shiftY = 0 )
	{
		_entities.sort(function ( _a, _b )
		{
			if (_a.Row > _b.Row)
			{
				return -1;
			}
			else if (_a.Row < _b.Row)
			{
				return 1;
			}

			return 0;
		});
		local size = this.Tactical.getMapSize();
		local radius = this.Const.Tactical.Settings.CampRadius;
		local centerTile = this.Tactical.getTileSquare(size.X / 2 + _shiftX, size.Y / 2 + _shiftY);
		local tiles = [];

		for( local x = 0; x < size.X; x = ++x )
		{
			for( local y = 0; y < size.Y; y = ++y )
			{
				local tile = this.Tactical.getTileSquare(x, y);

				if (!tile.IsEmpty)
				{
				}
				else
				{
					local d = tile.getDistanceTo(centerTile);

					if (d > radius || d <= 3)
					{
					}
					else
					{
						local cover = 0;

						for( local i = 0; i < 6; i = ++i )
						{
							if (!tile.hasNextTile(i))
							{
							}
							else if (!tile.getNextTile(i).IsEmpty)
							{
								cover = ++cover;
							}
						}

						local s = d + (centerTile.SquareCoords.X - x) * 2.5 + cover * 2;
						tiles.push({
							Tile = tile,
							Score = s,
							Distance = d,
							Cover = cover
						});
					}
				}
			}
		}

		tiles.sort(function ( _a, _b )
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

		foreach( e in _entities )
		{
			if (tiles.len() == 0)
			{
				break;
			}

			local tile;

			for( local i = 0; i < tiles.len(); i = ++i )
			{
				if (e.Row <= 0 && (tiles[i].Cover <= 2 || tiles[i].Distance == radius) && tiles[i].Distance >= radius - 1 || e.Row == 1 && tiles[i].Cover >= 1 && tiles[i].Distance == radius - 1 || e.Row == 2 && tiles[i].Distance <= radius - 1)
				{
					if (!this.isTileIsolated(tiles[i].Tile))
					{
						tile = tiles[i].Tile;
						tiles.remove(i);
						break;
					}
				}
			}

			if (tile == null)
			{
				for( local i = 0; i < tiles.len(); i = ++i )
				{
					if (!this.isTileIsolated(tiles[i].Tile))
					{
						tile = tiles[i].Tile;
						tiles.remove(i);
						break;
					}
				}
			}

			if (tile != null)
			{
				local entity = this.Tactical.spawnEntity(e.Script, tile.Coords.X, tile.Coords.Y);
				this.setupEntity(entity, e);
			}
		}
	}

	function spawnEntitiesInFormation( _entities, _factionNum, _offsetX = 0, _offsetY = 0 )
	{
		local max_per_row = 5;
		local last_faction = 0;
		local dir = _factionNum;
		local backup_dir = _factionNum;
		local dir_row_offset = [];
		dir_row_offset.resize(4);
		local flanks = [
			false,
			false,
			false,
			false
		];
		local barbarians = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians);
		local nomads = this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits);

		for( local i = 0; i < dir_row_offset.len(); i = ++i )
		{
			dir_row_offset[i] = [];
			dir_row_offset[i].resize(10, 0);
		}

		local num_for_faction = 0;
		local alliedWithPlayer = 0;
		local placed = 0;

		foreach( i, e in _entities )
		{
			if (num_for_faction >= 30 && this.World.FactionManager.isAlliedWithPlayer(e.Faction))
			{
				continue;
			}

			placed = ++placed;

			if (e.Faction != last_faction || num_for_faction >= 30)
			{
				last_faction = e.Faction;
				num_for_faction = 0;
				dir = backup_dir;

				if (placed > 1)
				{
					if (dir < dir_row_offset.len() - 1)
					{
						dir = ++dir;
						backup_dir = dir;
						local useFlanks = e.ID == this.Const.EntityType.Hyena || this.Math.rand(1, 100) <= 50 && (barbarians != null && e.Faction == barbarians.getID() || nomads != null && e.Faction == nomads.getID());

						if (useFlanks)
						{
							flanks[dir] = true;

							for( local i = 0; i < dir_row_offset.len(); i = ++i )
							{
								dir_row_offset[dir][i] = max_per_row;
							}
						}
					}
					else
					{
						  // [157]  OP_JMP            0    288    0    0
					}
				}
			}
			else
			{
				num_for_faction = ++num_for_faction;

				for( ; num_for_faction >= 48;  )
				{
				}
			}

			if (dir == 0 && this.World.FactionManager.isAlliedWithPlayer(e.Faction))
			{
				alliedWithPlayer = ++alliedWithPlayer;

				for( ; alliedWithPlayer >= 30;  )
				{
				}
			}

			local x = 0;
			local y = 0;
			local row_offset = dir_row_offset[dir];
			local current_row = e.Row;
			local tile;

			if (current_row == -1)
			{
				current_row = this.Math.rand(1, 3);
			}

			while (1)
			{
				if (current_row == -2)
				{
					while (1)
					{
						x = this.Math.rand(4, 24);
						y = this.Math.rand(4, 26);

						if (x >= 8 && x <= 19 && y >= 9 && y <= 23)
						{
							continue;
						}

						if (this.Tactical.isValidTileSquare(x, y) && this.Tactical.getTileSquare(x, y).IsEmpty && !this.isTileIsolated(this.Tactical.getTileSquare(x, y)))
						{
							break;
						}
					}
				}
				else
				{
					if (dir == 0)
					{
						x = 13 - current_row + _offsetX;
						y = 15 + row_offset[current_row] + _offsetY;
					}
					else if (dir == 1)
					{
						x = 19 + current_row - _offsetX;
						y = 15 + row_offset[current_row] + _offsetY;
					}
					else if (dir == 2)
					{
						x = 15 + row_offset[current_row];
						y = 25 + current_row - _offsetY;
					}
					else if (dir == 3)
					{
						x = 15 + row_offset[current_row];
						y = 6 - current_row + _offsetY;
					}
					else
					{
						this.logInfo("Too many participants, arg!");
					}

					if (!this.Tactical.isValidTileSquare(x, y) || !this.Tactical.getTileSquare(x, y).IsEmpty || this.isTileIsolated(this.Tactical.getTileSquare(x, y)))
					{
						if (current_row < row_offset.len() - 1 && (row_offset[current_row] == 0 && flanks[dir] || !flanks[dir] && row_offset[current_row] > max_per_row))
						{
							current_row = ++current_row;
						}
						else if (current_row >= row_offset.len() - 1 && row_offset[current_row] >= max_per_row)
						{
							break;
						}
						else if (flanks[dir])
						{
							if (row_offset[current_row] <= 0)
							{
								++row_offset[current_row];
							}

							row_offset[current_row] = -row_offset[current_row];
						}
						else
						{
							if (row_offset[current_row] <= 0)
							{
								--row_offset[current_row];
							}

							row_offset[current_row] = -row_offset[current_row];
						}

						continue;
					}
				}

				tile = this.Tactical.getTileSquare(x, y);
				break;
			}

			if (tile != null)
			{
				local entity = this.Tactical.spawnEntity(e.Script, tile.Coords.X, tile.Coords.Y);
				this.setupEntity(entity, e);
			}
		}
	}

	function spawnEntitiesAtCenter( _entities, _extraRadius = 0 )
	{
		foreach( e in _entities )
		{
			local x = 0;
			local y = 0;
			local tries = 0;

			while (1)
			{
				if (tries < 500)
				{
					x = this.Math.rand(14 - _extraRadius, 18 + _extraRadius);
					y = this.Math.rand(14 - _extraRadius, 18 + _extraRadius);
				}
				else if (tries < 1000)
				{
					x = this.Math.rand(13 - _extraRadius, 19 + _extraRadius);
					y = this.Math.rand(13 - _extraRadius, 19 + _extraRadius);
				}
				else
				{
					x = this.Math.rand(11 - _extraRadius, 21 + _extraRadius);
					y = this.Math.rand(11 - _extraRadius, 21 + _extraRadius);
				}

				tries = ++tries;

				if (this.Tactical.isValidTileSquare(x, y) && this.Tactical.getTileSquare(x, y).IsEmpty && !this.isTileIsolated(this.Tactical.getTileSquare(x, y)))
				{
					break;
				}
			}

			local tile = this.Tactical.getTileSquare(x, y);
			local entity = this.Tactical.spawnEntity(e.Script, tile.Coords.X, tile.Coords.Y);
			this.setupEntity(entity, e);
		}
	}

	function placePlayersAtCenter( _players )
	{
		foreach( player in _players )
		{
			local x = 0;
			local y = 0;
			local tries = 0;

			while (1)
			{
				if (tries > 1000 && !this.clearedArea)
				{
					for( local x = 13; x != 19; x = ++x )
					{
						for( local y = 13; y != 19; y = ++y )
						{
							this.Tactical.getTile(x, y - x / 2).removeObject();
						}
					}

					this.clearedArea = true;
				}

				tries = ++tries;

				if (tries < 100)
				{
					x = this.Math.rand(14, 18);
					y = this.Math.rand(14, 18) - x / 2;
				}
				else if (tries < 1000)
				{
					x = this.Math.rand(13, 19);
					y = this.Math.rand(13, 19) - x / 2;
				}

				if (this.Tactical.getTile(x, y).IsEmpty && !this.isTileIsolated(this.Tactical.getTile(x, y)))
				{
					break;
				}
			}

			this.Tactical.addEntityToMap(player, x, y);

			if (!this.World.getTime().IsDaytime && player.getBaseProperties().IsAffectedByNight)
			{
				player.getSkills().add(this.new("scripts/skills/special/night_effect"));
			}
		}
	}

	function placePlayersInCircle( _players )
	{
		foreach( player in _players )
		{
			local x = 0;
			local y = 0;
			local tries = 0;

			while (1)
			{
				x = this.Math.rand(2, 29);
				y = this.Math.rand(2, 29);

				if (x > 5 && x < 26 && y > 5 && y < 26)
				{
					continue;
				}

				y = y - x / 2;

				if (this.Tactical.getTile(x, y).IsEmpty && !this.isTileIsolated(this.Tactical.getTile(x, y)))
				{
					break;
				}
			}

			this.Tactical.addEntityToMap(player, x, y);

			if (!this.World.getTime().IsDaytime && player.getBaseProperties().IsAffectedByNight)
			{
				player.getSkills().add(this.new("scripts/skills/special/night_effect"));
			}
		}
	}

	function placePlayersAtBorder( _players )
	{
		for( local x = 9; x <= 23; x = ++x )
		{
			for( local y = 2; y <= 4; y = ++y )
			{
				this.Tactical.getTile(x, y - x / 2).removeObject();
			}
		}

		foreach( e in _players )
		{
			local p = e.getPlaceInFormation();
			local y = p < 9 ? 3 : 2;
			local x = p < 9 ? 11 + p : 11 + p - 9;
			local tile = this.Tactical.getTileSquare(x, y);

			if (!tile.IsEmpty)
			{
				tile.removeObject();
			}

			if (this.isTileIsolated(tile))
			{
				local avg = 0;

				for( local x = 0; x < 6; x = ++x )
				{
					if (tile.hasNextTile(x))
					{
						avg = avg + tile.getNextTile(x).Level;
					}
				}

				tile.Level = avg / 6;
			}

			this.Tactical.addEntityToMap(e, tile.Coords.X, tile.Coords.Y);

			if (!this.World.getTime().IsDaytime && e.getBaseProperties().IsAffectedByNight)
			{
				e.getSkills().add(this.new("scripts/skills/special/night_effect"));
			}
		}
	}

	function placePlayersInFormation( _players, _offsetX = 0, _offsetY = 0 )
	{
		for( local x = 11 + _offsetX; x <= 14 + _offsetX; x = ++x )
		{
			for( local y = 10; y <= 20 + _offsetY; y = ++y )
			{
				this.Tactical.getTile(x, y - x / 2).removeObject();
			}
		}

		foreach( e in _players )
		{
			local p = e.getPlaceInFormation();
			local x = 13 - p / 9 + _offsetX;
			local y = 30 - (11 + p - p / 9 * 9) + _offsetY;
			local tile = this.Tactical.getTileSquare(x, y);

			if (!tile.IsEmpty)
			{
				tile.removeObject();
			}

			if (this.isTileIsolated(tile))
			{
				local avg = 0;

				for( local x = 0; x < 6; x = ++x )
				{
					if (tile.hasNextTile(x))
					{
						avg = avg + tile.getNextTile(x).Level;
					}
				}

				tile.Level = avg / 6;
			}

			this.Tactical.addEntityToMap(e, tile.Coords.X, tile.Coords.Y);

			if (!this.World.getTime().IsDaytime && e.getBaseProperties().IsAffectedByNight)
			{
				e.getSkills().add(this.new("scripts/skills/special/night_effect"));
			}
		}
	}

	function setupEntity( _e, _t )
	{
		_e.setWorldTroop(_t);
		_e.setFaction(_t.Faction);

		if (("Callback" in _t) && _t.Callback != null)
		{
			_t.Callback(_e, "Tag" in _t ? _t.Tag : null);
		}

		if (_t.Variant != 0)
		{
			_e.makeMiniboss();
		}

		_e.assignRandomEquipment();

		if (("Name" in _t) && _t.Name != "")
		{
			_e.setName(_t.Name);
			_e.m.IsGeneratingKillName = false;
		}

		if (!this.World.getTime().IsDaytime && _e.getBaseProperties().IsAffectedByNight)
		{
			_e.getSkills().add(this.new("scripts/skills/special/night_effect"));
		}
	}

	function isTileIsolated( _tile )
	{
		local isCompletelyIsolated = true;

		for( local i = 0; i != 6; i = ++i )
		{
			if (!_tile.hasNextTile(i))
			{
			}
			else if (_tile.getNextTile(i).IsEmpty && this.Math.abs(_tile.Level - _tile.getNextTile(i).Level) <= 1)
			{
				isCompletelyIsolated = false;
				break;
			}
		}

		if (isCompletelyIsolated)
		{
			return true;
		}

		local size = this.Tactical.getMapSize();

		if (_tile.Level == 0 && this.Tactical.getTileSquare(0, 0).Level == 3 && this.Tactical.getTileSquare(size.X - 1, size.Y - 1).Level == 3 && this.Tactical.getTileSquare(0, size.Y - 1).Level == 3 && this.Tactical.getTileSquare(size.X - 1, 0).Level == 3)
		{
			return false;
		}

		local allFactions = [];
		allFactions.resize(32, 0);

		for( local i = 0; i != 32; i = ++i )
		{
			allFactions[i] = i;
		}

		local navigator = this.Tactical.getNavigator();
		local settings = navigator.createSettings();
		settings.ActionPointCosts = this.Const.SameMovementAPCost;
		settings.FatigueCosts = this.Const.PathfinderMovementFatigueCost;
		settings.AllowZoneOfControlPassing = true;
		settings.AlliedFactions = allFactions;

		if (!navigator.findPath(_tile, this.Tactical.getTileSquare(0, 0), settings, 1) && !navigator.findPath(_tile, this.Tactical.getTileSquare(size.X - 1, size.Y - 1), settings, 1) && !navigator.findPath(_tile, this.Tactical.getTileSquare(0, size.Y - 1), settings, 1) && !navigator.findPath(_tile, this.Tactical.getTileSquare(size.X - 1, 0), settings, 1))
		{
			return true;
		}

		return false;
	}

	function onFactionCompare( _e1, _e2 )
	{
		if (this.World.FactionManager.isAlliedWithPlayer(_e1.Faction) && !this.World.FactionManager.isAlliedWithPlayer(_e2.Faction))
		{
			return -1;
		}
		else if (!this.World.FactionManager.isAlliedWithPlayer(_e1.Faction) && this.World.FactionManager.isAlliedWithPlayer(_e2.Faction))
		{
			return 1;
		}
		else
		{
			if (_e1.Faction < _e2.Faction)
			{
				return -1;
			}
			else if (_e1.Faction > _e2.Faction)
			{
				return 1;
			}

			return 0;
		}
	}

};


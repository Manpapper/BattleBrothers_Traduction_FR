this.lightning_storm_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = this.Math.rand(0, 1),
		AffectedTiles = [],
		HasCooldownAfterImpact = true
	},
	function create()
	{
		this.m.ID = "actives.lightning_storm";
		this.m.Name = "Lightning Strike";
		this.m.Description = "";
		this.m.KilledString = "Electrocuted";
		this.m.Icon = "skills/active_216.png";
		this.m.IconDisabled = "skills/active_216.png";
		this.m.Overlay = "active_216";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc6/cast_lightning_01.wav",
			"sounds/enemies/dlc6/cast_lightning_02.wav",
			"sounds/enemies/dlc6/cast_lightning_03.wav",
			"sounds/enemies/dlc6/cast_lightning_04.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/dlc6/lightning_impact_01.wav",
			"sounds/enemies/dlc6/lightning_impact_02.wav",
			"sounds/enemies/dlc6/lightning_impact_03.wav",
			"sounds/enemies/dlc6/lightning_impact_04.wav"
		];
		this.m.SoundOnHitDelay = 0;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.Delay = 2500;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsWeaponSkill = false;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.InjuriesOnBody = this.Const.Injury.BurningAndPiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.BurningAndPiercingHead;
		this.m.DirectDamageMult = 0.5;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 0;
		this.m.MinRange = 1;
		this.m.MaxRange = 999;
		this.m.MaxLevelDifference = 4;
	}

	function setCooldownAfterImpact( _c )
	{
		this.m.HasCooldownAfterImpact = true;

		if (!_c)
		{
			this.m.Cooldown = 0;
		}
	}

	function isUsable()
	{
		return this.skill.isUsable() && this.m.Cooldown == 0 && this.Tactical.Entities.getFlags().getAsInt("LightningStrikesActive") <= 2;
	}

	function isWaitingOnImpact()
	{
		return this.m.AffectedTiles.len() != 0;
	}

	function getTiles()
	{
		return this.m.AffectedTiles;
	}

	function getAffectedTiles( _targetTile )
	{
		local ret = [];
		local size = this.Tactical.getMapSize();

		for( local y = 0; y < size.Y; y = ++y )
		{
			local tile = this.Tactical.getTileSquare(_targetTile.SquareCoords.X, y);

			if (!tile.IsEmpty && !tile.IsOccupiedByActor)
			{
			}
			else
			{
				ret.push(tile);
			}
		}

		return ret;
	}

	function updateImpact()
	{
		if (this.m.AffectedTiles.len() != 0)
		{
			this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], 0.8);
			this.Time.scheduleEvent(this.TimeUnit.Real, 600, this.onImpact.bindenv(this), this);
		}
	}

	function onTurnStart()
	{
		this.m.Cooldown = this.Math.max(0, this.m.Cooldown - 1);
	}

	function onUse( _user, _targetTile )
	{
		this.m.Cooldown = 1;
		this.m.AffectedTiles = this.getAffectedTiles(_targetTile);

		foreach( tile in this.m.AffectedTiles )
		{
			tile.Properties.IsMarkedForImpact = true;
			tile.spawnDetail("mortar_target_02", this.Const.Tactical.DetailFlag.SpecialOverlay, false, true);
		}

		this.Tactical.Entities.getFlags().increment("LightningStrikesActive");

		if (!_user.isHiddenToPlayer())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " summons lightning");
		}

		return true;
	}

	function onDeath()
	{
		foreach( tile in this.m.AffectedTiles )
		{
			tile.Properties.IsMarkedForImpact = false;
			tile.clear(this.Const.Tactical.DetailFlag.SpecialOverlay);
		}

		this.m.AffectedTiles = [];
		this.Tactical.Entities.getFlags().set("LightningStrikesActive", this.Math.max(0, this.Tactical.Entities.getFlags().getAsInt("LightningStrikesActive") - 1));
	}

	function onImpact( _tag )
	{
		this.Tactical.EventLog.log("Lightning strikes the battlefield");
		this.Tactical.getCamera().quake(this.createVec(0, -1.0), 6.0, 0.16, 0.35);
		local actor = this.getContainer().getActor();

		foreach( i, t in _tag.m.AffectedTiles )
		{
			this.Time.scheduleEvent(this.TimeUnit.Real, i * 30, function ( _data )
			{
				local tile = _data.Tile;

				for( local i = 0; i < this.Const.Tactical.LightningParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(true, this.Const.Tactical.LightningParticles[i].Brushes, tile, this.Const.Tactical.LightningParticles[i].Delay, this.Const.Tactical.LightningParticles[i].Quantity, this.Const.Tactical.LightningParticles[i].LifeTimeQuantity, this.Const.Tactical.LightningParticles[i].SpawnRate, this.Const.Tactical.LightningParticles[i].Stages);
				}

				tile.clear(this.Const.Tactical.DetailFlag.SpecialOverlay);
				tile.Properties.IsMarkedForImpact = false;

				if ((tile.IsEmpty || tile.IsOccupiedByActor) && tile.Type != this.Const.Tactical.TerrainType.ShallowWater && tile.Type != this.Const.Tactical.TerrainType.DeepWater)
				{
					tile.clear(this.Const.Tactical.DetailFlag.Scorchmark);
					tile.spawnDetail("impact_decal", this.Const.Tactical.DetailFlag.Scorchmark, false, true);
				}

				if (tile.IsOccupiedByActor && !_data.User.isAlliedWith(tile.getEntity()))
				{
					local target = tile.getEntity();
					local hitInfo = clone this.Const.Tactical.HitInfo;
					hitInfo.DamageRegular = this.Math.rand(25, 50);
					hitInfo.DamageArmor = hitInfo.DamageRegular * 1.0;
					hitInfo.DamageDirect = 0.75;
					hitInfo.BodyPart = 0;
					hitInfo.FatalityChanceMult = 0.0;
					hitInfo.Injuries = this.Const.Injury.BurningBody;
					target.onDamageReceived(_data.User, _data.Skill, hitInfo);
				}
			}, {
				Tile = t,
				Skill = this,
				User = actor
			});
		}

		_tag.m.AffectedTiles = [];

		if (_tag.m.HasCooldownAfterImpact)
		{
			_tag.m.Cooldown = 1;
		}

		this.Tactical.Entities.getFlags().set("LightningStrikesActive", this.Math.max(0, this.Tactical.Entities.getFlags().getAsInt("LightningStrikesActive") - 1));
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin += 25;
			_properties.DamageRegularMax += 50;
			_properties.DamageArmorMult *= 1.0;
		}
	}

});


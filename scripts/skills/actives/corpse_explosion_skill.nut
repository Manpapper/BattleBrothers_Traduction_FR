this.corpse_explosion_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.corpse_explosion";
		this.m.Name = "Explosion de cadavre";
		this.m.Description = "";
		this.m.Icon = "skills/active_234.png";
		this.m.IconDisabled = "skills/active_234.png";
		this.m.Overlay = "active_234";
		this.m.SoundOnUse = [
			"sounds/enemies/corpse_explosion_01.wav",
			"sounds/enemies/corpse_explosion_02.wav",
			"sounds/enemies/corpse_explosion_03.wav",
			"sounds/enemies/corpse_explosion_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.Delay = 2000;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 8;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 99;
		this.m.MaxLevelDifference = 4;
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

	function isUsable()
	{
		return this.skill.isUsable();
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		local isFleshCradle = _targetTile.getEntity() != null && _targetTile.getEntity().getType() == this.Const.EntityType.FleshCradle && !_targetTile.getEntity().getIsDestroyed();

		if ((!_targetTile.IsCorpseSpawned || !_targetTile.Properties.get("Corpse").IsConsumable) && !isFleshCradle)
		{
			return false;
		}

		return true;
	}

	function spawnBloodbath( _targetTile )
	{
		for( local i = 0; i != this.Const.CorpsePart.len(); i = ++i )
		{
			_targetTile.spawnDetail(this.Const.CorpsePart[i]);
		}

		for( local i = 0; i != 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _targetTile.getNextTile(i);

				for( local n = this.Math.rand(0, 4); n != 0; n = --n )
				{
					local decal = this.Const.BloodDecals[this.Const.BloodType.Red][this.Math.rand(0, this.Const.BloodDecals[this.Const.BloodType.Red].len() - 1)];
					tile.spawnDetail(decal);
				}
			}
		}

		for( local n = 2; n != 0; n = --n )
		{
			local decal = this.Const.BloodDecals[this.Const.BloodType.Red][this.Math.rand(0, this.Const.BloodDecals[this.Const.BloodType.Red].len() - 1)];
			_targetTile.spawnDetail(decal);
		}
	}

	function onRemoveCorpse( _tile )
	{
		this.Tactical.Entities.removeCorpse(_tile);
		_tile.clear(this.Const.Tactical.DetailFlag.Corpse);
		_tile.Properties.remove("Corpse");
		_tile.Properties.remove("IsSpawningFlies");
	}

	function onDestroyFleshCradle( _data )
	{
		_data.FleshCradle.setDestroyed(true);
	}

	function onUse( _user, _targetTile )
	{
		local isFleshCradle = _targetTile.getEntity() != null && _targetTile.getEntity().getType() == this.Const.EntityType.FleshCradle && !_targetTile.getEntity().getIsDestroyed();

		if (isFleshCradle)
		{
			this.Time.scheduleEvent(this.TimeUnit.Real, 250, this.onDestroyFleshCradle.bindenv(this), {
				FleshCradle = _targetTile.getEntity()
			});
		}
		else
		{
			this.onRemoveCorpse(_targetTile);
		}

		this.Time.scheduleEvent(this.TimeUnit.Real, 250, this.onApply.bindenv(this), {
			Skill = this,
			TargetTile = _targetTile,
			User = _user
		});
		return true;
	}

	function onApply( _data )
	{
		this.spawnBloodbath(_data.TargetTile);
		local isFleshCradle = _data.TargetTile.getEntity() != null && _data.TargetTile.getEntity().getType() == this.Const.EntityType.FleshCradle && !_data.TargetTile.getEntity().getIsDestroyed();

		if (!_data.User.isHiddenToPlayer() || _data.TargetTile.IsVisibleForPlayer)
		{
			if (isFleshCradle)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_data.User) + " fait exploser un berceau de chair!");
			}
			else
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_data.User) + " fait exploser un cadavre !");
			}

			if (this.m.SoundOnUse.len() != 0)
			{
				this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill * 1.2, _data.User.getPos());
			}
		}

		local targets = [];
		targets.push(_data.TargetTile);

		for( local i = 0; i != 6; i = ++i )
		{
			if (!_data.TargetTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _data.TargetTile.getNextTile(i);
				targets.push(tile);
			}
		}

		foreach( targetTile in targets )
		{
			if (targetTile.ID == _data.TargetTile.ID)
			{
				for( local i = 0; i < this.Const.Tactical.CorpseExplosionParticles.len(); i = ++i )
				{
					local effect = this.Const.Tactical.CorpseExplosionParticles[i];
					this.Tactical.spawnParticleEffect(false, effect.Brushes, targetTile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 0));
				}
			}
			else
			{
				for( local i = 0; i < this.Const.Tactical.CorpseExplosionOuterParticles.len(); i = ++i )
				{
					local effect = this.Const.Tactical.CorpseExplosionOuterParticles[i];
					this.Tactical.spawnParticleEffect(false, effect.Brushes, targetTile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 0));
				}
			}

			if (targetTile.IsOccupiedByActor && !targetTile.getEntity().getSkills().hasSkill("racial.grand_diviner") && targetTile.getEntity().getType() != this.Const.EntityType.FleshCradle)
			{
				local hitInfo = clone this.Const.Tactical.HitInfo;
				hitInfo.DamageRegular = targetTile.isSameTileAs(_data.TargetTile) ? this.Math.rand(30, 60) : this.Math.rand(25, 50);
				hitInfo.DamageArmor = hitInfo.DamageRegular * 0.75;
				hitInfo.DamageDirect = 0.2;
				hitInfo.BodyPart = 0;
				hitInfo.FatalityChanceMult = 0.0;
				hitInfo.Injuries = this.Const.Injury.BurningAndPiercingBody;
				targetTile.getEntity().onDamageReceived(null, this, hitInfo);
			}

			this.Tactical.State.spawnMiasmaOnTile(targetTile);
		}
	}

});


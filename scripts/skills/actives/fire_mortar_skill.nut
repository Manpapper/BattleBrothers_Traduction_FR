this.fire_mortar_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 0,
		AffectedTiles = []
	},
	function create()
	{
		this.m.ID = "actives.fire_mortar";
 		this.m.Name = "Tir de Mortier";
        this.m.Description = "";
        this.m.KilledString = "Réduit en morceaux";
		this.m.Icon = "skills/active_211.png";
		this.m.IconDisabled = "skills/active_211.png";
		this.m.Overlay = "active_211";
		this.m.SoundOnUse = [
			"sounds/combat/dlc6/fire_mortar_01.wav",
			"sounds/combat/dlc6/fire_mortar_02.wav",
			"sounds/combat/dlc6/fire_mortar_03.wav",
			"sounds/combat/dlc6/fire_mortar_04.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/dlc6/fire_mortar_impact_01.wav",
			"sounds/combat/dlc6/fire_mortar_impact_01.wav",
			"sounds/combat/dlc6/fire_mortar_impact_01.wav",
			"sounds/combat/dlc6/fire_mortar_impact_01.wav"
		];
		this.m.SoundOnHitDelay = 0;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.Delay = 2500;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsWeaponSkill = true;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.InjuriesOnBody = this.Const.Injury.BurningAndPiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.BurningAndPiercingHead;
		this.m.DirectDamageMult = 0.2;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 0;
		this.m.MinRange = 3;
		this.m.MaxRange = 999;
		this.m.MaxLevelDifference = 4;
	}

	function isUsable()
	{
		return this.skill.isUsable() && (this.m.AffectedTiles.len() != 0 || this.m.Cooldown == 0);
	}

	function isWaitingOnImpact()
	{
		return this.m.AffectedTiles.len() != 0;
	}

	function getAffectedTiles( _targetTile )
	{
		local ret = [
			_targetTile
		];
		local myTile = this.m.Container.getActor().getTile();

		for( local i = 0; i < 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				ret.push(_targetTile.getNextTile(i));
			}
		}

		return ret;
	}

	function updateImpact()
	{
		if (this.m.AffectedTiles.len() != 0)
		{
			this.getContainer().getActor().setActionPoints(0);
			this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], 1.0, this.m.AffectedTiles[0].Pos);
			this.Time.scheduleEvent(this.TimeUnit.Real, 1400, this.onImpact.bindenv(this), this);
		}
	}

	function onTurnStart()
	{
		this.m.Cooldown = this.Math.max(0, this.m.Cooldown - 1);
	}

	function onUse( _user, _targetTile )
	{
		this.m.Cooldown = 2;
		this.m.AffectedTiles = this.getAffectedTiles(_targetTile);

		foreach( tile in this.m.AffectedTiles )
		{
			tile.Properties.IsMarkedForImpact = true;
			tile.spawnDetail("mortar_target_02", this.Const.Tactical.DetailFlag.SpecialOverlay, false, true);
		}

		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, this.onSpawnFireEffect.bindenv(this), this);

		if (!_user.isHiddenToPlayer())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " tir un obus haut dans les airs");
		}

		return true;
	}

	function onSpawnFireEffect( _tag )
	{
		local myTile = _tag.getContainer().getActor().getTile();

		if (_tag.getContainer().getActor().isAlliedWithPlayer())
		{
			for( local i = 0; i < this.Const.Tactical.MortarFireRightParticles.len(); i = ++i )
			{
				local effect = this.Const.Tactical.MortarFireRightParticles[i];
				this.Tactical.spawnParticleEffect(false, effect.Brushes, myTile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 0));
			}
		}
		else
		{
			for( local i = 0; i < this.Const.Tactical.MortarFireLeftParticles.len(); i = ++i )
			{
				local effect = this.Const.Tactical.MortarFireLeftParticles[i];
				this.Tactical.spawnParticleEffect(false, effect.Brushes, myTile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 0));
			}
		}
	}

	function onImpact( _tag )
	{
		this.Tactical.EventLog.log("A mortar shell impacts on the battlefield");
		this.Tactical.getCamera().quake(this.createVec(0, -1.0), 6.0, 0.16, 0.35);

		for( local i = 0; i < this.Const.Tactical.MortarImpactParticles.len(); i = ++i )
		{
			local effect = this.Const.Tactical.MortarImpactParticles[i];
			this.Tactical.spawnParticleEffect(false, effect.Brushes, _tag.m.AffectedTiles[0], effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 0));
		}

		foreach( t in _tag.m.AffectedTiles )
		{
			t.clear(this.Const.Tactical.DetailFlag.SpecialOverlay);
			t.Properties.IsMarkedForImpact = false;

			if (t.IsOccupiedByActor)
			{
				local target = t.getEntity();

				if (target.getMoraleState() != this.Const.MoraleState.Ignore)
				{
					target.checkMorale(-1, 0);
					target.getSkills().add(this.new("scripts/skills/effects/shellshocked_effect"));
				}

				local hitInfo = clone this.Const.Tactical.HitInfo;
				hitInfo.DamageRegular = this.Math.rand(20, 40);
				hitInfo.DamageArmor = hitInfo.DamageRegular * 0.7;
				hitInfo.DamageDirect = 0.2;
				hitInfo.BodyPart = 0;
				hitInfo.FatalityChanceMult = 0.0;
				hitInfo.Injuries = this.Const.Injury.BurningAndPiercingBody;
				target.onDamageReceived(null, this, hitInfo);
			}

			if (t.Type != this.Const.Tactical.TerrainType.ShallowWater && t.Type != this.Const.Tactical.TerrainType.DeepWater)
			{
				t.clear(this.Const.Tactical.DetailFlag.Scorchmark);
				t.spawnDetail("impact_decal", this.Const.Tactical.DetailFlag.Scorchmark, false, true);
			}
		}

		_tag.m.AffectedTiles = [];
	}

});


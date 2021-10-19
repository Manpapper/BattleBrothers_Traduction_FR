this.actor <- this.inherit("scripts/entity/tactical/entity", {
	m = {
		Type = 0,
		AIAgent = null,
		BaseProperties = null,
		CurrentProperties = null,
		Skills = null,
		Items = null,
		Name = "",
		Title = "",
		WorldTroop = null,
		BloodType = this.Const.BloodType.None,
		BloodSaturation = 1.0,
		BloodColor = this.createColor("#ffffff"),
		ExcludedInjuries = [],
		MoraleState = this.Const.MoraleState.Steady,
		MaxMoraleState = this.Const.MoraleState.Confident,
		ConfidentMoraleBrush = "icon_confident",
		MaxEnemiesThisTurn = 1,
		Hitpoints = 1,
		ActionPoints = 0,
		Fatigue = 0,
		XP = 0,
		FleeingRounds = 0,
		PreviewActionPoints = 0,
		PreviewFatigue = 0,
		PreviewSkillID = "",
		OverwhelmCount = [],
		AttackedCount = [],
		BloodiedCount = 0,
		RiposteSkillCounter = 0,
		ActionPointCosts = this.Const.DefaultMovementAPCost,
		FatigueCosts = this.Const.DefaultMovementFatigueCost,
		LevelActionPointCost = this.Const.Movement.LevelDifferenceActionPointCost,
		LevelFatigueCost = this.Const.Movement.LevelDifferenceFatigueCost,
		CurrentMovementType = this.Const.Tactical.MovementType.Default,
		MaxTraversibleLevels = 1,
		Sound = [],
		SoundVolume = [],
		SoundPitch = 1.0,
		SoundVolumeOverall = 1.0,
		LastSound = "",
		BloodSplatterOffset = this.createVec(0, 0),
		DecapitateSplatterOffset = this.createVec(-4, -31),
		SmashSplatterOffset = this.createVec(-15, -45),
		ShakeLayers = this.Const.ShakeCharacterLayers,
		DecapitateBloodAmount = 1.0,
		DeathBloodAmount = 1.0,
		BloodPoolScale = 1.0,
		RenderAnimationStartTime = 0.0,
		RenderAnimationOffset = this.createVec(0, 0),
		RenderAnimationSpeed = 1.0,
		RenderAnimationDistanceMult = 1.0,
		OnMovementFinishCallback = null,
		IsControlledByPlayer = false,
		IsTurnStarted = false,
		IsTurnDone = false,
		IsWaitActionSpent = false,
		IsSkippingTurn = false,
		IsDying = false,
		IsAbleToDie = true,
		IsUsingZoneOfControl = true,
		IsExertingZoneOfOccupation = false,
		IsExertingZoneOfControl = false,
		IsMoving = false,
		IsCorpseFlipped = false,
		IsRaisingShield = false,
		IsLoweringShield = false,
		IsLoweringWeapon = false,
		IsRaisingWeapon = false,
		IsRaising = false,
		IsSinking = false,
		IsRaisingRooted = false,
		IsUsingCustomRendering = false,
		IsActingEachTurn = true,
		IsNonCombatant = false,
		IsShakingOnHit = true,
		IsFlashingOnHit = true,
		IsActingIm\'ately = false,
		IsResurrected = false,
		IsEmittingMovementSounds = true,
		IsHidingHelmet = false,
		IsGeneratingKillName = true,
		IsMiniboss = false
	},
	function getType()
	{
		return this.m.Type;
	}

	function getAIAgent()
	{
		return this.m.AIAgent;
	}

	function setAIAgent( _a )
	{
		this.m.AIAgent = _a;
	}

	function getBaseProperties()
	{
		return this.m.BaseProperties;
	}

	function getCurrentProperties()
	{
		return this.m.CurrentProperties;
	}

	function setCurrentProperties( _c )
	{
		this.m.CurrentProperties = _c;
	}

	function getSkills()
	{
		return this.m.Skills;
	}

	function getItems()
	{
		return this.m.Items;
	}

	function getOverwhelmCount()
	{
		return this.m.OverwhelmCount.len();
	}

	function getAttackedCount()
	{
		return this.m.AttackedCount.len();
	}

	function getAttackers()
	{
		return this.m.AttackedCount;
	}

	function getHitpoints()
	{
		return this.m.Hitpoints;
	}

	function getHitpointsMax()
	{
		return this.Math.floor(this.m.CurrentProperties.Hitpoints * (this.m.CurrentProperties.HitpointsMult >= 0 ? this.m.CurrentProperties.HitpointsMult : 1.0 / this.m.CurrentProperties.HitpointsMult));
	}

	function getHitpointsPct()
	{
		return this.Math.minf(1.0, this.getHitpoints() / this.Math.maxf(1.0, this.getHitpointsMax()));
	}

	function setHitpoints( _h )
	{
		this.m.Hitpoints = this.Math.round(_h);
		this.onUpdateInjuryLayer();
	}

	function setHitpointsPct( _h )
	{
		this.m.Hitpoints = this.Math.round(this.getHitpointsMax() * _h);
		this.onUpdateInjuryLayer();
	}

	function getActionPoints()
	{
		return this.m.ActionPoints;
	}

	function getActionPointsMax()
	{
		return this.m.CurrentProperties.ActionPoints * this.m.CurrentProperties.ActionPointsMult;
	}

	function setActionPoints( _a )
	{
		this.m.ActionPoints = this.Math.round(_a);
		this.setPreviewActionPoints(_a);
	}

	function getMoraleState()
	{
		return this.m.MoraleState;
	}

	function setMaxMoraleState( _s )
	{
		this.m.MaxMoraleState = _s;
	}

	function getBravery()
	{
		return this.m.CurrentProperties.getBravery();
	}

	function getFatigue()
	{
		return this.m.Fatigue;
	}

	function getFatigueMax()
	{
		return this.Math.floor(this.m.CurrentProperties.Stamina * (this.m.CurrentProperties.StaminaMult >= 0 ? this.m.CurrentProperties.StaminaMult : 1.0 / this.m.CurrentProperties.StaminaMult));
	}

	function getFatiguePct()
	{
		return this.Math.minf(1.0, this.m.Fatigue / this.Math.maxf(1.0, this.getFatigueMax()));
	}

	function setFatigue( _f )
	{
		this.m.Fatigue = this.Math.max(0, this.Math.round(_f));
		this.setPreviewFatigue(_f);
	}

	function getInitiative()
	{
		return this.Math.round(this.m.CurrentProperties.Initiative * (this.m.CurrentProperties.InitiativeMult >= 0 ? this.m.CurrentProperties.InitiativeMult : 1.0 / this.m.CurrentProperties.InitiativeMult) - this.m.Fatigue * this.m.CurrentProperties.FatigueToInitiativeRate - this.Math.max(0, this.m.BaseProperties.Stamina - this.m.CurrentProperties.Stamina));
	}

	function getTurnOrderInitiative()
	{
		return (this.getInitiative() + this.getCurrentProperties().InitiativeForTurnOrderAdditional) * this.getCurrentProperties().InitiativeForTurnOrderMult * (this.isWaitActionSpent() ? this.getCurrentProperties().InitiativeAfterWaitMult : 1.0);
	}

	function getXPValue()
	{
		return this.m.XP;
	}

	function getLevel()
	{
		return 1;
	}

	function getHitpointsState()
	{
		return this.Math.min(this.Const.HitpointsStateName.len() - 1, this.Math.max(0, this.Math.floor(this.m.Hitpoints / (this.getHitpointsMax() * 1.0) * (this.Const.HitpointsStateName.len() - 1))));
	}

	function getFatigueState()
	{
		return this.Math.min(this.Const.FatigueStateName.len() - 1, this.Math.max(0, this.Math.floor(this.m.Fatigue / (this.getFatigueMax() * 1.0) * (this.Const.FatigueStateName.len() - 1))));
	}

	function getArmorState( _bodyPart )
	{
		if (this.getArmor(_bodyPart) != 0)
		{
			return this.Math.min(this.Const.ArmorStateName.len() - 1, this.Math.max(0, 1 + this.Math.floor(this.getArmor(_bodyPart) / this.Math.maxf(1.0, this.getArmorMax(_bodyPart) * 1.0) * (this.Const.ArmorStateName.len() - 2))));
		}
		else
		{
			return 0;
		}
	}

	function getArmor( _bodyPart )
	{
		return this.Math.floor(this.m.CurrentProperties.Armor[_bodyPart] * this.m.CurrentProperties.ArmorMult[_bodyPart]);
	}

	function getArmorMax( _bodyPart )
	{
		return this.Math.floor(this.m.CurrentProperties.ArmorMax[_bodyPart] * this.m.CurrentProperties.ArmorMult[_bodyPart]);
	}

	function setPreviewActionPoints( _a )
	{
		this.m.PreviewActionPoints = this.Math.round(_a);
	}

	function getPreviewActionPoints()
	{
		return this.m.PreviewActionPoints;
	}

	function setPreviewFatigue( _f )
	{
		this.m.PreviewFatigue = this.Math.round(_f);
	}

	function getPreviewFatigue()
	{
		return this.m.PreviewFatigue;
	}

	function setPreviewSkillID( _id )
	{
		this.m.PreviewSkillID = _id;
	}

	function getPreviewSkillID()
	{
		return this.m.PreviewSkillID;
	}

	function getSoundPitch()
	{
		return this.m.SoundPitch;
	}

	function getSoundVolume( _t )
	{
		return this.m.SoundVolume[_t];
	}

	function getActionPointCostsRaw()
	{
		return this.m.ActionPointCosts;
	}

	function getActionPointCosts()
	{
		local c = clone this.m.ActionPointCosts;

		for( local i = 0; i < c.len(); i = ++i )
		{
			c[i] = this.Math.max(1, (c[i] + this.m.CurrentProperties.MovementAPCostAdditional) * this.m.CurrentProperties.MovementAPCostMult);
		}

		return c;
	}

	function getFatigueCosts()
	{
		local c = clone this.m.FatigueCosts;

		for( local i = 0; i < c.len(); i = ++i )
		{
			c[i] = this.Math.round((c[i] + this.m.CurrentProperties.MovementFatigueCostAdditional) * this.m.CurrentProperties.MovementFatigueCostMult);
		}

		return c;
	}

	function getLevelActionPointCost()
	{
		return this.m.LevelActionPointCost;
	}

	function getLevelFatigueCost()
	{
		return this.m.LevelFatigueCost;
	}

	function getMaxTraversibleLevels()
	{
		return this.m.MaxTraversibleLevels;
	}

	function getBloodType()
	{
		return this.m.BloodType;
	}

	function setCurrentMovementType( _t )
	{
		this.m.CurrentMovementType = _t;
	}

	function getWorldTroop()
	{
		return this.m.WorldTroop;
	}

	function setWorldTroop( _t )
	{
		this.m.WorldTroop = _t;
	}

	function isDying()
	{
		return this.m.IsDying;
	}

	function isResurrected()
	{
		return this.m.IsResurrected;
	}

	function isPlayingRenderAnimation()
	{
		return this.m.IsRaising || this.m.IsSinking;
	}

	function isWaitActionSpent()
	{
		return this.m.IsWaitActionSpent;
	}

	function isAbleToWait()
	{
		return this.Tactical.TurnSequenceBar.canEntityWait(this);
	}

	function isAbleToDie()
	{
		return this.m.IsAbleToDie;
	}

	function isWavering()
	{
		return this.m.IsWavering;
	}

	function isTurnStarted()
	{
		return this.m.IsTurnStarted;
	}

	function isPlayerControlled()
	{
		return this.getFaction() == this.Const.Faction.Player && this.m.IsControlledByPlayer;
	}

	function isInOverwhelmCount( _actor )
	{
		return this.m.OverwhelmCount.find(_actor.getID()) != null;
	}

	function isFatigued()
	{
		return this.getFatigueMax() - this.getFatigue() <= 20;
	}

	function isNonCombatant()
	{
		return this.m.IsNonCombatant;
	}

	function setIsAbleToDie( _d )
	{
		this.m.IsAbleToDie = _d;
	}

	function setWaitActionSpent( _f )
	{
		this.m.IsWaitActionSpent = _f;
	}

	function setSkipTurn( _f )
	{
		this.m.IsSkippingTurn = _f;
	}

	function isArmedWithRangedWeapon()
	{
		local item = this.m.Items.getItemAtSlot(this.Const.ItemSlot.Mainhand);
		return item != null && item.isItemType(this.Const.Items.ItemType.RangedWeapon);
	}

	function isArmedWithMeleeWeapon()
	{
		local item = this.m.Items.getItemAtSlot(this.Const.ItemSlot.Mainhand);
		return item != null && item.isItemType(this.Const.Items.ItemType.MeleeWeapon);
	}

	function isArmedWithShield()
	{
		local item = this.m.Items.getItemAtSlot(this.Const.ItemSlot.Offhand);
		return item != null && item.isItemType(this.Const.Items.ItemType.Shield) && item.getCondition() > 0;
	}

	function getIdealRange()
	{
		local item = this.m.Items.getItemAtSlot(this.Const.ItemSlot.Mainhand);

		if (item == null)
		{
			return 1;
		}
		else
		{
			return this.Math.min(item.getRangeIdeal(), this.m.CurrentProperties.getVision());
		}
	}

	function getImageOffsetX()
	{
		return 0;
	}

	function getImageOffsetY()
	{
		return 0;
	}

	function getName()
	{
		if (this.m.Title.len() != 0)
		{
			return this.m.Name + " " + this.m.Title;
		}
		else
		{
			return this.m.Name;
		}
	}

	function getNameOnly()
	{
		return this.m.Name;
	}

	function setName( _value )
	{
		this.m.Name = _value;
	}

	function getKilledName()
	{
		return this.m.IsGeneratingKillName ? this.Const.Strings.getArticle(this.m.Name) + this.m.Name : this.m.Name;
	}

	function getTitle()
	{
		return this.m.Title;
	}

	function setTitle( _value )
	{
		this.m.Title = _value;
	}

	function isTurnDone()
	{
		if (this.Tactical.getNavigator().isTravelling(this))
		{
			return false;
		}

		local adrenaline = this.m.Skills.getSkillByID("actives.adrenaline");

		if (!this.isPlayerControlled() || this.m.CurrentProperties.IsStunned || !this.Settings.getGameplaySettings().DontAutoEndTurns)
		{
			return this.m.IsTurnDone || this.m.IsSkippingTurn || this.m.ActionPoints < this.Const.Movement.AutoEndTurnBelowAP && !this.m.Skills.isBusy() && (adrenaline == null || this.m.ActionPoints < adrenaline.getActionPointCost() || this.getFatigueMax() - this.getFatigue() < adrenaline.getFatigueCost() || this.m.Skills.hasSkill("effects.adrenaline"));
		}
		else
		{
			return this.m.IsTurnDone || this.m.IsSkippingTurn;
		}
	}

	function isAlliedWith( _actor )
	{
		local f = 0;

		if (typeof _actor == "instance" || typeof _actor == "table")
		{
			f = _actor.getFaction();
		}
		else
		{
			f = _actor;
		}

		if (("State" in this.Tactical) && this.Tactical.State != null && this.Tactical.State.isScenarioMode())
		{
			return f == this.getFaction() || this.Const.FactionAlliance[this.getFaction()].find(f) != null;
		}
		else
		{
			return this.World.FactionManager.isAllied(this.getFaction(), f);
		}
	}

	function isAlliedWithPlayer()
	{
		if (("State" in this.Tactical) && this.Tactical.State != null && this.Tactical.State.isScenarioMode())
		{
			return this.Const.FactionAlliance[this.getFaction()].find(this.Const.Faction.Player) != null;
		}
		else
		{
			return this.World.FactionManager.isAlliedWithPlayer(this.getFaction());
		}
	}

	function getAlliedFactions()
	{
		if (("State" in this.Tactical) && this.Tactical.State != null && this.Tactical.State.isScenarioMode())
		{
			return this.Const.FactionAlliance[this.getFaction()];
		}
		else
		{
			return this.World.FactionManager.getAlliedFactions(this.getFaction());
		}
	}

	function setFaction( _f )
	{
		if (this.getFaction() == _f)
		{
			return;
		}

		if (this.isPlacedOnMap())
		{
			this.setZoneOfControl(this.getTile(), false);

			if (this.m.IsExertingZoneOfOccupation)
			{
				this.getTile().removeZoneOfOccupation(this.getFaction());
				this.m.IsExertingZoneOfOccupation = false;
			}

			this.Tactical.Entities.removeInstance(this, true);
		}

		this.setFactionEx(_f);

		if (this.isPlacedOnMap())
		{
			this.Tactical.Entities.addInstance(this);
			this.setZoneOfControl(this.getTile(), this.hasZoneOfControl());
			this.getTile().addZoneOfOccupation(this.getFaction());
			this.m.IsExertingZoneOfOccupation = true;
		}

		if (this.m.Items != null)
		{
			this.m.Items.onFactionChanged(_f);
		}

		this.onFactionChanged();
	}

	function showArrow( _v )
	{
		local arrow = this.getSprite("arrow");

		if (_v)
		{
			arrow.Visible = true;
			arrow.fadeIn(100);
		}
		else
		{
			arrow.fadeOutAndHide(100);
		}
	}

	function raiseRootsFromGround( _frontBrush, _backBrush )
	{
		local rooted_front = this.getSprite("status_rooted");
		rooted_front.setBrush(_frontBrush);
		rooted_front.Visible = true;
		local rooted_back = this.getSprite("status_rooted_back");
		rooted_back.setBrush(_backBrush);
		rooted_back.Visible = true;

		if (this.getTile().hasNextTile(this.Const.Direction.S) && this.getTile().Level <= this.getTile().getNextTile(this.Const.Direction.S).Level)
		{
			this.m.RenderAnimationOffset = this.getSpriteOffset("status_rooted");
			this.m.IsRaisingRooted = true;
			this.m.RenderAnimationStartTime = this.Time.getVirtualTimeF();
			this.setRenderCallbackEnabled(true);
		}
		else
		{
			rooted_front.Alpha = 0;
			rooted_front.fadeIn(300);
			rooted_back.Alpha = 0;
			rooted_back.fadeIn(300);
		}

		if (this.Const.Tactical.RaiseFromGroundParticles.len() != 0)
		{
			for( local i = 0; i < this.Const.Tactical.RaiseFromGroundParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.RaiseFromGroundParticles[i].Brushes, this.getTile(), 0, this.Const.Tactical.RaiseFromGroundParticles[i].Quantity, this.Const.Tactical.RaiseFromGroundParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseFromGroundParticles[i].SpawnRate, this.Const.Tactical.RaiseFromGroundParticles[i].Stages);
			}
		}
	}

	function riseFromGround( _speedMult = 1.0 )
	{
		if (!this.isHiddenToPlayer() || this.Math.rand(0, 1) == 1)
		{
			this.playSound(this.Const.Sound.ActorEvent.Resurrect, this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.Resurrect] * this.m.SoundVolumeOverall);
		}

		if (this.getTile().IsVisibleForPlayer)
		{
			if (this.getTile().hasNextTile(this.Const.Direction.S) && this.getTile().Level <= this.getTile().getNextTile(this.Const.Direction.S).Level && this.getTile().getNextTile(this.Const.Direction.S).IsDiscovered)
			{
				this.m.IsAttackable = false;
				this.m.IsRaising = true;
				this.m.RenderAnimationStartTime = this.Time.getVirtualTimeF();
				this.m.RenderAnimationSpeed = _speedMult;
				this.setRenderCallbackEnabled(true);
			}
			else
			{
				this.setAlpha(0);
				this.fadeIn(1000 * _speedMult);
			}

			if (this.Const.Tactical.TerrainDropdownParticles[this.getTile().Subtype].len() != 0)
			{
				local tile = this.getTile();

				for( local i = 0; i < this.Const.Tactical.TerrainDropdownParticles[tile.Subtype].len(); i = ++i )
				{
					if (this.Tactical.getWeather().IsRaining && !this.Const.Tactical.TerrainDropdownParticles[tile.Subtype][i].ApplyOnRain)
					{
					}
					else
					{
						this.Tactical.spawnParticleEffect(false, this.Const.Tactical.TerrainDropdownParticles[tile.Subtype][i].Brushes, tile, this.Const.Tactical.TerrainDropdownParticles[tile.Subtype][i].Delay, this.Const.Tactical.TerrainDropdownParticles[tile.Subtype][i].Quantity, this.Const.Tactical.TerrainDropdownParticles[tile.Subtype][i].LifeTimeQuantity, this.Const.Tactical.TerrainDropdownParticles[tile.Subtype][i].SpawnRate, this.Const.Tactical.TerrainDropdownParticles[tile.Subtype][i].Stages);
					}
				}
			}
			else if (this.Const.Tactical.RaiseFromGroundParticles.len() != 0)
			{
				for( local i = 0; i < this.Const.Tactical.RaiseFromGroundParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.RaiseFromGroundParticles[i].Brushes, this.getTile(), this.Const.Tactical.RaiseFromGroundParticles[i].Delay, this.Const.Tactical.RaiseFromGroundParticles[i].Quantity, this.Const.Tactical.RaiseFromGroundParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseFromGroundParticles[i].SpawnRate, this.Const.Tactical.RaiseFromGroundParticles[i].Stages);
				}
			}
		}
	}

	function sinkIntoGround( _speedMult = 1.0 )
	{
		if (!this.isHiddenToPlayer() || this.Math.rand(0, 1) == 1)
		{
			this.playSound(this.Const.Sound.ActorEvent.Resurrect, this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.Resurrect] * this.m.SoundVolumeOverall);
		}

		if (this.getTile().IsVisibleForPlayer)
		{
			if (this.getTile().hasNextTile(this.Const.Direction.S) && this.getTile().Level <= this.getTile().getNextTile(this.Const.Direction.S).Level && this.getTile().getNextTile(this.Const.Direction.S).IsDiscovered)
			{
				this.m.IsAttackable = false;
				this.m.IsSinking = true;
				this.m.RenderAnimationStartTime = this.Time.getVirtualTimeF();
				this.m.RenderAnimationSpeed = _speedMult;
				this.setRenderCallbackEnabled(true);
			}
			else
			{
				this.setAlpha(255);
				this.fadeOut(1000 * _speedMult);
			}

			if (this.Const.Tactical.TerrainDropdownParticles[this.getTile().Subtype].len() != 0)
			{
				local tile = this.getTile();

				for( local i = 0; i < this.Const.Tactical.TerrainDropdownParticles[tile.Subtype].len(); i = ++i )
				{
					if (this.Tactical.getWeather().IsRaining && !this.Const.Tactical.TerrainDropdownParticles[tile.Subtype][i].ApplyOnRain)
					{
					}
					else
					{
						this.Tactical.spawnParticleEffect(false, this.Const.Tactical.TerrainDropdownParticles[tile.Subtype][i].Brushes, tile, this.Const.Tactical.TerrainDropdownParticles[tile.Subtype][i].Delay, this.Const.Tactical.TerrainDropdownParticles[tile.Subtype][i].Quantity, this.Const.Tactical.TerrainDropdownParticles[tile.Subtype][i].LifeTimeQuantity, this.Const.Tactical.TerrainDropdownParticles[tile.Subtype][i].SpawnRate, this.Const.Tactical.TerrainDropdownParticles[tile.Subtype][i].Stages);
					}
				}
			}
			else if (this.Const.Tactical.RaiseFromGroundParticles.len() != 0)
			{
				for( local i = 0; i < this.Const.Tactical.RaiseFromGroundParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.RaiseFromGroundParticles[i].Brushes, this.getTile(), this.Const.Tactical.RaiseFromGroundParticles[i].Delay, this.Const.Tactical.RaiseFromGroundParticles[i].Quantity, this.Const.Tactical.RaiseFromGroundParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseFromGroundParticles[i].SpawnRate, this.Const.Tactical.RaiseFromGroundParticles[i].Stages);
				}
			}
		}
	}

	function setDirty( _value )
	{
		if (!this.m.IsAlive || this.m.IsDying)
		{
			return;
		}

		this.updateOverlay();
		this.m.ContentID = this.Math.rand() + this.Math.rand();

		if (this.isPlacedOnMap())
		{
			if (this.m.IsActingEachTurn && this.Tactical.TurnSequenceBar.getActiveEntity() == this)
			{
				this.m.IsDirty = _value;
			}
			else if (_value)
			{
				this.Tactical.TurnSequenceBar.updateEntity(this.getID());
				this.m.IsDirty = false;
			}
		}
		else
		{
			this.m.IsDirty = true;
		}
	}

	function updateOverlay()
	{
		if (!this.isAlive())
		{
			return;
		}

		local headArmor = 0.0;
		local bodyArmor = 0.0;

		if (this.getArmorMax(this.Const.BodyPart.Head) > 0)
		{
			headArmor = this.getArmor(this.Const.BodyPart.Head) / this.getArmorMax(this.Const.BodyPart.Head);
		}

		if (this.getArmorMax(this.Const.BodyPart.Body) > 0)
		{
			bodyArmor = this.getArmor(this.Const.BodyPart.Body) / this.getArmorMax(this.Const.BodyPart.Body);
		}

		this.setOverlayValues(headArmor, bodyArmor, this.Math.minf(1.0, this.getHitpoints() / this.getHitpointsMax()));
		local status = this.getSkills().query(this.Const.SkillType.StatusEffect | this.Const.SkillType.Terrain);
		local icons = [];

		foreach( s in status )
		{
			if (s.getIconMini().len() != 0)
			{
				icons.push(s.getIconMini());
			}
		}

		this.setOverlayIcons(icons);
	}

	function getImagePath()
	{
		if (!this.isPlacedOnMap() || this.isDiscovered())
		{
			return "tacticalentity(" + this.m.ContentID + "," + this.getID() + ",socket,miniboss,arrow)";
		}
		else
		{
			return "ui/images/undiscovered_opponent.png";
		}
	}

	function getLevelImagePath()
	{
		return this.isPlacedOnMap() ? "ui/tooltips/height_" + this.getTile().Level + ".png" : "";
	}

	function updateVisibilityForFaction()
	{
		this.updateVisibility(this.getTile(), this.m.CurrentProperties.getVision(), this.getFaction());

		if (this.getFaction() == this.Const.Faction.PlayerAnimals)
		{
			this.updateVisibility(this.getTile(), this.m.CurrentProperties.getVision(), this.Const.Faction.Player);
		}
	}

	function getSurroundedCount()
	{
		local tile = this.getTile();
		local c = 0;

		for( local i = 0; i != 6; i = ++i )
		{
			if (!tile.hasNextTile(i))
			{
			}
			else
			{
				local next = tile.getNextTile(i);

				if (next.IsOccupiedByActor && this.Math.abs(next.Level - tile.Level) <= 1 && !next.getEntity().isNonCombatant() && !next.getEntity().isAlliedWith(this) && !next.getEntity().getCurrentProperties().IsStunned && !next.getEntity().isArmedWithRangedWeapon())
				{
					c = ++c;
				}
			}
		}

		return this.Math.max(0, c - 1 - this.m.CurrentProperties.StartSurroundCountAt);
	}

	function getDefense( _attackingEntity, _skill, _properties )
	{
		local malus = 0;
		local d = 0;

		if (!this.m.CurrentProperties.IsImmuneToSurrounding)
		{
			malus = _attackingEntity != null ? this.Math.max(0, _attackingEntity.getCurrentProperties().SurroundedBonus - this.getCurrentProperties().SurroundedDefense) * this.getSurroundedCount() : this.Math.max(0, 5 - this.getCurrentProperties().SurroundedDefense) * this.getSurroundedCount();
		}

		if (_skill.isRanged())
		{
			d = _properties.getRangedDefense();
		}
		else
		{
			d = _properties.getMeleeDefense();
		}

		if (d > 50)
		{
			local e = d - 50;
			d = 50 + e * 0.5;
		}

		if (!_skill.isRanged())
		{
			d = d - malus;
		}

		return d;
	}

	function getTooltip( _targetedWithSkill = null )
	{
		if (!this.isPlacedOnMap() || !this.isAlive() || this.isDying())
		{
			return [];
		}

		if (!this.isDiscovered())
		{
			local tooltip = [
				{
					id = 1,
					type = "title",
					text = "Hidden Opponent"
				}
			];
			return tooltip;
		}

		local tooltip = [
			{
				id = 1,
				type = "title",
				text = this.getName(),
				icon = this.getLevelImagePath()
			}
		];

		if (this.isHiddenToPlayer())
		{
			tooltip.push({
				id = 3,
				type = "headerText",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Pas actuellement en vue[/color]"
			});
		}
		else
		{
			if (_targetedWithSkill != null && this.isKindOf(_targetedWithSkill, "skill"))
			{
				local tile = this.getTile();

				if (tile.IsVisibleForEntity && _targetedWithSkill.isUsableOn(tile))
				{
					local hitchance = _targetedWithSkill.getHitchance(this);
					tooltip.push({
						id = 3,
						type = "headerText",
						icon = "ui/icons/hitchance.png",
						children = _targetedWithSkill.getHitFactors(tile),
						text = "[color=" + this.Const.UI.Color.PositiveValue + "]" + hitchance + "%[/color] de chance de toucher"
					});
				}
			}

			if (this.m.IsActingEachTurn)
			{
				local turnsToGo = this.Tactical.TurnSequenceBar.getTurnsUntilActive(this.getID());

				if (this.Tactical.TurnSequenceBar.getActiveEntity() == this)
				{
					tooltip.push({
						id = 4,
						type = "text",
						icon = "ui/icons/initiative.png",
						text = "Agit maintenant !"
					});
				}
				else if (this.m.IsTurnDone || turnsToGo == null)
				{
					tooltip.push({
						id = 4,
						type = "text",
						icon = "ui/icons/initiative.png",
						text = "Tour terminé"
					});
				}
				else
				{
					tooltip.push({
						id = 4,
						type = "text",
						icon = "ui/icons/initiative.png",
						text = "Agit dans " + turnsToGo + (turnsToGo > 1 ? " tours" : " tour")
					});
				}
			}

			tooltip.push({
				id = 5,
				type = "progressbar",
				icon = "ui/icons/armor_head.png",
				value = this.getArmor(this.Const.BodyPart.Head),
				valueMax = this.getArmorMax(this.Const.BodyPart.Head),
				text = this.Const.ArmorStateName[this.getArmorState(this.Const.BodyPart.Head)],
				style = "armor-head-slim"
			});
			tooltip.push({
				id = 6,
				type = "progressbar",
				icon = "ui/icons/armor_body.png",
				value = this.getArmor(this.Const.BodyPart.Body),
				valueMax = this.getArmorMax(this.Const.BodyPart.Body),
				text = this.Const.ArmorStateName[this.getArmorState(this.Const.BodyPart.Body)],
				style = "armor-body-slim"
			});
			tooltip.push({
				id = 7,
				type = "progressbar",
				icon = "ui/icons/health.png",
				value = this.getHitpoints() >= 0 ? this.getHitpoints() : 0,
				valueMax = this.getHitpointsMax(),
				text = this.Const.HitpointsStateName[this.getHitpointsState()],
				style = "hitpoints-slim"
			});
			tooltip.push({
				id = 8,
				type = "progressbar",
				icon = "ui/icons/morale.png",
				value = this.getMoraleState(),
				valueMax = this.Const.MoraleState.COUNT - 1,
				text = this.Const.MoraleStateName[this.getMoraleState()],
				style = "morale-slim"
			});
			tooltip.push({
				id = 9,
				type = "progressbar",
				icon = "ui/icons/fatigue.png",
				value = this.getFatigue(),
				valueMax = this.getFatigueMax(),
				text = this.Const.FatigueStateName[this.getFatigueState()],
				style = "fatigue-slim"
			});
			local result = [];
			local statusEffects = this.getSkills().query(this.Const.SkillType.StatusEffect | this.Const.SkillType.TemporaryInjury, false, true);

			foreach( i, statusEffect in statusEffects )
			{
				tooltip.push({
					id = 100 + i,
					type = "text",
					icon = statusEffect.getIcon(),
					text = statusEffect.getName()
				});
			}
		}

		return tooltip;
	}

	function getOverlayImage()
	{
		return this.Const.EntityIcon[this.m.Type];
	}

	function wait()
	{
		this.m.IsWaitActionSpent = true;
		this.m.Skills.onWaitTurn();
	}

	function playIdleSound()
	{
		this.playSound(this.Const.Sound.ActorEvent.Idle, this.Const.Sound.Volume.Actor * this.Const.Sound.Volume.ActorIdle * this.m.SoundVolume[this.Const.Sound.ActorEvent.Idle] * this.m.SoundVolumeOverall * (this.Math.rand(60, 100) * 0.01) * (this.isHiddenToPlayer ? 0.33 : 1.0), this.m.SoundPitch * (this.Math.rand(85, 115) * 0.01));
	}

	function playAttackSound()
	{
		if (this.Math.rand(1, 100) <= 50)
		{
			this.playSound(this.Const.Sound.ActorEvent.Attack, this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.Attack] * (this.Math.rand(75, 100) * 0.01), this.m.SoundPitch);
		}
	}

	function addBloodied()
	{
		++this.m.BloodiedCount;

		if (this.m.BloodiedCount >= this.Const.Combat.BloodiedBustCount)
		{
			if (this.hasSprite("body_blood"))
			{
				local sprite = this.getSprite("body_blood");

				if (!sprite.Visible)
				{
					sprite.Visible = true;
					this.setDirty(true);
				}
			}
		}
	}

	function resetBloodied( _setDirty = true )
	{
		this.m.BloodiedCount = 0;

		if (this.hasSprite("body_blood"))
		{
			local sprite = this.getSprite("body_blood");

			if (sprite.Visible)
			{
				sprite.Visible = false;
				this.setDirty(_setDirty);
			}
		}
	}

	function create()
	{
		this.entity.create();
		this.m.Items = this.new("scripts/items/item_container");
		this.m.Items.setActor(this);
		this.m.Skills = this.new("scripts/skills/skill_container");
		this.m.Skills.setActor(this);

		if (this.m.Type != this.Const.EntityType.Player && this.m.Name == "")
		{
			this.m.Name = this.Const.Strings.EntityName[this.m.Type];
		}

		this.m.Sound.resize(this.Const.Sound.ActorEvent.COUNT);
		this.m.SoundVolume.resize(this.Const.Sound.ActorEvent.COUNT);

		for( local i = 0; i < this.Const.Sound.ActorEvent.COUNT; i = ++i )
		{
			this.m.Sound[i] = [];
			this.m.SoundVolume[i] = 1.0;
		}

		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			this.Const.Sound.DefaultOnDeathSound
		];
	}

	function onUpdate()
	{
		if (this.m.IsDirty)
		{
			this.Tactical.TurnSequenceBar.updateEntity(this.getID());
			this.m.IsDirty = false;
		}
	}

	function onBeforeActivation()
	{
		if (!this.m.IsWaitActionSpent)
		{
			this.m.Skills.onBeforeActivation();
		}
	}

	function onRoundStart()
	{
		if (!this.isAlive())
		{
			return;
		}

		this.m.IsTurnStarted = false;
		this.m.IsTurnDone = false;
		this.m.IsSkippingTurn = false;
		this.m.Items.onNewRound();
		this.m.Skills.onNewRound();
		this.m.ActionPoints = this.getActionPointsMax();
		this.m.PreviewActionPoints = this.m.ActionPoints;

		if (this.m.AIAgent)
		{
			this.m.AIAgent.onRoundStarted();
		}
	}

	function onTurnStart()
	{
		this.logDebug("Début du tour pour " + this.getName());

		if (!this.isAlive())
		{
			return;
		}

		this.m.IsTurnStarted = true;
		this.showArrow(false);
		local p = this.m.CurrentProperties;
		this.m.Hitpoints = this.Math.min(this.getHitpointsMax(), this.m.Hitpoints + p.HitpointsRecoveryRate * p.HitpointsRecoveryRateMult);
		this.m.ActionPoints = this.Math.min(this.m.ActionPoints, this.getActionPointsMax());
		this.m.Fatigue = this.Math.max(0, this.Math.min(this.getFatigueMax() - 15, this.Math.max(0, this.m.Fatigue - this.Math.max(0, p.FatigueRecoveryRate) * p.FatigueRecoveryRateMult)));
		this.m.PreviewFatigue = this.m.Fatigue;
		this.m.PreviewSkillID = "";
		this.m.OverwhelmCount = [];
		this.m.MaxEnemiesThisTurn = this.Math.max(1, this.getTile().getZoneOfControlCountOtherThan(this.getAlliedFactions()));
		this.m.CurrentMovementType = this.Const.Tactical.MovementType.Default;
		this.m.Skills.onTurnStart();

		if (!this.isAlive())
		{
			return;
		}

		if (this.m.MoraleState == this.Const.MoraleState.Fleeing)
		{
			if (!this.getTile().hasZoneOfControlOtherThan(this.getAlliedFactions()))
			{
				local myTile = this.getTile();
				local size = this.Tactical.getMapSize();
				local bonus = !this.Tactical.State.isScenarioMode() && this.Tactical.State.getStrategicProperties().IsArenaMode ? this.Const.Morale.RallyBonusPerRoundArena : 0;

				if (this.isPlayerControlled() && (myTile.SquareCoords.X == 0 || myTile.SquareCoords.Y == 0 || myTile.SquareCoords.X == size.X - 1 || myTile.SquareCoords.Y == size.Y - 1))
				{
					this.checkMorale(this.Const.MoraleState.Breaking - this.Const.MoraleState.Fleeing, this.Const.Morale.RallyBaseDifficulty + this.m.FleeingRounds * (this.Const.Morale.RallyBonusPerRound + bonus));
				}
				else
				{
					this.checkMorale(this.Const.MoraleState.Wavering - this.Const.MoraleState.Fleeing, this.Const.Morale.RallyBaseDifficulty + this.m.FleeingRounds * (this.Const.Morale.RallyBonusPerRound + bonus));
				}
			}

			if (this.getMoraleState() == this.Const.MoraleState.Fleeing)
			{
				++this.m.FleeingRounds;

				if (!this.isHiddenToPlayer())
				{
					this.playSound(this.Const.Sound.ActorEvent.Flee, this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.Flee] * this.m.SoundVolumeOverall, this.m.SoundPitch);
				}
			}
		}

		this.setDirty(true);

		if (!this.isPlayerControlled())
		{
			foreach( id in this.m.AttackedCount )
			{
				local attacker = this.Tactical.getEntityByID(id);

				if (attacker != null && attacker.isPlacedOnMap())
				{
					attacker.getTile().addVisibilityForFaction(this.getFaction());
				}
			}
		}

		this.updateVisibility(this.getTile(), this.m.CurrentProperties.getVision(), this.getFaction());

		if (this.m.AIAgent)
		{
			this.m.AIAgent.onTurnStarted();
		}
	}

	function onTurnResumed()
	{
		this.showArrow(false);
		this.m.Skills.onResumeTurn();
		this.Tactical.TurnSequenceBar.updateEntity(this.getID());
		this.updateVisibility(this.getTile(), this.m.CurrentProperties.getVision(), this.getFaction());

		if (this.m.AIAgent)
		{
			if (!this.m.AIAgent.isTurnStarted())
			{
				this.m.AIAgent.onTurnStarted();
			}

			this.m.AIAgent.onTurnResumed();
		}
	}

	function onRoundEnd()
	{
		if (!this.isAlive() || !this.isPlacedOnMap())
		{
			return;
		}

		this.m.Skills.onRoundEnd();
	}

	function onTurnEnd()
	{
		if (!this.isAlive() || !this.isPlacedOnMap())
		{
			return;
		}

		this.m.AttackedCount = [];
		this.m.IsTurnDone = true;
		this.m.IsTurnStarted = false;
		this.m.Skills.onTurnEnd();

		if (this.isAlive())
		{
			local tile = this.getTile();

			if (tile.Properties.Effect != null && tile.Properties.Effect.IsAppliedAtTurnEnd && tile.Properties.Effect.Callback != null)
			{
				tile.Properties.Effect.Callback(tile, this);
			}
		}

		this.m.ActionPoints = 0;

		if (this.m.AIAgent)
		{
			this.m.AIAgent.onTurnEnd();
		}
	}

	function onAttacked( _attacker )
	{
		if (!this.m.CurrentProperties.IsImmuneToOverwhelm && _attacker.getTile().getDistanceTo(this.getTile()) <= 1 && this.m.OverwhelmCount.find(_attacker.getID()) == null)
		{
			this.m.OverwhelmCount.push(_attacker.getID());
		}

		if (this.m.AttackedCount.find(_attacker.getID()) == null)
		{
			this.m.AttackedCount.push(_attacker.getID());
		}

		if (this.isPlayerControlled())
		{
			_attacker.setDiscovered(true);
			_attacker.getTile().addVisibilityForFaction(this.Const.Faction.Player);
		}
		else
		{
			_attacker.getTile().addVisibilityForFaction(this.getFaction());
			this.onActorSighted(_attacker);
			local actors = this.Tactical.Entities.getInstancesOfFaction(this.getFaction());

			foreach( a in actors )
			{
				if (a.getID() != this.getID() && a.isAlive() && a.isAlliedWith(this))
				{
					a.onActorSighted(_attacker);
				}
			}

			if (_attacker.isPlayerControlled())
			{
				this.setDiscovered(true);
				this.getTile().addVisibilityForFaction(this.Const.Faction.Player);
			}
		}
	}

	function onRiposte( _info )
	{
		if (!_info.User.isAlive())
		{
			return;
		}

		if (this.m.RiposteSkillCounter == this.Const.SkillCounter)
		{
			return;
		}

		this.m.RiposteSkillCounter = this.Const.SkillCounter;
		_info.Skill.useForFree(_info.TargetTile);
	}

	function onMissed( _attacker, _skill, _dontShake = false )
	{
		if (!_dontShake && !this.isHiddenToPlayer() && this.m.IsShakingOnHit && (!_skill.isRanged() || _attacker.getTile().getDistanceTo(this.getTile()) == 1) && !this.Tactical.getNavigator().isTravelling(this))
		{
			this.Tactical.getShaker().shake(this, _attacker.getTile(), 4);
		}

		if (this.m.CurrentProperties.IsRiposting && _attacker != null && !_attacker.isAlliedWith(this) && _attacker.getTile().getDistanceTo(this.getTile()) == 1 && this.Tactical.TurnSequenceBar.getActiveEntity() != null && this.Tactical.TurnSequenceBar.getActiveEntity().getID() == _attacker.getID() && _skill != null && !_skill.isIgnoringRiposte())
		{
			local skill = this.m.Skills.getAttackOfOpportunity();

			if (skill != null)
			{
				local info = {
					User = this,
					Skill = skill,
					TargetTile = _attacker.getTile()
				};
				this.Time.scheduleEvent(this.TimeUnit.Virtual, this.Const.Combat.RiposteDelay, this.onRiposte.bindenv(this), info);
			}
		}

		if (_skill != null && !_skill.isRanged())
		{
			this.m.Fatigue = this.Math.min(this.getFatigueMax(), this.Math.round(this.m.Fatigue + this.Const.Combat.FatigueLossOnBeingMissed * this.m.CurrentProperties.FatigueEffectMult));
		}

		this.m.Skills.onMissed(_attacker, _skill);
	}

	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		if (!this.isAlive() || !this.isPlacedOnMap())
		{
			return 0;
		}

		if (_hitInfo.DamageRegular == 0 && _hitInfo.DamageArmor == 0)
		{
			return 0;
		}

		if (typeof _attacker == "instance")
		{
			_attacker = _attacker.get();
		}

		if (_attacker != null && _attacker.isAlive() && _attacker.isPlayerControlled() && !this.isPlayerControlled())
		{
			this.setDiscovered(true);
			this.getTile().addVisibilityForFaction(this.Const.Faction.Player);
			this.getTile().addVisibilityForCurrentEntity();
		}

		if (this.m.Skills.hasSkill("perk.steel_brow"))
		{
			_hitInfo.BodyDamageMult = 1.0;
		}

		local p = this.m.Skills.buildPropertiesForBeingHit(_attacker, _skill, _hitInfo);
		this.m.Items.onBeforeDamageReceived(_attacker, _skill, _hitInfo, p);
		local dmgMult = p.DamageReceivedTotalMult;

		if (_skill != null)
		{
			dmgMult = dmgMult * (_skill.isRanged() ? p.DamageReceivedRangedMult : p.DamageReceivedMeleeMult);
		}

		_hitInfo.DamageRegular *= p.DamageReceivedRegularMult * dmgMult;
		_hitInfo.DamageArmor *= p.DamageReceivedArmorMult * dmgMult;
		local armor = 0;
		local armorDamage = 0;

		if (_hitInfo.DamageDirect < 1.0)
		{
			armor = p.Armor[_hitInfo.BodyPart] * p.ArmorMult[_hitInfo.BodyPart];
			armorDamage = this.Math.min(armor, _hitInfo.DamageArmor);
			armor = armor - armorDamage;
			_hitInfo.DamageInflictedArmor = this.Math.max(0, armorDamage);
		}

		_hitInfo.DamageFatigue *= p.FatigueEffectMult;
		this.m.Fatigue = this.Math.min(this.getFatigueMax(), this.Math.round(this.m.Fatigue + _hitInfo.DamageFatigue * p.FatigueReceivedPerHitMult));
		local damage = 0;
		damage = damage + this.Math.maxf(0.0, _hitInfo.DamageRegular * _hitInfo.DamageDirect * p.DamageReceivedDirectMult - armor * this.Const.Combat.ArmorDirectDamageMitigationMult);

		if (armor <= 0 || _hitInfo.DamageDirect >= 1.0)
		{
			damage = damage + this.Math.max(0, _hitInfo.DamageRegular * this.Math.maxf(0.0, 1.0 - _hitInfo.DamageDirect * p.DamageReceivedDirectMult) - armorDamage);
		}

		damage = damage * _hitInfo.BodyDamageMult;
		damage = this.Math.max(0, this.Math.max(this.Math.round(damage), this.Math.min(this.Math.round(_hitInfo.DamageMinimum), this.Math.round(_hitInfo.DamageMinimum * p.DamageReceivedTotalMult))));
		_hitInfo.DamageInflictedHitpoints = damage;
		this.m.Skills.onDamageReceived(_attacker, _hitInfo.DamageInflictedHitpoints, _hitInfo.DamageInflictedArmor);

		if (armorDamage > 0 && !this.isHiddenToPlayer() && _hitInfo.IsPlayingArmorSound)
		{
			local armorHitSound = this.m.Items.getAppearance().ImpactSound[_hitInfo.BodyPart];

			if (armorHitSound.len() > 0)
			{
				this.Sound.play(armorHitSound[this.Math.rand(0, armorHitSound.len() - 1)], this.Const.Sound.Volume.ActorArmorHit, this.getPos());
			}

			if (damage < this.Const.Combat.PlayPainSoundMinDamage)
			{
				this.playSound(this.Const.Sound.ActorEvent.NoDamageReceived, this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.NoDamageReceived] * this.m.SoundVolumeOverall);
			}
		}

		if (damage > 0)
		{
			if (!this.m.IsAbleToDie && damage >= this.m.Hitpoints)
			{
				this.m.Hitpoints = 1;
			}
			else
			{
				this.m.Hitpoints = this.Math.round(this.m.Hitpoints - damage);
			}
		}

		if (this.m.Hitpoints <= 0)
		{
			local skill = this.m.Skills.getSkillByID("perk.nine_lives");

			if (skill != null && (!skill.isSpent() || skill.getLastFrameUsed() == this.Time.getFrame()))
			{
				this.getSkills().removeByType(this.Const.SkillType.DamageOverTime);
				this.m.Hitpoints = this.Math.rand(5, 10);
				skill.setSpent(true);
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this) + " a neuf vies !");
			}
		}

		local fatalityType = this.Const.FatalityType.None;

		if (this.m.Hitpoints <= 0)
		{
			this.m.IsDying = true;

			if (_skill != null)
			{
				if (_skill.getChanceDecapitate() >= 100 || _hitInfo.BodyPart == this.Const.BodyPart.Head && this.Math.rand(1, 100) <= _skill.getChanceDecapitate() * _hitInfo.FatalityChanceMult)
				{
					fatalityType = this.Const.FatalityType.Decapitated;
				}
				else if (_skill.getChanceSmash() >= 100 || _hitInfo.BodyPart == this.Const.BodyPart.Head && this.Math.rand(1, 100) <= _skill.getChanceSmash() * _hitInfo.FatalityChanceMult)
				{
					fatalityType = this.Const.FatalityType.Smashed;
				}
				else if (_skill.getChanceDisembowel() >= 100 || _hitInfo.BodyPart == this.Const.BodyPart.Body && this.Math.rand(1, 100) <= _skill.getChanceDisembowel() * _hitInfo.FatalityChanceMult)
				{
					fatalityType = this.Const.FatalityType.Disemboweled;
				}
			}
		}

		if (_hitInfo.DamageDirect < 1.0)
		{
			local overflowDamage = _hitInfo.DamageArmor;

			if (this.m.BaseProperties.Armor[_hitInfo.BodyPart] != 0)
			{
				overflowDamage = overflowDamage - this.m.BaseProperties.Armor[_hitInfo.BodyPart] * this.m.BaseProperties.ArmorMult[_hitInfo.BodyPart];
				this.m.BaseProperties.Armor[_hitInfo.BodyPart] = this.Math.max(0, this.m.BaseProperties.Armor[_hitInfo.BodyPart] * this.m.BaseProperties.ArmorMult[_hitInfo.BodyPart] - _hitInfo.DamageArmor);
				this.Tactical.EventLog.logEx("L\'armure de " + this.Const.UI.getColorizedEntityName(this) + " a été touché pour [b]" + this.Math.floor(_hitInfo.DamageArmor) + "[/b] dégâts");
			}

			if (overflowDamage > 0)
			{
				this.m.Items.onDamageReceived(overflowDamage, fatalityType, _hitInfo.BodyPart == this.Const.BodyPart.Body ? this.Const.ItemSlot.Body : this.Const.ItemSlot.Head, _attacker);
			}
		}

		if (this.getFaction() == this.Const.Faction.Player && _attacker != null && _attacker.isAlive())
		{
			this.Tactical.getCamera().quake(_attacker, this, 5.0, 0.16, 0.3);
		}

		if (damage <= 0 && armorDamage >= 0)
		{
			if ((this.m.IsFlashingOnHit || this.getCurrentProperties().IsStunned || this.getCurrentProperties().IsRooted) && !this.isHiddenToPlayer() && _attacker != null && _attacker.isAlive())
			{
				local layers = this.m.ShakeLayers[_hitInfo.BodyPart];
				local recoverMult = 1.0;
				this.Tactical.getShaker().cancel(this);
				this.Tactical.getShaker().shake(this, _attacker.getTile(), this.m.IsShakingOnHit ? 2 : 3, this.Const.Combat.ShakeEffectArmorHitColor, this.Const.Combat.ShakeEffectArmorHitHighlight, this.Const.Combat.ShakeEffectArmorHitFactor, this.Const.Combat.ShakeEffectArmorSaturation, layers, recoverMult);
			}

			this.m.Skills.update();
			this.setDirty(true);
			return 0;
		}

		if (damage >= this.Const.Combat.SpawnBloodMinDamage)
		{
			this.spawnBloodDecals(this.getTile());
		}

		if (this.m.Hitpoints <= 0)
		{
			this.spawnBloodDecals(this.getTile());
			this.kill(_attacker, _skill, fatalityType);
		}
		else
		{
			if (damage >= this.Const.Combat.SpawnBloodEffectMinDamage)
			{
				local mult = this.Math.maxf(0.75, this.Math.minf(2.0, damage / this.getHitpointsMax() * 3.0));
				this.spawnBloodEffect(this.getTile(), mult);
			}

			if (this.Tactical.State.getStrategicProperties() != null && this.Tactical.State.getStrategicProperties().IsArenaMode && _attacker != null && _attacker.getID() != this.getID())
			{
				local mult = damage / this.getHitpointsMax();

				if (mult >= 0.75)
				{
					this.Sound.play(this.Const.Sound.ArenaBigHit[this.Math.rand(0, this.Const.Sound.ArenaBigHit.len() - 1)], this.Const.Sound.Volume.Tactical * this.Const.Sound.Volume.Arena);
				}
				else if (mult >= 0.25 || this.Math.rand(1, 100) <= 20)
				{
					this.Sound.play(this.Const.Sound.ArenaHit[this.Math.rand(0, this.Const.Sound.ArenaHit.len() - 1)], this.Const.Sound.Volume.Tactical * this.Const.Sound.Volume.Arena);
				}
			}

			if (this.m.CurrentProperties.IsAffectedByInjuries && this.m.IsAbleToDie && damage >= this.Const.Combat.InjuryMinDamage && this.m.CurrentProperties.ThresholdToReceiveInjuryMult != 0 && _hitInfo.InjuryThresholdMult != 0 && _hitInfo.Injuries != null)
			{
				local potentialInjuries = [];
				local bonus = _hitInfo.BodyPart == this.Const.BodyPart.Head ? 1.25 : 1.0;

				foreach( inj in _hitInfo.Injuries )
				{
					if (inj.Threshold * _hitInfo.InjuryThresholdMult * this.Const.Combat.InjuryThresholdMult * this.m.CurrentProperties.ThresholdToReceiveInjuryMult * bonus <= damage / (this.getHitpointsMax() * 1.0))
					{
						if (!this.m.Skills.hasSkill(inj.ID) && this.m.ExcludedInjuries.find(inj.ID) == null)
						{
							potentialInjuries.push(inj.Script);
						}
					}
				}

				local appliedInjury = false;

				while (potentialInjuries.len() != 0)
				{
					local r = this.Math.rand(0, potentialInjuries.len() - 1);
					local injury = this.new("scripts/skills/" + potentialInjuries[r]);

					if (injury.isValid(this))
					{
						this.m.Skills.add(injury);

						if (this.isPlayerControlled() && this.isKindOf(this, "player"))
						{
							this.worsenMood(this.Const.MoodChange.Injury, "A subi une blessure");
						}

						if (this.isPlayerControlled() || !this.isHiddenToPlayer())
						{
							this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this) + "\'s " + this.Const.Strings.BodyPartName[_hitInfo.BodyPart] + " is hit for [b]" + this.Math.floor(damage) + "[/b] damage and suffers " + injury.getNameOnly() + "!");
						}

						appliedInjury = true;
						break;
					}
					else
					{
						potentialInjuries.remove(r);
					}
				}

				if (!appliedInjury)
				{
					if (damage > 0 && !this.isHiddenToPlayer())
					{
						this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this) + "\'s " + this.Const.Strings.BodyPartName[_hitInfo.BodyPart] + " is hit for [b]" + this.Math.floor(damage) + "[/b] damage");
					}
				}
			}
			else if (damage > 0 && !this.isHiddenToPlayer())
			{
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this) + "\'s " + this.Const.Strings.BodyPartName[_hitInfo.BodyPart] + " is hit for [b]" + this.Math.floor(damage) + "[/b] damage");
			}

			if (this.m.MoraleState != this.Const.MoraleState.Ignore && damage > this.Const.Morale.OnHitMinDamage && this.getCurrentProperties().IsAffectedByLosingHitpoints)
			{
				if (!this.isPlayerControlled() || !this.m.Skills.hasSkill("effects.berserker_mushrooms"))
				{
					this.checkMorale(-1, this.Const.Morale.OnHitBaseDifficulty * (1.0 - this.getHitpoints() / this.getHitpointsMax()) - (_attacker != null && _attacker.getID() != this.getID() ? _attacker.getCurrentProperties().ThreatOnHit : 0), this.Const.MoraleCheckType.Default, "", true);
				}
			}

			this.m.Skills.onAfterDamageReceived();

			if (damage >= this.Const.Combat.PlayPainSoundMinDamage && this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived].len() > 0)
			{
				local volume = 1.0;

				if (damage < this.Const.Combat.PlayPainVolumeMaxDamage)
				{
					volume = damage / this.Const.Combat.PlayPainVolumeMaxDamage;
				}

				this.playSound(this.Const.Sound.ActorEvent.DamageReceived, this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.DamageReceived] * this.m.SoundVolumeOverall * volume, this.m.SoundPitch);
			}

			this.m.Skills.update();
			this.onUpdateInjuryLayer();

			if ((this.m.IsFlashingOnHit || this.getCurrentProperties().IsStunned || this.getCurrentProperties().IsRooted) && !this.isHiddenToPlayer() && _attacker != null && _attacker.isAlive())
			{
				local layers = this.m.ShakeLayers[_hitInfo.BodyPart];
				local recoverMult = this.Math.minf(1.5, this.Math.maxf(1.0, damage * 2.0 / this.getHitpointsMax()));
				this.Tactical.getShaker().cancel(this);
				this.Tactical.getShaker().shake(this, _attacker.getTile(), this.m.IsShakingOnHit ? 2 : 3, this.Const.Combat.ShakeEffectHitpointsHitColor, this.Const.Combat.ShakeEffectHitpointsHitHighlight, this.Const.Combat.ShakeEffectHitpointsHitFactor, this.Const.Combat.ShakeEffectHitpointsSaturation, layers, recoverMult);
			}

			this.setDirty(true);
		}

		return damage;
	}

	function playSound( _type, _volume, _pitch = 1.0 )
	{
		if (this.m.Sound[_type].len() == 0)
		{
			return;
		}

		local s;

		do
		{
			s = this.m.Sound[_type][this.Math.rand(0, this.m.Sound[_type].len() - 1)];
		}
		while (this.m.LastSound == s && this.m.Sound[_type].len() > 1);

		this.Sound.play(s, _volume, this.getPos(), _pitch);
		this.m.LastSound = s;
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
	}

	function onActorKilled( _actor, _tile, _skill )
	{
		if (!this.m.IsAlive || this.m.IsDying)
		{
			return;
		}

		this.m.Skills.onTargetKilled(_actor, _skill);
	}

	function onOtherActorDeath( _killer, _victim, _skill )
	{
		if (!this.m.IsAlive || this.m.IsDying)
		{
			return;
		}

		if (_victim.getXPValue() <= 1)
		{
			return;
		}

		if (_victim.getFaction() == this.getFaction() && _victim.getCurrentProperties().TargetAttractionMult >= 0.5 && this.getCurrentProperties().IsAffectedByDyingAllies)
		{
			local difficulty = this.Const.Morale.AllyKilledBaseDifficulty - _victim.getXPValue() * this.Const.Morale.AllyKilledXPMult + this.Math.pow(_victim.getTile().getDistanceTo(this.getTile()), this.Const.Morale.AllyKilledDistancePow);
			this.checkMorale(-1, difficulty, this.Const.MoraleCheckType.Default, "", true);
		}
		else if (this.getAlliedFactions().find(_victim.getFaction()) == null)
		{
			local difficulty = this.Const.Morale.EnemyKilledBaseDifficulty + _victim.getXPValue() * this.Const.Morale.EnemyKilledXPMult - this.Math.pow(_victim.getTile().getDistanceTo(this.getTile()), this.Const.Morale.EnemyKilledDistancePow);

			if (_killer != null && _killer.isAlive() && _killer.getID() == this.getID())
			{
				difficulty = difficulty + this.Const.Morale.EnemyKilledSelfBonus;
			}

			this.checkMorale(1, difficulty);
		}
	}

	function onOtherActorFleeing( _actor )
	{
		if (!this.m.IsAlive || this.m.IsDying)
		{
			return;
		}

		if (this.m.CurrentProperties.IsAffectedByFleeingAllies)
		{
			local difficulty = this.Const.Morale.AllyFleeingBaseDifficulty - _actor.getXPValue() * this.Const.Morale.AllyFleeingXPMult + this.Math.pow(_actor.getTile().getDistanceTo(this.getTile()), this.Const.Morale.AllyFleeingDistancePow);
			this.checkMorale(-1, difficulty);
		}
	}

	function hasZoneOfControl()
	{
		return !(!this.m.IsAlive || this.m.IsDying || this.m.CurrentProperties.IsStunned || this.m.MoraleState == this.Const.MoraleState.Fleeing || this.m.Skills.getAttackOfOpportunity() == null);
	}

	function isExertingZoneOfControl()
	{
		return this.m.IsExertingZoneOfControl;
	}

	function setZoneOfControl( _t, _f )
	{
		if (!this.isPlacedOnMap() || !this.m.IsActingEachTurn || !this.m.IsUsingZoneOfControl)
		{
			return;
		}

		if (_f && !this.m.IsExertingZoneOfControl && this.hasZoneOfControl())
		{
			_t.addZoneOfControl(this.getFaction());
			this.m.IsExertingZoneOfControl = true;
		}
		else if (!_f && this.m.IsExertingZoneOfControl)
		{
			_t.removeZoneOfControl(this.getFaction());
			this.m.IsExertingZoneOfControl = false;
		}
	}

	function onSkillsUpdated()
	{
		if (this.isPlacedOnMap() && !this.m.IsDying && !this.m.IsMoving && !this.Tactical.getNavigator().isTravelling(this))
		{
			this.setZoneOfControl(this.getTile(), this.hasZoneOfControl());
		}
	}

	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		if (!this.m.IsAlive || this.m.IsDying)
		{
			return;
		}

		if (this.hasSprite("arms_icon") && this.m.CurrentProperties.IsAbleToUseWeaponSkills)
		{
			local arms_icon = this.getSprite("arms_icon");

			if (_appearance.Weapon.len() != 0)
			{
				local arms_rotation = arms_icon.Rotation;
				arms_icon.setBrush(_appearance.Weapon);
				arms_icon.Visible = true;

				if (!this.m.IsLoweringWeapon && _appearance.LowerWeapon && arms_icon.Rotation == 0)
				{
					this.m.IsLoweringWeapon = true;
					this.setRenderCallbackEnabled(true);
					this.m.RenderAnimationStartTime = this.Time.getVirtualTimeF();
				}

				if (!this.m.IsRaisingWeapon && !_appearance.LowerWeapon && arms_icon.Rotation != 0)
				{
					this.m.IsRaisingWeapon = true;
					this.setRenderCallbackEnabled(true);
					this.m.RenderAnimationStartTime = this.Time.getVirtualTimeF();
				}
			}
			else
			{
				arms_icon.Visible = false;
				arms_icon.setBrush("");
			}
		}

		if (this.hasSprite("shield_icon"))
		{
			local shield_icon = this.getSprite("shield_icon");

			if (_appearance.Shield.len() != 0)
			{
				shield_icon.setBrush(_appearance.Shield);
				shield_icon.Visible = true;
				local offset = this.getSpriteOffset("shield_icon");

				if (!this.m.IsRaisingShield && _appearance.RaiseShield && offset.Y == 0)
				{
					this.m.IsRaisingShield = true;
					this.setRenderCallbackEnabled(true);
					this.m.RenderAnimationStartTime = this.Time.getVirtualTimeF();
				}

				if (!this.m.IsLoweringShield && !_appearance.RaiseShield && offset.Y != 0)
				{
					this.m.IsLoweringShield = true;
					this.setRenderCallbackEnabled(true);
					this.m.RenderAnimationStartTime = this.Time.getVirtualTimeF();
				}
			}
			else
			{
				shield_icon.Visible = false;
				shield_icon.setBrush("");
				this.m.IsRaisingShield = false;
				this.m.IsLoweringShield = false;
			}
		}

		if (this.hasSprite("head"))
		{
			this.getSprite("head").Visible = !_appearance.HideHead;
		}

		if (this.hasSprite("permanent_injury_1"))
		{
			this.getSprite("permanent_injury_1").Visible = !_appearance.HideHead || this.m.IsHidingHelmet;
		}

		if (this.hasSprite("permanent_injury_2"))
		{
			this.getSprite("permanent_injury_2").Visible = !_appearance.HideHead || this.m.IsHidingHelmet;
		}

		if (this.hasSprite("permanent_injury_3"))
		{
			this.getSprite("permanent_injury_3").Visible = !_appearance.HideHead || this.m.IsHidingHelmet;
		}

		if (this.hasSprite("permanent_injury_4"))
		{
			this.getSprite("permanent_injury_4").Visible = !_appearance.HideHead || this.m.IsHidingHelmet;
		}

		if (this.hasSprite("helmet"))
		{
			if (_appearance.Helmet.len() != 0 && !this.m.IsHidingHelmet)
			{
				local helmet = this.getSprite("helmet");
				helmet.setBrush(_appearance.Helmet);
				helmet.Color = _appearance.HelmetColor;
				helmet.Visible = true;
			}
			else
			{
				this.getSprite("helmet").Visible = false;
			}
		}

		if (this.hasSprite("helmet_damage"))
		{
			if (_appearance.HelmetDamage.len() != 0 && !this.m.IsHidingHelmet)
			{
				local helmet_damage = this.getSprite("helmet_damage");
				helmet_damage.setBrush(_appearance.HelmetDamage);
				helmet_damage.Color = _appearance.HelmetColor;
				helmet_damage.Visible = true;
			}
			else
			{
				this.getSprite("helmet_damage").Visible = false;
			}
		}

		if (this.hasSprite("body"))
		{
			this.getSprite("body").Visible = !_appearance.HideBody;
		}

		if (this.hasSprite("armor"))
		{
			if (_appearance.Armor.len() != 0)
			{
				local armor = this.getSprite("armor");
				armor.setBrush(_appearance.Armor);
				armor.Color = _appearance.ArmorColor;
				armor.Visible = true;
			}
			else
			{
				this.getSprite("armor").Visible = false;
			}
		}

		if (this.hasSprite("armor_upgrade_back"))
		{
			if (_appearance.ArmorUpgradeBack.len() != 0)
			{
				local armor = this.getSprite("armor_upgrade_back");
				armor.setBrush(_appearance.ArmorUpgradeBack);
				armor.Visible = true;
			}
			else
			{
				this.getSprite("armor_upgrade_back").Visible = false;
			}
		}

		if (this.hasSprite("armor_upgrade_front"))
		{
			if (_appearance.ArmorUpgradeFront.len() != 0)
			{
				local armor = this.getSprite("armor_upgrade_front");
				armor.setBrush(_appearance.ArmorUpgradeFront);
				armor.Visible = true;
			}
			else
			{
				this.getSprite("armor_upgrade_front").Visible = false;
			}
		}

		if (this.hasSprite("accessory"))
		{
			if (_appearance.Accessory.len() != 0)
			{
				local accessory = this.getSprite("accessory");
				accessory.setBrush(_appearance.Accessory);
				accessory.Visible = true;
			}
			else
			{
				local accessory = this.getSprite("accessory");
				accessory.resetBrush();
				accessory.Visible = false;
			}
		}

		if (this.hasSprite("quiver"))
		{
			if (_appearance.ShowQuiver && _appearance.Quiver.len() != 0)
			{
				local quiver = this.getSprite("quiver");
				quiver.setBrush(_appearance.Quiver);
				quiver.Visible = true;
			}
			else
			{
				this.getSprite("quiver").Visible = false;
			}
		}

		if (this.hasSprite("hair"))
		{
			this.getSprite("hair").Visible = !_appearance.HideHair && !_appearance.HideHead || this.m.IsHidingHelmet;
		}

		if (this.hasSprite("beard"))
		{
			this.getSprite("beard").Visible = !_appearance.HideBeard && !_appearance.HideHead || this.m.IsHidingHelmet;
		}

		if (this.hasSprite("beard_top"))
		{
			this.getSprite("beard_top").Visible = !_appearance.HideBeard && !_appearance.HideHead || this.m.IsHidingHelmet;
		}

		if (_setDirty)
		{
			this.setDirty(true);
		}
	}

	function onFactionChanged()
	{
		local flip = !this.isAlliedWithPlayer();
		this.getSprite("arrow").setHorizontalFlipping(flip);
		this.getSprite("status_rooted_back").setHorizontalFlipping(flip);
		this.getSprite("status_stunned").setHorizontalFlipping(flip);
		this.getSprite("shield_icon").setHorizontalFlipping(flip);
		this.getSprite("arms_icon").setHorizontalFlipping(flip);
		this.getSprite("status_rooted").setHorizontalFlipping(flip);
		this.getSprite("status_hex").setHorizontalFlipping(flip);

		if (this.m.MoraleState != this.Const.MoraleState.Ignore)
		{
			local morale = this.getSprite("morale");
			morale.setHorizontalFlipping(flip);

			if (this.m.MoraleState == this.Const.MoraleState.Confident)
			{
				morale.setBrush(this.m.ConfidentMoraleBrush);
			}
		}

		this.setDirty(true);
	}

	function onInit()
	{
		this.entity.onInit();

		if (!this.isInitialized())
		{
			this.createOverlay();
			this.m.BaseProperties = this.Const.CharacterProperties.getClone();
			this.m.CurrentProperties = this.Const.CharacterProperties.getClone();
			this.m.IsAttackable = true;

			if (this.m.MoraleState != this.Const.MoraleState.Ignore)
			{
				this.m.Skills.add(this.new("scripts/skills/special/morale_check"));
			}

			this.m.Items.setUnlockedBagSlots(this.Const.ItemSlotSpaces[this.Const.ItemSlot.Bag]);
		}

		this.setPreventOcclusion(true);
		this.setBlockSight(false);
		this.setVisibleInFogOfWar(false);
		local arrow = this.addSprite("arrow");
		arrow.setBrush("bust_arrow");
		arrow.Visible = false;
		this.setSpriteColorization("arrow", false);
		local rooted = this.addSprite("status_rooted_back");
		rooted.Visible = false;
		rooted.Scale = 0.55;
	}

	function onAfterInit()
	{
		this.updateOverlay();
		this.setSpriteOffset("status_rooted_back", this.getSpriteOffset("status_rooted"));
		this.getSprite("status_rooted_back").Scale = this.getSprite("status_rooted").Scale;
	}

	function loadResources()
	{
		for( local i = 0; i != this.Const.Sound.ActorEvent.COUNT; i = ++i )
		{
			for( local j = 0; j != this.m.Sound[i].len(); j = ++j )
			{
				this.Tactical.addResource(this.m.Sound[i][j]);
			}
		}

		if (this.hasSprite("body"))
		{
			local body = this.getSprite("body");

			if (body.HasBrush)
			{
				this.Tactical.addResource(body.getBrush().TextureName);
			}
		}

		this.m.Skills.addResources();
	}

	function onPlacedOnMap()
	{
		local tile = this.getTile();
		this.m.IsAlive = true;
		this.m.IsDying = false;
		this.m.RiposteSkillCounter = 0;
		this.m.IsExertingZoneOfOccupation = false;
		this.m.IsExertingZoneOfControl = false;

		if (this.getFaction() == this.Const.Faction.Player || tile.IsVisibleForPlayer)
		{
			this.setDiscovered(true);
		}

		this.Tactical.OrientationOverlay.addOverlay(this);
		this.Tactical.Entities.addInstance(this);
		this.setZoneOfControl(tile, this.hasZoneOfControl());

		if (!this.m.IsExertingZoneOfOccupation)
		{
			tile.addZoneOfOccupation(this.getFaction());
			this.m.IsExertingZoneOfOccupation = true;
		}

		if (this.Const.Tactical.TerrainEffect[tile.Type].len() > 0 && !this.m.Skills.hasSkill(this.Const.Tactical.TerrainEffectID[tile.Type]))
		{
			this.m.Skills.add(this.new(this.Const.Tactical.TerrainEffect[tile.Type]));
		}

		if (tile.IsHidingEntity)
		{
			this.m.Skills.add(this.new(this.Const.Movement.HiddenStatusEffect));
		}

		local ourTile = this.getTile();

		for( local i = 0; i < 6; i = ++i )
		{
			if (!ourTile.hasNextTile(i))
			{
			}
			else
			{
				local nextTile = ourTile.getNextTile(i);

				if (nextTile.IsOccupiedByActor)
				{
					nextTile.getEntity().setDirty(true);
				}
			}
		}

		if (this.m.IsActingEachTurn)
		{
			if (this.m.IsActingIm\'ately && this.Time.getRound() > 0)
			{
				this.Tactical.TurnSequenceBar.insertEntity(this);
			}
			else
			{
				this.Tactical.TurnSequenceBar.addEntity(this);
			}
		}
	}

	function onFinish()
	{
		if (("State" in this.Tactical) && this.Tactical.State != null && this.Tactical.State.m.IsExitingToMenu)
		{
			return;
		}

		this.onRemovedFromMap();
		this.entity.onFinish();
	}

	function onRemovedFromMap()
	{
		this.m.IsDying = true;

		if (this.isPlacedOnMap())
		{
			this.Tactical.getShaker().cancel(this);
			this.setZoneOfControl(this.getTile(), false);

			if (this.m.IsExertingZoneOfOccupation)
			{
				this.getTile().removeZoneOfOccupation(this.getFaction());
				this.m.IsExertingZoneOfOccupation = false;
			}

			this.Tactical.Entities.removeInstance(this);

			if (this.Tactical.OrientationOverlay != null)
			{
				this.Tactical.OrientationOverlay.removeOverlay(this);
			}

			if (this.m.IsActingEachTurn && this.Tactical.TurnSequenceBar != null)
			{
				this.Tactical.TurnSequenceBar.removeEntity(this);
			}
		}
	}

	function onRender()
	{
		if (this.m.IsRaisingShield)
		{
			if (this.moveSpriteOffset("shield_icon", this.createVec(0, 0), this.Const.Items.Default.RaiseShieldOffset, this.Const.Items.Default.RaiseShieldDuration, this.m.RenderAnimationStartTime))
			{
				this.m.IsRaisingShield = false;

				if (!this.m.IsUsingCustomRendering)
				{
					this.setRenderCallbackEnabled(false);
				}
			}
		}
		else if (this.m.IsLoweringShield)
		{
			if (this.moveSpriteOffset("shield_icon", this.Const.Items.Default.RaiseShieldOffset, this.createVec(0, 0), this.Const.Items.Default.LowerShieldDuration, this.m.RenderAnimationStartTime))
			{
				this.m.IsLoweringShield = false;

				if (!this.m.IsUsingCustomRendering)
				{
					this.setRenderCallbackEnabled(false);
				}
			}
		}

		if (this.m.IsLoweringWeapon)
		{
			local p = (this.Time.getVirtualTimeF() - this.m.RenderAnimationStartTime) / this.Const.Items.Default.LowerWeaponDuration;

			if (this.m.Items.getAppearance().TwoHanded)
			{
				this.getSprite("arms_icon").Rotation = this.Math.minf(1.0, p) * -70.0;
			}
			else
			{
				this.getSprite("arms_icon").Rotation = this.Math.minf(1.0, p) * -33.0;
			}

			if (p >= 1.0)
			{
				this.m.IsLoweringWeapon = false;

				if (!this.m.IsUsingCustomRendering)
				{
					this.setRenderCallbackEnabled(false);
				}
			}
		}
		else if (this.m.IsRaisingWeapon)
		{
			local p = (this.Time.getVirtualTimeF() - this.m.RenderAnimationStartTime) / this.Const.Items.Default.RaiseWeaponDuration;

			if (this.m.Items.getAppearance().TwoHanded)
			{
				this.getSprite("arms_icon").Rotation = (1.0 - this.Math.minf(1.0, p)) * -70.0;
			}
			else
			{
				this.getSprite("arms_icon").Rotation = (1.0 - this.Math.minf(1.0, p)) * -33.0;
			}

			if (p >= 1.0)
			{
				this.m.IsRaisingWeapon = false;

				if (!this.m.IsUsingCustomRendering)
				{
					this.setRenderCallbackEnabled(false);
				}
			}
		}

		if (this.m.IsRaising)
		{
			local p = (this.Time.getVirtualTimeF() - this.m.RenderAnimationStartTime) / (this.Const.Combat.ResurrectAnimationTime * this.m.RenderAnimationSpeed);

			if (p >= 1.0)
			{
				this.setPos(this.createVec(0, 0));
				this.setAlpha(255);
				this.m.IsRaising = false;
				this.m.IsAttackable = true;

				if (!this.m.IsUsingCustomRendering)
				{
					this.setRenderCallbackEnabled(false);
				}
			}
			else
			{
				this.setPos(this.createVec(0, this.Const.Combat.ResurrectAnimationDistance * this.m.RenderAnimationDistanceMult * (1.0 - p)));
			}
		}
		else if (this.m.IsSinking)
		{
			local p = (this.Time.getVirtualTimeF() - this.m.RenderAnimationStartTime) / (this.Const.Combat.ResurrectAnimationTime * this.m.RenderAnimationSpeed);

			if (p >= 1.0)
			{
				this.setPos(this.createVec(0, this.Const.Combat.ResurrectAnimationDistance * this.m.RenderAnimationDistanceMult));
				this.m.IsSinking = false;
				this.m.IsAttackable = true;

				if (!this.m.IsUsingCustomRendering)
				{
					this.setRenderCallbackEnabled(false);
				}
			}
			else
			{
				this.setPos(this.createVec(0, this.Const.Combat.ResurrectAnimationDistance * this.m.RenderAnimationDistanceMult * p));
			}
		}

		if (this.m.IsRaisingRooted)
		{
			local from = this.createVec(this.m.RenderAnimationOffset.X, this.m.RenderAnimationOffset.Y - 100);
			this.moveSpriteOffset("status_rooted_back", from, this.m.RenderAnimationOffset, this.Const.Combat.RootedAnimationTime, this.m.RenderAnimationStartTime);

			if (this.moveSpriteOffset("status_rooted", from, this.m.RenderAnimationOffset, this.Const.Combat.RootedAnimationTime, this.m.RenderAnimationStartTime))
			{
				this.m.IsRaisingRooted = false;

				if (!this.m.IsUsingCustomRendering)
				{
					this.setRenderCallbackEnabled(false);
				}

				this.setDirty(true);
			}
		}
	}

	function resetRenderEffects()
	{
		this.m.IsRaising = false;
		this.m.IsSinking = false;
		this.m.IsRaisingShield = false;
		this.m.IsLoweringShield = false;
		this.m.IsRaisingWeapon = false;
		this.m.IsLoweringWeapon = false;
		this.setRenderCallbackEnabled(false);
		this.setSpriteOffset("shield_icon", this.createVec(0, 0));
		this.setSpriteOffset("arms_icon", this.createVec(0, 0));
		this.getSprite("arms_icon").Rotation = 0;
		this.getSprite("status_rooted").Visible = false;
		this.getSprite("status_rooted_back").Visible = false;
	}

	function onMovementUndo( _tile, _levelDifference )
	{
		local apCost = this.Math.max(1, (this.m.ActionPointCosts[_tile.Type] + this.m.CurrentProperties.MovementAPCostAdditional) * this.m.CurrentProperties.MovementAPCostMult);
		local fatigueCost = this.Math.round((this.m.FatigueCosts[_tile.Type] + this.m.CurrentProperties.MovementFatigueCostAdditional) * this.m.CurrentProperties.MovementFatigueCostMult);

		if (_levelDifference != 0)
		{
			apCost = apCost + this.m.LevelActionPointCost;
			fatigueCost = fatigueCost + this.m.LevelFatigueCost;

			if (_levelDifference > 0)
			{
				fatigueCost = fatigueCost + this.Const.Movement.LevelClimbingFatigueCost;
			}
		}

		fatigueCost = fatigueCost * this.m.CurrentProperties.FatigueEffectMult;
		this.m.ActionPoints = this.Math.round(this.m.ActionPoints + apCost);
		this.m.Fatigue = this.Math.min(this.getFatigueMax(), this.Math.round(this.m.Fatigue - fatigueCost));
	}

	function onMovementStep( _tile, _levelDifference )
	{
		if (this.m.CurrentProperties.IsRooted || this.m.CurrentProperties.IsStunned)
		{
			return false;
		}

		local apCost = this.Math.max(1, (this.m.ActionPointCosts[_tile.Type] + this.m.CurrentProperties.MovementAPCostAdditional) * this.m.CurrentProperties.MovementAPCostMult);
		local fatigueCost = this.Math.round((this.m.FatigueCosts[_tile.Type] + this.m.CurrentProperties.MovementFatigueCostAdditional) * this.m.CurrentProperties.MovementFatigueCostMult);

		if (_levelDifference != 0)
		{
			apCost = apCost + this.m.LevelActionPointCost;
			fatigueCost = fatigueCost + this.m.LevelFatigueCost;

			if (_levelDifference > 0)
			{
				fatigueCost = fatigueCost + this.Const.Movement.LevelClimbingFatigueCost;
			}
		}

		fatigueCost = fatigueCost * this.m.CurrentProperties.FatigueEffectMult;

		if (this.m.ActionPoints >= apCost && this.m.Fatigue + fatigueCost <= this.getFatigueMax())
		{
			this.m.ActionPoints = this.Math.round(this.m.ActionPoints - apCost);
			this.m.Fatigue = this.Math.min(this.getFatigueMax(), this.Math.round(this.m.Fatigue + fatigueCost));
			this.updateVisibility(_tile, this.m.CurrentProperties.getVision(), this.getFaction());

			if (this.getFaction() == this.Const.Faction.PlayerAnimals)
			{
				this.updateVisibility(_tile, this.m.CurrentProperties.getVision(), this.Const.Faction.Player);
			}

			return true;
		}
		else
		{
			return false;
		}
	}

	function onMovementStart( _tile, _numTiles )
	{
		this.m.IsMoving = true;
		this.setZoneOfControl(_tile, false);

		if (this.m.IsExertingZoneOfOccupation)
		{
			_tile.removeZoneOfOccupation(this.getFaction());
			this.m.IsExertingZoneOfOccupation = false;
		}

		if (this.Const.Tactical.TerrainEffectID[_tile.Type].len() > 0)
		{
			this.m.Skills.removeByID(this.Const.Tactical.TerrainEffectID[_tile.Type]);
		}

		if (_tile.IsHidingEntity)
		{
			this.m.Skills.removeByID(this.Const.Movement.HiddenStatusEffectID);
		}

		if (_numTiles > 1)
		{
			this.playSound(this.Const.Sound.ActorEvent.Move, this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.Move] * this.m.SoundVolumeOverall * (this.Math.rand(50, 100) * 0.01) * (_tile.IsVisibleForPlayer ? 1.0 : 0.5));
		}

		this.m.IsMoving = false;
	}

	function onMovementFinish( _tile )
	{
		this.m.IsMoving = true;
		this.updateVisibility(_tile, this.m.CurrentProperties.getVision(), this.getFaction());

		if (this.Tactical.TurnSequenceBar.getActiveEntity() != null && this.Tactical.TurnSequenceBar.getActiveEntity().getID() != this.getID())
		{
			this.Tactical.TurnSequenceBar.getActiveEntity().updateVisibilityForFaction();
		}

		this.setZoneOfControl(_tile, this.hasZoneOfControl());

		if (!this.m.IsExertingZoneOfOccupation)
		{
			_tile.addZoneOfOccupation(this.getFaction());
			this.m.IsExertingZoneOfOccupation = true;
		}

		if (this.Const.Tactical.TerrainEffect[_tile.Type].len() > 0 && !this.m.Skills.hasSkill(this.Const.Tactical.TerrainEffectID[_tile.Type]))
		{
			this.m.Skills.add(this.new(this.Const.Tactical.TerrainEffect[_tile.Type]));
		}

		if (_tile.IsHidingEntity)
		{
			this.m.Skills.add(this.new(this.Const.Movement.HiddenStatusEffect));
		}

		local numOfEnemiesAdjacentToMe = _tile.getZoneOfControlCountOtherThan(this.getAlliedFactions());

		if (this.m.CurrentMovementType == this.Const.Tactical.MovementType.Default)
		{
			if (this.m.MoraleState != this.Const.MoraleState.Fleeing)
			{
				for( local i = 0; i != 6; i = ++i )
				{
					if (!_tile.hasNextTile(i))
					{
					}
					else
					{
						local otherTile = _tile.getNextTile(i);

						if (!otherTile.IsOccupiedByActor)
						{
						}
						else
						{
							local otherActor = otherTile.getEntity();
							local numEnemies = otherTile.getZoneOfControlCountOtherThan(otherActor.getAlliedFactions());

							if (otherActor.m.MaxEnemiesThisTurn < numEnemies && !otherActor.isAlliedWith(this))
							{
								local difficulty = this.Math.maxf(10.0, 50.0 - this.getXPValue() * 0.1);
								otherActor.checkMorale(-1, difficulty);
								otherActor.m.MaxEnemiesThisTurn = numEnemies;
							}
						}
					}
				}
			}
		}
		else if (this.m.CurrentMovementType == this.Const.Tactical.MovementType.Involuntary)
		{
			if (this.m.MaxEnemiesThisTurn < numOfEnemiesAdjacentToMe)
			{
				local difficulty = 40.0;
				this.checkMorale(-1, difficulty);
			}
		}

		this.m.CurrentMovementType = this.Const.Tactical.MovementType.Default;
		this.m.MaxEnemiesThisTurn = this.Math.max(1, numOfEnemiesAdjacentToMe);

		if (this.isPlayerControlled() && this.getMoraleState() > this.Const.MoraleState.Breaking && this.getMoraleState() != this.Const.MoraleState.Ignore && (_tile.SquareCoords.X == 0 || _tile.SquareCoords.Y == 0 || _tile.SquareCoords.X == 31 || _tile.SquareCoords.Y == 31))
		{
			local change = this.getMoraleState() - this.Const.MoraleState.Breaking;
			this.checkMorale(-change, -1000);
		}

		if (this.m.IsEmittingMovementSounds && this.Const.Tactical.TerrainMovementSound[_tile.Subtype].len() != 0)
		{
			local sound = this.Const.Tactical.TerrainMovementSound[_tile.Subtype][this.Math.rand(0, this.Const.Tactical.TerrainMovementSound[_tile.Subtype].len() - 1)];
			this.Sound.play("sounds/" + sound.File, sound.Volume * this.Const.Sound.Volume.TacticalMovement * this.Math.rand(90, 100) * 0.01, this.getPos(), sound.Pitch * this.Math.rand(95, 105) * 0.01);
		}

		this.spawnTerrainDropdownEffect(_tile);

		if (_tile.Properties.Effect != null && _tile.Properties.Effect.IsAppliedOnEnter)
		{
			_tile.Properties.Effect.Callback(_tile, this);
		}

		this.m.Skills.update();
		this.m.Items.onMovementFinished();
		this.setDirty(true);
		this.m.IsMoving = false;
	}

	function onMovementInZoneOfControl( _entity, _isOnEnter )
	{
		if (!this.m.IsActingEachTurn)
		{
			return false;
		}

		if (!this.m.IsUsingZoneOfControl || !this.m.IsExertingZoneOfControl)
		{
			return false;
		}

		if (this.m.MoraleState == this.Const.MoraleState.Fleeing || this.getCurrentProperties().IsStunned)
		{
			return false;
		}

		if (_isOnEnter && (!this.getCurrentProperties().IsAttackingOnZoneOfControlEnter || !this.getCurrentProperties().IsAttackingOnZoneOfControlAlways && this.getTile().getZoneOfControlCountOtherThan(this.getAlliedFactions()) > 1))
		{
			return false;
		}

		if (!_entity.getCurrentProperties().IsImmuneToZoneOfControl && !_entity.isAlliedWith(this))
		{
			local skill = this.m.Skills.getAttackOfOpportunity();

			if (skill != null)
			{
				return true;
			}
		}

		return false;
	}

	function onAttackOfOpportunity( _entity, _isOnEnter )
	{
		if (!this.m.IsActingEachTurn)
		{
			return false;
		}

		if (!this.m.IsUsingZoneOfControl || !this.m.IsExertingZoneOfControl)
		{
			return false;
		}

		if (this.m.MoraleState == this.Const.MoraleState.Fleeing || this.getCurrentProperties().IsStunned)
		{
			return false;
		}

		if (_isOnEnter && (!this.getCurrentProperties().IsAttackingOnZoneOfControlEnter || !this.getCurrentProperties().IsAttackingOnZoneOfControlAlways && this.getTile().getZoneOfControlCountOtherThan(this.getAlliedFactions()) > 1))
		{
			return false;
		}

		if (_entity.getTile().Properties.Effect != null && _entity.getTile().Properties.Effect.Type == "smoke")
		{
			return false;
		}

		if (!_entity.getCurrentProperties().IsImmuneToZoneOfControl && !_entity.isAlliedWith(this))
		{
			local skill = this.m.Skills.getAttackOfOpportunity();

			if (skill != null)
			{
				if (skill.useForFree(_entity.getTile()))
				{
					_entity.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);
					return true;
				}
			}
		}

		return false;
	}

	function onDiscovered()
	{
		if (!this.isPlayerControlled())
		{
			if (this.getFaction() != this.Const.Faction.Player && this.getFaction() != this.Const.Faction.PlayerAnimals)
			{
				if (this.Const.Movement.AnnounceDiscoveredEntities)
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this) + " a été découvert!");
				}
			}

			this.setDirty(true);
		}
	}

	function onActorSighted( _actor )
	{
		if (this.m.AIAgent != null)
		{
			if (!this.isAlliedWith(_actor))
			{
				this.m.AIAgent.onOpponentSighted(_actor);
			}
			else
			{
				this.m.AIAgent.onAllySighted(_actor);
			}
		}
	}

	function onUpdateInjuryLayer()
	{
		if (!this.hasSprite("injury"))
		{
			return;
		}

		local injury = this.getSprite("injury");
		local p = this.getHitpointsPct();

		if (p > 0.5)
		{
			if (injury.Visible)
			{
				injury.Visible = false;

				if (this.hasSprite("injury_skin"))
				{
					this.getSprite("injury_skin").Visible = false;
				}

				if (this.hasSprite("injury_body"))
				{
					this.getSprite("injury_body").Visible = false;
				}

				this.setDirty(true);
			}
		}
		else if (!injury.Visible)
		{
			injury.Visible = true;

			if (this.hasSprite("injury_skin"))
			{
				this.getSprite("injury_skin").Visible = true;
			}

			if (this.hasSprite("injury_body"))
			{
				this.getSprite("injury_body").Visible = true;
			}

			this.setDirty(true);
		}
	}

	function onBeforeCombatResult()
	{
	}

	function setMoraleState( _m )
	{
		if (this.m.MoraleState == _m)
		{
			return;
		}

		if (_m == this.Const.MoraleState.Fleeing)
		{
			this.m.Skills.removeByID("effects.shieldwall");
			this.m.Skills.removeByID("effects.spearwall");
			this.m.Skills.removeByID("effects.riposte");
			this.m.Skills.removeByID("effects.return_favor");
			this.m.Skills.removeByID("effects.indomitable");
		}

		this.m.MoraleState = _m;
		local morale = this.getSprite("morale");

		if (this.Const.MoraleStateBrush[this.m.MoraleState].len() != 0)
		{
			if (this.m.MoraleState == this.Const.MoraleState.Confident)
			{
				morale.setBrush(this.m.ConfidentMoraleBrush);
			}
			else
			{
				morale.setBrush(this.Const.MoraleStateBrush[this.m.MoraleState]);
			}

			morale.Visible = true;
		}
		else
		{
			morale.Visible = false;
		}

		this.m.Skills.update();
	}

	function checkMorale( _change, _difficulty, _type = this.Const.MoraleCheckType.Default, _showIconBeforeMoraleIcon = "", _noNewLine = false )
	{
		if (!this.isAlive() || this.isDying())
		{
			return false;
		}

		if (this.m.MoraleState == this.Const.MoraleState.Ignore)
		{
			return false;
		}

		if (_change > 0 && this.m.MoraleState == this.Const.MoraleState.Confident)
		{
			return false;
		}

		if (_change < 0 && this.m.MoraleState == this.Const.MoraleState.Fleeing)
		{
			return false;
		}

		if (_change > 0 && this.m.MoraleState >= this.m.MaxMoraleState)
		{
			return false;
		}

		if (_change == 1 && this.m.MoraleState == this.Const.MoraleState.Fleeing)
		{
			return false;
		}

		local myTile = this.getTile();

		if (this.isPlayerControlled() && _change > 0 && (myTile.SquareCoords.X == 0 || myTile.SquareCoords.Y == 0 || myTile.SquareCoords.X == 31 || myTile.SquareCoords.Y == 31))
		{
			return false;
		}

		_difficulty = _difficulty * this.getCurrentProperties().MoraleEffectMult;
		local bravery = (this.getBravery() + this.getCurrentProperties().MoraleCheckBravery[_type]) * this.getCurrentProperties().MoraleCheckBraveryMult[_type];

		if (bravery > 500)
		{
			if (_change != 0)
			{
				return false;
			}
			else
			{
				return true;
			}
		}

		local numOpponentsAdjacent = 0;
		local numAlliesAdjacent = 0;
		local threatBonus = 0;

		for( local i = 0; i != 6; i = ++i )
		{
			if (!myTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = myTile.getNextTile(i);

				if (tile.IsOccupiedByActor && tile.getEntity().getMoraleState() != this.Const.MoraleState.Fleeing)
				{
					if (tile.getEntity().isAlliedWith(this))
					{
						numAlliesAdjacent = ++numAlliesAdjacent;
					}
					else
					{
						numOpponentsAdjacent = ++numOpponentsAdjacent;
						threatBonus = threatBonus + tile.getEntity().getCurrentProperties().Threat;
					}
				}
			}
		}

		if (_change > 0)
		{
			if (this.Math.rand(1, 100) > this.Math.minf(95, bravery + _difficulty - numOpponentsAdjacent * this.Const.Morale.OpponentsAdjacentMult - threatBonus))
			{
				if (this.Math.rand(1, 100) > this.m.CurrentProperties.RerollMoraleChance || this.Math.rand(1, 100) > this.Math.minf(95, bravery + _difficulty - numOpponentsAdjacent * this.Const.Morale.OpponentsAdjacentMult - threatBonus))
				{
					return false;
				}
			}
		}
		else if (_change < 0)
		{
			if (this.Math.rand(1, 100) <= this.Math.minf(95, bravery + _difficulty - numOpponentsAdjacent * this.Const.Morale.OpponentsAdjacentMult + numAlliesAdjacent * this.Const.Morale.AlliesAdjacentMult - threatBonus))
			{
				return false;
			}

			if (this.Math.rand(1, 100) <= this.m.CurrentProperties.RerollMoraleChance && this.Math.rand(1, 100) <= this.Math.minf(95, bravery + _difficulty - numOpponentsAdjacent * this.Const.Morale.OpponentsAdjacentMult + numAlliesAdjacent * this.Const.Morale.AlliesAdjacentMult - threatBonus))
			{
				return false;
			}
		}
		else if (this.Math.rand(1, 100) <= this.Math.minf(95, bravery + _difficulty - numOpponentsAdjacent * this.Const.Morale.OpponentsAdjacentMult + numAlliesAdjacent * this.Const.Morale.AlliesAdjacentMult - threatBonus))
		{
			return true;
		}
		else if (this.Math.rand(1, 100) <= this.m.CurrentProperties.RerollMoraleChance && this.Math.rand(1, 100) <= this.Math.minf(95, bravery + _difficulty - numOpponentsAdjacent * this.Const.Morale.OpponentsAdjacentMult + numAlliesAdjacent * this.Const.Morale.AlliesAdjacentMult - threatBonus))
		{
			return true;
		}
		else
		{
			return false;
		}

		local oldMoraleState = this.m.MoraleState;
		this.m.MoraleState = this.Math.min(this.Const.MoraleState.Confident, this.Math.max(0, this.m.MoraleState + _change));
		this.m.FleeingRounds = 0;

		if (oldMoraleState == this.Const.MoraleState.Fleeing && this.m.IsActingEachTurn)
		{
			this.setZoneOfControl(this.getTile(), this.hasZoneOfControl());

			if (this.isPlayerControlled() || !this.isHiddenToPlayer())
			{
				if (_noNewLine)
				{
					this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this) + " s\'est rallié");
				}
				else
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this) + " s\'est rallié");
				}
			}
		}
		else if (this.m.MoraleState == this.Const.MoraleState.Fleeing)
		{
			this.setZoneOfControl(this.getTile(), this.hasZoneOfControl());
			this.m.Skills.removeByID("effects.shieldwall");
			this.m.Skills.removeByID("effects.spearwall");
			this.m.Skills.removeByID("effects.riposte");
			this.m.Skills.removeByID("effects.return_favor");
			this.m.Skills.removeByID("effects.indomitable");
		}

		local morale = this.getSprite("morale");

		if (this.Const.MoraleStateBrush[this.m.MoraleState].len() != 0)
		{
			if (this.m.MoraleState == this.Const.MoraleState.Confident)
			{
				morale.setBrush(this.m.ConfidentMoraleBrush);
			}
			else
			{
				morale.setBrush(this.Const.MoraleStateBrush[this.m.MoraleState]);
			}

			morale.Visible = true;
		}
		else
		{
			morale.Visible = false;
		}

		if (this.isPlayerControlled() || !this.isHiddenToPlayer())
		{
			if (_noNewLine)
			{
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this) + this.Const.MoraleStateEvent[this.m.MoraleState]);
			}
			else
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this) + this.Const.MoraleStateEvent[this.m.MoraleState]);
			}

			if (_showIconBeforeMoraleIcon != "")
			{
				this.Tactical.spawnIconEffect(_showIconBeforeMoraleIcon, this.getTile(), this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
			}

			if (_change > 0)
			{
				this.Tactical.spawnIconEffect(this.Const.Morale.MoraleUpIcon, this.getTile(), this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
			}
			else
			{
				this.Tactical.spawnIconEffect(this.Const.Morale.MoraleDownIcon, this.getTile(), this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
			}
		}

		this.m.Skills.update();
		this.setDirty(true);

		if (this.m.MoraleState == this.Const.MoraleState.Fleeing && this.Tactical.TurnSequenceBar.getActiveEntity() != this)
		{
			this.Tactical.TurnSequenceBar.pushEntityBack(this.getID());
		}

		if (this.m.MoraleState == this.Const.MoraleState.Fleeing)
		{
			local actors = this.Tactical.Entities.getInstancesOfFaction(this.getFaction());

			if (actors != null)
			{
				foreach( a in actors )
				{
					if (a.getID() != this.getID())
					{
						a.onOtherActorFleeing(this);
					}
				}
			}
		}

		return true;
	}

	function spawnBloodEffect( _tile, _mult = 1.0 )
	{
		local n = this.m.BloodType;

		for( local i = 0; i < this.Const.Tactical.BloodEffects[n].len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.BloodEffects[n][i].Brushes, _tile, this.Const.Tactical.BloodEffects[n][i].Delay, this.Math.max(1, this.Const.Tactical.BloodEffects[n][i].Quantity * _mult), this.Math.max(1, this.Const.Tactical.BloodEffects[n][i].LifeTimeQuantity * _mult), this.Math.max(1, this.Const.Tactical.BloodEffects[n][i].SpawnRate * _mult), this.Const.Tactical.BloodEffects[n][i].Stages);
		}
	}

	function spawnBloodDecals( _tile )
	{
		if (this.Const.BloodDecals[this.m.BloodType].len() == 0)
		{
			return;
		}

		if (this.Math.rand(0, 100) < this.Const.Combat.SpawnBloodSameTileChance)
		{
			for( local n = this.Const.Combat.SpawnBloodAttempts; n != 0;  )
			{
				local decal = this.Const.BloodDecals[this.m.BloodType][this.Math.rand(0, this.Const.BloodDecals[this.m.BloodType].len() - 1)];
				local detail = _tile.spawnDetail(decal, this.Math.rand(0, 1) == 0, false, 0);

				if (detail != null)
				{
					detail.Color = this.m.BloodColor;
					detail.Saturation = this.m.BloodSaturation;
					n = --n;
					continue;
				}

				break;
			}
		}

		if (this.Math.rand(0, 100) < this.Const.Combat.SpawnBloodAdjacentTileChance)
		{
			local spawnOnTile;
			local dir = this.Math.rand(0, this.Const.Direction.COUNT - 1);

			if (_tile.hasNextTile(dir))
			{
				spawnOnTile = _tile.getNextTile(dir);
			}

			if (spawnOnTile != null)
			{
				if (spawnOnTile.Level > _tile.Level)
				{
					return;
				}

				for( local n = this.Const.Combat.SpawnBloodAttempts; n != 0;  )
				{
					local decal = this.Const.BloodDecals[this.m.BloodType][this.Math.rand(0, this.Const.BloodDecals[this.m.BloodType].len() - 1)];
					local detail = spawnOnTile.spawnDetail(decal, this.Math.rand(0, 1) == 0, false, 0);

					if (detail != null)
					{
						detail.Color = this.m.BloodColor;
						detail.Saturation = this.m.BloodSaturation;
						n = --n;
						continue;
					}

					break;
				}
			}
		}
	}

	function spawnFlies( _tile )
	{
	}

	function spawnTerrainDropdownEffect( _tile )
	{
		if (_tile.IsVisibleForPlayer && this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype].len() != 0)
		{
			for( local i = 0; i < this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype].len(); i = ++i )
			{
				if (this.Tactical.getWeather().IsRaining && !this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].ApplyOnRain)
				{
				}
				else
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].Brushes, _tile, this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].Delay, this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].Quantity, this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].LifeTimeQuantity, this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].SpawnRate, this.Const.Tactical.TerrainDropdownParticles[_tile.Subtype][i].Stages);
				}
			}
		}
	}

	function spawnBloodPool( _tile, _num )
	{
		if (this.Const.BloodPoolDecals[this.m.BloodType].len() == 0)
		{
			return;
		}

		for( local i = 0; i < _num; i = ++i )
		{
			this.Tactical.spawnPoolEffect(this.Const.BloodPoolDecals[this.m.BloodType][this.Math.rand(0, this.Const.BloodPoolDecals[this.m.BloodType].len() - 1)], _tile, this.Const.BloodPoolTerrainAlpha[_tile.Type], this.m.BloodPoolScale, this.Const.Tactical.DetailFlag.Corpse);
		}
	}

	function spawnBloodSplatters( _tile, _quantityMult )
	{
		if (this.Const.Tactical.BloodSplatters[this.m.BloodType].len() == 0)
		{
			return;
		}

		local offset = this.createVec(this.m.IsCorpseFlipped ? -this.m.BloodSplatterOffset.X : this.m.BloodSplatterOffset.X, this.m.BloodSplatterOffset.Y);

		for( local i = 0; i < this.Const.Tactical.BloodSplatters[this.m.BloodType].len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.BloodSplatters[this.m.BloodType][i].Brushes, _tile, this.Const.Tactical.BloodSplatters[this.m.BloodType][i].Delay, this.Math.max(1, this.Const.Tactical.BloodSplatters[this.m.BloodType][i].Quantity * _quantityMult), this.Math.max(1, this.Const.Tactical.BloodSplatters[this.m.BloodType][i].LifeTimeQuantity * _quantityMult), this.Const.Tactical.BloodSplatters[this.m.BloodType][i].SpawnRate, this.Const.Tactical.BloodSplatters[this.m.BloodType][i].Stages, offset);
		}
	}

	function spawnDecapitateSplatters( _tile, _quantityMult )
	{
		if (this.Const.Tactical.DecapitateSplatters[this.m.BloodType].len() == 0)
		{
			return;
		}

		local offset = this.createVec(this.m.IsCorpseFlipped ? -this.m.DecapitateSplatterOffset.X : this.m.DecapitateSplatterOffset.X, this.m.DecapitateSplatterOffset.Y);

		for( local i = 0; i < this.Const.Tactical.DecapitateSplatters[this.m.BloodType].len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(true, this.Const.Tactical.DecapitateSplatters[this.m.BloodType][i].Brushes, _tile, this.Const.Tactical.DecapitateSplatters[this.m.BloodType][i].Delay, this.Math.max(1, this.Const.Tactical.DecapitateSplatters[this.m.BloodType][i].Quantity * _quantityMult), this.Math.max(1, this.Const.Tactical.DecapitateSplatters[this.m.BloodType][i].LifeTimeQuantity * _quantityMult), this.Const.Tactical.DecapitateSplatters[this.m.BloodType][i].SpawnRate, this.Const.Tactical.DecapitateSplatters[this.m.BloodType][i].Stages, offset);
		}
	}

	function spawnSmashSplatters( _tile, _quantityMult )
	{
		if (this.Const.Tactical.SmashSplatters[this.m.BloodType].len() == 0)
		{
			return;
		}

		local offset = this.createVec(this.m.IsCorpseFlipped ? -this.m.SmashSplatterOffset.X : this.m.SmashSplatterOffset.X, this.m.SmashSplatterOffset.Y);

		for( local i = 0; i < this.Const.Tactical.SmashSplatters[this.m.BloodType].len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(true, this.Const.Tactical.SmashSplatters[this.m.BloodType][i].Brushes, _tile, this.Const.Tactical.SmashSplatters[this.m.BloodType][i].Delay, this.Math.max(1, this.Const.Tactical.SmashSplatters[this.m.BloodType][i].Quantity * _quantityMult), this.Math.max(1, this.Const.Tactical.SmashSplatters[this.m.BloodType][i].LifeTimeQuantity * _quantityMult), this.Const.Tactical.SmashSplatters[this.m.BloodType][i].SpawnRate, this.Const.Tactical.SmashSplatters[this.m.BloodType][i].Stages, offset);
		}
	}

	function spawnDust( _tile, _quantityMult )
	{
		if (this.Const.Tactical.DustParticles.len() == 0)
		{
			return;
		}

		for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, _tile, this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity * _quantityMult, this.Const.Tactical.DustParticles[i].LifeTimeQuantity * _quantityMult, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages);
		}
	}

	function findTileToSpawnCorpse( _killer )
	{
		if (!this.isPlacedOnMap())
		{
			return null;
		}

		local ourTile = this.getTile();
		local killerTile = _killer != null ? _killer.getTile() : null;

		if (ourTile == null || !ourTile.IsCorpseSpawned)
		{
			return ourTile;
		}

		if (_killer != null && ourTile.hasNextTile(killerTile.getDirectionTo(ourTile)))
		{
			local oppositeTile = ourTile.getNextTile(killerTile.getDirectionTo(ourTile));

			if (oppositeTile.IsEmpty && !oppositeTile.IsCorpseSpawned && oppositeTile.Level - ourTile.Level <= 1)
			{
				return oppositeTile;
			}
		}

		local lowerOrEqual = [];
		local all = [];

		for( local i = 0; i < this.Const.Direction.COUNT; i = ++i )
		{
			if (!ourTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = ourTile.getNextTile(i);

				if (!tile.IsEmpty || tile.IsCorpseSpawned)
				{
				}
				else if (tile.Level - ourTile.Level > 1)
				{
				}
				else
				{
					if (tile.Level <= ourTile.Level)
					{
						lowerOrEqual.push(tile);
					}

					all.push(tile);
				}
			}
		}

		if (lowerOrEqual.len() != 0)
		{
			return lowerOrEqual[this.Math.rand(0, lowerOrEqual.len() - 1)];
		}

		if (all.len() != 0)
		{
			return all[this.Math.rand(0, all.len() - 1)];
		}

		if (_killer != null && !killerTile.IsCorpseSpawned && killerTile.getDistanceTo(ourTile) == 1 && killerTile.Level - ourTile.Level <= 1)
		{
			return killerTile;
		}

		return null;
	}

	function isReallyKilled( _fatalityType )
	{
		return true;
	}

	function killSilently()
	{
		this.kill(null, null, this.Const.FatalityType.None, true);
	}

	function kill( _killer = null, _skill = null, _fatalityType = this.Const.FatalityType.None, _silent = false )
	{
		if (!this.isAlive())
		{
			return;
		}

		if (_killer != null && !_killer.isAlive())
		{
			_killer = null;
		}

		if (this.m.IsMiniboss && !this.Tactical.State.isScenarioMode() && _killer != null && _killer.isPlayerControlled())
		{
			this.updateAchievement("GiveMeThat", 1, 1);

			if (!this.Tactical.State.isScenarioMode() && this.World.Retinue.hasFollower("follower.bounty_hunter"))
			{
				this.World.Retinue.getFollower("follower.bounty_hunter").onChampionKilled(this);
			}
		}

		if (!this.Tactical.State.isScenarioMode() && _killer != null && _killer.isPlayerControlled() && _skill != null && _skill.getID() == "actives.deathblow")
		{
			this.updateAchievement("Assassin", 1, 1);
		}

		this.m.IsDying = true;
		local isReallyDead = this.isReallyKilled(_fatalityType);

		if (!isReallyDead)
		{
			_fatalityType = this.Const.FatalityType.Unconscious;
			this.logDebug(this.getName() + " est inconscient.");
		}
		else
		{
			this.logDebug(this.getName() + " est mort.");
		}

		if (!_silent)
		{
			this.playSound(this.Const.Sound.ActorEvent.Death, this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.Death] * this.m.SoundVolumeOverall, this.m.SoundPitch);
		}

		local myTile = this.isPlacedOnMap() ? this.getTile() : null;
		local tile = this.findTileToSpawnCorpse(_killer);
		this.m.Skills.onDeath();
		this.onDeath(_killer, _skill, tile, _fatalityType);

		if (!this.Tactical.State.isFleeing() && _killer != null)
		{
			_killer.onActorKilled(this, tile, _skill);
		}

		if (_killer != null && !_killer.isHiddenToPlayer() && !this.isHiddenToPlayer())
		{
			if (isReallyDead)
			{
				if (_killer.getID() != this.getID())
				{
					this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_killer) + " a tué " + this.Const.UI.getColorizedEntityName(this));
				}
				else
				{
					this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this) + " est mort");
				}
			}
			else if (_killer.getID() != this.getID())
			{
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_killer) + " à mis à terre " + this.Const.UI.getColorizedEntityName(this));
			}
			else
			{
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(this) + " est au sol");
			}
		}

		if (!this.Tactical.State.isFleeing() && myTile != null)
		{
			local actors = this.Tactical.Entities.getAllInstances();

			foreach( i in actors )
			{
				foreach( a in i )
				{
					if (a.getID() != this.getID())
					{
						a.onOtherActorDeath(_killer, this, _skill);
					}
				}
			}
		}

		if (!this.isHiddenToPlayer())
		{
			if (tile != null)
			{
				if (_fatalityType == this.Const.FatalityType.Decapitated)
				{
					this.spawnDecapitateSplatters(tile, 1.0 * this.m.DecapitateBloodAmount);
				}
				else if (_fatalityType == this.Const.FatalityType.Smashed && (this.getFlags().has("human") || this.getFlags().has("zombie_minion")))
				{
					this.spawnSmashSplatters(tile, 1.0);
				}
				else
				{
					this.spawnBloodSplatters(tile, this.Const.Combat.BloodSplattersAtDeathMult * this.m.DeathBloodAmount);

					if (!this.getTile().isSameTileAs(tile))
					{
						this.spawnBloodSplatters(this.getTile(), this.Const.Combat.BloodSplattersAtOriginalPosMult);
					}
				}
			}
			else if (myTile != null)
			{
				this.spawnBloodSplatters(this.getTile(), this.Const.Combat.BloodSplattersAtDeathMult * this.m.DeathBloodAmount);
			}
		}

		if (tile != null)
		{
			this.spawnBloodPool(tile, this.Math.rand(this.Const.Combat.BloodPoolsAtDeathMin, this.Const.Combat.BloodPoolsAtDeathMax));
		}

		this.m.IsTurnDone = true;
		this.m.IsAlive = false;

		if (this.m.WorldTroop != null && ("Party" in this.m.WorldTroop) && this.m.WorldTroop.Party != null && !this.m.WorldTroop.Party.isNull())
		{
			this.m.WorldTroop.Party.removeTroop(this.m.WorldTroop);
		}

		if (!this.Tactical.State.isScenarioMode())
		{
			this.World.Contracts.onActorKilled(this, _killer, this.Tactical.State.getStrategicProperties().CombatID);
			this.World.Events.onActorKilled(this, _killer, this.Tactical.State.getStrategicProperties().CombatID);

			if (this.Tactical.State.getStrategicProperties() != null && this.Tactical.State.getStrategicProperties().IsArenaMode)
			{
				if (_killer == null || _killer.getID() == this.getID())
				{
					this.Sound.play(this.Const.Sound.ArenaFlee[this.Math.rand(0, this.Const.Sound.ArenaFlee.len() - 1)], this.Const.Sound.Volume.Tactical * this.Const.Sound.Volume.Arena);
				}
				else
				{
					this.Sound.play(this.Const.Sound.ArenaKill[this.Math.rand(0, this.Const.Sound.ArenaKill.len() - 1)], this.Const.Sound.Volume.Tactical * this.Const.Sound.Volume.Arena);
				}
			}
		}

		if (this.isPlayerControlled())
		{
			if (isReallyDead)
			{
				if (this.isGuest())
				{
					this.World.getGuestRoster().remove(this);
				}
				else
				{
					this.World.getPlayerRoster().remove(this);
				}
			}

			if (this.Tactical.Entities.getHostilesNum() != 0)
			{
				this.Tactical.Entities.setLastCombatResult(this.Const.Tactical.CombatResult.PlayerDestroyed);
			}
			else
			{
				this.Tactical.Entities.setLastCombatResult(this.Const.Tactical.CombatResult.EnemyDestroyed);
			}
		}
		else
		{
			if (!this.Tactical.State.isAutoRetreat())
			{
				this.Tactical.Entities.setLastCombatResult(this.Const.Tactical.CombatResult.EnemyDestroyed);
			}

			if (_killer != null && _killer.isPlayerControlled() && !this.Tactical.State.isScenarioMode() && this.World.FactionManager.getFaction(this.getFaction()) != null && !this.World.FactionManager.getFaction(this.getFaction()).isTemporaryEnemy())
			{
				this.World.FactionManager.getFaction(this.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationUnitKilled);
			}
		}

		if (isReallyDead)
		{
			if (!this.Tactical.State.isScenarioMode() && this.isPlayerControlled() && !this.isGuest())
			{
				local roster = this.World.getPlayerRoster().getAll();

				foreach( bro in roster )
				{
					if (bro.isAlive() && !bro.isDying() && bro.getCurrentProperties().IsAffectedByDyingAllies)
					{
						if (this.World.Assets.getOrigin().getID() != "scenario.manhunters" || this.getBackground().getID() != "background.slave" || bro.getBackground().getID() == "background.slave")
						{
							bro.worsenMood(this.Const.MoodChange.BrotherDied, this.getName() + " mort au combat");
						}
					}
				}
			}

			this.die();
		}
		else
		{
			this.removeFromMap();
		}

		if (this.m.Items != null)
		{
			this.m.Items.onActorDied(tile);

			if (isReallyDead)
			{
				this.m.Items.setActor(null);
			}
		}

		if (!this.Tactical.State.isScenarioMode() && _killer != null && _killer.getFaction() == this.Const.Faction.PlayerAnimals && _skill != null && _skill.getID() == "actives.wardog_bite")
		{
			this.updateAchievement("WhoLetTheDogsOut", 1, 1);
		}

		this.onAfterDeath(myTile);
	}

	function onAfterDeath( _tile )
	{
	}

	function retreat()
	{
		if (!this.isHiddenToPlayer())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this) + " s\'est retiré de la bataille");
		}

		this.m.IsTurnDone = true;
		this.m.IsAlive = false;

		if (this.m.WorldTroop != null && ("Party" in this.m.WorldTroop) && this.m.WorldTroop.Party != null)
		{
			this.m.WorldTroop.Party.removeTroop(this.m.WorldTroop);
		}

		if (!this.Tactical.State.isScenarioMode())
		{
			this.World.Contracts.onActorRetreated(this, this.Tactical.State.getStrategicProperties().CombatID);
			this.World.Events.onActorRetreated(this, this.Tactical.State.getStrategicProperties().CombatID);
		}

		if (this.isPlayerControlled())
		{
			this.Tactical.Entities.setLastCombatResult(this.Const.Tactical.CombatResult.PlayerRetreated);
		}
		else
		{
			this.Tactical.Entities.setLastCombatResult(this.Const.Tactical.CombatResult.EnemyRetreated);
		}

		this.die();
	}

	function pickupMeleeWeaponAndShield( _tile )
	{
		local currentItem = this.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

		if (currentItem != null && !currentItem.isItemType(this.Const.Items.ItemType.MeleeWeapon))
		{
			currentItem.drop();
		}

		if (_tile.IsContainingItems)
		{
			local weapon = this.isArmedWithMeleeWeapon();
			local shield = this.isArmedWithShield();
			local remove = [];

			foreach( item in _tile.Items )
			{
				if (!weapon && item.isItemType(this.Const.Items.ItemType.MeleeWeapon))
				{
					this.getItems().equip(item);

					if (item.isEquipped())
					{
						remove.push(item);
					}

					weapon = true;
					continue;
				}

				if (!shield && item.isItemType(this.Const.Items.ItemType.Shield))
				{
					this.getItems().equip(item);

					if (item.isEquipped())
					{
						remove.push(item);
					}

					shield = true;
					continue;
				}
			}

			foreach( item in remove )
			{
				item.removeFromTile();
			}
		}
	}

	function pickupRangedWeapon( _tile )
	{
		if (_tile.IsContainingItems)
		{
			local weapon = this.isArmedWithRangedWeapon();
			local secondary = !this.getItems().hasEmptySlot(this.Const.Items.ItemType.MeleeWeapon);
			local remove = [];

			foreach( item in _tile.Items )
			{
				if (!weapon && item.isItemType(this.Const.Items.ItemType.RangedWeapon))
				{
					this.getItems().equip(item);

					if (item.isEquipped())
					{
						remove.push(item);
					}

					weapon = true;
					continue;
				}

				if (!secondary && item.isItemType(this.Const.Items.ItemType.MeleeWeapon))
				{
					this.getItems().addToBag(item);

					if (item.isInBag())
					{
						remove.push(item);
					}

					secondary = true;
					continue;
				}
			}

			foreach( item in remove )
			{
				item.removeFromTile();
			}
		}
	}

	function addDefaultStatusSprites()
	{
		this.addSprite("miniboss");
		local hex = this.addSprite("status_hex");
		hex.Visible = false;
		local sweat = this.addSprite("status_sweat");
		local stunned = this.addSprite("status_stunned");
		stunned.setBrush(this.Const.Combat.StunnedBrush);
		stunned.Visible = false;
		local shield_icon = this.addSprite("shield_icon");
		shield_icon.Visible = false;
		local arms_icon = this.addSprite("arms_icon");
		arms_icon.Visible = false;
		local rooted = this.addSprite("status_rooted");
		rooted.Visible = false;
		rooted.Scale = this.getSprite("status_rooted_back").Scale;

		if (this.m.MoraleState != this.Const.MoraleState.Ignore)
		{
			local morale = this.addSprite("morale");
			morale.Visible = false;
		}
	}

	function onResurrected( _info )
	{
		this.setFaction(_info.Faction);
		this.getItems().clear();
		_info.Items.transferTo(this.getItems());

		if (_info.Name.len() != 0)
		{
			this.m.Name = _info.Name;
		}

		if (_info.Description.len() != 0)
		{
			this.m.Description = _info.Description;
		}

		this.m.Hitpoints = this.getHitpointsMax() * _info.Hitpoints;
		this.m.XP = this.Math.floor(this.m.XP * _info.Hitpoints);
		this.m.BaseProperties.Armor = _info.Armor;
		this.onUpdateInjuryLayer();
	}

	function assignRandomEquipment()
	{
	}

	function makeMiniboss()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return false;
		}

		this.m.XP *= 1.5;
		this.m.Skills.add(this.new("scripts/skills/racial/champion_racial"));
		this.m.IsMiniboss = true;
		this.m.IsGeneratingKillName = false;
		return true;
	}

	function isArmed()
	{
		return this.m.Items.hasItemWithType(this.Const.Items.ItemType.Weapon);
	}

	function hasRangedWeapon( _trueRangedOnly = false )
	{
		local items = [];
		local mainhand = this.m.Items.getItemAtSlot(this.Const.ItemSlot.Mainhand);

		if (mainhand != null)
		{
			items.push(mainhand);
		}

		local bags = this.m.Items.getAllItemsAtSlot(this.Const.ItemSlot.Bag);

		if (bags.len() != 0)
		{
			items.extend(bags);
		}

		if (items.len() == 0)
		{
			return false;
		}

		foreach( it in items )
		{
			if (it.isItemType(this.Const.Items.ItemType.RangedWeapon) && (!_trueRangedOnly || this.Math.min(it.getRangeMax(), this.m.CurrentProperties.getVision()) >= 6 && this.m.CurrentProperties.getRangedSkill() >= 45))
			{
				if (it.getAmmoMax() == 0 && it.getAmmoID() == "")
				{
					return true;
				}
				else if (it.getAmmoMax() == 0)
				{
					local ammo = this.m.Items.getItemAtSlot(this.Const.ItemSlot.Ammo);

					if (ammo != null && ammo.getID() == it.getAmmoID() && ammo.getAmmo() > 0)
					{
						return true;
					}

					foreach( ammo in bags )
					{
						if (ammo != null && ammo.getID() == it.getAmmoID() && ammo.getAmmo() > 0)
						{
							return true;
						}
					}
				}
				else if (it.getAmmo() > 0)
				{
					return true;
				}
			}
		}

		return false;
	}

	function getRangedWeaponInfo()
	{
		local items = [];
		local result = {
			HasRangedWeapon = false,
			IsTrueRangedWeapon = false,
			Range = 0,
			RangeWithLevel = 0
		};
		local mainhand = this.m.Items.getItemAtSlot(this.Const.ItemSlot.Mainhand);

		if (mainhand != null)
		{
			items.push(mainhand);
		}

		local bags = this.m.Items.getAllItemsAtSlot(this.Const.ItemSlot.Bag);

		if (bags.len() != 0)
		{
			items.extend(bags);
		}

		if (items.len() == 0)
		{
			return result;
		}

		foreach( it in items )
		{
			if (it.isItemType(this.Const.Items.ItemType.RangedWeapon))
			{
				local isViable = false;

				if (it.getAmmoMax() == 0 && it.getAmmoID() == "")
				{
					isViable = true;
				}
				else if (it.getAmmo() > 0)
				{
					isViable = true;
				}
				else if (it.getAmmoMax() == 0)
				{
					local ammo = this.m.Items.getItemAtSlot(this.Const.ItemSlot.Ammo);

					if (ammo != null && ammo.getID() == it.getAmmoID() && ammo.getAmmo() > 0)
					{
						isViable = true;
					}

					foreach( ammo in bags )
					{
						if (ammo != null && ammo.getID() == it.getAmmoID() && ammo.getAmmo() > 0)
						{
							isViable = true;
						}
					}
				}

				if (isViable)
				{
					result.HasRangedWeapon = true;
					local range = this.Math.min(it.getRangeEffective() + it.getAdditionalRange(this), this.m.CurrentProperties.getVision());

					if (range >= 6 && this.m.CurrentProperties.getRangedSkill() >= 45)
					{
						result.IsTrueRangedWeapon = true;
					}

					result.Range = this.Math.max(result.Range, range);
					result.RangeWithLevel = this.Math.max(result.RangeWithLevel, range + this.Math.min(it.getRangeMaxBonus(), this.getTile().Level));
				}
			}
		}

		return result;
	}

	function spasmCorpse( _decals, _offset )
	{
		local corpse_data = {
			Decals = _decals,
			Offset = _offset,
			Start = this.Time.getRealTimeF(),
			Vector = this.createVec(0.0, -1.0),
			Iterations = 0,
			function onCorpseEffect( _data )
			{
				if (this.Time.getRealTimeF() - _data.Start > 0.2)
				{
					if (++_data.Iterations > 5)
					{
						return;
					}

					_data.Vector = this.createVec(this.Math.rand(-100, 100) * 0.01, this.Math.rand(-100, 100) * 0.01);
					_data.Start = this.Time.getRealTimeF();
				}

				local f = (this.Time.getRealTimeF() - _data.Start) / 0.2;

				for( local i = 0; i < _data.Decals.len(); i = ++i )
				{
					_data.Decals[i].setOffset(this.createVec(_offset.X + 0.25 * _data.Vector.X * f, _offset.Y + 0.5 * _data.Vector.Y * f));
				}

				this.Time.scheduleEvent(this.TimeUnit.Real, 10, _data.onCorpseEffect, _data);
			}

		};
		this.Time.scheduleEvent(this.TimeUnit.Real, 10, corpse_data.onCorpseEffect, corpse_data);
	}

	function onSerialize( _out )
	{
		this.entity.onSerialize(_out);
		this.m.BaseProperties.onSerialize(_out);
		this.m.Items.onSerialize(_out);
		this.m.Skills.onSerialize(_out);
		_out.writeString(this.m.Name);
		_out.writeString(this.m.Title);
		_out.writeF32(this.getHitpointsPct());
		_out.writeI32(this.m.XP);
	}

	function onDeserialize( _in )
	{
		this.entity.onDeserialize(_in);
		this.m.BaseProperties.onDeserialize(_in);
		this.m.Items.onDeserialize(_in);
		this.m.Skills.onDeserialize(_in);
		this.m.Name = _in.readString();
		this.m.Title = _in.readString();
		this.setHitpointsPct(this.Math.maxf(0.0, _in.readF32()));
		this.m.XP = _in.readI32();
	}

});


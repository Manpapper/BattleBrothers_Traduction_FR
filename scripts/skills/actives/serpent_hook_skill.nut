this.serpent_hook_skill <- this.inherit("scripts/skills/skill", {
	m = {
		DestinationTile = null
	},
	function create()
	{
		this.m.ID = "actives.serpent_hook";
		this.m.Name = "Drag";
		this.m.Description = "";
		this.m.Icon = "skills/active_192.png";
		this.m.Overlay = "active_192";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc6/snake_snare_01.wav",
			"sounds/enemies/dlc6/snake_snare_02.wav",
			"sounds/enemies/dlc6/snake_snare_03.wav"
		];
		this.m.Delay = 1000;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsWeaponSkill = true;
		this.m.IsUsingHitchance = false;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
	}

	function setDestinationTile( _t )
	{
		this.m.DestinationTile = _t;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.getContainer().getActor().getCurrentProperties().IsRooted;
	}

	function findTileToKnockBackTo( _userTile, _targetTile )
	{
		return this.getPulledToTile(_userTile, _targetTile);
	}

	function getPulledToTile( _userTile, _targetTile )
	{
		local tiles = this.getPulledToTiles(_userTile, _targetTile);

		if (tiles.len() != 0)
		{
			return tiles[0];
		}
		else
		{
			return null;
		}
	}

	function getPulledToTiles( _userTile, _targetTile )
	{
		local tiles = [];

		for( local i = 0; i < 6; i = ++i )
		{
			if (!_userTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _userTile.getNextTile(i);

				if (tile.Level <= _userTile.Level && tile.IsEmpty && tile.getDistanceTo(_targetTile) <= 2)
				{
					tiles.push(tile);
				}
			}
		}

		return tiles;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		if (_targetTile.getEntity().getCurrentProperties().IsRooted || _targetTile.getEntity().getCurrentProperties().IsImmuneToKnockBackAndGrab)
		{
			return false;
		}

		local pulledTo = this.getPulledToTile(_originTile, _targetTile);

		if (pulledTo == null)
		{
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		local pullToTile;

		if (this.m.DestinationTile != null)
		{
			pullToTile = this.m.DestinationTile;
			this.m.DestinationTile = null;
		}
		else
		{
			pullToTile = this.getPulledToTile(_user.getTile(), _targetTile);
		}

		if (pullToTile == null)
		{
			return false;
		}

		if (target.getCurrentProperties().IsImmuneToKnockBackAndGrab)
		{
			return false;
		}

		if (!_user.isHiddenToPlayer() && pullToTile.IsVisibleForPlayer)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " drags in " + this.Const.UI.getColorizedEntityName(_targetTile.getEntity()));
		}

		if (!_user.isHiddenToPlayer() || !target.isHiddenToPlayer())
		{
			local variant = _user.m.Variant;
			local scaleBackup = target.getSprite("status_rooted").Scale;
			_user.fadeOut(50);
			local rooted_front = target.getSprite("status_rooted");
			rooted_front.Scale = 1.0;
			rooted_front.setBrush("snake_ensnare_front_0" + variant);
			rooted_front.Visible = true;
			rooted_front.Alpha = 0;
			rooted_front.fadeIn(50);
			local rooted_back = target.getSprite("status_rooted_back");
			rooted_back.Scale = 1.0;
			rooted_back.setBrush("snake_ensnare_back_0" + variant);
			rooted_back.Visible = true;
			rooted_back.Alpha = 0;
			rooted_back.fadeIn(50);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 900, this.onDone, {
				User = _user,
				Target = target,
				ScaleBackup = scaleBackup,
				Skill = this
			});
		}

		local skills = _targetTile.getEntity().getSkills();
		skills.removeByID("effects.shieldwall");
		skills.removeByID("effects.spearwall");
		skills.removeByID("effects.riposte");
		target.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);
		local damage = this.Math.max(0, this.Math.abs(pullToTile.Level - _targetTile.Level) - 1) * this.Const.Combat.FallingDamage;

		if (damage == 0)
		{
			this.Tactical.getNavigator().teleport(_targetTile.getEntity(), pullToTile, null, null, true);
		}
		else
		{
			local tag = {
				Attacker = _user,
				Skill = this,
				HitInfo = clone this.Const.Tactical.HitInfo
			};
			tag.HitInfo.DamageRegular = damage;
			tag.HitInfo.DamageFatigue = this.Const.Combat.FatigueReceivedPerHit;
			tag.HitInfo.DamageDirect = 1.0;
			tag.HitInfo.BodyPart = this.Const.BodyPart.Body;
			this.Tactical.getNavigator().teleport(_targetTile.getEntity(), pullToTile, this.onPulledDown, tag, true);
		}

		target.getSkills().add(this.new("scripts/skills/effects/staggered_effect"));

		if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " has staggered " + this.Const.UI.getColorizedEntityName(target) + " for one turn");
		}

		return true;
	}

	function onPulledDown( _entity, _tag )
	{
		_entity.onDamageReceived(_tag.Attacker, _tag.Skill, _tag.HitInfo);
	}

	function onDone( _data )
	{
		_data.User.fadeIn(50);
		local rooted_front = _data.Target.getSprite("status_rooted");
		rooted_front.fadeOutAndHide(50);
		rooted_front.Scale = _data.ScaleBackup;
		local rooted_back = _data.Target.getSprite("status_rooted_back");
		rooted_back.fadeOutAndHide(50);
		rooted_back.Scale = _data.ScaleBackup;
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 100, _data.Skill.onAfterDone, _data);
	}

	function onAfterDone( _data )
	{
		_data.Target.setDirty(true);
	}

});


this.explode_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.explode";
		this.m.Name = "Explode";
		this.m.Description = "";
		this.m.Icon = "skills/active_221.png";
		this.m.IconDisabled = "skills/active_221.png";
		this.m.Overlay = "active_221";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc6/skull_death_01.wav",
			"sounds/enemies/dlc6/skull_death_02.wav",
			"sounds/enemies/dlc6/skull_death_03.wav",
			"sounds/enemies/dlc6/skull_death_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.NonTargeted;
		this.m.Delay = 300;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.ActionPointCost = 2;
		this.m.FatigueCost = 0;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return;
		}

		local myTile = this.getContainer().getActor().getTile();

		for( local i = 0; i < 6; i = ++i )
		{
			if (!myTile.hasNextTile(i))
			{
			}
			else
			{
				local nextTile = myTile.getNextTile(i);

				if (this.Math.abs(myTile.Level - nextTile.Level) <= 1 && nextTile.IsOccupiedByActor)
				{
					local target = nextTile.getEntity();

					if (!target.isAlive() || target.isDying())
					{
					}
					else if (!this.getContainer().getActor().isAlliedWith(target))
					{
						return true;
					}
				}
			}
		}

		return false;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return true;
	}

	function onUse( _user, _targetTile )
	{
		if (!_user.isHiddenToPlayer())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " explose dans un éclat d\'os!");
		}

		this.Time.scheduleEvent(this.TimeUnit.Real, 300, function ( _user )
		{
			_user.kill();
		}, _user);
		return true;
	}

});


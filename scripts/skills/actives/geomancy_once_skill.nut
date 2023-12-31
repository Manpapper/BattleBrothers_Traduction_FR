this.geomancy_once_skill <- this.inherit("scripts/skills/skill", {
	m = {
		AffectedTiles = []
	},
	function create()
	{
		this.m.ID = "actives.geomancy_once";
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
		this.m.ActionPointCost = 6;
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
		return this.skill.isUsable() && this.Tactical.Entities.getFlags().getAsInt("GeomancyOnceUsed") == 0 && phylacteries <= 6;
	}

	function updateTiles()
	{
		if (this.m.AffectedTiles.len() != 0)
		{
			this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], 1.0, this.m.AffectedTiles[0].Pos);
			this.Time.scheduleEvent(this.TimeUnit.Real, 100, this.onLowerTiles.bindenv(this), this);
		}
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return true;
	}

	function onTurnStart()
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

		if (phylacteries <= 5)
		{
			this.updateTiles();
		}
	}

	function onUse( _user, _targetTile )
	{
		if (!_user.isHiddenToPlayer())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " a fait monter la terre!");
		}

		local candidates = [];
		local entities = this.Tactical.Entities.getInstancesOfFaction(_user.getFaction());

		foreach( e in entities )
		{
			if (e.getType() == this.Const.EntityType.SkeletonPhylactery)
			{
				candidates.push(e.getTile());
			}
		}

		this.m.AffectedTiles = candidates;

		foreach( t in this.m.AffectedTiles )
		{
			for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, t, this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity, this.Const.Tactical.DustParticles[i].LifeTimeQuantity, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages);
			}

			t.Level = 3;
		}

		if (this.Tactical.getCamera().Level < 3)
		{
			this.Tactical.getCamera().Level = 3;
		}

		this.Tactical.Entities.getFlags().increment("GeomancyOnceUsed");
		return true;
	}

	function onDeath( _fatalityType )
	{
		this.updateTiles();
	}

	function onLowerTiles( _tag )
	{
		this.Tactical.EventLog.log("The earth lowers again");

		foreach( t in _tag.m.AffectedTiles )
		{
			t.Level = 0;

			for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, t, this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity, this.Const.Tactical.DustParticles[i].LifeTimeQuantity, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages);
			}
		}

		if (this.Tactical.getCamera().Level == 3)
		{
			this.Tactical.getCamera().Level = 2;
		}

		_tag.m.AffectedTiles = [];
	}

});


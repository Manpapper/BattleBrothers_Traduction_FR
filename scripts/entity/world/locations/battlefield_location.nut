this.battlefield_location <- this.inherit("scripts/entity/world/location", {
	m = {
		SpawnTime = 0.0,
		Description = ""
	},
	function getDescription()
	{
		return "A battle took place here a short while ago. Broken and lost equipment, blood stains and torn ground tell of a determined fight.";
	}

	function setSize( _s )
	{
		this.getSprite("body").setBrush("world_battlefield_0" + _s);
	}

	function create()
	{
		this.location.create();
		this.m.Name = "Battle Site";
		this.m.TypeID = "location.battlefield";
		this.m.LocationType = this.Const.World.LocationType.Passive;
		this.m.IsDespawningDefenders = false;
		this.m.IsBattlesite = true;
		this.m.IsAttackable = false;
		this.m.Resources = 0;
		this.m.SpawnTime = this.Time.getVirtualTimeF();
	}

	function onSpawned()
	{
		this.m.Name = "Battle Site";
		this.location.onSpawned();
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.Scale = 0.75;
		body.setBrush("world_battlefield_0" + this.Math.rand(1, 2));
		body.setHorizontalFlipping(this.Math.rand(0, 1) == 1);
		this.registerThinker();
	}

	function onFinish()
	{
		this.location.onFinish();
		this.unregisterThinker();
	}

	function onUpdate()
	{
		if (this.isAlive() && !this.getSprite("selection").Visible && this.Time.getVirtualTimeF() - this.m.SpawnTime > this.World.getTime().SecondsPerDay * 2.0)
		{
			this.onCombatLost();
		}
	}

	function onSerialize( _out )
	{
		this.location.onSerialize(_out);
		_out.writeF32(this.m.SpawnTime);
		_out.writeString(this.m.Description);
	}

	function onDeserialize( _in )
	{
		this.location.onDeserialize(_in);
		this.m.SpawnTime = _in.readF32();
		this.m.Description = _in.readString();
	}

});


this.situation <- {
	m = {
		ID = "",
		InstanceID = 0,
		Name = "",
		Description = "",
		Icon = null,
		Rumors = [],
		IsStacking = true,
		ValidDays = 0,
		ValidUntil = 0.0
	},
	function getID()
	{
		return this.m.ID;
	}

	function getInstanceID()
	{
		return this.m.InstanceID;
	}

	function getName()
	{
		return this.m.Name;
	}

	function getDescription()
	{
		return this.m.Description;
	}

	function getIcon()
	{
		return this.m.Icon;
	}

	function getValidUntil()
	{
		return this.m.ValidUntil;
	}

	function getDefaultDays()
	{
		return this.m.ValidDays;
	}

	function getRumors()
	{
		return this.m.Rumors;
	}

	function isStacking()
	{
		return this.m.IsStacking;
	}

	function isValid()
	{
		return this.m.ValidUntil == 0 || this.Time.getVirtualTimeF() <= this.m.ValidUntil;
	}

	function setValidForDays( _d )
	{
		this.m.ValidUntil = this.Time.getVirtualTimeF() + _d * this.World.getTime().SecondsPerDay;
	}

	function setInstanceID( _id )
	{
		this.m.InstanceID = _id;
	}

	function getAddedString( _s )
	{
		return _s + " a maintenant " + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return _s + " n\'a plus " + this.m.Name;
	}

	function invalidate()
	{
		this.m.ValidUntil = 1;
	}

	function create()
	{
	}

	function getTooltip()
	{
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
			}
		];
	}

	function onUpdate( _modifiers )
	{
	}

	function onUpdateShop( _stash )
	{
	}

	function onUpdateDraftList( _draftList )
	{
	}

	function onAdded( _settlement )
	{
	}

	function onRemoved( _settlement )
	{
	}

	function onSerialize( _out )
	{
		_out.writeI32(this.m.InstanceID);
		_out.writeF32(this.m.ValidUntil);
	}

	function onDeserialize( _in )
	{
		this.m.InstanceID = _in.readI32();
		this.m.ValidUntil = _in.readF32();
	}

};


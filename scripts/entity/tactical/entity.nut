this.entity <- {
	m = {
		Flags = null,
		ContentID = this.Math.rand(),
		IsAlive = true,
		IsDirty = false,
		IsAttackable = false
	},
	function getName()
	{
		return "UNKNOWN";
	}

	function getNameOnly()
	{
		return this.getName();
	}

	function getDescription()
	{
		return "UNKNOWN";
	}

	function getFlags()
	{
		return this.m.Flags;
	}

	function setDirty( _value )
	{
		this.m.IsDirty = _value;
	}

	function setName( _value )
	{
	}

	function isAlive()
	{
		return this.m.IsAlive;
	}

	function isDirty()
	{
		return this.m.IsDirty;
	}

	function isAttackable()
	{
		return this.m.IsAttackable;
	}

	function setIsAlive( _f )
	{
		this.m.IsAlive = _f;
	}

	function getImagePath()
	{
		return "tacticalentity(" + this.m.ContentID + "," + this.getID() + ",socket)";
	}

	function getTooltip( _targetedWidthSkill = null )
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName(),
				icon = "ui/tooltips/height_" + this.getTile().Level + ".png"
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				icon = "ui/icons/cancel.png",
				text = "Bloque le mouvement"
			}
		];

		if (this.isBlockingSight())
		{
			ret.push({
				id = 4,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Bloque la vision"
			});
		}

		return ret;
	}

	function getOverlayImage()
	{
		return this.Const.Tactical.EntityUIOverlay.Default;
	}

	function create()
	{
		this.m.Flags = this.new("scripts/tools/tag_collection");
	}

	function onInit()
	{
		this.m.IsDirty = true;
	}

	function onAfterInit()
	{
	}

	function onFinish()
	{
		this.m.IsAlive = false;
	}

	function onSerialize( _out )
	{
		this.m.Flags.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.m.Flags.onDeserialize(_in, false);
	}

};


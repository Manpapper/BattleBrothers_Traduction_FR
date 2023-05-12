this.attached_location <- this.inherit("scripts/entity/world/location", {
	m = {
		ID = "",
		Sprite = "",
		SpriteDestroyed = "",
		Settlement = null,
		IsActive = true,
		IsMilitary = false,
		IsConnected = true,
		IsUsable = true
	},
	function getTypeID()
	{
		return this.m.ID;
	}

	function isEnterable()
	{
		return false;
	}

	function isActive()
	{
		return this.m.IsActive;
	}

	function isMilitary()
	{
		return this.m.IsMilitary;
	}

	function isConnected()
	{
		return this.m.IsConnected;
	}

	function isUsable()
	{
		return this.m.IsUsable;
	}

	function getSettlement()
	{
		return this.m.Settlement;
	}

	function setSettlement( _s )
	{
		if (_s == null || !_s.isLocation())
		{
			this.m.Settlement = null;
		}
		else
		{
			this.m.Settlement = this.WeakTableRef(_s);
			this.m.Settlement.onAttachedLocationsChanged();
		}
	}

	function getName()
	{
		return this.m.IsActive ? this.world_entity.getName() : "Ruines";
	}

	function getRealName()
	{
		return this.world_entity.getName();
	}

	function getDescription()
	{
		if (this.m.IsActive)
		{
			return this.world_entity.getDescription();
		}
		else
		{
			return "Ces ruines faisaient autrefois parties de la colonie voisine, il n'en reste aujourd'hui que des ruines brûlées et abandonnées.";
		}
	}

	function setActive( _a )
	{
		if (_a == this.m.IsActive)
		{
			return;
		}

		this.m.IsActive = _a;
		this.getSprite("body").setBrush(_a ? this.m.Sprite : this.m.SpriteDestroyed);
		this.getSprite("lighting").Visible = _a;

		if (this.m.Settlement != null && !this.m.Settlement.isNull() && this.m.Settlement.isAlive())
		{
			this.m.Settlement.onAttachedLocationsChanged();
		}
	}

	function updateLighting()
	{
		local lighting = this.getSprite("lighting");

		if (lighting.IsFadingDone)
		{
			if (lighting.Alpha == 0 && this.World.getTime().TimeOfDay >= 4 && this.World.getTime().TimeOfDay <= 7)
			{
				lighting.Color = this.createColor("ffffff00");

				if (this.World.getCamera().isInsideScreen(this.getPos(), 0))
				{
					lighting.fadeIn(5000);
				}
				else
				{
					lighting.Alpha = 255;
				}
			}
			else if (lighting.Alpha != 0 && this.World.getTime().TimeOfDay >= 0 && this.World.getTime().TimeOfDay <= 3)
			{
				if (this.World.getCamera().isInsideScreen(this.getPos(), 0))
				{
					lighting.fadeOut(4000);
				}
				else
				{
					lighting.Alpha = 0;
				}
			}
		}
	}

	function create()
	{
		this.location.create();
		this.m.IsAttackable = false;
		this.m.IsAttackableByAI = false;
		this.m.IsDestructible = false;
		this.m.IsShowingName = false;
		this.m.CombatLocation.Template[0] = "tactical.human_camp";
		this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.None;
		this.m.CombatLocation.CutDownTrees = true;
		this.m.CombatLocation.AdditionalRadius = 5;
		this.m.LocationType = this.Const.World.LocationType.AttachedLocation;
	}

	function onUpdate()
	{
	}

	function onBuild()
	{
		return true;
	}

	function onUpdateProduce( _list )
	{
	}

	function onUpdateDraftList( _list )
	{
	}

	function onUpdateShopList( _id, _list )
	{
	}

	function onRaided()
	{
	}

	function onInit()
	{
		this.location.onInit();
		this.setDiscovered(true);
		this.setShowName(false);
		local body = this.addSprite("body");
		body.setBrush(this.m.Sprite);
		local lighting = this.addSprite("lighting");
		this.setSpriteColorization("lighting", false);
		lighting.Alpha = 0;
		lighting.IgnoreAmbientColor = true;
	}

	function onFinish()
	{
		this.location.onFinish();
	}

	function onSerialize( _out )
	{
		this.location.onSerialize(_out);

		if (this.m.Settlement != null && !this.m.Settlement.isNull() && this.m.Settlement.isAlive())
		{
			_out.writeU32(this.m.Settlement.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		_out.writeBool(this.m.IsActive);
	}

	function onDeserialize( _in )
	{
		this.location.onDeserialize(_in);
		local settlementID = _in.readU32();

		if (settlementID != 0)
		{
			this.setSettlement(this.World.getEntityByID(settlementID));

			if (this.m.Settlement != null)
			{
				this.m.Settlement.getAttachedLocations().push(this);
				this.m.Settlement.updateProduce();
			}
		}

		this.setActive(_in.readBool());
		this.setAttackable(false);
		this.getSprite("lighting").Color = this.createColor("ffffff00");
	}

});


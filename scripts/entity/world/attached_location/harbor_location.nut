this.harbor_location <- this.inherit("scripts/entity/world/attached_location", {
	m = {},
	function create()
	{
		this.attached_location.create();
		this.m.Name = "Port";
		this.m.ID = "attached_location.harbor";
		this.m.Description = "Un port qui sert à la fois aux navires de commerce étrangers et aux pêcheurs locaux.";
		this.m.Sprite = "";
		this.m.SpriteDestroyed = "";
		this.m.IsUsable = true;
		this.m.IsConnected = false;
	}

	function getSounds( _all = true )
	{
		local r = [];

		if (this.World.getTime().IsDaytime)
		{
			r = [
				{
					File = "ambience/buildings/docks_bell_00.wav",
					Volume = 1.0,
					Pitch = 1.0
				},
				{
					File = "ambience/buildings/docks_bell_01.wav",
					Volume = 1.0,
					Pitch = 1.0
				},
				{
					File = "ambience/buildings/docks_bell_02.wav",
					Volume = 1.0,
					Pitch = 1.0
				},
				{
					File = "ambience/buildings/docks_working_00.wav",
					Volume = 1.0,
					Pitch = 1.0
				},
				{
					File = "ambience/buildings/docks_working_01.wav",
					Volume = 1.0,
					Pitch = 1.0
				},
				{
					File = "ambience/buildings/docks_working_02.wav",
					Volume = 1.0,
					Pitch = 1.0
				},
				{
					File = "ambience/buildings/docks_working_03.wav",
					Volume = 1.0,
					Pitch = 1.0
				},
				{
					File = "ambience/buildings/docks_working_04.wav",
					Volume = 1.0,
					Pitch = 1.0
				}
			];
			return r;
		}

		return r;
	}

	function onBuild()
	{
		local deepWaterTile = this.m.Settlement.getDeepOceanTile();

		if (deepWaterTile == null)
		{
			return false;
		}

		local myTile = this.getTile();
		local navSettings = this.World.getNavigator().createSettings();
		navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Ship;
		local path = this.World.getNavigator().findPath(myTile, deepWaterTile, navSettings, 0);

		if (path.isEmpty())
		{
			return false;
		}

		local myTile = this.getTile();
		local ships = 0;

		for( local i = 0; i != 6; i = ++i )
		{
			if (!myTile.hasNextTile(i))
			{
			}
			else
			{
				local nextTile = myTile.getNextTile(i);

				if (nextTile.Type != this.Const.World.TerrainType.Ocean)
				{
				}
				else
				{
					local isOpenSea = true;

					for( local j = 0; j != 6; j = ++j )
					{
						if (nextTile.hasNextTile(j) && nextTile.getNextTile(j).Type != this.Const.World.TerrainType.Ocean)
						{
							isOpenSea = false;
							break;
						}
					}

					if (isOpenSea || this.Math.rand(1, 100) <= 20)
					{
						nextTile.clearAllBut(this.Const.World.DetailType.Shore);
						nextTile.spawnDetail("world_ship_0" + this.Math.rand(1, 2), this.Const.World.ZLevel.Object, 0);
						ships = ++ships;
					}

					if (ships >= 2)
					{
						break;
					}
				}
			}
		}

		local harbors = [
			"world_harbor_n",
			"world_harbor_ne",
			"world_harbor_se",
			"world_harbor_s",
			"world_harbor_sw",
			"world_harbor_nw"
		];
		local tile = this.getTile();
		local landDir = -1;

		if ((tile.Subregion & this.Const.DirectionAsBit.N) != 0 && tile.hasNextTile(this.Const.Direction.S) && tile.getNextTile(this.Const.Direction.S).Type == this.Const.World.TerrainType.Ocean)
		{
			landDir = this.Const.Direction.N;
		}
		else if ((tile.Subregion & this.Const.DirectionAsBit.NE) != 0 && tile.hasNextTile(this.Const.Direction.SW) && tile.getNextTile(this.Const.Direction.SW).Type == this.Const.World.TerrainType.Ocean)
		{
			landDir = this.Const.Direction.NE;
		}
		else if ((tile.Subregion & this.Const.DirectionAsBit.SE) != 0 && tile.hasNextTile(this.Const.Direction.NW) && tile.getNextTile(this.Const.Direction.NW).Type == this.Const.World.TerrainType.Ocean)
		{
			landDir = this.Const.Direction.SE;
		}
		else if ((tile.Subregion & this.Const.DirectionAsBit.S) != 0 && tile.hasNextTile(this.Const.Direction.N) && tile.getNextTile(this.Const.Direction.N).Type == this.Const.World.TerrainType.Ocean)
		{
			landDir = this.Const.Direction.S;
		}
		else if ((tile.Subregion & this.Const.DirectionAsBit.SW) != 0 && tile.hasNextTile(this.Const.Direction.NE) && tile.getNextTile(this.Const.Direction.NE).Type == this.Const.World.TerrainType.Ocean)
		{
			landDir = this.Const.Direction.SW;
		}
		else if ((tile.Subregion & this.Const.DirectionAsBit.NW) != 0 && tile.hasNextTile(this.Const.Direction.SE) && tile.getNextTile(this.Const.Direction.SE).Type == this.Const.World.TerrainType.Ocean)
		{
			landDir = this.Const.Direction.NW;
		}

		if (landDir == -1)
		{
			for( local i = 0; i != 6; i = ++i )
			{
				if (!tile.hasNextTile(i))
				{
				}
				else if (tile.getNextTile(i).Type != this.Const.World.TerrainType.Shore)
				{
					if (tile.hasNextTile(i - 1 < 0 ? 5 : i - 1) && tile.getNextTile(i - 1 < 0 ? 5 : i - 1).Type != this.Const.World.TerrainType.Shore && tile.hasNextTile(i + 1 <= 5 ? i + 1 : 0) && tile.getNextTile(i + 1 <= 5 ? i + 1 : 0).Type != this.Const.World.TerrainType.Shore && tile.hasNextTile(i + 3 > 5 ? i + 3 - 6 : i + 3) && tile.getNextTile(i + 3 > 5 ? i + 3 - 6 : i + 3).Type == this.Const.World.TerrainType.Shore)
					{
						landDir = i;
						break;
					}
				}
			}

			if (landDir == -1)
			{
				for( local i = 0; i != 6; i = ++i )
				{
					if (!tile.hasNextTile(i))
					{
					}
					else if (tile.getNextTile(i).Type != this.Const.World.TerrainType.Shore)
					{
						if (tile.hasNextTile(i + 3 > 5 ? i + 3 - 6 : i + 3) && tile.getNextTile(i + 3 > 5 ? i + 3 - 6 : i + 3).Type == this.Const.World.TerrainType.Shore)
						{
							landDir = i;
							break;
						}
					}
				}
			}

			if (landDir == -1)
			{
				for( local i = 0; i != 6; i = ++i )
				{
					if (!tile.hasNextTile(i))
					{
					}
					else if (tile.getNextTile(i).Type != this.Const.World.TerrainType.Shore)
					{
						landDir = i;
						break;
					}
				}
			}
		}

		if (landDir != -1)
		{
			this.m.Sprite = harbors[landDir];
			this.m.SpriteDestroyed = harbors[landDir] + "_ruins";

			if (this.isActive())
			{
				this.getSprite("body").setBrush(this.m.Sprite);
			}
			else
			{
				this.getSprite("body").setBrush(this.m.SpriteDestroyed);
			}
		}

		return true;
	}

	function onUpdateDraftList( _list )
	{
		if (!this.isActive())
		{
			return;
		}
	}

	function onUpdateShopList( _id, _list )
	{
		if (_id == "building.marketplace")
		{
			_list.push({
				R = 20,
				P = 1.0,
				S = "tools/throwing_net"
			});
		}
	}

	function onSerialize( _out )
	{
		_out.writeString(this.m.Sprite);
		_out.writeString(this.m.SpriteDestroyed);
		this.attached_location.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.m.Sprite = _in.readString();
		this.m.SpriteDestroyed = _in.readString();
		this.attached_location.onDeserialize(_in);
	}

});


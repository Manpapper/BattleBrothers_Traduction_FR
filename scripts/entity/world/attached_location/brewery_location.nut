this.brewery_location <- this.inherit("scripts/entity/world/attached_location", {
	m = {},
	function create()
	{
		this.attached_location.create();
		this.m.Name = "Brasserie";
		this.m.ID = "attached_location.brewery";
		this.m.Description = "Cette brasserie produit de grandes quantités de bière pour les tavernes locales et les commerçants.";
		this.m.Sprite = "world_brewery_01";
		this.m.SpriteDestroyed = "world_brewery_01_ruins";
	}

	function onBuild()
	{
		local myTile = this.getTile();
		local num = 0;

		for( local i = 0; i != 6; i = ++i )
		{
			if (!myTile.hasNextTile(i))
			{
			}
			else
			{
				local nextTile = myTile.getNextTile(i);

				if (nextTile.IsOccupied || nextTile.HasRoad)
				{
				}
				else if (nextTile.Type != this.Const.World.TerrainType.Plains && nextTile.Type != this.Const.World.TerrainType.Tundra && nextTile.Type != this.Const.World.TerrainType.Steppe)
				{
				}
				else
				{
					if (this.Math.rand(1, 100) <= 50)
					{
						nextTile.clear();
						local d = nextTile.spawnDetail("world_brewery_detail_0" + this.Math.rand(1, 2), this.Const.World.ZLevel.Object, this.Const.World.DetailType.NotCompatibleWithRoad);
						d.Scale = 0.9;
						num = ++num;
					}

					if (num >= 2)
					{
						break;
					}
				}
			}
		}

		return true;
	}

	function onUpdateProduce( _list )
	{
		_list.push("supplies/beer_item");
	}

	function onUpdateDraftList( _list )
	{
		if (!this.isActive())
		{
			return;
		}

		_list.push("monk_background");
		_list.push("brawler_background");
		_list.push("gambler_background");
	}

	function onUpdateShopList( _id, _list )
	{
		if (_id == "building.marketplace")
		{
			_list.push({
				R = 0,
				P = 1.0,
				S = "supplies/beer_item"
			});
		}
		else if (_id == "building.specialized_trader")
		{
		}
	}

	function onInit()
	{
		this.attached_location.onInit();
		this.getSprite("body").Scale = 0.9;
	}

});


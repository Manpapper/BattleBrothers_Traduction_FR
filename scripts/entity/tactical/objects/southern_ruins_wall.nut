this.southern_ruins_wall <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Old Wall";
	}

	function getDescription()
	{
		return "An old and partly crumbled wall.";
	}

	function setDirBasedOnCenter( _centerTile, _dist )
	{
		local b = this.getSprite("body");
		local myTile = this.getTile();

		if (myTile.SquareCoords.X < _centerTile.SquareCoords.X)
		{
			if (myTile.SquareCoords.Y < _centerTile.SquareCoords.Y + _dist / 2 && myTile.SquareCoords.Y > _centerTile.SquareCoords.Y - _dist / 2 - 1)
			{
				b.setBrush("southern_ruins_wall_29_07");
			}
			else if (myTile.SquareCoords.Y > _centerTile.SquareCoords.Y)
			{
				b.setBrush("southern_ruins_wall_29_01");
			}
			else
			{
				b.setBrush("southern_ruins_wall_29_02");
			}
		}
		else if (myTile.SquareCoords.X > _centerTile.SquareCoords.X)
		{
			if (myTile.SquareCoords.Y < _centerTile.SquareCoords.Y + _dist / 2 && myTile.SquareCoords.Y > _centerTile.SquareCoords.Y - _dist / 2 - 1)
			{
				b.setBrush("southern_ruins_wall_29_06");
			}
			else if (myTile.SquareCoords.Y > _centerTile.SquareCoords.Y)
			{
				b.setBrush("southern_ruins_wall_29_02");
			}
			else
			{
				b.setBrush("southern_ruins_wall_29_01");
			}
		}
		else if (myTile.SquareCoords.Y < _centerTile.SquareCoords.Y)
		{
			b.setBrush("southern_ruins_wall_29_03");
		}
		else
		{
			b.setBrush("southern_ruins_wall_29_05");
		}
	}

	function onInit()
	{
		local body = this.addSprite("body");
		body.setBrush("southern_ruins_wall_29_0" + this.Math.rand(1, 7));
		body.IgnoreCameraFlip = true;
		this.setBlockSight(false);
	}

});


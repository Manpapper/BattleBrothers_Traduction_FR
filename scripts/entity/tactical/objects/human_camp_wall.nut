this.human_camp_wall <- this.inherit("scripts/entity/tactical/entity", {
	m = {},
	function getName()
	{
		return "Palissade";
	}

	function getDescription()
	{
		return "Une palissade en bois.";
	}

	function setDirBasedOnCenter( _centerTile, _dist )
	{
		local b = this.getSprite("body");
		local myTile = this.getTile();

		if (myTile.SquareCoords.X < _centerTile.SquareCoords.X)
		{
			if (myTile.SquareCoords.Y < _centerTile.SquareCoords.Y + _dist / 2 && myTile.SquareCoords.Y > _centerTile.SquareCoords.Y - _dist / 2 - 1)
			{
				b.setBrush("camp_18_07");
			}
			else if (myTile.SquareCoords.Y > _centerTile.SquareCoords.Y)
			{
				b.setBrush("camp_18_01");
			}
			else
			{
				b.setBrush("camp_18_02");
			}
		}
		else if (myTile.SquareCoords.X > _centerTile.SquareCoords.X)
		{
			if (myTile.SquareCoords.Y < _centerTile.SquareCoords.Y + _dist / 2 && myTile.SquareCoords.Y > _centerTile.SquareCoords.Y - _dist / 2 - 1)
			{
				b.setBrush("camp_18_06");
			}
			else if (myTile.SquareCoords.Y > _centerTile.SquareCoords.Y)
			{
				b.setBrush("camp_18_02");
			}
			else
			{
				b.setBrush("camp_18_01");
			}
		}
		else if (myTile.SquareCoords.Y < _centerTile.SquareCoords.Y)
		{
			b.setBrush("camp_18_03");
		}
		else
		{
			b.setBrush("camp_18_05");
		}
	}

	function onInit()
	{
		local body = this.addSprite("body");
		body.setBrush("camp_18_0" + this.Math.rand(1, 7));
		body.IgnoreCameraFlip = true;
		this.setBlockSight(false);
	}

});


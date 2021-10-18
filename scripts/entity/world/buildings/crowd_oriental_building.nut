this.crowd_oriental_building <- this.inherit("scripts/entity/world/settlements/buildings/crowd_building", {
	m = {},
	function getUIImage()
	{
		local roster = this.World.getRoster(this.m.Settlement.getID());

		if (roster.getSize() == 0 || !this.World.getTime().IsDaytime)
		{
			return null;
		}
		else
		{
			local img;

			if (roster.getSize() <= 3)
			{
				img = "ui/settlements/crowd_01_southern";
			}
			else if (roster.getSize() <= 6)
			{
				img = "ui/settlements/crowd_02_southern";
			}
			else
			{
				img = "ui/settlements/crowd_03_southern";
			}

			return img;
		}
	}

	function create()
	{
		this.crowd_building.create();
	}

});


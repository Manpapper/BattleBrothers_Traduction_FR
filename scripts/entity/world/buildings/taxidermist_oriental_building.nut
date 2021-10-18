this.taxidermist_oriental_building <- this.inherit("scripts/entity/world/settlements/buildings/taxidermist_building", {
	m = {},
	function create()
	{
		this.taxidermist_building.create();
		this.m.ID = "building.taxidermist_oriental";
		this.m.UIImage = "ui/settlements/desert_building_13";
		this.m.UIImageNight = "ui/settlements/desert_building_13_night";
	}

});


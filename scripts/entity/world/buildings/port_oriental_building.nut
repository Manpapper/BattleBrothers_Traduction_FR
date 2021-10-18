this.port_oriental_building <- this.inherit("scripts/entity/world/settlements/buildings/port_building", {
	m = {},
	function create()
	{
		this.port_building.create();
		this.m.UIImage = "ui/settlements/building_09";
		this.m.UIImageNight = "ui/settlements/building_09_night";
	}

});


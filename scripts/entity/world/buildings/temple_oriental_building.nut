this.temple_oriental_building <- this.inherit("scripts/entity/world/settlements/buildings/temple_building", {
	m = {},
	function create()
	{
		this.temple_building.create();
		this.m.UIImage = "ui/settlements/desert_building_03";
		this.m.UIImageNight = "ui/settlements/desert_building_03_night";
		this.m.Sounds = [];
		this.m.SoundsAtNight = [];
	}

	function onUpdateDraftList( _list )
	{
		_list.push("cripple_southern_background");
	}

});


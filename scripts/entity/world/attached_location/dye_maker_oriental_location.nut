this.dye_maker_oriental_location <- this.inherit("scripts/entity/world/attached_location/dye_maker_location", {
	m = {},
	function create()
	{
		this.dye_maker_location.create();
		this.m.Sprite = "world_southern_dye";
		this.m.SpriteDestroyed = "world_southern_dye_ruins";
	}

});


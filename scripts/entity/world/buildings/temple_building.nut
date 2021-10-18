this.temple_building <- this.inherit("scripts/entity/world/settlements/buildings/building", {
	m = {},
	function create()
	{
		this.building.create();
		this.m.ID = "building.temple";
		this.m.Name = "Temple";
		this.m.Description = "Have your wounded treated by priests";
		this.m.UIImage = "ui/settlements/building_03";
		this.m.UIImageNight = "ui/settlements/building_03_night";
		this.m.Tooltip = "world-town-screen.main-dialog-module.Temple";
		this.m.TooltipIcon = "ui/icons/buildings/temple.png";
		this.m.Sounds = [
			{
				File = "ambience/buildings/temple_prayer_00.wav",
				Volume = 0.75,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/temple_prayer_01.wav",
				Volume = 0.75,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/temple_prayer_02.wav",
				Volume = 0.75,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/temple_bell_00.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/temple_bell_01.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/temple_bell_02.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/temple_bell_03.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/temple_bell_04.wav",
				Volume = 1.0,
				Pitch = 1.0
			}
		];
		this.m.SoundsAtNight = [];
	}

	function onUpdateDraftList( _list )
	{
		_list.push("monk_background");
		_list.push("cripple_background");
	}

	function onClicked( _townScreen )
	{
		_townScreen.showTempleDialog();
		this.pushUIMenuStack();
	}

	function onSettlementEntered()
	{
	}

	function onSerialize( _out )
	{
		this.building.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.building.onDeserialize(_in);
	}

});


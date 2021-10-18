this.barber_building <- this.inherit("scripts/entity/world/settlements/buildings/building", {
	m = {},
	function create()
	{
		this.building.create();
		this.m.ID = "building.barber";
		this.m.Name = "Barber";
		this.m.Description = "Customize the appearance of your men at the barber";
		this.m.UIImage = "ui/settlements/building_12";
		this.m.UIImageNight = "ui/settlements/building_12_night";
		this.m.Tooltip = "world-town-screen.main-dialog-module.Barber";
		this.m.TooltipIcon = "ui/icons/buildings/barber.png";
		this.m.Sounds = [];
		this.m.SoundsAtNight = [];
	}

	function onClicked( _townScreen )
	{
		_townScreen.showBarberDialog();
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


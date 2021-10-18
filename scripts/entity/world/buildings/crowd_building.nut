this.crowd_building <- this.inherit("scripts/entity/world/settlements/buildings/building", {
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
				img = "ui/settlements/crowd_01";
			}
			else if (roster.getSize() <= 6)
			{
				img = "ui/settlements/crowd_02";
			}
			else
			{
				img = "ui/settlements/crowd_03";
			}

			return img;
		}
	}

	function create()
	{
		this.building.create();
		this.m.ID = "building.crowd";
		this.m.UIImage = "ui/settlements/crowd_01";
		this.m.Tooltip = "world-town-screen.main-dialog-module.Crowd";
		this.m.Name = "Hire";
	}

	function onClicked( _townScreen )
	{
		_townScreen.getHireDialogModule().setRosterID(this.m.Settlement.getID());
		_townScreen.showHireDialog();
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


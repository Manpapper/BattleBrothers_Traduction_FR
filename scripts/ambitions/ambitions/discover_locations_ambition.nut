this.discover_locations_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		LocationsDiscovered = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.discover_locations";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Great explorers become men of legend. Going into the wild lands is a dangerous\nbusiness, but the tales we\'ll tell afterward will surely increase our renown.";
		this.m.UIText = "Discover hidden locations by exploring the world";
		this.m.TooltipText = "Discover 8 hidden locations, like ruins or hostile camps, by going off on your own and exploring the world. Make sure to stock up on provisions before heading out!";
		this.m.SuccessText = "[img]gfx/ui/events/event_54.png[/img]Seizing destiny by the beard, you declared your intention to travel across the land and make your mark as an explorer. Reasoning that uncovering new locations, be they dens of evil or prosperous villages, would lead to new opportunities for wealth, the men enthusiastically followed.\n\nIn the succeeding days, the company has looked upon many a broad vista, surveying high towers and treacherous canyons. You have dodged enemy scouts, and made fireless camps beneath stars like a thousand candle flames in the void. Charting the course of untamed rivers and skirting the hostile edges of uncrossable mountain ranges, the %companyname% can honestly claim themselves more widely traveled than many other band of their kind.";
		this.m.SuccessButtonText = "We draw our own maps.";
	}

	function getUIText()
	{
		return this.m.UIText + " (" + this.m.LocationsDiscovered + "/8)";
	}

	function onUpdateScore()
	{
		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.find_and_destroy_location").isDone())
		{
			return;
		}

		local locations = this.World.EntityManager.getLocations();
		local numDiscovered = 0;

		foreach( v in locations )
		{
			if (v.isDiscovered())
			{
				numDiscovered = ++numDiscovered;
			}
		}

		if (numDiscovered + 12 >= locations.len())
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.m.LocationsDiscovered >= 8)
		{
			return true;
		}

		return false;
	}

	function onLocationDiscovered( _location )
	{
		if (_location.getTypeID() == "location.battlefield")
		{
			return;
		}

		if (this.World.Contracts.getActiveContract() == null || !this.World.Contracts.getActiveContract().isTileUsed(_location.getTile()))
		{
			this.m.LocationsDiscovered = this.Math.min(8, this.m.LocationsDiscovered + 1);
			this.World.Ambitions.updateUI();
		}
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeU8(this.m.LocationsDiscovered);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
		this.m.LocationsDiscovered = _in.readU8();
	}

});


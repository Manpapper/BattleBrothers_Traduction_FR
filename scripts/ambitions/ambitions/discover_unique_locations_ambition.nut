this.discover_unique_locations_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		LocationsDiscovered = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.discover_unique_locations";
		this.m.Duration = 7.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "The wilds are teeming with hidden treasures that others are not bold enough to claim.\nThis is our chance, so let us head out there and find three legendary places!";
		this.m.UIText = "Discover legendary locations by exploring the world";
		this.m.TooltipText = "Discover 3 legendary locations by going off on your own and exploring the world. Make sure to stock up on provisions before heading out!";
		this.m.SuccessText = "[img]gfx/ui/events/event_41.png[/img]A man with a mule approaches the party. As he nears, you notice that the draught animal is laden with panniers long and rolled tight like telescopes. Sleek feathervanes stick out of the saddlebags and there\'s a tub of ink bouncing alongside them. He introduces himself as a cartographer of these parts and knows your company by name. He bows.%SPEECH_ON%As a fellow man of the map, you have my thanks.%SPEECH_OFF%You ask what for. The stranger seems rather shocked that he has to explain his adorations, as if you\'ve no notion of your celebrity. Which you don\'t.%SPEECH_ON%Why, because you opened this land up! Before you not a soul would walk these parts and I\'d nothing to plot to the page besides warnings to not go there. You ever see the line about \'here there be dragons\'? That\'s my doing! And now I\'ve mind to erase it and I\'ve never been happier to do so. Thank you, explorer, and you may have one of these, an ornament so that others may know your deeds!%SPEECH_OFF%Explorer? Fellow man of the map? It appears this stranger has you all wrong, but you entertain his notions anyway. He hands you a fancy feather as thanks and then bids adieu. It appears the %companyname% is acquiring a name for itself beyond just killing and slaying. You\'re not sure if that is good or bad.";
		this.m.SuccessButtonText = "We draw our own maps.";
	}

	function getUIText()
	{
		return this.m.UIText + " (" + this.m.LocationsDiscovered + "/3)";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.discover_locations").isDone())
		{
			return;
		}

		if (!this.World.Flags.has("LegendaryLocationsDiscovered"))
		{
			this.World.Flags.set("LegendaryLocationsDiscovered", 0);
		}

		if (this.World.Flags.get("LegendaryLocationsDiscovered") >= 11 - 3)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.m.LocationsDiscovered >= 3)
		{
			return true;
		}

		return false;
	}

	function onLocationDiscovered( _location )
	{
		if (this.World.Contracts.getActiveContract() == null || !this.World.Contracts.getActiveContract().isTileUsed(_location.getTile()))
		{
			if (_location.isLocationType(this.Const.World.LocationType.Unique))
			{
				this.m.LocationsDiscovered = this.Math.min(3, this.m.LocationsDiscovered + 1);
				this.World.Ambitions.updateUI();
			}
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


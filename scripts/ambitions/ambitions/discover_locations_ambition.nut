this.discover_locations_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		LocationsDiscovered = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.discover_locations";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Les grands explorateurs deviennent des hommes de légende. S\'aventurer dans les terres sauvages est une activité périlleuse, mais les histoires que nous raconterons par la suite ne feront qu\'accroître notre renommée.";
		this.m.UIText = "Découvrez des lieux cachés en explorant le monde";
		this.m.TooltipText = "Découvrez 8 lieux cachés, comme des ruines ou des camps hostiles, en partant seul à la découverte du monde. Assurez-vous de faire le plein de provisions avant de partir !";
		this.m.SuccessText = "[img]gfx/ui/events/event_54.png[/img]Prenant en main votre destin, vous avez déclaré votre intention de voyager à travers le pays et de laisser votre marque en tant qu\'explorateur. Pensant que la découverte de nouveaux lieux, qu\'il s\'agisse d\'antres du mal ou de villages prospères, mènerait à de nouvelles opportunités de richesse, vos hommes vous ont suivi avec enthousiasme.\n\n Dans les jours qui ont suivi, la compagnie a contemplé de nombreux panoramas, arpenté de hautes tours et des canyons périlleux. Vous avez esquivé les éclaireurs ennemis et établi des camps sans feu sous les étoiles, comme des milliers de bougies dans le vide. En suivant le cours de rivières indomptées et en longeant les bords hostiles de chaînes de montagnes infranchissables, %companyname% peut honnêtement se targuer d\'avoir plus voyagé que beaucoup d\'autres groupes de son genre.";
		this.m.SuccessButtonText = "Nous dessinons nos propres cartes.";
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


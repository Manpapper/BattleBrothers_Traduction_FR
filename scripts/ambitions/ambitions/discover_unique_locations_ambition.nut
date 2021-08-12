this.discover_unique_locations_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		LocationsDiscovered = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.discover_unique_locations";
		this.m.Duration = 7.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Les régions sauvages regorgent de trésors cachés que d'autres n'ont pas l'audace de revendiquer. \nC'est notre chance, alors partons à la recherche de trois lieux légendaires !";
		this.m.UIText = "Découvrez des lieux légendaires en explorant le monde";
		this.m.TooltipText = "Découvrez 3 lieux légendaires en partant seul à la découverte du monde. Assurez-vous de faire le plein de provisions avant de partir !";
		this.m.SuccessText = "[img]gfx/ui/events/event_41.png[/img]Un homme avec une mule s'approche du groupe. Alors qu'il s'approche, vous remarquez que l'animal de trait est chargé de sacoches longues et enroulées comme des draps. Des plumes élégantes dépassent des sacoches et un pot d'encre rebondit à côté. Il se présente comme un cartographe de la région et connaît votre compagnie par son nom. Il s'incline.%SPEECH_ON%En tant que collègue cartographe, vous avez mes remerciements.%SPEECH_OFF%Vous demandez pourquoi. L'étranger semble plutôt choqué de devoir expliquer ses adorations, comme si vous n'aviez aucune idée de votre célébrité. Ce qui n'est pas le cas.%SPEECH_ON%Pourquoi, parce que vous avez ouvert ce pays ! Avant vous, pas une âme ne se promenait dans ces régions et je n'avais rien à ajouter à la carte à part des avertissements pour ne pas y aller. Vous avez déjà vu la phrase \"Ici, il y a des dragons\" ? C'est moi qui l'ai faite ! Et maintenant j'ai l'esprit pour l'effacer et je n'ai jamais été aussi heureux de le faire. Merci, explorateur, et vous pouvez avoir ceci, un objet décoratif pour que les autres puissent connaître vos exploits!%SPEECH_OFF%Explorateur ? Compagnon cartographe ? Il semble que cet étranger se trompe sur vous, mais vous l'écoutez quand même. Il vous tend une plume fantaisiste en guise de remerciement et vous dit adieu. Il semblerait que %companyname% soit en train de se faire un nom en dehors du fait fait de tuer et de chasser. Vous ne savez pas si c'est bien ou mal.";
		this.m.SuccessButtonText = "Nous dessinons nos propres cartes.";
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


this.discover_all_unique_locations_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.discover_all_unique_locations";
		this.m.Duration = 7.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Des lieux de légende parsèment le monde, cachant de merveilleux secrets. Ne nous reposons pas avant d\'avoir trouvé chacun d\'eux !";
		this.m.UIText = "Découvrez tous les lieux légendaires du monde";
		this.m.TooltipText = "Découvrez tous les trésors légendaires qui existent dans le monde en partant seul et en explorant les régions sauvages. Assurez-vous de faire le plein de provisions avant de partir !";
		this.m.SuccessText = "[img]gfx/ui/events/event_45.png[/img]Les bords de votre carte sont effilochés, et ses plis sont si usés qu\'ils pourraient aussi bien être sentis contre vos doigts. Le papier est plus lourd qu\'il n\'en a l\'air, il est venu vous protéger de la pluie et de la neige, il a été placé sous la paille de foin sur laquelle vous avez dormi, et il a été menacé d\'être utilisé comme bois d\'allumage dans les moments difficiles. Mais elle est aussi plus légère qu\'elle n\'en a l\'air, car le vent l\'a volée directement de vos doigts une ou plusieurs fois et vous l\'avez poursuivie à travers champs tout en hurlant comme un chacal perdant la chasse et en la traitant de fils de pute alors qu\'elle se tordait et s\'échappait.\n\n D\'après le travail du cartographe original, votre compagnie ne devait pas quitter les routes ou s\'éloigner des villes. Il avait écrit des avertissements tels que \"seulement le malheur et le malheur\" et \"voici les bandits et leurs bonnes mères\". Vous les avez ignorés et avez dessiné par-dessus vos propres lignes gribouillées de démarcations exploratoires. Ce n\'était pas des lieux de superstition, c\'était des lieux où %companyname% allait. Pour avoir gravé des lignes sur une carte boiteuse, vous êtes devenus célèbres en tant que quasi-explorateurs d\'endroits dont le monde a depuis longtemps fermé les portes. Et qu\'y a-t-il d\'autre là-bas, si ce n\'est un endroit bien au-delà de celui-ci ?";
		this.m.SuccessButtonText = "Nous dessinons nos propres cartes.";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.discover_unique_locations").isDone())
		{
			return;
		}

		if (!this.World.Flags.has("LegendaryLocationsDiscovered"))
		{
			this.World.Flags.set("LegendaryLocationsDiscovered", 0);
		}

		if (this.World.Flags.get("LegendaryLocationsDiscovered") >= 11)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		return this.World.Flags.get("LegendaryLocationsDiscovered") >= 11;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
	}

});


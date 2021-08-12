this.fulfill_x_southern_contracts_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		ContractsToFulfill = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.fulfill_x_southern_contracts";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Les villes-états du sud ont des couronnes à profusion. \nNous allons nous enrichir sous le soleil brûlant du désert !";
		this.m.UIText = "Exécuter les contrats pour les Cités-États";
		this.m.TooltipText = "Voyagez vers le sud, visitez les Cités-États du sud et trouvez-y un emploi. Acceptez et remplissez des contrats pour l'élite dirigeante.";
		this.m.SuccessText = "[img]gfx/ui/events/event_150.png[/img]Malgré toutes leurs recherches intellectuelles et leurs bonnes manières, les gens du Sud ne se méprennent pas sur votre rôle de mercenaire. Alors que dans le nord, on vous appellerait mercenaire, ici, on vous surnomme couronne. Vous ne vous souciez guère de l'une ou l'autre de ces attributions, reconnaissant seulement la dure réalité que, même s'ils vous méprisent, ils recherchent votre travail, récompensent vos compétences et se souviennent de vous lors des crises futures.\n\nEt c'est là que se trouve le point commun entre le Nord et le Sud : la puissante couronne elle-même. Les langues, les religions, les peuples, peu importer. Un peu d'or n'a besoin d'aucune traduction, d'aucun compromis, et d'aucun arbitrage. Votre quête de la couronne a montré que vous étiez digne de confiance aux yeux des Sudistes, et votre renommée est aussi grande que leurs poches.";
		this.m.SuccessButtonText = "L'or c'est de l'or.";
	}

	function getUIText()
	{
		local d = 5 - (this.m.ContractsToFulfill - this.World.Statistics.getFlags().getAsInt("CityStateContractsDone"));
		return this.m.UIText + " (" + this.Math.min(5, d) + "/5)";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 2)
		{
			return;
		}

		if (this.World.Statistics.getFlags().getAsInt("CityStateContractsDone") > 15)
		{
			return;
		}

		this.m.ContractsToFulfill = this.World.Statistics.getFlags().getAsInt("CityStateContractsDone") + 5;
		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Statistics.getFlags().getAsInt("CityStateContractsDone") >= this.m.ContractsToFulfill)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeU16(this.m.ContractsToFulfill);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
		this.m.ContractsToFulfill = _in.readU16();
	}

});


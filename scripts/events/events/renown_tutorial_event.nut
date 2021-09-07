this.renown_tutorial_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.renown_tutorial";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_82.png[/img]Pendant que la compagnie fait une courte pause, vous vous asseyez pour examiner la blessure où une flèche vous a transpercé le flanc il n\'y a pas longtemps. La guérison est lente et vous avez encore mal si vous bougez trop vite, mais les choses s\'améliorent. %bro1% vous rejoint, profitant de l\'occasion pour parler à son capitaine.%SPEECH_ON%De la façon dont je vois les choses, personne n\'est encore au courant de %companyname%. Nous ne voulons pas chasser éternellement des bandes de brigands à travers les bois, mais nous devons d\'abord nous faire un nom en tant que mercenaires fiables qui peuvent faire avancer les choses avant que les maisons nobles ne s\'en rendent compte. Ils voudront utiliser la compagnie pour des tâches bien plus lucratives, j\'en suis sûr.%SPEECH_OFF%Il ajuste sa ceinture d\'arme et continue.%SPEECH_ON%N\'oublions pas que les grands seigneurs jouent un jeu dangereux et nous ne voulons pas nous les mettre à dos. Il y a assez d\'histoires de gens qui les ont croisés pour finir écartelés et donnés en pâture aux cochons, et ils ont les moyens d\'écraser même une compagnie de mercenaires.%SPEECH_OFF%Il fait une courte pause puis ajoute une autre pensée.%SPEECH_ON%Les maîtres de guilde et les conseillers qui dirigent les villages et les villes ont aussi bonne mémoire. Nous dépendons d\'eux pour engager la compagnie pour l\'instant, mais avoir quelques amis influents peut aussi nous aider à obtenir de meilleures affaires avec les marchands.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je m\'en souviendrai.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local bro = this.World.getPlayerRoster().getAll()[0];
				this.Characters.push(bro.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Contracts.getContractsFinished() < 2)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.tutorial")
		{
			return;
		}

		this.m.Score = 5000;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"bro1",
			this.World.getPlayerRoster().getAll()[0].getName()
		]);
	}

	function onClear()
	{
	}

});


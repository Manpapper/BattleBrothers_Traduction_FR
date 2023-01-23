this.volunteers_event <- this.inherit("scripts/events/event", {
	m = {
		Dude1 = null,
		Dude2 = null,
		Dude3 = null
	},
	function create()
	{
		this.m.ID = "event.volunteers";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_80.png[/img]{Vous êtes assis dans votre tente et faites tourner une plume d\'oie entre vos doigts. Il y a quelque temps, vous avez vu un scribe le faire, mais vous n\'arrivez pas à comprendre comment il a pu le faire si vite sans faire tomber cette satanée chose. Une brise s\'échappe de vos doigts. %randombrother% secoue la tête.%SPEECH_ON%Est-ce que nous nous en remettrons un jour financièrement?%SPEECH_OFF%En soupirant, vous levez les yeux. Vous aviez espéré que les hommes garderaient leur sang-froid et ne s\'inquiéteraient pas des pertes, mais au vu de toute une série d\'événements récents, la compagnie semble presque sur le point de subir des dommages irréversibles. Le moral est bas, la trésorerie est faible, mais même si vous aviez l\'argent, il semble que beaucoup ne voudraient pas rejoindre la compagnie étant donné ses performances médiocres. À ce moment-là, un mercenaire entre dans votre camp avec trois hommes à sa botte. L\'homme en tête se présente, puis expose son cas.%SPEECH_ON%Nous connaissions la compagnie %companyname% pour sa réputation et nous venons de loin pour la voir par nous-mêmes. Maintenant, si je peux parler honnêtement, vous semblez tous complétement abattus et ne ressemblez pas du tout aux récits dont on parle, mais, merde, nous savons que ce monde est dur pour les gens, la seule chose à faire est d\'en tirer profit. Nous n\'avons pas fait tout ce chemin pour nous énerver à cause d\'une petite éraflure, vous savez?%SPEECH_OFF%Les hommes offrent leurs services gratuitement. Cela suffit pour que toute la compagnie soit de nouveau sur pied, encouragé par le fait que le monde a toujours eu une haute opinion d\'eux et de leurs services. Tout ce temps passé à assurer la renommée de la compagnie %companyname%\ a finalement porté ses fruits.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bienvenue à bord.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude1);
						this.World.getPlayerRoster().add(_event.m.Dude2);
						this.World.getPlayerRoster().add(_event.m.Dude3);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude1.onHired();
						_event.m.Dude2.onHired();
						_event.m.Dude3.onHired();
						return 0;
					}

				},
				{
					Text = "We\'re good, thanks.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude1 = roster.create("scripts/entity/tactical/player");
				_event.m.Dude1.setStartValuesEx([
					"bastard_background",
					"caravan_hand_background",
					"deserter_background",
					"houndmaster_background"
				]);
				_event.m.Dude1.getBackground().buildDescription(true);
				_event.m.Dude2 = roster.create("scripts/entity/tactical/player");
				_event.m.Dude2.setStartValuesEx([
					"killer_on_the_run_background",
					"gambler_background",
					"graverobber_background",
					"poacher_background",
					"thief_background"
				]);
				_event.m.Dude2.getBackground().buildDescription(true);
				_event.m.Dude3 = roster.create("scripts/entity/tactical/player");
				_event.m.Dude3.setStartValuesEx([
					"butcher_background",
					"gravedigger_background",
					"mason_background",
					"miller_background",
					"miner_background",
					"peddler_background",
					"ratcatcher_background",
					"shepherd_background",
					"tailor_background"
				]);
				_event.m.Dude3.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude1.getImagePath());
				this.Characters.push(_event.m.Dude2.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		local fallen = [];
		local fallen = this.World.Statistics.getFallen();

		if (fallen.len() < 5)
		{
			return;
		}

		if (fallen[0].Time > this.World.getTime().Days + 7 || fallen[1].Time > this.World.getTime().Days + 7 || fallen[2].Time > this.World.getTime().Days + 7 || fallen[3].Time > this.World.getTime().Days + 7 || fallen[4].Time > this.World.getTime().Days + 7)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() + 3 >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 1800 || this.World.Assets.getMoney() > 1500)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		this.m.Score = 20;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Dude1 = null;
		this.m.Dude2 = null;
		this.m.Dude3 = null;
	}

});


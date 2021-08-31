this.peddler_sells_rat_event <- this.inherit("scripts/events/event", {
	m = {
		Peddler = null,
		Ratcatcher = null
	},
	function create()
	{
		this.m.ID = "event.peddler_sells_rat";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 80.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%SPEECH_ON%Pour la dernière fois, non, je n\'achèterai pas de rat.%SPEECH_OFF%Vous voyez %ratcatcher% le chasseur de rats tourner un coin de rue avec le colporteur %peddler% derrière lui. Le vendeur lance un autre discours. %SPEECH_ON%Bien sûr, tu n\'en achèteras pas ! Tu es un chasseur de rats, pourquoi en achèterais-tu un ? Mais si... %SPEECH_OFF%Le chasseur de rats s\'arrête et tourne sur ses talons, plantant un doigt ferme dans la poitrine du colporteur. %SPEECH_ON%Les rats de compagnie ne poussent pas sur les arbres, %peddler% ! Ils sont d\'une autre race ! Si j\'ai besoin d\'un rat à mes côtés, je le trouverai moi-même ! Maintenant, si tu as un rat à tuer, c\'est une autre histoire. %SPEECH_OFF%Les yeux de %peddler% se baissent vers le sol, il réfléchit un moment. Soudain, son regard se lève avec son esprit et un doigt pointé.%SPEECH_ON%Ah, un poisson rouge alors ? Est-ce que vous achèteriez un poisson rouge ?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tout est en ordre ici.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Peddler.getImagePath());
				this.Characters.push(_event.m.Ratcatcher.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_peddler = [];
		local candidates_ratcatcher = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.peddler")
			{
				candidates_peddler.push(bro);
			}
			else if (bro.getBackground().getID() == "background.ratcatcher")
			{
				candidates_ratcatcher.push(bro);
			}
		}

		if (candidates_peddler.len() == 0 || candidates_ratcatcher.len() == 0)
		{
			return;
		}

		this.m.Peddler = candidates_peddler[this.Math.rand(0, candidates_peddler.len() - 1)];
		this.m.Ratcatcher = candidates_ratcatcher[this.Math.rand(0, candidates_ratcatcher.len() - 1)];
		this.m.Score = candidates_peddler.len() * candidates_ratcatcher.len() * 3 * 50000;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"peddler",
			this.m.Peddler.getName()
		]);
		_vars.push([
			"ratcatcher",
			this.m.Ratcatcher.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Peddler = null;
		this.m.Ratcatcher = null;
	}

});


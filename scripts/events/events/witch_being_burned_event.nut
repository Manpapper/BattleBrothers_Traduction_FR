this.witch_being_burned_event <- this.inherit("scripts/events/event", {
	m = {
		Witchhunter = null,
		Townname = null
	},
	function create()
	{
		this.m.ID = "event.witch_being_burned";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_79.png[/img]{Vous vous promenez dans %townname% juste à temps pour voir un corps fumant s\'écrouler sur le pieu noirci auquel il était attaché. Quelques citoyens passent devant vous, applaudissant la mort d\'une sorcière. Curieux de savoir si cela était vrai ou non, votre propre chasseur de sorcières, %witchhunter%, se dirige vers le corps et l\'examine. Avec un soupir, il se retourne vers vous et secoue la tête. | La ville de %townname% vous accueille avec des cris horribles. Trois de ses citoyens sont brûlés vifs dans le centre ville. Le feu grandit sous eux jusqu\'à ce que les flammes leur lèchent les pieds, puis remontent le long de leurs jambes, les poussant à crier grâce, ce à quoi la foule répond en jetant des pierres. Vous êtes sur le point de dégainer votre épée pour mettre fin à cette injustice lorsque %witchhunter_short%, le chasseur de sorcières, retient votre main. Il secoue la tête et montre du doigt les brûlures. Très vite, les supplications cessent et les trois victimes ouvrent la bouche, émettant un grondement qui fait taire la foule et même le crépitement du feu sous leurs pieds. Ils parlent d\'une voix gutturale et uniforme.%SPEECH_ON%Vous qui nous regardez périr, périrons eux-mêmes!%SPEECH_OFF%Les corps s\'affaissent soudainement vers l\'avant comme s\'ils étaient morts sur le coup et la cuisson de leur chair reprend avec un bruit sec et régulier. Le chasseur de sorcières ordonne à vos hommes de regarder ailleurs, ce que vous faites rapidement, et derrière vous retentissent de nouveaux cris, mais cette fois-ci de la part des habitants eux-mêmes. Vous n\'oublierez pas ce moment de sitôt.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Qu\'est-ce que c\'était... ?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();
		local foundTown = false;

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern() || t.getSize() > 2)
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				foundTown = true;
				this.m.Townname = t.getNameOnly();
				break;
			}
		}

		if (!foundTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local witchhunter_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.witchhunter")
			{
				witchhunter_candidates.push(bro);
			}
		}

		if (witchhunter_candidates.len() == 0)
		{
			return;
		}

		this.m.Witchhunter = witchhunter_candidates[this.Math.rand(0, witchhunter_candidates.len() - 1)];
		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"witchhunter",
			this.m.Witchhunter.getName()
		]);
		_vars.push([
			"witchhunter_short",
			this.m.Witchhunter.getNameOnly()
		]);
		_vars.push([
			"townname",
			this.m.Townname
		]);
	}

	function onClear()
	{
		this.m.Witchhunter = null;
		this.m.Townname = "";
	}

});


this.ancient_watchtower_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.ancient_watchtower";
		this.m.Title = "En approchant...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_108.png[/img]{Le clocher est deux fois plus haute que n'importe quel château que vous avez vu, et plus étroit que n'importe quelle tour. C'est comme si quelqu'un avait tous les matériaux pour construire une forteresse, et qu'au lieu de construire le bastion, il avait construit le clocher. %randombrother% plisse les yeux en regardant sa supériorité.%SPEECH_ON%C'est comme si elle s'étendait à l'infini, monsieur. Presque jusqu'aux nuages.%SPEECH_OFF%Vous entrez avec une carte et quelques hommes. A l'intérieur vous trouvez une sphère de verre posée sur un lutrin creux. A l'intérieur de la sphère se trouvent des restes poudreux. Peut-être la dernière émission d'une magie, vous ne savez pas. Votre intuition vous dit que celui qui a habité ce mince refuge n'a pas toujours pris les escaliers. Mais vous devez le faire. L'ascension est brutale et longue. Au sommet, vous trouvez encore une autre sphère, celle-ci est brisée, et sous le verre, un squelette. Un bâton endommagé gît à proximité. Vous secouez la tête et vous vous dirigez vers les créneaux. Les vues sont si étendues que le monde lui-même semble se courber à l'horizon, un étrange tour de passe-passe de l'œil sans doute. Vous dessinez la topographie sur votre carte, prenez une pause de cinq minutes, puis redescendez.\n\nQuand vous arrivez en bas, le squelette est là avec son équipe à ses côtés, la sphère est cassée et repose sur le lutrin. Le groupe s'enfuit par la porte et vous êtes sur leurs talons. En regardant en arrière, vous voyez la porte du clocher se fermer lentement avec un puissant cliquetis métallique.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Au moins, on a eu un aperçu du terrain.",
					function getResult( _event )
					{
						this.World.uncoverFogOfWar(this.World.State.getPlayer().getPos(), 1900.0);
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
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
	}

});


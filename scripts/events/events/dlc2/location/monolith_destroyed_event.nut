this.monolith_destroyed_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.monolith_destroyed";
		this.m.Title = "Après le combat";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_101.png[/img]{%SPEECH_START%C\'est décevant.%SPEECH_OFF%Dit %randombrother% en regardant les cadavres. Il renifle et crache.%SPEECH_ON%Je ne pense pas que \"décevant\" soit le mot juste, cependant. Ils sont juste là, os et vêtements, comme si on avait combattu un placard. Pas de chair, pas de sang. Ce n\'est pas satisfaisant, cela me perturbe.%SPEECH_OFF%Vous n\'avez rien à dire à ce sujet, si ce n\'est qu\'il y a un fond de vérité dans vos pensées. Si cela n\'était pas la conséquence de son désir, pourquoi cette propension à la violence? Un autre mercenaire vous interpelle, interrompant toute introspection solennelle.%SPEECH_ON%onsieur, venez voir.%SPEECH_OFF%Vous vous dirigez et repérez un crâne posé un lit de pauldrons, comme un œuf sur la poitrine d\'un sudiste bien portant. Pour autant qu\'on puisse en juger, le reste de son corps est meurtri et laissé à l\'abandon. Ce qui reste est une plaque cabossée pour armure de poitrine. Elle est couverte de glyphes et de formules, de prédictions et de récits historiques, et est ornée de pompons rouges et de peignes en poils hirsutes. Vous touchez le métal et à la seconde où vous le faites, le crâne à côté s\'envole et se pulvérise. Le mercenaire, voyant cela, hausse les épaules de manière plutôt maladroite.%SPEECH_ON%Si vous avez des pouvoirs magiques, je ne le dirai à personne.%SPEECH_OFF%Vous frappez le mercenaire et lui dites de charger l\'armure dans l\'inventaire pour une répartition ultérieure.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je devrais regarder de plus près cette armure.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_101.png[/img]{Alors que les hommes se préparent à partir, vous entendez une voix derrière vous.%SPEECH_ON%...jamais été...%SPEECH_OFF%Vous faites demi-tour et le monde s\'assombrit dans un tunnel obscur, vos hommes et leurs voix s\'évanouissent dans l\'obscurité jusqu\'à ce qu\'il ne reste plus qu\'un vieil homme et une lumière au bout du tunnel, un scintillement instable et un tremblement de chair qui tente de la retenir. Vous vous approchez lentement, en prenant appui sur votre interlocuteur. Il s\'agit d\'un homme âgé et avisé, courbé à la taille et dans le dos, ses bras sont plus fins que la poignée d\'une épée. Vous regardez en arrière pour voir que le monde des ténèbres vous a suivi, et qu\'il n\'y a que du noir derrière vous. LEn regardant à nouveau vers l\'avant, l\'homme est soudainement devant vous. Il a l\'air si familier, comme quelqu\'un que vous avez vu dans le passé et que vous avez oublié, peut-être quelqu\'un que vous avez vu dans votre enfance, un oncle mourant aperçu lors de votre quatrième hiver. Il tient le chandelier, la cire tombant sur ses phalanges et roulant sur son poignet.%SPEECH_ON%Vous n\'avez jamais été destiné à être... jamais été... jamais été... jamais été destiné à être, vous, celui qu\'ils appellent le Faux Roi.%SPEECH_OFF%Vous vous réveillez sur le sol. Des mercenaires vous regardent d\'un air inquiet.%SPEECH_ON%Uhh, vous allez bien capitaine?%SPEECH_OFF%En vous levant, vous leur dites que vous faisiez juste une sieste rapide. En regardant le Monolithe noir, vous vous voyez dans le reflet de l\'obélisque, seul votre image est visible.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je vais bien.",
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


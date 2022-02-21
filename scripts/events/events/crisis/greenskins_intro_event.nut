this.greenskins_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.greenskins_intro";
		this.m.Title = "Pendant un campement...";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_59.png[/img]%randombrother% entre dans votre tente.%SPEECH_ON%Monsieur, nous avons ici un groupe de réfugiés qui aimeraient vous parler.%SPEECH_OFF%Vous mettez de côté votre plume d\'oie et allez à leur rencontre. Ils sont un gâchis affreux, ressemblant plus à des torchons jetés dans la boue qu\'à des gens. L\'un d\'eux, un homme qui soigne un moignon là où se trouvait sa main, s\'avance et parle.%SPEECH_ON%Je suppose que vous êtes le responsable ?%SPEECH_OFF%Acquiesçant, vous demandez à l\'homme ce qui s\'est passé et pourquoi cela concerne la compagnie. Il explique en gesticulant avec sa seule bonne main.%SPEECH_ON%Les Peaux-Vertes attaquent.%SPEECH_OFF%Eh bien, ce n\'est pas nouveau. Vous demandez où ils sont et si ce sont des gobelins ou des orcs. L\'homme secoue la tête.%SPEECH_ON%Eh bien, voyez, c\'est exactement ce dont je parle. C\'est les deux. Ils... ils travaillent ensemble. Des hordes aussi nombreuses que les brins d\'herbe sous nos pieds. Je me suis mal exprimé, en quelque sorte. Ce que j\'aurais dû dire, c\'est qu\'ils ne font pas qu\'attaquer, ils ENVAHISSENT. Tous. Ensemble. Une invasion au-delà de toute proportion, vous ne comprenez pas ?%SPEECH_OFF%Vous regardez la foule de réfugiés. Des enfants blottis sous les jupes de leurs mères, des hommes l\'air perdus. L\'homme continue.%SPEECH_ON%Mon père les a combattu durant la Bataille des Nommés. Il a toujours dit qu\'ils reviendraient et maintenant je suppose qu\'il a raison. Nous entendons dire que les maisons nobles paniquent et pourraient unir leurs forces, de peur que nous ne soyons tous envahis ! Si vous voulez mon avis, je vous dis de ne pas vous en mêler. Ces hordes... rien ne les arrête. Et les choses qu\'ils font...%SPEECH_OFF%Vous attrapez l\'homme par sa chemise.%SPEECH_ON%Les choses qu\'ils font ne m\'inquiètent pas. Sors d\'ici, paysan, et laisse le combat aux combattants.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "La guerre est sur nous.",
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
		if (this.World.Statistics.hasNews("crisis_greenskins_start"))
		{
			this.m.Score = 6000;
		}
	}

	function onPrepare()
	{
		this.World.Statistics.popNews("crisis_greenskins_start");
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});


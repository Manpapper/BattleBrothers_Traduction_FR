this.undead_town_destroyed_event <- this.inherit("scripts/events/event", {
	m = {
		News = null
	},
	function create()
	{
		this.m.ID = "event.crisis.undead_town_destroyed";
		this.m.Title = "Le long de la route...";
		this.m.Cooldown = 7.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_99.png[/img]{Vous rencontrez un âne debout à côté d\'une charrette pleine de cadavres brûlés. Un homme se tient à côté d\'elle et semble, naturellement, en moins bon état. Il vous regarde et secoue la tête.%SPEECH_ON%J\'espère que vous ne vous dirigez pas vers %city%.%SPEECH_OFF%Pas du genre à dire aux étrangers où vous vous dirigez, vous lui demandez simplement pourquoi. Il secoue la tête une deuxième fois.%SPEECH_ON%Les morts-vivants ont compris. La maladie s\'est propagée dans la ville et ceux qui mouraient ont continué à se relever. Il ne fallut pas longtemps avant que tout l\'endroit ne tombe aux mains de ces âmes immortelles. On dit que la ville est maintenant gouvernée par des nécromanciens, mais qui sait vraiment. Je suis sûr que je ne vais pas m\'approcher pour le savoir.%SPEECH_OFF% | Il y a barbe grise, pâle, accroupi au milieu du chemin. Il vous entend venir, mais ne se tourne pas pour regarder. Au lieu de cela, il parle simplement.%SPEECH_ON%Je vous ai vu dans une vision. Vous tous. Mercenaires sur la voie pour redresser les maux de ce monde, bien que vous ne connaissiez peut-être pas mieux ce but qu\'un enfant royal ne comprend sa place royale. Mais vous arrivez trop tard.%SPEECH_OFF%Sa tête tourne brusquement. Des yeux blancs regardent sous des sourcils broussailleux. Il lui manque un nez et ses lèvres ricanent avec des plis jaunes maladifs.%SPEECH_ON%%city% est perdu ! Les morts errent dans les rues, tenus en laisse par ceux que vous appelez des nécromanciens.%SPEECH_OFF%Attention, vous avancez et demandez comment il sait tout cela. L\'homme pâle tient une boule ronde qui ondule comme si un dieu prenait la forme d\'un étang dans sa paume. Les images se tordent dans leurs reflets, vont et viennent, événements sans début ni fin. Il rit.%SPEECH_ON%Qui mieux que l\'homme qui a orchestré sa disparition pour connaître le destin de la ville ?%SPEECH_OFF%Soudain, la chair de l\'étranger se brise, ne révélant rien d\'autre que de l\'air en dessous, et les éclats noircis de sa nouvelle forme se répandirent en un nuage de chauves-souris. Vous dégainez votre épée, mais les créatures s\'éloignent en hurlant et gazouillant alors qu\'elles s\'élancent vers l\'horizon. | Deux hommes sont retrouvés sur le côté du chemin. L\'un se tient devant un chevalet, dans une main un pinceau, dans l\'autre une palette de couleurs mélangées. L\'autre homme pose, les mains sur la tête, tenant une expression d\'horreur absolue. Le peintre vous regarde.%SPEECH_ON%Ah, mercenaires. Je suppose que vous vous dirigez vers la ville, oui ?%SPEECH_OFF%Vous demandez pourquoi il dirait cela. Il repose nerveusement la brosse. Vous voyez que sa peinture représente une ville sombre avec des miasmes bleus sortant de derrière ses murs, une lune pâle planant de manière oppressante au-dessus. Une figure à moitié peinte se dresse au premier plan, reflétant l\'apparence du modèle du peintre. Sans bouger d\'un pouce, le poseur répond à votre question.%SPEECH_ON%%city%\ a été détruite. Eh bien, pas détruite, mais envahi par ces cadavres ambulants. La rumeur veut que des hommes pâles en détiennent le pouvoir.%SPEECH_OFF%Vous demandez s\'ils le savent avec certitude. Le peintre agite le bras pour présenter son œuvre.%SPEECH_ON%Si je ne l\'avais pas vue de mes propres yeux, ne serait-ce pas l\'œuvre d\'un fou ? Maintenant, s\'il vous plaît, je dois me remettre au travail avant que ce souvenir macabre ne s\'efface.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Sommes-nous en train de perdre cette guerre ?",
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
		if (!this.World.State.getPlayer().getTile().HasRoad)
		{
			return;
		}

		if (this.World.Statistics.hasNews("crisis_undead_town_destroyed"))
		{
			this.m.Score = 2000;
		}
	}

	function onPrepare()
	{
		this.m.News = this.World.Statistics.popNews("crisis_undead_town_destroyed");
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"city",
			this.m.News.get("City")
		]);
	}

	function onClear()
	{
		this.m.News = null;
	}

});


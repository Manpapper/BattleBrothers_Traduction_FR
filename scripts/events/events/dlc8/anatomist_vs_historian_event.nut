this.anatomist_vs_historian_event <- this.inherit("scripts/events/event", {
	m = {
		Historian = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_vs_historian";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_40.png[/img]{%historien%, l\'historien, et les anatomistes ont une sorte de dispute scribale. Vous vous approchez pour voir que %historien% brandit un livre rempli de descriptions et d\'images corporelles. Il affirme qu\'il s\'agit de la représentation la plus précise du corps humain connue de l\'homme, mais les anatomistes se moquent, disant qu\'un tel livre n\'existe pas car ils doivent encore en écrire un. Intéressé, vous jetez un coup d\'œil au livre. Les dessins montrent l\'homme ayant une multitude de longs vers lui traversants le corps, qui vont vers son cœur et en ressortent, chacun étant dédié à une trajectoire bien établie. D\'autres pages montrent les parties du corps étalées, les poumons, les reins, le foie, etc. Cela semble plutôt détaillé, mais vous n\'êtes pas exactement celui qui pourrait en dire plus.%SPEECH_ON%Ne vous fiez pas aux mensonges de ce livre, capitaine. Laissez-nous, anatomistes, faire notre travail, pour que ces horribles tomes soient mis à la poubelle, là où ils doivent être.%SPEECH_OFF%Furieux, l\'historien vous arrache le livre des mains et leur montre une page. On y voit le cerveau humain, avec de nombreuses cordes ou cordons qui partent de celui-ci et descendent le long de la colonne vertébrale. Il affirme que cet organe est au cœur de l\'expérience humaine, que tout ce que nous sommes et tout ce que nous pensons être se trouve dans cet organe. Encore une fois, les anatomistes se moquent. L\'historien se tourne vers vous, comme si votre point de vue de profane pouvait arbitrer les opinions des intellectuels, et en effet, toutes les parties présentes semblent attendre votre parole.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je pense que l\'historien a raison.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Les anatomistes en savent probablement plus à ce sujet.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_64.png[/img]{Vous soupirez et dites, sans littéralement aucune connaissance du sujet, que l\'historien à raison. Après tout, si quelqu\'un l\'a écrit à l\'encre, cela signifie sûrement quelque chose d\'important, et c\'est sans doute vrai. Cette affirmation réunit les deux parties contre vous. Même l\'historien proteste, malgré le fait que vous ayez pris sa défense.%SPEECH_ON%Ce n\'est pas parce que c\'est écrit à l\'encre que c\'est forcément correct.%SPEECH_OFF%Soupirant à nouveau, vous demandez qui gaspillerait de l\'encre pour une idée fausse? L\'historien et les anatomistes se moquent de vous, car vous vous obstinez dans une voie absurde. Ils partent ensemble en secouant la tête et en marmonnant quelque chose à propos des laïcs. Pendant un bref instant, vous vous imaginez en train de les transpercer avec une épée, l\'image est très satisfaisante mais vous n\'allez pas plus loin.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Se faire malmener par des intellos.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_64.png[/img]{Vous dites à l\'historien que les anatomistes ont beaucoup voyagé et qu\'ils ont sûrement vu d\'autres livres plus importants et plus grandioses que celui qu\'il possède. Les anatomistes se tournent vers vous. Ils parlent sans détour.%SPEECH_ON%Non, pas du tout.%SPEECH_OFF%Ne sachant pas trop ce qu\'ils veulent dire, vous essayez d\'insister sur le fait que vous les défendez sur cette question, en répétant qu\'ils ont sûrement lu beaucoup de choses sur le sujet. Encore une fois, ils se moquent de vous.%SPEECH_ON%Lire beaucoup? LIRE? Ne voyez-vous pas que nous sommes venus ici non pas pour lire, mais pour agir. Nous sommes des hommes d\'action et c\'est par l\'action que nous trouverons la vérité sur toutes les questions de ce monde, en particulier celles qui concernent ses hommes et ses bêtes. L\'idée que nous avons lu pour arriver là où nous en sommes est quelque chose qui nous offense.%SPEECH_OFF%En soupirant, vous essayez de rectifier le problème, mais voilà que %historien% l\'historien s\'en mêle.%SPEECH_ON%Capitaine, vous me voyez aussi sous cet angle? Que j\'ai simplement lu pour arriver là où j\'en suis? Moi aussi, je peux me battre, vous savez? C\'est pourquoi je suis ici. J\'espère que vous ne me voyez pas comme quelqu\'un de peu utile qui lit un livre ici et là et ne fait pas grand-chose d\'autre.%SPEECH_OFF%Vous décidez de partir car vous en avez assez de ces gens. En vous éloignant, des murmures se font entendre concernant à quel point il est insultant que vous les considériez comme de simples intellos et non comme des guerriers que n\'importe quelle compagnie de mercenaire engagerait. L\'idée de les défier en combat martial vous vient à l\'esprit, mais vous laissez tomber. De même que l\'idée de les massacrer dans leur sommeil. Vous y pensez pendant une minute, mais vous laissez aussi tomber.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Se faire malmener par des intellos.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomistCandidates = [];
		local historianCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomistCandidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.historian")
			{
				historianCandidates.push(bro);
			}
		}

		if (historianCandidates.len() == 0 || anatomistCandidates.len() <= 1)
		{
			return;
		}

		this.m.Historian = historianCandidates[this.Math.rand(0, historianCandidates.len() - 1)];
		this.m.Score = 5 * historianCandidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"historian",
			this.m.Historian.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Historian = null;
	}

});


this.scientist_in_the_mountains_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.scientist_in_the_mountains";
		this.m.Title = "In the mountains...";
		this.m.Cooldown = 150.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_42.png[/img]Vous tombez sur un spectacle inattendu au sommet de la montagne : un homme assis dans un étrange engin en bois, qu\'il incline vers le bord d\'un précipice mortel. Il a un foulard sur les yeux et le baisse pour parler. %SPEECH_ON%Bonjour, étrangers. Il semble que vous allez voir un moment historique ! Comme les hommes ont gouverné le cheval pour courir plus vite qu\'il ne savait le faire, je gouvernerai les oiseaux pour... enfin, nous ne pouvons pas monter les oiseaux, mais je peux, comme vous pouvez le voir avec cette machine, les simuler. Les chaînes de l\'espace et du temps seront levées, tout comme ces ailes en bois me feront monter dans les cieux !%SPEECH_OFF%Cet \"engin\" est livré avec des pédales, des rayons en bois et des bâches en cuir très fines et cousues à la hâte.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tu dois arrêter ça, tu vas seulement te tuer.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Ce sera intéressant à voir.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "C" : "D";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_42.png[/img]Vous vous avancez et expliquez la réalité de la situation.%SPEECH_ON%Bon... monsieur. Quel oiseau s\'envole à une telle hauteur ? Un oiseau ne se propulse-t-il pas simplement vers le haut avec la poussée de ses ailes ? Vous allez vous jeter de cette falaise dans l\'espoir que votre machine fonctionnera, sachant au fond de vous qu\'elle ne fonctionnera pas.%SPEECH_OFF%Le scientifique de la montagne à l\'air hagard regarde ses pieds. Il hoche la tête solennellement. %SPEECH_ON% Il faudrait la bricoler un peu, je suppose. Vous avez un œil aviaire, mon bon monsieur. Et vous avez aussi mes remerciements. Je parlerai de votre grande sagesse à tout le monde!%SPEECH_OFF%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est vrai, je suis intelligent.",
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
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_42.png[/img]{Vous reculez et laissez l\'homme s\'envoler. Il enroule son visage dans l\'écharpe et s\'assoit sur le siège de sa machine. Avec quelques longues respirations, il pédale en avant. Il tombe rapidement par-dessus le bord. L\'homme est projeté à travers les ailes de cuir comme une sorte de chauve-souris hurlante. Il tourne à travers l\'appareil qui explose le long de la paroi rocheuse dans un torrent de bois et de mauvaise conception. Un moment plus tard, vous entendez le faible vacarme de ses derniers points d\'atterrissage. Spectaculaire ! | L\'homme pousse sa machine du bord, sautant dans son siège au dernier moment. Ils basculent tous les deux dans le précipice et il y a un bref cri. Mais, contre toute attente, l\'homme réapparaît rapidement ! Son engin vacille d\'un côté à l\'autre comme un papillon ivre, mais il est quand même dans les airs.%SPEECH_ON%J\'ai réussi, par les dieux j\'ai réussi ! Regardez-moi... %SPEECH_OFF%Soudainement, un faucon hurlant transperce une de ses ailes. L\'oiseau se retourne pour frapper à nouveau, déchirant l\'autre aile. Vous agitez vos mains et essayez de faire fuir l\'oiseau tueur.%SPEECH_ON%Hey, hey!%SPEECH_OFF%La machine titube et commence à perdre lentement de l\'altitude. L\'homme pédale plus fort pour compenser, les rayons commencent à se briser et un moment plus tard, l\'ensemble se brise et on ne peut que regarder le scientifique hagard dégringoler vers sa perte. Le faucon s\'accroupit simplement sur la falaise et regarde son ennemi mourir.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Quel spectacle !",
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
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_42.png[/img]{Contre votre meilleur jugement, vous avez laissé l\'homme voler. Il s\'emmitoufle le visage dans l\'écharpe comme si cela allait le sauver de l\'atterrissage brutal qui s\'annonce. Avec une profonde inspiration, il pousse son engin du bord et saute au dernier moment comme s\'il rejoignait son amant dans un suicide romantique. L\'homme et la machine disparaissent rapidement. Vous commencez à rire quand soudain l\'homme réapparaît. Il pédale furieusement sur sa machine, les ailes battent fort. Il vole autour de lui, faisant des loopings dans tous les sens, prenant lentement de plus en plus de hauteur.%SPEECH_ON%Par les dieux, je l\'ai fait ! Regardez à quelle hauteur je peux aller!%SPEECH_OFF%Il s\'élève dans les nuages, le vacarme de ses rayons de bois s\'éloignant en gémissant.%SPEECH_ON%Ohh, ohhhh!%SPEECH_OFF%C\'est la dernière fois que vous le voyez ou l\'entendez. | L\'homme pousse l\'engin du bord et saute dans le siège juste au moment où il bascule. En hurlant, l\'homme grimpe sur l\'engin qui s\'écroule. Il saute sur la dernière extrémité de son cadre en bois mal construit, se propulsant à nouveau vers le précipice où il s\'accroche pour sauver sa vie. Vous vous précipitez et le remontez. Sa machine s\'écrase sur le sol, loin en dessous, dans un doux vacarme de destruction prédéterminée. En se secouant, l\'homme vous fait un signe de tête.%SPEECH_ON%Merci monsieur. J\'ai eu un moment de lucidité. Que fait un oiseau ? Il ne s\'envole pas de très haut, il s\'envole où il veut ! Je vais retravailler le projet ! Merci de m\'avoir sauvé la vie, monsieur.%SPEECH_OFF%De la façon dont vous le voyez, ça s\'est passé aussi bien que possible. Les hommes sont de toute façon très amusés.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Une science spectaculaire.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 25)
					{
						bro.improveMood(1.0, "Felt entertained");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Mountains)
		{
			return;
		}

		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});


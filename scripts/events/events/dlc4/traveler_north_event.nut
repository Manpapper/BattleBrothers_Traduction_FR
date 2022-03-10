this.traveler_north_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.traveler_north";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Vous rencontrez un homme à côté d\'un trou dans la glace. Il a une canne à pêche à côté de lui et, malgré l\'environnement, vous accueille chaleureusement.%SPEECH_ON%Vous voulez discuter, voyageur ? Vous n\'avez pas l\'air d\'être d\'ici.%SPEECH_OFF% | Un homme portant une fourrure d\'ours découpe un trou dans la glace. Il vous regarde juste au moment où le morceau de glace qu\'il a coupé tombe et qu\'il s\'enfonce dans l\'eau avec un coup de poing.%SPEECH_ON%Viens, voyageur, repose-toi près de moi un moment. Je suis inoffensif.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Rejoignez-nous au feu de camp pour ce soir.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Non, gardez vos distances.",
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
			ID = "B",
			Text = "[img]gfx/ui/events/event_26.png[/img]{Vous demandez à l\'homme si le Nord a connu des guerres dévastatrices. Il hausse les épaules.%SPEECH_ON%Oui, nous avons nos différences. Cette querelle la ou cette querelle ci. Mais il y a un siècle, un collectif de guerriers s\'est formé pour vaincre une horde de morts-vivants. Ohh oui, je vois dans vos yeux que vous ne le saviez pas. Il est probable que s\'ils avaient été vaincus, les cadavres ambulants auraient envahi le sud et vous auraient tous tués. Il n\'y a pas de quoi. Je parie qu\'ils n\'enseignent pas ça dans vos jolis textes d\'histoire du sud.%SPEECH_OFF% | L\'homme grogne et fait un signe de tête vers la canne à pêche.%SPEECH_ON%On dit qu\'il y a de gros poissons là-dessous. Inoffensifs, mais assez gros pour stimuler l\'imagination. Je ne peux pas dire que j\'en ai vu en chair et en os, mais il fut un temps où une grande ombre passait sous mes pieds, elle passait juste là, à travers les eaux, et elle passait et passait, comme si elle était éternelle. Et puis elle a disparu.%SPEECH_OFF%Vous lui demandez pourquoi il pense que c\'est une bête inoffensive. Il hausse les épaules.%SPEECH_ON%Parce que ça n\'a rien fait d\'autre que d\'aller de là à là et encore plus loin.%SPEECH_OFF% | L\'homme teste une canne à pêche puis s\'accroupit sur ses hanches. Il fait un signe de tête en direction de la glace.%SPEECH_ON%De vieux ours blancs traverseront ces étendues. Il faut faire attention à eux. Un peu de feu les repoussera, ou vous pouvez jeter du poisson et vous enfuir. J\'ai connu un homme qui a été mangé par un ours blanc. Ils disaient qu\'il l\'avait mangé à partir des jambes, sans se soucier de ses cris et de ses hurlements. Je préférerais me trancher la gorge plutôt que de laisser une de ces bêtes m\'attraper.%SPEECH_OFF% | Assez sympathique, l\'homme se repose près de ses cannes à pêche et parle à la nature de son propre peuple.%SPEECH_ON%J\'ai été assez près du sud pour savoir que vous nous prenez pour des sauvages. C\'est très bien, mais il y a plus que ça, ou moins je suppose. On a moins de choses. Beaucoup moins. Et on s\'en accommode quand même.%SPEECH_OFF%Vous faites remarquer que les gens du Nord ne fréquentent le Sud que pour violer et piller ce qu\'il possède. L\'homme hausse les épaules.%SPEECH_ON%Et vous envoyez des guerriers au nord pour nous offrir un sens de la justice du sud. Ça semble assez juste. Personne ne fait rien sans qu\'il y ait un peu de représailles bien visibles. Nous sommes tous au même niveau.%SPEECH_OFF% | Alors que vous vous installez à côté de l\'homme, il attrape un poisson et le jette sur la glace. Il le saisit d\'une main gantée de fourrure et lui fracasse la tête pour l\'empêcher de sautiller. Il parle en le vidant et en le salant.%SPEECH_ON%Certains habitants du nord ont trouvé un moyen de dompter ces géants, les unholds je crois que vous les appelez.  Ne me demandez pas comment. Chaque fois que j\'ai entendu parler d\'un géant qui allait quelque part, tout ce qu\'il faisait c\'était tuer tous ceux qui se trouvaient sur son chemin et manger tout le bétail.%SPEECH_OFF% | L\'homme grogne, teste ses cannes à pêche et soupire lorsqu\'il n\'y a pas de prise.%SPEECH_ON%Je suis allé dans le sud il y a quelques années. J\'y suis resté quelques années, c\'est aussi bien. C\'est pour ça que je connais si bien votre langue. Quand j\'étais là-bas, j\'ai goûté ce que vous appelez des légumes. Des choses dégoûtantes, vraiment, et le Sud se demande comment nous devenons si grands et si forts dans ces régions désolées ? Je vais vous dire, on ne peut pas faire pousser de putains de légumes. La seule chose qu\'on mange doit mourir et rien de ce qui a un cœur ne veut mourir facilement.%SPEECH_OFF% | Le sympathique pêcheur du Nord vous raconte des histoires sur les allées et venues des tribus.%SPEECH_ON%Je dirai ceci, nous sommes seulement dirigés par les forts, mais un homme fort est seulement aussi bon que sa santé et sa constitution. Quand il devient vieux, il perd les deux. Quand il devient vieux, il perd donc. C\'est ainsi que le nouvel homme fort arrive au pouvoir, et avec lui, l\'histoire et les succès de la tribu s\'effondrent. J\'envie en partie le sens du devoir des sudistes, et leurs capacité à cacher leurs pouvoirs, et de toujours le garder à porter de main pour que les autres ait besoin de plus que de les titiller pour le faire resortir. Je vous dis cela en vérité, et seulement ici, aussi loin que possible de mes congénères. Vous ne m\'entendrez jamais dire ça autour d\'un feu de camp ordinaire, compris ?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous avons besoin d\'un autre verre.",
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
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.SquareCoords.Y < this.World.getMapSize().Y * 0.8)
		{
			return;
		}

		this.m.Score = 15;
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


this.webknecht_exposition_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.webknecht_exposition";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Vous trouvez un homme au bord de la route en train de piler des feuilles avec un mortier et un pilon. Il est également en train d\'en mâcher quelques unes et vous regarde avec un sourire vert.%SPEECH_ON%J\'ai eu affaire aux insectes toute ma vie, mais les webknechts, c\'est tout autre chose. Je n\'ai jamais vu un insecte se déplacer aussi vite. Ils avancent en coupant , attrapent les chiens, les chats et autres, et les volent. Restez à l\'écart de ces putains d\'araignées, vous entendez ?%SPEECH_OFF%L\'étranger se reprend une feuille et continue son travail comme si vous n\'étiez pas là. | Une femme à l\'entrée d\'une ferme observe la compagnie avec une série de hochements de tête. Une tasse à la main, elle vous montre du doigt, en agitant sa boisson tout autant que son discours.%SPEECH_ON%Ah, la nourriture des araignées arrive ? Hein ? Eh bien, ces créatures à huit pattes ne sont pas très enthousiastes à l\'idée d\'attendre, elles vous trouveront dès qu\'elles auront faim, et elles ont toujours faim, oui, elles ont toujours le poison à la bouche, oui, oui, oui.%SPEECH_OFF%Elle lance en arrière la tasse qui passe par l\'embrasure de la porte de la maison avant de tomber avec un bruit sourd. | You come across a young man up in a poplar tree. He\'s somehow managed to construct a tiny abode the size and shape of an outhouse up in the heights. Looking down at you, he nods.%SPEECH_ON%Yeah you are incredulous about me and this here tree, well let me tell ya, them webknechts come fast. Spiders the size of dogs! And you know what I say to that? Fuck all of it. You can find me in these here trees from now on and if those damn beasts grow wings I\'ll just up and off my ownself thank ye very much.%SPEECH_OFF%Webknechts seem to be driving the locals mad, though you can\'t really blame them.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Someone ought to pay us for taking care of them.",
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
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		this.m.Score = 5;
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


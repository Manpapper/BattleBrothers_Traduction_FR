this.webknecht_exposition_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.webknecht_exposition";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Vous trouvez un homme au bord de la route en train de piler des feuilles avec un mortier et un pilon. Il est également en train d\'en mâcher quelques unes et vous regarde avec un sourire vert.%SPEECH_ON%J\'ai eu affaire aux insectes toute ma vie, mais les webknechts, c\'est tout autre chose. Je n\'ai jamais vu un insecte se déplacer aussi vite. Ils avancent en coupant , attrapent les chiens, les chats et autres, et les volent. Restez à l\'écart de ces putains d\'araignées, vous entendez ?%SPEECH_OFF%L\'étranger se reprend une feuille et continue son travail comme si vous n\'étiez pas là. | Une femme à l\'entrée d\'une ferme observe la compagnie avec une série de hochements de tête. Une tasse à la main, elle vous montre du doigt, en agitant sa boisson tout autant que son discours.%SPEECH_ON%Ah, la nourriture des araignées arrive ? Hein ? Eh bien, ces créatures à huit pattes ne sont pas très enthousiastes à l\'idée d\'attendre, elles vous trouveront dès qu\'elles auront faim, et elles ont toujours faim, oui, elles ont toujours le poison à la bouche, oui, oui, oui.%SPEECH_OFF%Elle lance en arrière la tasse qui passe par l\'embrasure de la porte de la maison avant de tomber avec un bruit sourd. | Vous apercevez un jeune homme dans un peuplier. Il a réussi à construire une petite maison de la taille et de la forme de toilettes extérieures dans les hauteurs. En vous regardant, il fait un signe de tête.%SPEECH_ON%Oui, vous êtes incrédules à propos de moi et de cet arbre, et bien laissez-moi vous dire, les webknechts arrivent vite. Des araignées de la taille d\'un chien ! Et vous savez ce que je réponds à ça ? J\'emmerde tout ça. Vous pouvez me trouver dans ces arbres à partir de maintenant et si ces maudites bêtes ont des ailes, je me lèverai et je partirai tout seul, merci beaucoup.%SPEECH_OFF%Les webknechts semblent rendre les habitants fous, mais on ne peut pas vraiment leur en vouloir.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Quelqu\'un devrait nous payer pour que nous nous en occupions.",
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

